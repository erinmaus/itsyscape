--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerInventoryProvider.lua
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

local PlayerInventoryProvider = Class(InventoryProvider)
PlayerInventoryProvider.MAX_INVENTORY_SPACE = 28

function PlayerInventoryProvider:new(peep, slots)
	InventoryProvider.new(self)

	self.peep = peep
	self.slots = slots or PlayerInventoryProvider.MAX_INVENTORY_SPACE
end

function PlayerInventoryProvider:getPeep()
	return self.peep
end

function PlayerInventoryProvider:getMaxInventorySpace()
	return self.slots
end

function PlayerInventoryProvider:assignKey(item)
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

function PlayerInventoryProvider:onSpawn(item, count)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end

	self:getPeep():poke('spawnItem', {
		item = item,
		count = count
	})
end

function PlayerInventoryProvider:onTransferTo(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end

	self:getPeep():poke('transferItemTo', {
		source = source:getPeep(),
		item = item,
		count = count,
		purpose = purpose
	})
end

function PlayerInventoryProvider:onTransferFrom(destination, item, count, purpose)
	self:getPeep():poke('transferItemFrom', {
		destination = destination:getPeep(),
		item = item,
		count = count,
		purpose = purpose
	})
end

function PlayerInventoryProvider:onUnnote(item, items)
	for i = 1, #items do
		self:assignKey(items[i])
	end
end

function PlayerInventoryProvider:onNote(item)
	self:assignKey(item)
end

function PlayerInventoryProvider:load(...)
	InventoryProvider.load(self, ...)

	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Player")
	if storage then
		for key, section in storage:iterateSections() do
			local item = broker:itemFromStorage(self, section)
			broker:setItemZ(item, broker:getItemKey(item))
		end
	end
end

function PlayerInventoryProvider:unload(...)
	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Player", true)
	if storage then
		for item in broker:iterateItems(self) do
			local key = broker:getItemKey(item)
			broker:itemToStorage(item, storage, key)
		end
	end

	InventoryProvider.unload(self, ...)
end

return PlayerInventoryProvider
