--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CraftWindow2Controller.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Controller = require "ItsyScape.UI.Controller"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PropReferenceBehavior = require "ItsyScape.Peep.Behaviors.PropReferenceBehavior"

local CraftWindowController = Class(Controller)

function CraftWindowController:new(peep, director, prop, categoryKey, categoryValue, actionTypeFilter)
	actionTypeFilter = actionTypeFilter or ""

	Controller.new(self, peep, director)

	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local brochure = gameDB:getBrochure()

	local resources = gameDB:getRecords("ResourceCategory", {
		Key = categoryKey,
		Value = categoryValue
	})

	local groups, groupIndices = {}, {}
	do
		local g = gameDB:getRecords("ResourceCategoryGroup", {
			Key = categoryKey,
			Value = categoryValue,
			Language = "en-US"
		})

		table.sort(g, function(a, b)
			local aTier, bTier = a:get("Tier"), b:get("Tier")

			if aTier < bTier then
				return true
			elseif aTier > bTier then
				return false
			else
				return a:get("Value") < b:get("Value")
			end
		end)

		for i = 1, #g do
			local value = g[i]:get("Value")
			local hasIndex = groupIndices[value]
			if not hasIndex then
				table.insert(groups, { value = g[i]:get("Value"), literal = g[i]:get("Name"), itemIcon = g[i]:get("Icon").name })
				groupIndices[groups[i].value] = i
			end
		end
	end

	table.insert(groups, { value = "Misc", literal = "Misc", itemIcon = false })
	groupIndices["Misc"] = #groups

	local verb = "Craft"
	if actionTypeFilter ~= "" then
		local verbRecord = gameDB:getRecord("ActionTypeVerb", {
			Language = "en-US",
			Type = actionTypeFilter
		})

		verb = verbRecord and verbRecord:get("Value") or verb
	end

	local target
	if prop and prop:hasBehavior(PropReferenceBehavior) then
		target = { type = "prop", id = prop:getBehavior(PropReferenceBehavior).prop:getID() }
	elseif prop and prop:hasBehavior(ActorReferenceBehavior) then
		target = { type = "actor", id = prop:getBehavior(ActorReferenceBehavior).actor:getID() }
	else
		target = { type = "none", id = false }
	end

	self.state = {
		action = {
			verb = verb,
			categoryKey = categoryKey,
			categoryValue = categoryValue
		},

		target = target,

		groups = groups
	}
	self.actionsByID = {}
	self.prop = prop

	local flags = { ['item-inventory'] = true }
	for i = 1, #resources do
		local resource = resources[i]:get("Resource")
		local groupValue = resources[i]:get("Value")
		local groupIndex = groupIndices[groupValue] or groupIndices["Misc"]
		local group = groups[groupIndex]

		for action in brochure:findActionsByResource(resource) do
			local actionType = brochure:getActionDefinitionFromAction(action)
			if actionType.name == actionTypeFilter or actionTypeFilter == "" then
				local a, ActionType = Utility.getAction(game, action, 'craft', true)
				if ActionType then
					local actionInstance = ActionType(game, action)
					local canPerform = actionInstance:canPerform(peep:getState(), flags)

					local item, count
					for output in brochure:getOutputs(action) do
						local outputResource = brochure:getConstraintResource(output)
						local outputType = brochure:getResourceTypeFromResource(outputResource)
						if outputType.name == "Item" then
							item = outputResource
							count = output.count
							break
						end
					end

					if item and count then
						a.item = {
							id = item.name,
							name = Utility.getName(item, gameDB) or "*" .. item.name,
							description = Utility.getDescription(item, gameDB) or string.format("It's %s, as if you didn't know.", Utility.getName(item, gameDB) or "*" .. item.name)
						}

						a.constraints = Utility.getActionConstraints(game, action)

						a.count = count
						a.actionCount = actionInstance:count(peep:getState(), flags)
						a.canPerformAction = canPerform
						table.insert(group, a)
					end

					self.actionsByID[a.id] = actionInstance
				end
			end
		end
	end

	for i = #groups, 1, -1 do
		if #groups[i] == 0 then
			table.remove(groups, i)
		end
	end

	self:sort()
end

function CraftWindowController:findActionLevelRequirement(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()

	local sum = 0
	for requirement in brochure:getRequirements(action) do
		local resource = brochure:getConstraintResource(requirement)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == 'skill' then
			sum = sum + Curve.XP_CURVE:getLevel(requirement.count)
		end
	end
	return math.floor(sum)
end

function CraftWindowController:findActionOutputXP(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()

	local sum = 0
	for output in brochure:getOutputs(action) do
		local resource = brochure:getConstraintResource(output)
		local resourceType = brochure:getResourceTypeFromResource(resource)
		if resourceType.name:lower() == 'skill' then
			sum = sum + output.count
		end
	end

	return math.floor(sum)
end

function CraftWindowController:findActionResource(action)
	local gameDB = self:getDirector():getGameDB()
	local brochure = gameDB:getBrochure()
	for resource in brochure:findResourcesByAction(action) do
		return resource
	end

	return nil
end

function CraftWindowController:sort()
	for i = 1, #self.state.groups do
		local group = self.state.groups[i]
		table.sort(group, function(a, b)
			a = self.actionsByID[a.id]:getAction()
			b = self.actionsByID[b.id]:getAction()

			local aReqXP, bReqXP = self:findActionLevelRequirement(a), self:findActionLevelRequirement(b)
			local aOutXP, bOutXP = self:findActionOutputXP(a), self:findActionOutputXP(b)
			local aResource, bResource = self:findActionResource(a), self:findActionResource(b)

			if aReqXP < bReqXP then
				return true
			elseif aReqXP == bReqXP then
				if aOutXP < bOutXP then
					return true
				elseif aOutXP == bOutXP then
					if aResource and bResource then
						return aResource.name < bResource.name
					else
						return a.id < b.id
					end
				end
			end

			return false
		end)
	end
end

function CraftWindowController:poke(actionID, actionIndex, e)
	if actionID == "craft" then
		self:craft(e)
	elseif actionID == "select" then
		self:select(e)
	elseif actionID == "close" then
		self:getGame():getUI():closeInstance(self)
	else
		Controller.poke(self, actionID, actionIndex, e)
	end
end

function CraftWindowController:pull()
	return self.state
end

function CraftWindowController:craft(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")
	assert(type(e.count) == "number", "count must be number")
	assert(e.count < math.huge, "count must be less than infinity")

	e.count = math.max(math.min(e.count, 99), 0)

	local action = self.actionsByID[e.id]
	local player = self:getPeep()
	local count = math.min(action:count(player:getState(), player), e.count)

	if player:getCommandQueue():clear() then
		for i = 1, e.count do
			action:perform(
				player:getState(),
				player,
				self.prop)
		end
	end

	self:getGame():getUI():closeInstance(self)
end

function CraftWindowController:select(e)
	assert(type(e.id) == "number", "action ID must be number")
	assert(self.actionsByID[e.id] ~= nil, "action with ID not found")

	self.currentAction = self.actionsByID[e.id]
end

return CraftWindowController
