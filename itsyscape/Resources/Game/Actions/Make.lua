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

function Make:make(state, player, prop)
	local flags = self.FLAGS

	self:transfer(state, player, flags)
	Action.perform(self, state, player)

	player:poke('resourceObtained', {})
end

return Make
