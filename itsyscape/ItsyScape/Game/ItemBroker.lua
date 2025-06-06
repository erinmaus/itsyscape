--------------------------------------------------------------------------------
-- ItsyScape/Game/ItemBroker.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"
local ItemInstance = require "ItsyScape.Game.ItemInstance"
local RPCState = require "ItsyScape.Game.RPC.State"

-- Manages items and inventories.
--
-- The ItemBroker is the absolute authority on what items exist in the world
-- and what items exist in inventories.
--
-- Manipulating items requires creating a Transaction (see
-- ItemBroker.createTransaction). If the transaction fails by any means (either
-- the operation is invalid; the inventory is full; a condition fails; there is
-- a runtime error; and so on), the transaction is not committed and everything
-- stays the same.
--
-- Item duplication should be impossible; that is the goal.
local ItemBroker = Class()

ItemBroker.Transaction = Class()

-- Constructs a new transaction.
--
-- This should be not be called directory; instead use
-- ItemBroker.createTransaction.
function ItemBroker.Transaction:new(broker)
	self.broker = broker
	self.parties = {}
	self.steps = {}
	self.conditions = {}
	self.items = {}
end

-- Gets the ItemBroker this transaction belongs to.
function ItemBroker.Transaction:getBroker(broker)
	return self.broker
end

function ItemBroker.Transaction:iterateItems()
	return pairs(self.items)
end

-- Adds provider 'party' as a party to the Transaction.
function ItemBroker.Transaction:addParty(party)
	assert(self.broker:hasProvider(party), "broker does not have provider")

	self.parties[party] = true
end

function ItemBroker.Transaction:commit()
	local conditions = self.conditions
	local steps = self.steps
	assert(#conditions == #steps, "step/condition desynchronize")

	local state = {}
	for party in pairs(self.parties) do
		state[party] = { count = self.broker:count(party) }
	end

	self.conditions = {}
	self.steps = {}

	for i = 1, #conditions do
		local s, r = pcall(conditions[i], state)
		if not s then
			print(s, r)
			return false, r
		end
	end

	for i = 1, #steps do
		steps[i]()
	end

	return true, "success"
end

-- Consumes an item.
--
-- ItemInstance must belong to a Party.
--
-- If 'count' exceeds item.getCount(), the transaction fails. 'count' defaults
-- to item.getCount().
--
-- Upon executing,
-- 1) Invokes ItemLogic.canConsume(). If ItemLogic.canConsume fails or returns
--    false, the transaction fails.
-- 2) Removes the ItemInstance if 'count' == item.getCount(), or reduces count
--    of item by 'count' otherwise.
function ItemBroker.Transaction:consume(item, count)
	count = count or item:getCount()

	local condition = function(state)
		assert(self.broker:hasItem(item), "broker doesn't have item")

		local itemParty = self.broker.items[item]
		assert(self.parties[itemParty], "inventory provider not party to transaction")

		assert(count <= item:getCount(), "consume count exceeds item count")
		
		local logic = self.broker.manager:getLogic(item:getID())
		if not logic:canConsume(item, itemParty) then
			error("cannot consume item")
		end

		if item:getCount() == count then
			local p = state[itemParty]
			p.count = p.count - 1
		end
	end

	local step = function()
		local provider = self.broker.items[item]

		if count < item:getCount() then
			item:setCount(item:getCount(count) - count)
		else
			self.broker:removeItem(item)
		end

		self.items[item:getRef()] = item

		local s, r = pcall(provider.onConsume, provider, item, count)
		if not s then
			return false, r
		else
			return true
		end
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

-- Destroys an item.
--
-- ItemInstance must be a Party.
--
-- Upon executing,
-- 1) Invokes ItemLogic.canDestroy(). If ItemLogic.canDestroy fails or returns
--    false, the transaction fails. If 'force' is set to true, then this step is
--    skipped. Be careful!
function ItemBroker.Transaction:destroy(item, force)
	local condition = function(state)
		assert(self.broker:hasItem(item), "broker doesn't have item")

		local itemParty = self.broker.items[item]
		assert(self.parties[itemParty], "inventory provider not party to transaction")
		
		local logic = self.broker.manager:getLogic(item:getID())
		if not logic:canDestroy(item, itemParty) and not force then
			error("cannot destroy item")
		end

		local p = state[itemParty]
		p.count = p.count - 1
	end

	local step = function()
		local provider = self.broker.items[item]
		self.broker:removeItem(item)

		self.items[item:getRef()] = item

		local s, r = pcall(provider.onDestroy, provider, item)
		if not s then
			return false, r
		else
			return true
		end
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

function ItemBroker.Transaction:spawn(provider, id, count, noted, merge, force, serializedUserdata)
	if merge == nil then
		merge = true
	end

	serializedUserdata = serializedUserdata or {}

	count = count or 1

	local condition = function(state)
		assert(self.parties[provider], "inventory provider not party to transaction")
		
		local logic = self.broker.manager:getLogic(id)
		if not logic or not logic:canSpawn(itemParty) and not force then
			error("cannot spawn item")
		end

		local isStackable
		if self.broker.manager:isStackable(id) or
		   (noted and self.broker.manager:isNoteable(id))
		then
			isStackable = true
		else
			isStackable = false
		end

		if not self.broker.manager:isNoteable(id) then
			noted = false
		end

		local inventory = self.broker.inventories[provider]
		if merge and isStackable then
			local item = inventory:findFirst(id, true, noted, serializedUserdata)
			if not item then
				local c = state[provider].count

				if c + 1 > provider:getMaxInventorySpace() then
					error("inventory full")
				else
					local p = state[provider]
					p.count = p.count + 1
				end
			end
		else
			local p = state[provider]
			if isStackable then
				if p.count + 1 > provider:getMaxInventorySpace() then
					error("inventory full")
				end

				p.count = p.count + 1
			else
				if p.count + count > provider:getMaxInventorySpace() then
					error("inventory full")
				end

				p.count = p.count + count
			end
		end
	end

	local step = function()
		local inventory = self.broker.inventories[provider]

		local item
		if merge then
			item = inventory:findFirst(id, true, noted, serializedUserdata)
		end

		local items
		if not item then
			items = {}
			if self.broker.manager:isStackable(id) or
			   (self.broker.manager:isNoteable(id) and noted)
			then
				items[1] = self.broker:addItem(provider, id, count, noted)
			else
				for i = 1, count do
					table.insert(items, self.broker:addItem(provider, id, count, noted))
				end
			end
		else
			item:setCount(item:getCount() + count)
			items = { item }
		end

		for i = 1, #items do
			self.items[items[i]:getRef()] = items[i]
			items[i]:setUserdata(serializedUserdata)

			local s, r = pcall(provider.onSpawn, provider, items[i], count)
			if not s then
				return false, r
			end
		end

		return true
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

function ItemBroker.Transaction:note(destination, id, count)
	local condition = function(state)
		assert(self.broker.manager:isNoteable(id), "item cannot be noted")
		assert(self.parties[destination], "destination inventory provider not party to transaction")
		assert(self.broker.manager:isNoteable(id), "item cannot be noted")

		local inventory = self.broker.inventories[destination]

		local items = { count = 0 }
		for item in inventory:findAll(id, self.broker.manager:isStackable(id), false) do
			table.insert(items, item)
			if #items >= count then
				assert(#items == count, "found more items than requested")
				break
			end

			items.count = items.count + item:getCount()
		end

		assert(count >= #items, "not enough items in inventory")

		local p = state[destination]
		for i = 1, #items do
			local destinationItem = inventory:findFirst(id, true, true, items[i]:getSerializedUserdata())
			if destinationItem then
				p.count = p.count - #items
			else
				p.count = p.count - #items + 1
			end
		end
	end

	local step = function()
		local inventory = self.broker.inventories[destination]

		local items = {}
		for item in inventory:findAll(id, self.broker.manager:isStackable(id), false) do
			table.insert(items, item)
			if #items >= count then
				assert(#items == count, "found more items than requested")
				break
			end
		end

		assert(count >= #items, "not enough items in inventory")

		for i = 1, #items do
			self.items[items[i]:getRef()] = items[i]

			local destinationItem = inventory:findFirst(id, true, true, items[i]:getSerializedUserdata())
			self.broker:removeItem(items[i])

			if not destinationItem then
				destinationItem = self.broker:addItem(destination, id, items[i]:getCount(), true)
				destinationItem:setUserdata(items[i]:getSerializedUserdata())
			else
				destinationItem:setCount(destinationItem:getCount() + items[i]:getCount())
			end

			self.items[destinationItem:getRef()] = destinationItem

			local s, r = pcall(destination.onNote, destination, destinationItem, items)
			if not s then
				return false, r
			end
		end

		return true
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

function ItemBroker.Transaction:unnote(item, count)
	local condition = function(state)
		local destination = self.broker:getItemProvider(item)
		assert(self.parties[destination], "destination inventory provider not party to transaction")
		assert(item:isNoted(), "item isn't noted")
		assert(count <= item:getCount(), "item stack too small")

		if self.broker.manager:isStackable(item:getID()) then
			local destinationItem = inventory:findFirst(id, true, false)
			if not destinationItem then
				local c = state[destination].count + 1

				if c > destination:getMaxInventorySpace() then
					error("inventory full")
				end

				p.count = c
			end
		else
			local c = state[destination].count
			if count >= item:getCount() then
				c = c - 1
			end

			c = c + count

			if c > destination:getMaxInventorySpace() then
				error("inventory full")
			end

			state[destination].count = c
		end
	end

	local step = function()
		local destination = self.broker:getItemProvider(item)
		local inventory = self.broker.inventories[destination]

		local serializedUserdata = item:getSerializedUserdata()

		if count >= item:getCount() then
			self.items[item:getRef()] = item
			self.broker:removeItem(item)
		end

		local items
		if self.broker.manager:isStackable(item:getID()) then
			local destinationItem = inventory:findFirst(item:getID(), true, false)
			if destinationItem then
				destinationItem:setCount(destinationItem:getCount() + count)
			else
				destinationItem = self.broker:addItem(destination, item:getID(), count, false)
			end

			items = { destinationItem }
		else
			items = {}
			for i = 1, count do
				local item = self.broker:addItem(destination, item:getID(), 1, false)
				table.insert(items, item)
			end
		end

		for i = 1, #items do
			self.items[items[i]:getRef()] = items[i]
			items[i]:setUserdata(serializedUserdata)
		end

		local s, r = pcall(destination.onUnnote, destination, item, items)
		if not s then
			return false, r
		end
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

function ItemBroker.Transaction:transfer(destination, item, count, purpose, merge)
	if merge == nil then
		merge = true
	end

	count = count or item:getCount()

	local condition = function(state)
		assert(self.broker:hasItem(item), "broker doesn't have item")

		local source = self.broker.items[item]
		assert(self.parties[source], "source inventory provider not party to transaction")
		assert(self.parties[destination], "destination inventory provider not party to transaction")
		assert(item:getCount() >= count, "count exceeds item count")
		
		local id = item:getID()
		local noted = item:isNoted()

		local logic = self.broker.manager:getLogic(id)
		if not logic:canSpawn(item, source) and not force then
			error("cannot spawn item")
		end

		local logic = self.broker.manager:getLogic(item:getID())
		if not logic:canTransfer(item, source, destination, purpose) then
			error("cannot transfer item")
		end

		if merge then
			local inventory = self.broker.inventories[destination]
			local item = inventory:findFirst(id, true, noted, item:getSerializedUserdata())
			if not item then
				if self.broker.manager:isStackable(id) or
				   (noted and self.broker.manager:isNoteable(id))
				then
					c = 1
				else
					assert(count == 1, "unstackable item is not singular")
					c = count -- This should be 1 but w/e
				end

				if state[destination].count + c > destination:getMaxInventorySpace() then
					error("inventory full")
				else
					local p = state[destination]
					p.count = p.count + c
				end
			else
				local p = state[destination]
				p.count = p.count + 1
			end
		end

		if item:getCount() == count then
			local p = state[source]
			p.count = p.count - 1
		end
	end

	local step = function()
		local source = self.broker.items[item]
		local id = item:getID()
		local noted = item:isNoted()

		local destinationItem
		if merge then
			local inventory = self.broker.inventories[destination]
			destinationItem = inventory:findFirst(id, true, noted, item:getSerializedUserdata())
		end

		if not destinationItem then
			if count == item:getCount() then
				destinationItem = item
			else
				destinationItem = self.broker:addItem(destination, id, count, noted)
				destinationItem:setUserdata(item:getSerializedUserdata())
			end
		else
			destinationItem:setCount(destinationItem:getCount() + count)
		end

		self.items[destinationItem:getRef()] = destinationItem

		local s, r = pcall(source.onTransferFrom, source, destination, item, count, purpose)
		if not s then
			io.stderr:write('error (onTransferFrom): ',  r, '\n')
		end

		if destinationItem ~= item then
			if count == item:getCount() then
				self.broker:removeItem(item)
			else
				item:setCount(item:getCount() - count)
			end
		else
			local sourceInventory = self.broker.inventories[source]
			local destinationInventory = self.broker.inventories[destination]

			sourceInventory:remove(item)
			destinationInventory:add(item)

			self.broker:moveItem(item, destination)
		end

		self.items[item:getRef()] = item

		s, r = pcall(destination.onTransferTo, destination, destinationItem, source, count, purpose)
		if not s then
			io.stderr:write('error (onTransferTo):', r, '\n')
			return false, r
		else
			return true
		end
	end

	table.insert(self.conditions, condition)
	table.insert(self.steps, step)
end

ItemBroker.Inventory = Class()

-- Creates a new Inventory for the specified Provider.
function ItemBroker.Inventory:new(provider)
	assert(provider ~= nil, "provider is nil")
	assert(provider:isCompatibleType(InventoryProvider), "provider is not derived from InventoryProvider")

	self.provider = provider
	self.items = {}
	self.keys = {}
	self.itemsByKey = {}
	self.zValues = {}
	self.itemsByZ = {}
	self.tags = {}
	self.count = 0
end

-- Gets the provider this Inventory belongs to.
function ItemBroker.Inventory:getProvider(provider)
	return self.provider
end

-- Gets the number of items in the inventory.
function ItemBroker.Inventory:getCount()
	return self.count
end

-- Adds an item 'item' to the inventory.
--
-- The item must not be in this Inventory.
function ItemBroker.Inventory:add(item)
	assert(not self:has(item), "item already in inventory")

	local zValue
	do
		local maxZ
		local minZ
		local zValues = {}
		for _, z in pairs(self.zValues) do
			zValues[z] = true
			minZ = math.min(minZ or z, z)
			maxZ = math.max(maxZ or z, z)
		end

		if not minZ or not maxZ then
			zValue = 1
		else
			if minZ > 1 then
				zValue = 1
			else
				for i = minZ, maxZ do
					if not zValues[i] then
						zValue = i
						break
					end
				end

				if not zValue then
					zValue = maxZ + 1
				end
			end
		end
	end

	self.items[item] = {}
	self.tags[item] = {}
	self.count = self.count + 1
	self.zValues[item] = zValue
	table.insert(self.itemsByZ, item)
	self:sortItems()
end

-- Removes item 'item' from the inventory.
--
-- The item must be in the inventory.
function ItemBroker.Inventory:remove(item)
	assert(self.items[item], "item not in inventory")

	self:unsetKey(item)

	self.items[item] = nil
	self.tags[item] = nil
	self.zValues[item] = nil
	self.count = self.count - 1

	for i = 1, #self.itemsByZ do
		if self.itemsByZ[i] == item then
			table.remove(self.itemsByZ, i)
			break
		end
	end

	assert(self.count >= 0, "critical logic error! count desynchronized")
end

-- Returns true if the item is in the Inventory, false otherwise.
function ItemBroker.Inventory:has(item)
	return self.items[item] ~= nil
end

-- Finds all the items in the inventory matching the arguments.
function ItemBroker.Inventory:findFirst(id, stackable, noted, serializedUserdata)
	return self:findAll(id, stackable, noted, serializedUserdata)()
end

-- Finds all the items in the inventory matching the arguments.
function ItemBroker.Inventory:findAll(id, stackable, noted, serializedUserdata)
	local iterator, current = self:iterate()
	return function()
		local item = iterator(current)
		current = item
		while item do
			if item:getID() == id
			   and item:isStackable() == stackable
			   and item:isNoted() == noted
			   and (not serializedUserdata or RPCState.deepEquals(item:getSerializedUserdata(), serializedUserdata))
			then
				return item
			else
				item = iterator(current)
				current = item
			end
		end
	end
end

-- Returns an iterator over the items in the Inventory.
function ItemBroker.Inventory:iterate()
	local index = 0
	return function()
		index = index + 1
		return self.itemsByZ[index]
	end
end

-- Iterates by key 'value'.
--
-- If no items match the key then an empty set iterator is returned. In other
-- words, the iterator will immediately terminate.
function ItemBroker.Inventory:iterateByKey(value)
	local key
	do
		-- TODO binary search
		for i = 1, #self.keys do
			if self.keys[i]:getValue() == value then
				key = self.keys[i]
				break
			end
		end
	end

	if key then
		return key:iterate()
	else
		return function() return nil end
	end
end

-- Iterates over the keys.
function ItemBroker.Inventory:iterateKeys()
	local index = 1
	return function()
		if index <= #self.keys then
			local key = self.keys[index]
			index = index + 1

			return key:getValue()
		else
			return nil
		end
	end
end

-- Tags 'item' with 'value' at 'key'.
function ItemBroker.Inventory:tag(item, key, value)
	assert(self:has(item), "item not in inventory")

	self.tags[item][key] = value
end

-- Untags 'item' with 'key'.
function ItemBroker.Inventory:untag(item, key)
	assert(self:has(item), "item not in inventory")

	self.tags[item][key] = nil
end

-- Returns an iterator over the tags for 'item'.
function ItemBroker.Inventory:getTags(item, key)
	assert(self:has(item), "item not in inventory")

	if key == nil then
		return pairs(self.tags[item])
	else
		return self.tags[item][key]
	end
end

-- Adds a key with 'value' to the Inventory.
--
-- If key already exists, does nothing.
--
-- Returns the key.
--
-- Internal method; do not call publicly.
function ItemBroker.Inventory:addKey(value)
	-- TODO binary search
	for i = 1, #self.keys do
		if self.keys[i]:getValue() == value then
			return self.keys[i]
		end
	end

	local key = ItemBroker.Key(value)
	table.insert(self.keys, key)
	table.sort(self.keys)

	return key
end

-- Gets the key for the item.
--
-- If the item has no key, nil is returned.
function ItemBroker.Inventory:getKey(value)
	return self.itemsByKey[value]
end

-- Assigns an item the specified key.
--
-- If the item already has a key, then the key will be changed.
--
-- The item must be in the inventory.
function ItemBroker.Inventory:setKey(item, key)
	assert(self:has(item), "item is not in inventory")

	self:unsetKey(item)

	if key then
		local k = self:addKey(key)
		k:add(item)

		self.itemsByKey[item] = k
	end
end

-- Unsets a key, if any.
--
-- The item must be in the inventory.
function ItemBroker.Inventory:unsetKey(item)
	assert(self:has(item), "item is not in inventory")

	local k = self.itemsByKey[item]
	if k then
		k:remove(item)

		if k:isEmpty() then
			for i = 1, #self.keys do
				if self.keys[i] == k then
					table.remove(self.keys, i)
					break
				end
			end
		end

		self.itemsByKey[item] = nil
	end
end

function ItemBroker.Inventory:setZ(item, value)
	assert(self:has(item), "item is not in inventory")

	self.zValues[item] = value
	self:sortItems()
end

function ItemBroker.Inventory:getZ(item)
	assert(self:has(item), "item is not in inventory")

	return self.zValues[item] or 0
end

function ItemBroker.Inventory:sortItems()
	table.sort(self.itemsByZ, function(a, b)
		return self:getZ(a) < self:getZ(b)
	end)
end

ItemBroker.Key = Class()

-- Constructs a key with the specified value.
--
-- value should implement the less-than operator.
--
-- Any two Keys with the same value should be considered equal.
function ItemBroker.Key:new(value)
	self.value = value
	self.items = {}
end

-- Gets the value of this key.
function ItemBroker.Key:getValue()
	return self.value
end

-- Adds 'item' to this key. Does nothing if the item already is added.
function ItemBroker.Key:add(item)
	if not self.items[item] then
		table.insert(self.items, item)
		self.items[item] = true
	end
end

-- Removes 'item' from this key. Does nothing if the item is not added.
function ItemBroker.Key:remove(item)
	if self.items[item] then
		for i = 1, #self.items do
			if self.items[i] == item then
				table.remove(self.items, i)
				break
			end
		end

		self.items[item] = nil
	end
end

function ItemBroker.Key:iterate()
	local index = 1
	return function()
		if index <= #self.items then
			local result = self.items[index]
			index = index + 1

			return result
		else
			return nil
		end
	end
end

function ItemBroker.Key:isEmpty()
	return #self.items == 0
end

-- Comparison operator; returns a:getValue() < b:getValue().
function ItemBroker.Key._METATABLE.__lt(a, b)
	return a.value < b.value
end

-- Constructs a new ItemBroker instance.
function ItemBroker:new(manager)
	self.manager = manager
	self.items = {}
	self.itemRefs = { n = 1 }
	self.inventories = {}
end

-- Returns the number of inventory slots used by the provider.
function ItemBroker:count(provider)
	local inventory = self.inventories[provider]
	return inventory:getCount()
end

-- Internal. Adds an item to the provider.
--
-- Fails if adding the item would exceed the provider's max inventory space.
function ItemBroker:addItem(provider, id, count, noted)
	assert(provider ~= nil, "provider cannot be nil")
	assert(self:hasProvider(provider), "provider does not exist")
	assert(count >= 0, "count must be greater than or equal to 1")

	local inventory = self.inventories[provider]
	if inventory:getCount() > provider:getMaxInventorySpace() then
		assert(inventory:getCount() <= provider:getMaxInventorySpace(), "inventory somehow exceeded")
		error("inventory full")
	end

	local ref = self.itemRefs.n

	local item = ItemInstance(id, ref, self.manager)
	if noted then
		item:note()
	end
	item:setCount(count or 1)

	self.items[item] = provider
	self.itemRefs[item] = ref
	self.inventories[provider]:add(item)

	self.itemRefs.n = ref + 1

	return item
end

-- Internal. Removes an item from the broker.
function ItemBroker:removeItem(item)
	assert(self:hasItem(item), "item does not exist in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]

	inventory:remove(item)
	self.items[item] = nil
	self.itemRefs[item] = nil
end

function ItemBroker:moveItem(item, provider)
	assert(self:hasItem(item), "item does not exist in broker")

	self.items[item] = provider
end

function ItemBroker:hasItem(item)
	if item and self.items[item] ~= nil then
		return true
	end

	return false
end

function ItemBroker:getItemRef(item)
	assert(self:hasItem(item), "item does not exist in broker")

	return self.itemRefs[item]
end

-- Adds a provider, 'provider', to the ItemBroker.
--
-- If provider.load fails, then the error is propagated. In such a case, the
-- provider is not added.
function ItemBroker:addProvider(provider, skipSerialize)
	assert(provider ~= nil, "provider cannot be nil")
	assert(Class.isCompatibleType(provider, InventoryProvider), "provider must be derived from InventoryProvider")
	assert(not self:hasProvider(provider), "provider already exists")

	self.inventories[provider] = ItemBroker.Inventory(provider)
	provider:attach(self)

	if provider:getIsSerializable() and not skipSerialize then
		local s, r = xpcall(function() provider:load(self) end, debug.traceback)
		if not s then
			self.inventories[provider] = nil
			error(r)
		end
	end
end

-- Removes a provider, 'provider', from the ItemBroker.
--
-- The provider must previously have been added (see ItemBroker.addProvider).
--
-- If provider.unload fails, then the error is propagated. Regardless, the
-- provider is removed from the Inventory and all ItemInstances are removed.
function ItemBroker:removeProvider(provider, skipSerialize)
	assert(provider ~= nil, "provider cannot be nil")
	assert(self:hasProvider(provider), "provider does not exist")

	local s, r
	if provider:getIsSerializable() and not skipSerialize then
		s, r = xpcall(function() provider:unload(self, true) end, debug.traceback)
	else
		s = true
	end

	provider:detach(self)

	local inventory = self.inventories[provider]
	for item in inventory:iterate() do
		self.items[item] = nil
	end
	self.inventories[provider] = nil

	if not s then
		error(r)
	end
end

-- Returns true if the provider has been previously added, false otherwise.
function ItemBroker:hasProvider(provider)
	assert(provider ~= nil, "provider cannot be nil")
	return self.inventories[provider] ~= nil
end

function ItemBroker:getItemProvider(item)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	return self.items[item]
end

-- Removes a provider, 'provider', from the ItemBroker.
--
-- The provider must previously have been added (see ItemBroker.addProvider).
function ItemBroker:iterateItems(provider)
	assert(provider ~= nil, "provider cannot be nil")
	assert(self:hasProvider(provider), "provider does not exist")

	return self.inventories[provider]:iterate()
end

-- Returns an iterator that iterators over items assigned 'key'.
function ItemBroker:iterateItemsByKey(provider, key)
	assert(provider ~= nil, "provider cannot be nil")
	assert(self:hasProvider(provider), "provider does not exist")

	return self.inventories[provider]:iterateByKey(key)
end

-- Counts how many items are stored at 'key'.
function ItemBroker:countItemsByKey(provider, key)
	local count = 0
	for item in self:iterateItemsByKey(provider, key) do
		count = count + 1
	end
	return count
end

function ItemBroker:countItems(provider)
	local count = 0
	for item in self:iterateItems(provider) do
		count = count + 1
	end
	return count
end

-- Returns an iterator over the tags assigned to 'item'.
function ItemBroker:tags(item)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local inventory = self.items[item]
	return inventory:tags(item)
end

-- Returns an iterator over the keys assigned to 'provider'.
--
-- The keys will be in the order for least to greatest, whatever that means. For
-- an integer key, this will be smallest to largest, for example.
function ItemBroker:keys(provider)
	assert(provider ~= nil, "provider cannot be nil")
	assert(self:hasProvider(provider), "provider does not exist")

	local inventory = self.inventories[provider]
	return inventory:iterateKeys()
end

-- Sets the key for 'item'.
function ItemBroker:setItemKey(item, key)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	return inventory:setKey(item, key)
end

-- Gets the key for 'item'.
function ItemBroker:getItemKey(item)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	local key = inventory:getKey(item)
	if key then
		return key:getValue()
	else
		return nil
	end
end

-- Sets the 'Z' (or sorting order) for 'item'.
function ItemBroker:setItemZ(item, value)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	return inventory:setZ(item, value)
end

-- Gets the 'Z' (or sorting order) for 'item'.
function ItemBroker:getItemZ(item)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	inventory:getZ(item)
end

-- Sets a tag 'key' with value 'value' for the item 'item'.
function ItemBroker:tagItem(item, key, value)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	return inventory:tag(item, key, value)
end

-- Unsets tag, 'key', belonging to the item.
function ItemBroker:untagItem(item, key)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	return inventory:untag(item, key)
end

-- Gets tag, 'key', belonging to the item.
function ItemBroker:getItemTag(item, key)
	assert(item ~= nil, "item is nil")
	assert(self:hasItem(item), "item not in broker")

	local provider = self.items[item]
	local inventory = self.inventories[provider]
	return inventory:getTags(item, key)
end

function ItemBroker:toStorage()
	for provider in pairs(self.inventories) do
		if provider:getIsSerializable() then
			local s, r = xpcall(function() provider:unload(self, false) end, debug.traceback)

			if not s then
				Log.warn("Couldn't serialize provider: %s", r)
			end
		end
	end
end

function ItemBroker:itemFromStorage(provider, storage)
	local key = storage:get("item-key")
	local count = storage:get("item-count")
	local id = storage:get("item-id")
	local noted = storage:get("item-noted")
	local userdata = storage:getSection("item-userdata")

	if count ~= nil and id ~= nil and noted ~= nil then
		local item = self:addItem(provider, id, count, noted)
		item:setUserdata(userdata:get())

		if key then
			self:setItemKey(item, key)
		end

		return item
	end

	return nil
end

function ItemBroker:itemToStorage(item, storage, key)
	local itemStorage = storage:getSection(key)
	itemStorage:set({
		["item-key"] = key,
		["item-id"] = item:getID(),
		["item-noted"] = item:isNoted(),
		["item-count"] = item:getCount()
	})

	local userdata = item:getSerializedUserdata()
	if userdata then
		itemStorage:set("item-userdata", userdata)
	end

	return itemStorage
end

-- Creates a transaction.
--
-- The transaction is not executed until Transaction.commit is called.
function ItemBroker:createTransaction()
	return ItemBroker.Transaction(self)
end

return ItemBroker
