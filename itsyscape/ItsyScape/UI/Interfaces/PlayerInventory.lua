--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerInventory.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"
local InventoryItemButton = require "ItsyScape.UI.InventoryItemButton"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"

local PlayerInventory = Class(Interface)

function PlayerInventory:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.buttons = {}
	self.numItems = 0
	self.onInventoryResized = Callback()

	self.panel = Panel()
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)
end

function PlayerInventory:poke(actionID, actionIndex, e)
	if not Interface.poke(self, actionID, actionIndex, e) then
		-- Nothing.
	end
end

function PlayerInventory:getNumItems()
	return self.numItems
end

function PlayerInventory:setNumItems(value)
	value = value or self.numItems
	assert(value >= 0 and value < math.huge, "too many or too little inventory value")

	if value ~= #self.buttons then
		if value < #self.buttons then
			while #self.buttons > value do
				local top = #self.buttons

				top.onDrop:unregister(self.swap)
				self:removeChild(self.buttons[top])

				table.remove(self.buttons, top)
			end
		else
			for i = #self.buttons + 1, value do
				local button = InventoryItemButton()
				button:getIcon():setData('index', i)
				button:getIcon():bind("itemID", "items[{index}].id")
				button:getIcon():bind("itemCount", "items[{index}].count")
				button:getIcon():bind("itemIsNoted", "items[{index}].noted")

				button.onDrop:register(self.swap, self)
				button.onDrag:register(self.drag, self)
				button.onLeftClick:register(self.activate, self)

				self:addChild(button)
				table.insert(self.buttons, button)
			end
		end

		self.onInventoryResized(self, #self.buttons)
	end

	self:performLayout()

	self.numItems = value
end

function PlayerInventory:performLayout()
	local width, height = self:getSize()
	local padding = 8
	local x, y = 0, padding

	for _, child in ipairs(self.buttons) do
		local childWidth, childHeight = child:getSize()
		if x > 0 and x + childWidth + InventoryItemButton.DEFAULT_PADDING > width then
			x = 0
			y = y + childHeight + padding
		end

		child:setPosition(x + padding, y)
		x = x + childWidth + padding
	end

	self.panel:setSize(width, height)
end

function PlayerInventory:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getIcon() then
		self:getView():getRenderManager():setCursor(button:getIcon())
	end
end

function PlayerInventory:swap(button, x, y)
	local index = button:getIcon():getData('index')
	if index then
		local width, height = self:getSize()
		if x >= 0 and y >= 0 and x <= width and y <= height then
			local buttonSize = InventoryItemButton.DEFAULT_SIZE + 8
			
			local i = math.floor(x / buttonSize)
			local j = math.floor(y / buttonSize)
			local newIndex = j * math.max(math.floor(width / buttonSize), 1) + i + 1

			self:sendPoke("swap", nil, { a = index, b = newIndex })
		end
	end

	if self:getView():getRenderManager():getCursor() == button:getIcon() then
		self:getView():getRenderManager():setCursor(nil)
	end
end

function PlayerInventory:activate(button)
	local index = button:getIcon():getData('index')
	if index then
		self:sendPoke("activate", nil, { index = index })
	end
end

return PlayerInventory