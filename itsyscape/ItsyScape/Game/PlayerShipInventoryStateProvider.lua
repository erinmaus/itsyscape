--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerShipInventoryStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleInventoryProvider = require "ItsyScape.Game.SimpleInventoryProvider"
local State = require "ItsyScape.Game.State"
local Utility = require "ItsyScape.Game.Utility"
local StateProvider = require "ItsyScape.Game.StateProvider"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local PlayerShipInventoryStateProvider = Class(StateProvider)

function PlayerShipInventoryStateProvider:new(peep)
	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.ship then
		self.inventory = inventory.ship
	else
		self.inventory = false
	end

	self.peep = peep
end

function PlayerShipInventoryStateProvider:getPriority()
	return State.PRIORITY_DISTANT - 50 -- Closer than bank, further than inventory.
end

function PlayerShipInventoryStateProvider:isReady()
	return self.inventory and self.inventory:getBroker()
end

-- Flags:
--  * item-noted: only search for noted items; otherwise, search for unnoted
--                items.
function PlayerShipInventoryStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function PlayerShipInventoryStateProvider:take(name, count, flags)
	if not self:isReady() then
		return false
	end

	local noted = false
	if flags['item-noted'] then
		noted = true
	end

	local items = { count = 0 }

	local broker = self.inventory:getBroker()
	for item in broker:iterateItems(self.inventory) do
		if item:getID() == name and item:isNoted() == noted then
			items.count = items.count + item:getCount()
			table.insert(items, item)
			if items.count > count then
				break
			end
		end
	end

	if items.count < count then
		return false
	end

	local transaction = broker:createTransaction()
	do
		transaction:addParty(self.inventory)
		local remainder = count
		for i = 1, #items do
			local c = math.min(items[i]:getCount(), remainder)
			transaction:consume(items[i], c)
			remainder = remainder - c
		end
	end
	return transaction:commit()
end

function PlayerShipInventoryStateProvider:give(name, count, flags)
	if not self:isReady() then
		return false
	end

	if not flags['item-inventory'] then
		return false
	end

	local noted = false
	if flags['item-noted'] then
		noted = true
	end

	local broker = self.inventory:getBroker()
	local transaction = broker:createTransaction()
	local successfullyAddedToInventory

	transaction:addParty(self.inventory)
	transaction:spawn(self.inventory, name, count, noted, true)
	return transaction:commit()
end

function PlayerShipInventoryStateProvider:count(name, flags)
	if not self:isReady() then
		return 0
	end

	if not flags['item-inventory'] then
		return 0
	end

	local noted = false
	if flags['item-noted'] then
		noted = true
	end

	local broker = self.inventory:getBroker()
	local c = 0
	for item in broker:iterateItems(self.inventory) do
		if item:getID() == name and item:isNoted() == noted then
			c = c + item:getCount()
		end
	end

	return c
end

return PlayerShipInventoryStateProvider
