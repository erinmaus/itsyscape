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
local InventoryProvider = require "ItsyScape.Game.InventoryProvider"

local PlayerInventoryProvider = Class(InventoryProvider)
PlayerInventoryProvider.MAX_INVENTORY_SPACE = 28

function PlayerInventoryProvider:new(peep, slots)
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
end

function PlayerInventoryProvider:onSpawn(item, count)
	self:assignKey(item)
end

function PlayerInventoryProvider:onTransfer(item, source, count, purpose)
	local index = self:getBroker():getItemKey(item)
	if index == nil then
		self:assignKey(item)
	end
end

return PlayerInventoryProvider
