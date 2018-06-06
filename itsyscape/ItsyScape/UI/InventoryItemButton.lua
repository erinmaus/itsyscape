--------------------------------------------------------------------------------
-- ItsyScape/UI/InventoryItemButton.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Widget = require "ItsyScape.UI.Widget"
local ItemIcon = require "ItsyScape.UI.ItemIcon"

local InventoryItemButton = Class(Widget)
InventoryItemButton.DEFAULT_ICON_SIZE = 48
InventoryItemButton.DEFAULT_PADDING = 2
InventoryItemButton.DEFAULT_SIZE = InventoryItemButton.DEFAULT_ICON_SIZE + InventoryItemButton.DEFAULT_PADDING * 2

function InventoryItemButton:new()
	Widget.new(self)

	self.onLeftClick = Callback()
	self.onRightClick = Callback()
	self.onDrop = Callback()
	self.onDrag = Callback()
	self.button = 0
	self.isMouseOver = false
	self.isPressed = false
	self.isDragging = false
	self.mouseX = 0
	self.mouseY = 0
	self.dragX = 0
	self.dragY = 0

	self.icon = ItemIcon()
	self.icon:setSize(
		InventoryItemButton.DEFAULT_ICON_SIZE,
		InventoryItemButton.DEFAULT_ICON_SIZE)
	self.icon:setPosition(
		InventoryItemButton.DEFAULT_PADDING,
		InventoryItemButton.DEFAULT_PADDING)
	self:addChild(self.icon)

	self:setSize(
		InventoryItemButton.DEFAULT_SIZE,
		InventoryItemButton.DEFAULT_SIZE)
end

function InventoryItemButton:getIsFocusable()
	return true
end

function InventoryItemButton:getIcon()
	return self.icon
end

function InventoryItemButton:getOverflow()
	return true
end

function InventoryItemButton:mouseEnter(...)
	self.isMouseOver = true
	Widget.mouseEnter(self, ...)
end

function InventoryItemButton:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function InventoryItemButton:mousePress(x, y, button)
	if button == 1 or button == 2 then
		if not self.isPressed then
			self.button = button
			self.isPressed = true
			self.mouseX = x
			self.mouseY = y
			self.dragX = 0
			self.dragY = 0
		end
	end
end

function InventoryItemButton:mouseRelease(x, y, button, ...)
	if button == self.button and self.isPressed then
		if self.button == 1 then
			if self.isDragging then
				local s, t = self:getPosition()
				local u, v = self.dragX, self.dragY
				self.onDrop(self, s + u, t + v)
			elseif self.isMouseOver then
				self.onClick(self)
			end
		elseif self.button == 2 and self.isMouseOver then
			self.onRightClick(self)
		end
	end

	self.isPressed = false
	self:blur()

	self.icon:setPosition(2, 2)

	Widget.mouseRelease(self, x, y, button, ...)
end

function InventoryItemButton:mouseMove(x, y, ...)
	if self.isPressed and self.button == 1 then
		self.isDragging = true

		local s, t = self.dragX, self.dragY
		s = s + (x - self.mouseX)
		t = t + (y - self.mouseY)
		self.onDrag(self, s, t)

		self.dragX = s
		self.dragY = t

		self.mouseX = x
		self.mouseY = y
	end

	Widget.mouseMove(self, x, y, ...)
end

function InventoryItemButton:focus(e)
	if e == 'key' then
		self:blur()
	end
end

return InventoryItemButton
