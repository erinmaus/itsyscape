--------------------------------------------------------------------------------
-- Resources/Game/Makes/Mine.lua
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
local Make = require "Resources.Game.Actions.Make"

local Mine = Class(Make)
Mine.SCOPES = { ['world'] = true, ['world-pvm'] = true, ['world-pvp'] = true }

function Mine:perform(state, player, prop)
	local flags = { ['item-equipment'] = true }

	local gameDB = self:getGame():getGameDB()
	if self:canPerform(state, flags) then
		local equippedItem = Utility.Peep.getEquippedItem(player, Equipment.PLAYER_SLOT_RIGHT_HAND)
		if equippedItem then
			local itemResource = gameDB:getResource(equippedItem:getID(), "Item") 
			if itemResource then
				local equipmentType = gameDB:getRecord("ResourceCategory", {
					Key = "WeaponType",
					Resource = itemResource
				})

				local i, j, k = Utility.Peep.getTile(prop)
				local walk = Utility.Peep.getWalk(player, i, j, k)

				if (equipmentType and equipmentType:get("Value") == "pickaxe") or true then
					local a = GatherResourceCommand(prop, equippedItem, { skill = "mining" })
					local b = CallbackCommand(self.make, self, state, player, prop)
					local queue = player:getCommandQueue()
					queue:push(CompositeCommand(nil, walk, a, b))
				else
					Log.info("Need pickaxe as equipped weapon!")
				end
			else
				Log.error("Item '%s' not found.", equippedItem:getID())
			end
		else
			Log.info("No equipped weapon.")
		end
	end
end

return Mine
