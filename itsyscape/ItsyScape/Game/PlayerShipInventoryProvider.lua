--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerShipInventoryProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"

local PlayerShipInventoryProvider = Class(InventoryProvider)

function PlayerShipInventoryProvider:new(peep)
	InventoryProvider.new(self)

	self.peep = peep
end

function PlayerShipInventoryProvider:getPeep()
	return self.peep
end

function PlayerShipInventoryProvider:getMaxInventorySpace()
	return Sailing.Ship.getInventorySpace(self.peep)
end

function PlayerShipInventoryProvider:assignKey(item)
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

function PlayerShipInventoryProvider:onSpawn(item, count)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function PlayerShipInventoryProvider:onTransferTo(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

function PlayerShipInventoryProvider:onTransferFrom(destination, item, count, purpose)
	-- Nothing.
end

function PlayerShipInventoryProvider:onUnnote(item, items)
	for i = 1, #items do
		self:assignKey(items[i])
	end
end

function PlayerShipInventoryProvider:onNote(item)
	self:assignKey(item)
end

function PlayerShipInventoryProvider:load(...)
	InventoryProvider.load(self, ...)

	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Ship")
	if storage then
		for key, section in storage:iterateSections() do
			local item = broker:itemFromStorage(self, section)
			broker:setItemZ(item, broker:getItemKey(item))
		end
	end
end

function PlayerShipInventoryProvider:unload(...)
	local broker = self:getBroker()

	local storage = Utility.Item.getStorage(self.peep, "Ship", true)
	if storage then
		for item in broker:iterateItems(self) do
			local key = broker:getItemKey(item)
			broker:itemToStorage(item, storage, key)
		end
	end

	InventoryProvider.unload(self, ...)
end

return PlayerShipInventoryProvider
