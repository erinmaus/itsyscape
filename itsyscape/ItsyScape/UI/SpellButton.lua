--------------------------------------------------------------------------------
-- ItsyScape/UI/SpellButton.lua
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
local SpellIcon = require "ItsyScape.UI.SpellIcon"

local SpellButton = Class(Widget)
SpellButton.DEFAULT_ICON_SIZE = 48
SpellButton.DEFAULT_PADDING = 2
SpellButton.DEFAULT_SIZE = SpellButton.DEFAULT_ICON_SIZE + SpellButton.DEFAULT_PADDING * 2

function SpellButton:new()
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

	self.icon = SpellIcon()
	self.icon:setSize(
		SpellButton.DEFAULT_ICON_SIZE,
		SpellButton.DEFAULT_ICON_SIZE)
	self.icon:setPosition(
		SpellButton.DEFAULT_PADDING,
		SpellButton.DEFAULT_PADDING)
	self:addChild(self.icon)

	self:setSize(
		SpellButton.DEFAULT_SIZE,
		SpellButton.DEFAULT_SIZE)
end

function SpellButton:getIsFocusable()
	return true
end

function SpellButton:getIcon()
	return self.icon
end

function SpellButton:getOverflow()
	return true
end

function SpellButton:mouseEnter(...)
	self.isMouseOver = true
	Widget.mouseEnter(self, ...)
end

function SpellButton:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function SpellButton:mousePress(x, y, button)
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

function SpellButton:mouseRelease(x, y, button, ...)
	if button == self.button and self.isPressed then
		if self.button == 1 then
			if self.isDragging then
				local s, t = self:getPosition()
				local u, v = self.dragX, self.dragY
				self.onDrop(self, s + u, t + v)
			elseif self.isMouseOver then
				self.onLeftClick(self)
			end
		elseif self.button == 2 and self.isMouseOver then
			self.onRightClick(self)
		end
	end

	self.isPressed = false
	self.isDragging = false
	self:blur()

	self.icon:setPosition(2, 2)

	Widget.mouseRelease(self, x, y, button, ...)
end

function SpellButton:mouseMove(x, y, ...)
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

function SpellButton:focus(e)
	if e == 'key' then
		self:blur()
	end
end

return SpellButton
