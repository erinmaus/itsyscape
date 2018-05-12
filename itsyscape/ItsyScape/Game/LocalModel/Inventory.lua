--------------------------------------------------------------------------------
-- ItsyScape/Game/Body.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Inventory = require "ItsyScape.Game.Model.Inventory"

local LocalInventory = Class(Inventory)
LocalInventory.DEFAULT_QUANTITY = 28

function LocalInventory:new(quantity)
	quantity = quantity or LocalInventory.DEFAULT_QUANTITY
	if quantity < 1 then
		quantity = 1
	end

	self.quantity = quantity
	self.items = {}
	for i = 1, self.quantity do
		self.items[i] = false
	end
end

function LocalInventory:add(item)
	for i = 1, self.quantity do
		local slot = self.items[i]
		if slot and
		   slot:getID() == item:getID() and 
		   slot:isNoted() == item:isNoted() and
		   slot:isStackable() then
		then
			local quantity = item:getQuantity() + slot:getQuantity()
			slot:setQuantity(quantity)
			
			return true
		end
	end

	for i = 1, #self.quantity do
		local slot = self.items[i]
		if slot == false then
			self.items[i] = item
			return true
		end
	end

	return false
end

function LocalInventory:remove(index)
	if self.items[index] then
		local item = self.items[index]
		self.items[index] = false

		return item
	end

	return nil
end

function LocalInventory:hasItem(index)
	return self.items[index] ~= false
end

function LocalInventory:getItem(index)
	local item = self.items[index]
	if item then
		return item
	else
		return nil
	end
end

function LocalInventory:swap(a, b)
	if a > 0 and a <= self.quantity and
	   b > 0 and b <= self.quantity
	then
		local t = self.items[a]
		self.items[a] = self.items[b]
		self.items[b] = t

		return true
	end

	return false
end

return LocalInventory
