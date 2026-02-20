--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/EquipInventoryItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local EquipInventoryItem = B.Node("EquipInventoryItem")
EquipInventoryItem.ITEM = B.Reference()

function EquipInventoryItem:update(mashina, state, executor)
	local gameDB = mashina:getDirector():getGameDB()

	local item = state[self.ITEM]
	local inventory = Utility.Peep.getInventory(mashina)
	for _, i in ipairs(inventory) do
		if (Class.isCallable(item) and item(i)) or i:getID() == item then
			local itemResource = gameDB:getResource(i:getID(), "Item")
			local actions = Utility.getActions(
				mashina:getDirector():getGameInstance(),
				itemResource,
				"inventory")

			for _, action in pairs(actions) do
				if action.instance:is("Equip") then
					local success = action.instance:perform(mashina:getState(), mashina, i)
					if not success then
						return B.Status.Failure
					end

					return B.Status.Success
				end
			end
		end
	end

	return B.Status.Failure
end

return EquipInventoryItem
