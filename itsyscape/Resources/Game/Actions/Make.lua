--------------------------------------------------------------------------------
-- Resources/Game/Actions/Make.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local CacheRef = require "ItsyScape.Game.CacheRef"
local GatherResourceCommand = require "ItsyScape.Game.GatherResourceCommand"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Action = require "ItsyScape.Peep.Action"

local Make = Class(Action)
Make.SCOPES = { ['craft'] = true }
Make.FLAGS = { ['item-inventory'] = true }
Make.PAUSE = 1.5

function Make:canPerform(state, flags)
	return Action.canPerform(self, state, flags) and Action.canTransfer(self, state, flags)
end

function Make:count(state, flags)
	flags = flags or self.FLAGS

	local count
	local brochure = self:getGameDB():getBrochure()
	for input in brochure:getInputs(self.action) do
		local resource = brochure:getConstraintResource(input)
		local resourceType = brochure:getResourceTypeFromResource(resource)

		if not state:has(resourceType.name, resource.name, input.count, flags) then
			return 0
		else
			if resourceType.name == "Item" then
				local resourceCount = state:count(resourceType.name, resource.name, flags)
				count = math.min(math.floor(resourceCount / input.count), count or math.huge)
			end
		end
	end

	return count or 0
end

function Make:getActionDuration(...)
	return self.PAUSE
end

function Make:getSecondaryResourceActions(state, prop)
	local gameDB = self:getGameDB()
	local brochure = gameDB:getBrochure()

	local secondaryActions = Utility.getActions(self:getGame(), Utility.Peep.getResource(prop), 'make-action')
	local secondaryResourceActions = {}
	for i = 1, #secondaryActions do
		local action = secondaryActions[i].instance
		for output in brochure:getOutputs(action:getAction()) do
			local resource = brochure:getConstraintResource(output)
			local resourceActions = Utility.getActions(self:getGame(), resource, 'make-action')
			local weight = gameDB:getRecord("SecondaryWeight", {
				Resource = resource
			})

			if weight then
				for j = 1, #resourceActions do
					if resourceActions[j].instance:canPerform(state) then
						table.insert(secondaryResourceActions, {
							action = resourceActions[j].instance,
							resource = resource,
							weight = weight:get("Weight")
						})
					end
				end
			end
		end
	end

	return secondaryResourceActions
end

function Make:gatherSecondaries(state, player, prop)
	local actions = self:getSecondaryResourceActions(state, prop)

	local maxWeight = 0
	for i = 1, #actions do
		maxWeight = maxWeight + actions[i].weight
	end

	local maxNumRolls = 1
	local progress = prop:getBehavior(PropResourceHealthBehavior)
	if progress then
		maxNumRolls = math.ceil(progress.maxProgress / 5)
	end

	local loot = {}

	-- The '0' is so there's a chance an action doesn't give any resources.
	local numRolls = math.random(0, maxNumRolls)
	for i = 1, maxNumRolls do
		local item = actions[1]
		local currentWeight = 0
		if item then
			currentWeight = item.weight
		end

		local roll = math.random(0, maxWeight)
		for j = 2, #actions do
			if currentWeight > roll then
				print(">>> break", item.weight)
				break
			end

			local nextItem = actions[j]
			local nextItemWeight = nextItem.weight
			local nextWeight = currentWeight + nextItemWeight

			item = nextItem
			currentWeight = nextWeight

			print(">>> next", item.resource.name, nextItemWeight)
		end

		if item then
			print(">>> droppping", item.resource.name, roll, maxWeight)
			local l = loot[item.resource.name] or { item = item, count = 0}
			l.count = l.count + 1
			loot[item.resource.name] = l
		end
	end

	for lootName, lootItem in pairs(loot) do
		lootItem.item.action:perform(state, player, lootItem.count)
	end
end

function Make:gather(state, player, prop, toolType, skill)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) then
		local bestTool = Utility.Peep.getBestTool(player, toolType)
		if bestTool then
			local skin

			local itemResource = gameDB:getResource(bestTool:getID(), "Item")
			if itemResource then
				local equipmentModelRecord = gameDB:getRecord("EquipmentModel", { Resource = itemResource })
				if equipmentModelRecord then
					skin = CacheRef(
						equipmentModelRecord:get("Type"),
						equipmentModelRecord:get("Filename"))
				else
					Log.error("No skin for tool '%s'.", bestTool:getID())
				end

				local equipmentRecord = gameDB:getRecord("Equipment", { Resource = itemResource })
				if equipmentRecord then
					slot = equipmentRecord:get("EquipSlot")
				else
					Log.error("No equipment record for tool '%s'.", bestTool:getID())
				end
			else
				Log.warn("No item resource for tool '%s', is it an XWeapon?", bestTool:getID())
			end

			Log.info("Using tool '%s'.", bestTool:getID())

			local progress = prop:getBehavior(PropResourceHealthBehavior)
			if progress and progress.currentProgress < progress.maxProgress then
				local i, j, k = Utility.Peep.getTile(prop)
				local walk = Utility.Peep.getWalk(player, i, j, k, self.MAX_DISTANCE or 1.5)
				local face = CallbackCommand(Utility.Peep.face, player, prop)

				if not walk then
					return false
				end

				local callback = Callback.bind(self.make, self, state, player, prop)
				local gatherCommand = GatherResourceCommand(prop, bestTool, callback, { skill = skill, skin = skin, action = self })
				local queue = player:getCommandQueue()
				queue:interrupt(CompositeCommand(nil, walk, face, gatherCommand))

				return true
			else
				Log.info("Resource '%s' depleted.", prop:getName())
			end
		else
			Log.info("Does not have tool of type '%s'.", toolType)
		end
	end

	return false
end

function Make:getDynamicCount(state, player, flags)
	flags = flags or self.FLAGS
	local f = {}
	for k, v in pairs(flags) do
		f[k] = v
	end

	local count = 1
	do
		local action = self:getAction()
		local record = self:getGameDB():getRecord("DynamicSkillMultiplier", {
			Action = action
		})

		if record then
			local minMultiplier = record:get("MinMultiplier")
			local maxMultiplier = record:get("MaxMultiplier")
			local minLevel = record:get("MinLevel")
			local maxLevel = record:get("MaxLevel")
			local skill = record:get("Skill").name
			local currentLevel = state:count("Skill", skill, { ['skill-as-level'] = true })
			local levelMultiplier = math.max(currentLevel - minLevel, 1) / (maxLevel - minLevel)
			local multiplier = (maxMultiplier - minMultiplier) * levelMultiplier + minMultiplier

			count = math.min(math.max(math.floor(multiplier), minMultiplier), maxMultiplier)
		end
	end

	f['action-output-count'] = count

	return f
end

function Make:make(state, player, prop, flags)
	self:transfer(state, player, flags)

	if prop then
		self:gatherSecondaries(state, player, prop)
	end

	Action.perform(self, state, player)

	player:poke('resourceObtained', {})
end

return Make
