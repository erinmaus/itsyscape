--------------------------------------------------------------------------------
-- ItsyScape/Peep/Action.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Probe = require "ItsyScape.Peep.Probe"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local Action = Class()
Action.DEFAULT_FLAGS = {
	['item-inventory'] = true
}

function Action:new(game, action)
	self.game = game
	self.gameDB = game:getGameDB()
	self.action = action

	local definition = self.gameDB:getBrochure():getActionDefinitionFromAction(action)
	self.definitionName = definition.name
	self.definitionID = definition.id.value
end

function Action:getActionDuration(ticks)
	if ticks >= 0 then
		return self.game:getDelta() * ticks
	else
		return 0
	end
end

function Action:getGame()
	return self.game
end

function Action:getGameDB()
	return self.gameDB
end

function Action:getAction()
	return self.action
end

-- Returns the ID of the action, as a number.
--
-- This should be the GameDB ID.
function Action:getID()
	return self.action.id.value
end

-- Returns the name of the action, from the definition.
function Action:getName()
	return self.definitionName
end

-- Returns true if the action is of the specified name, false otherwise.
function Action:is(name)
	return self.definitionName:lower() == name:lower()
end

-- Gets the definition ID, as a number.
--
-- This should be the GameDB ID.
function Action:getDefinitionID()
	return self.definitionID
end

-- Gets the verb in 'lang'.
--
-- 'lang' defaults to "en-US". If no verb is found, returns false.
function Action:getVerb(lang)
	lang = lang or "en-US"

	local nameRecord = self.gameDB:getRecord("ActionVerb", { Action = self.action, Language = lang })
	if nameRecord then
		return nameRecord:get("Value") or false
	else
		local typeRecord = self.gameDB:getRecord("ActionTypeVerb", { Type = self.definitionName, Language = lang })
		if typeRecord then
			return typeRecord:get("Value") or false
		end

	end

	return false
end

local VOWELS = { a = true, e = true, i = true, o = true, u = true }

-- Gets the progressive verb in 'lang'.
--
-- 'lang' defaults to "en-US". If no verb is found, returns false.
function Action:getXProgressiveVerb(lang)
	lang = lang or "en-US"

	local nameRecord = self.gameDB:getRecord("ActionVerb", { Action = self.action, Language = lang })
	if nameRecord and nameRecord:get("XProgressive") ~= "" then
		return nameRecord:get("XProgressive")
	else
		local typeRecord = self.gameDB:getRecord("ActionTypeVerb", { Type = self.definitionName, Language = lang })
		if typeRecord and typeRecord:get("XProgressive") ~= "" then
			return typeRecord:get("XProgressive")
		end
	end

	local actionName = self.definitionName:lower()
	if VOWELS[actionName:sub(-1)] then
		actionName = actionName:sub(1, -2) .. "ing"
	else
		actionName = actionName .. "ing"
	end

	actionName = actionName:gsub("_", " ")
	actionName = actionName:sub(1, 1):upper() .. actionName:sub(2)

	return actionName
end

-- Returns true if the Action can be performed. Otherwise, returns false.
--
-- The default implementation only evaluates requirements, not inputs.
function Action:canPerform(state, flags)
	flags = flags or self.FLAGS or Action.DEFAULT_FLAGS

	local brochure = self.gameDB:getBrochure()
	for requirement in brochure:getRequirements(self.action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, requirement.count, flags) then
			return false
		end
	end

	local debug = self.gameDB:getRecord("DebugAction", { Action = self.action })
	if debug and not _DEBUG then
		return false
	end

	return true
end

-- Returns true if the Action can be performed. Otherwise, returns false.
--
-- The default implementation only evaluates inputs, not requirements.
function Action:canTransfer(state, flags)
	flags = flags or self.FLAGS or Action.DEFAULT_FLAGS

	local brochure = self:getGameDB():getBrochure()
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, input.count, flags) then
			Log.info(
				"Input not met; need %d of %s %s",
				input.count,
				resourceType.name,
				resource.name)
			return false
		end
	end

	return true
end

-- Counts how many times the action can be performed.
function Action:count(state, flags)
	return 0
end

function Action:sendEvent(peep, event, eventArgs)
	eventArgs = eventArgs or {}

	local slot = event:get("Slot")

	local poke = { peep = peep }
	do
		function getArguments(meta)
			local args = self.gameDB:getRecords(meta, {
				Slot = slot or 0,
				Action = self.action
			})

			for i = 1, #args do
				local key = args[i]:get("Key")
				if key then
					poke[key] = args[i]:get("Value")
				end
			end
		end

		getArguments("ActionEventTextArgument")
		getArguments("ActionEventIntegerArgument")
		getArguments("ActionEventRealArgument")
		getArguments("ActionEventResourceArgument")
		getArguments("ActionEventActionArgument")

		for key, value in pairs(eventArgs) do
			poke[key] = value
		end
	end

	local targets = {}
	do
		local t = self.gameDB:getRecords("ActionEventTarget", {
			Slot = slot,
			Action = self.action
		})

		for i = 1, #t do
			targets[t[i]:get("Value").id.value] = true
		end
	end

	local peeps
	if next(targets, nil) == nil then
		peeps = peep:getLayerName()
	else
		peeps = peep:getDirector():probe(peep:getLayerName(), function(p)
			local mapObject = Utility.Peep.getMapObject(p)
			local resource = Utility.Peep.getResource(p)

			if resource and targets[resource.id.value] then
				return true
			end

			if mapObject and targets[mapObject.id.value] then
				return true
			end

			return false
		end)
	end

	peep:getDirector():broadcast(peeps, event:get("Event"), poke)
end

-- Performs the action.
--
-- The arguments vary depending on the type of Action; there can be no standard.
--
-- For example, Actions perfomed on an Item generally are in the form
-- (item, peep); Actions performed via an object are in the form (item, peep,
-- object); and so on.
--
-- Returns true if the action could be performed, or false otherwise. If the
-- action fails, a message should be returned.
function Action:perform(state, player, eventArgs, ...)
	local events = self.gameDB:getRecords("ActionEvent", {
		Action = self.action
	})

	for i = 1, #events do
		self:sendEvent(player, events[i], eventArgs)
	end

	player:poke('actionPerformed', { action = self })
end

-- Consumes inputs.
function Action:consume(state, player, flags)
	flags = flags or self.FLAGS or Action.DEFAULT_FLAGS

	local multiplier = flags['action-count'] or 1

	if self:canTransfer(state, flags) then
		local gameDB = self:getGameDB()
		local brochure = gameDB:getBrochure()
		for input in brochure:getInputs(self.action) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			state:take(resourceType.name, resource.name, input.count * multiplier, flags)
		end

		return true
	end

	return false
end

-- Transfers inputs/outputs.
function Action:transfer(state, player, flags, force)
	flags = flags or self.FLAGS or Action.DEFAULT_FLAGS

	local multiplier = flags['action-count'] or 1
	local outputMultiplier = flags['action-output-count'] or 1

	if force or self:canTransfer(state, flags) then
		local gameDB = self:getGameDB()
		local brochure = gameDB:getBrochure()
		local inputs, outputs = {}, {}
		local function reverse()
			for _, output in ipairs(outputs) do
				state:take(output.type, output.name, output.count, flags)
			end

			for _, input in ipairs(inputs) do
				state:give(input.type, input.name, input.count, flags)
			end
		end

		for input in brochure:getInputs(self.action) do
			local resource = brochure:getConstraintResource(input)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			if not state:take(resourceType.name, resource.name, input.count * multiplier, flags) and not force then
				reverse()
				return false
			else
				table.insert(inputs, {
					type = resourceType.name,
					name = resource.name,
					count = input.count * multiplier
				})
			end
		end

		for output in brochure:getOutputs(self.action) do
			local resource = brochure:getConstraintResource(output)
			local resourceType = brochure:getResourceTypeFromResource(resource)

			if not state:give(resourceType.name, resource.name, output.count * multiplier * outputMultiplier, flags) and not force then
				reverse()
				return false
			else
				table.insert(outputs, {
					type = resourceType.name,
					name = resource.name,
					count = output.count * multiplier
				})
			end
		end

		local stage = player:getDirector():getGameInstance():getStage(player)
		do
			local props = gameDB:getRecords("ActionSpawnProp", {
				Action = self.action
			})

			for i = 1, #props do
				local resource = props[i]:get("Prop")
				if resource then
					local s, p = stage:placeProp("resource://" .. resource.name, Utility.Peep.getLayer(player), player:getLayerName())
					if s then
						local propPeep = p:getPeep()
						propPeep:listen('ready', function()
							local i, j, k = Utility.Peep.getTile(player)
							local map = player:getDirector():getMap(k)

							local position = propPeep:getBehavior(PositionBehavior)
							if position then
								position.position = map:getTileCenter(i, j)
							end

							propPeep:poke('spawnedByAction', player)
						end)
					end
				end
			end
		end

		return true
	end

	return false
end

function Action:getFailureReason(state, peep)
	local game = peep:getDirector():getGameInstance()
	local brochure = self.gameDB:getBrochure()

	local requirements = {}
	for requirement in brochure:getRequirements(self.action) do
		local resource = brochure:getConstraintResource(requirement)
		local constraint = Utility.getActionConstraintResource(game, resource, requirement.count)

		table.insert(requirements, constraint)
	end

	local inputs = {}
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local constraint = Utility.getActionConstraintResource(game, resource, input.count)

		table.insert(inputs, constraint)
	end

	local debug = self.gameDB:getRecord("DebugAction", { Action = self.action })
	if debug and not _DEBUG then
		table.insert(requirements, {
			type = "KeyItem",
			resource = "_DEBUG",
			name = "Mysterious divine force",
			description = "A mysterious divine force stops you.",
			count = 1
		})
	end

	return { requirements = requirements, inputs = inputs }
end

-- Called when the action fails
function Action:fail(state, peep, ...)
	local reason = self:getFailureReason(state, peep, ...)

	peep:poke('actionFailed', reason)
end

return Action
