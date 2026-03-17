--------------------------------------------------------------------------------
-- ItsyScape/Game/Utility/Peep/Inventory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local Inventory = {}

function Inventory:reload(skipSerialize)
	local director = self:getDirector()
	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():removeProvider(inventory.inventory, skipSerialize)
	director:getItemBroker():addProvider(inventory.inventory)
end

function Inventory:onAssign(director)
	local PlayerInventoryStateProvider = require "ItsyScape.Game.PlayerInventoryStateProvider"

	local inventory = self:getBehavior(InventoryBehavior)
	director:getItemBroker():addProvider(inventory.inventory)

	self:getState():addProvider("Item", PlayerInventoryStateProvider(self))
end

function Inventory:onReady(director)
	local broker = director:getItemBroker()
	local function spawnItems(records)
		local inventory = self:getBehavior(InventoryBehavior)
		if inventory and inventory.inventory then
			inventory = inventory.inventory
			for i = 1, #records do
				local record = records[i]
				local item = record:get("Item")
				local count = record:get("Count") or 1
				local noted = record:get("Noted") ~= 0

				local transaction = broker:createTransaction()
				transaction:addParty(inventory)
				transaction:spawn(inventory, item.name, count, noted)
				local s, r = transaction:commit()
				if not s then
					Log.error("Failed to spawn item: %s", r)
				end
			end
		end
	end
	
	local gameDB = director:getGameDB()
	local resource = Utility.Peep.getResource(self)
	local mapObject = Utility.Peep.getMapObject(self)

	if resource then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = resource }))
	end

	if mapObject then
		spawnItems(gameDB:getRecords("PeepInventoryItem", { Resource = mapObject }))
	end
end

return Inventory
