--------------------------------------------------------------------------------
-- Resources/Game/Makes/Fish.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Equipment = require "ItsyScape.Game.Equipment"
local GatherResourceCommand = require "ItsyScape.Game.GatherResourceCommand"
local Utility = require "ItsyScape.Game.Utility"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local CompositeCommand = require "ItsyScape.Peep.CompositeCommand"
local WaitCommand = require "ItsyScape.Peep.WaitCommand"
local PropResourceHealthBehavior = require "ItsyScape.Peep.Behaviors.PropResourceHealthBehavior"
local Make = require "Resources.Game.Actions.Make"

local Fish = Class(Make)
Fish.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }
Fish.MAX_DISTANCE = 4
Fish.FLAGS = {
	['item-equipment'] = true,
	['item-inventory'] = true,
	['item-drop-excess'] = true
}

function Fish:perform(state, player, prop)
	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state) then
		local equippedItem =
			Utility.Peep.getEquippedItem(player, Equipment.PLAYER_SLOT_RIGHT_HAND) or
			Utility.Peep.getEquippedItem(player, Equipment.PLAYER_SLOT_TWO_HANDED)
		if equippedItem then
			local itemResource = gameDB:getResource(equippedItem:getID(), "Item") 
			if itemResource then
				local equipmentType = gameDB:getRecord("ResourceCategory", {
					Key = "WeaponType",
					Resource = itemResource
				})

				local progress = prop:getBehavior(PropResourceHealthBehavior)
				if progress then
					if progress.currentProgress < progress.maxProgress then
						local i, j, k = Utility.Peep.getTile(prop)
						local walk = Utility.Peep.getWalk(player, i, j, k, Fish.MAX_DISTANCE, { asCloseAsPossible = true })
						local face = CallbackCommand(Utility.Peep.face, player, prop)

						if not walk then
							return false
						end

						if (equipmentType and equipmentType:get("Value") == "fishing-rod") then
							local a = GatherResourceCommand(prop, equippedItem, { skill = "fishing", action = self })
							local b = CallbackCommand(self.make, self, state, player, prop)
							local queue = player:getCommandQueue()
							queue:interrupt(CompositeCommand(nil, walk, face, a, b))

							return true
						else
							Log.info("Need a fishing rod as equipped weapon!")
						end
					else
						Log.info("Resource is depleted.")
					end
				else
					Log.error("Prop is malformed! Missing PropResourceHealthBehavior.")
				end
			else
				Log.error("Item '%s' not found.", equippedItem:getID())
			end
		else
			Log.info("No equipped weapon.")
		end
	end

	return false
end

function Fish:getFailureReason(state, player)
	local reason = Make.getFailureReason(self, state, player)

	local equippedItem = Utility.Peep.getEquippedItem(player, Equipment.PLAYER_SLOT_RIGHT_HAND)
	if equippedItem then
		local gameDB = self:getGame():getGameDB()
		local itemResource = gameDB:getResource(equippedItem:getID(), "Item") 
		if itemResource then
			local equipmentType = gameDB:getRecord("ResourceCategory", {
				Key = "WeaponType",
				Resource = itemResource
			})

			if (equipmentType and equipmentType:get("Value") == "pickaxe") then
				return reason
			end
		end
	end

	table.insert(reason.requirements, {
		type = "Item",
		resource = "WimpyFishingRod",
		name = "Fishing rod",
		count = 1
	})

	return reason
end

return Fish
