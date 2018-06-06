--------------------------------------------------------------------------------
-- ItsyScape/UI/Inventory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Widget = require "ItsyScape.UI.Widget"
local InventoryItemButton = require "ItsyScape.UI.InventoryItemButton"

local Inventory = Class(Widget)

function Inventory:new()
	Widget.new(self)

	self.numItems = 0
	self.buttons = {}
	self.onInventoryResized = Callback()
end

function Inventory:getNumItems()
	return self.numItems
end

function Inventory:setNumItems(value)
	value = value or self.numItems
	assert(value >= 0 and value < math.huge, "too many or too little inventory value")

	if value ~= #self.buttons then
		if value < #self.buttons then
			while #self.buttons > value do
				local top = #self.buttons
				self:removeChild(self.buttons[top])
				table.remove(self.buttons, top)
			end
		else
			for i = #self.buttons, value do
				local button = InventoryItemButton()
				button:getIcon():setData('index', i)
				button:getIcon():bind("itemID", "items[{index}].id")
				button:getIcon():bind("itemCount", "items[{index}].count")
				button:getIcon():bind("itemIsNoted", "items[{index}].noted")

				self:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onInventoryResized(self, #self.buttons)
	end

	self.numItems = value
end

return Inventory
