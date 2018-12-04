--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerInventoryStateProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local State = require "ItsyScape.Game.State"
local Utility = require "ItsyScape.Game.Utility"
local StateProvider = require "ItsyScape.Game.StateProvider"
local InventoryBehavior = require "ItsyScape.Peep.Behaviors.InventoryBehavior"

local PlayerInventoryStateProvider = Class(StateProvider)

function PlayerInventoryStateProvider:new(peep)
	local inventory = peep:getBehavior(InventoryBehavior)
	if inventory and inventory.inventory then
		self.inventory = inventory.inventory
	else
		self.inventory = false
	end

	self.peep = peep
end

function PlayerInventoryStateProvider:getPriority()
	return State.PRIORITY_LOCAL
end

-- Flags:
--  * item-noted: only search for noted items; otherwise, search for unnoted
--                items.
function PlayerInventoryStateProvider:has(name, count, flags)
	return count <= self:count(name, flags)
end

function PlayerInventoryStateProvider:take(name, count, flags)
	if not self.inventory then
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

function PlayerInventoryStateProvider:give(name, count, flags)
	if not self.inventory then
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
	do
		transaction:addParty(self.inventory)
		transaction:spawn(self.inventory, name, count, noted, true)
	end
	return transaction:commit()
end

function PlayerInventoryStateProvider:count(name, flags)
	if not self.inventory then
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

return PlayerInventoryStateProvider
