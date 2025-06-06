--------------------------------------------------------------------------------
-- ItsyScape/UI/DraggableButton.lua
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

local DraggableButton = Class(Widget)
DraggableButton.DEFAULT_DRAG_DISTANCE = 6

function DraggableButton:new()
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
	self.offsetX = 0
	self.offsetY = 0
	self.dragDistance = DraggableButton.DEFAULT_DRAG_DISTANCE
end

function DraggableButton:getDragDistance()
	return self.dragDistance
end

function DraggableButton:setDragDistance(value)
	self.dragDistance = value or self.dragDistance
end

function DraggableButton:getIsDraggable()
	return true
end

function DraggableButton:getIsFocusable()
	return true
end

function DraggableButton:mouseEnter(...)
	self.isMouseOver = true
	Widget.mouseEnter(self, ...)
end

function DraggableButton:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function DraggableButton:mousePress(x, y, button)
	if button == 1 or button == 2 then
		if not self.isPressed then
			self.button = button
			self.isMouseOver = true
			self.isPressed = true
			self.mouseX = x
			self.mouseY = y
			self.dragX = 0
			self.dragY = 0

			local absoluteX, absoluteY = self:getAbsolutePosition()
			self.offsetX = x - absoluteX
			self.offsetY = y - absoluteY
		end
	end
end

function DraggableButton:mouseRelease(x, y, button, ...)
	if button == self.button and self.isPressed then
		if self.button == 1 then
			if self.isDragging then
				local s, t = self:getPosition()
				local z, w = self:getAbsolutePosition()
				local u, v = self.dragX, self.dragY
				self.onDrop(
					self,
					s + u + self.offsetX,
					t + v + self.offsetY,
					z + u + self.offsetX,
					w + v + self.offsetY)
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

	Widget.mouseRelease(self, x, y, button, ...)
end

function DraggableButton:mouseMove(x, y, ...)
	if self.isPressed and self.button == 1 then
		local distanceSquared = (self.mouseX - x) ^ 2 + (self.mouseY - y) ^ 2
		if distanceSquared >= self.dragDistance * self.dragDistance then
			self.isDragging = true

			local s, t = self.dragX, self.dragY
			local u, v = self:getPosition()
			s = s + (x - self.mouseX)
			t = t + (y - self.mouseY)
			self.onDrag(self, s, t, s + u + self.offsetX, t + v + self.offsetY)

			self.dragX = s
			self.dragY = t

			self.mouseX = x
			self.mouseY = y
		end
	end

	Widget.mouseMove(self, x, y, ...)
end

function DraggableButton:gamepadRelease(joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if button == inputProvider:getKeybind("gamepadPrimaryAction") then
			self:onLeftClick()
		elseif button == inputProvider:getKeybind("gamepadSecondaryAction") then
			self:onRightClick()
		end
	end

	Widget.gamepadRelease(self, joystick, button)
end

return DraggableButton
