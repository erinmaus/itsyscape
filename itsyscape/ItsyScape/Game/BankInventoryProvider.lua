--------------------------------------------------------------------------------
-- ItsyScape/Game/BankInventoryProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"

local BankInventoryProvider = Class(InventoryProvider)

function BankInventoryProvider:new(peep)
	self.peep = peep
end

function BankInventoryProvider:getPeep()
	return self.peep
end

function BankInventoryProvider:getMaxInventorySpace()
	return math.huge
end

function BankInventoryProvider:deposit(item, count, clamp)
	local broker = self:getBroker()
	local manager = self.peep:getDirector():getItemManager()
	do
		local transaction = broker:createTransaction()
		transaction:addParty(self)
		transaction:addParty(broker:getItemProvider(item))

		if not manager:isStackable(item:getID()) and
		   not item:isNoted()
		then
			transaction:transfer(self, item, 1, 'bank-deposit', true)

			local remainingCount = count - 1
			local newCount = 1
			for i in broker:iterateItems(broker:getItemProvider(item)) do
				if i:getID() == item:getID() and
				   remainingCount > 0 and
				   i ~= item
				then
					local c = math.min(remainingCount, i:getCount())
					transaction:transfer(
						self,
						i,
						c,
						'bank-deposit',
						true)
					newCount = newCount + c
					remainingCount = remainingCount - c
				end
			end

			if not clamp and remainingCount > 0 then
				return false
			end

			count = newCount
		else
			if not clamp then
				if count > item:getCount() then
					return false
				end
			end

			transaction:transfer(
				self,
				item,
				math.min(count, item:getCount()),
				'bank-deposit',
				true)
		end

		if not transaction:commit() then
			return false
		end
	end

	if manager:isNoteable(item:getID()) then
		local transaction = broker:createTransaction()
		transaction:addParty(self)
		transaction:note(self, item:getID(), count)
		if not transaction:commit() then
			return false
		end
	end

	return true
end

function BankInventoryProvider:withdraw(destination, id, count, noted, clamp)
	if clamp == nil then
		clamp = true
	end

	local broker = self:getBroker()
	local manager = self.peep:getDirector():getItemManager()
	local transaction = broker:createTransaction()
	transaction:addParty(self)
	transaction:addParty(destination)

	if noted and not manager:isNoteable(id) then
		return false, 0
	end

	local hasNotedItem
	if manager:isNoteable(id) then
		for item in broker:iterateItems(destination) do
			if item:getID() == id and item:isNoted() then
				hasNotedItem = true
				break
			end
		end
	else
		hasNotedItem = false
	end

	local hasStackableItem
	if manager:isStackable(id) then
		for item in broker:iterateItems(destination) do
			if item:getID() == id  then
				hasStackableItem = true
				break
			end
		end
	else
		hasStackableItem = true
	end

	local requiredSpace
	if hasNotedItem then
		if noted then
			requiredSpace = 0
		else
			requiredSpace = count - 1
		end
	else
		if noted then
			requiredSpace = 1
		elseif manager:isStackable(id) then
			if hasStackableItem then
				requiredSpace = 0
			else
				requiredSpace = 1
			end
		else
			requiredSpace = count
		end
	end

	local freeSpace = destination:getMaxInventorySpace() - broker:count(destination)
	if freeSpace < requiredSpace then
		if not clamp then
			return false, 0
		else
			-- If there's no room for even a noted item, then there's nothing we can do.
			if requiredSpace == 0 then
				return false, 0
			end

			count = math.min(freeSpace, count)
		end
	end

	local withdrawnCount = 0
	local remainingCount = count
	for item in broker:iterateItems(self) do
		if item:getID() == id then
			local transferCount = math.min(remainingCount, item:getCount())
			transaction:transfer(destination, item, transferCount, 'bank-withdraw')

			remainingCount = remainingCount - transferCount
			withdrawnCount = withdrawnCount + transferCount
		end
	end

	if remainingCount > 0 then
		if not clamp then
			return false, 0
		end
	end

	if not transaction:commit() then
		return false, 0
	end

	if not noted then
		if manager:isNoteable(id) then
			for item in broker:iterateItems(destination) do
				if item:getID() == id and item:isNoted() then
					local unnoteTransaction = broker:createTransaction()
					unnoteTransaction:addParty(destination)
					unnoteTransaction:unnote(item, withdrawnCount)
					if not unnoteTransaction:commit() then
						Log.warn("Couldn't unnote items.")
					end
				end
			end
		end
	end

	return true, count
end

function BankInventoryProvider:assignKey(item)
	local index
	local previousIndex = 0
	for currentIndex in self:getBroker():keys(self) do
		if currentIndex - previousIndex > 1 then
			index = previousIndex + 1
			break
		end

		previousIndex = currentIndex
	end


	index = index or previousIndex + 1
	self:getBroker():setItemKey(item, index)
	self:getBroker():setItemZ(item, index)
end

function BankInventoryProvider:onSpawn(item, count)
	self:assignKey(item)
end

function BankInventoryProvider:onTransferTo(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function BankInventoryProvider:onTransferFrom(destination, item, count, purpose)
	local broker = self:getBroker()
	local index = broker:getItemKey(item)
	if index ~= nil and item:getCount() == count then
		local keys = {}
		for key in broker:keys(self) do
			if key > index then
				table.insert(keys, key)
			end
		end

		for _, key in pairs(keys) do
			for item in broker:iterateItemsByKey(self, key) do
				broker:setItemKey(item, key - 1)
				broker:setItemZ(item, key - 1)
				break
			end
		end
	end
end

function BankInventoryProvider:onNote(item)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function BankInventoryProvider:load(...)
	InventoryProvider.load(self, ...)

	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Bank")
	if storage then
		for key, section in storage:iterateSections() do
			local item = broker:itemFromStorage(self, section)
			broker:setItemZ(item, broker:getItemKey(item))
		end
	end
end

function BankInventoryProvider:unload(...)
	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Bank", true)
	if storage then
		for item in broker:iterateItems(self) do
			local key = broker:getItemKey(item)
			broker:itemToStorage(item, storage, key)
		end
	end

	InventoryProvider.unload(self, ...)
end

return BankInventoryProvider
