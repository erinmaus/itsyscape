--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PokeInventoryItem.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local PokeInventoryItem = B.Node("PokeInventoryItem")
PokeInventoryItem.ACTION = B.Reference()
PokeInventoryItem.ITEM = B.Reference()

function PokeInventoryItem:update(mashina, state, executor)
	local actionType = state[self.ACTION]
	local item = state[self.ITEM]

	local gameDB = mashina:getDirector():getGameDB()

	local resource
	if type(item) == "string" then
		resource = gameDB:getResource(item, "Item")

		local inventory = mashina:getBehavior(InventoryBehavior)
		if not inventory or not inventory.inventory then
			return B.Status.Failure
		end

		local broker = mashina:getDirector():getItemBroker()

		local gotItem = false
		for i in broker:iterateItems(inventory.inventory) do
			if not i:isNoted() and i:getID() == item then
				gotItem = true
				item = i
				break
			end
		end

		if not gotItem then
			Log.warn("Item '%s' not found in Peep '%s' inventory.", item, mashina:getName())
			return B.Status.Failure
		end
	else
		resource = gameDB:getResource(item:getID(), "Item")
	end

	local actions = Utility.getActions(mashina:getDirector():getGameInstance(), resource, 'inventory')
	for i = 1, #actions do
		if actions[i].instance:is(actionType) then
			local success = Utility.performAction(
				mashina:getDirector():getGameInstance(),
				resource,
				actions[i].id,
				'inventory',
				mashina:getState(), mashina, item)
			if success then
				return B.Status.Success
			end
		end
	end

	return B.Status.Failure
end

return PokeInventoryItem
