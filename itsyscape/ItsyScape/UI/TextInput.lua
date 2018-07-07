--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInput.lua
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

local TextInput = Class(Widget)
TextInput.CURSOR_LEFT  = 1
TextInput.CURSOR_RIGHT = 2

function TextInput:new()
	Widget.new(self)
	self.onValueChanged = Callback()
	self.onSubmit = Callback()
	self.cursorIndex = 1
	self.cursorLength = 0
	self.isShiftDown = 0
	self.isMouseOver = false
	self.isPressed = false
end

function TextInput:getActiveCursor()
	if self.cursorLength < 0 then
		return TextInput.CURSOR_LEFT
	else
		return TextInput.CURSOR_RIGHT
	end
end

function TextInput:getIsFocusable()
	return true
end

function TextInput:mouseEnter(...)
	self.isMouseOver = true
	Widget.mouseEnter(self, ...)
end

function TextInput:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function TextInput:getCursor()
	return self.cursorIndex, self.cursorLength
end

function TextInput:getLeftCursor()
	return math.min(self.cursorIndex, self.cursorIndex + self.cursorLength)
end

function TextInput:getRightCursor()
	return math.max(self.cursorIndex, self.cursorIndex + self.cursorLength)
end

function TextInput:setCursor(index, length)
	index = index or 1
	length = length or 0

	self.cursorIndex = math.max(math.min(index, #self.text), 0)
	self.cursorLength = math.max(math.min(self.cursorIndex + length, #self.text) - self.cursorIndex, -#self.text)
end

function TextInput:select(a, b)
	local index = a
	local length = b - a

	self:setCursor(index, length)
end

function TextInput:slideSelection(amount)
	self:setCursor(self.cursorIndex, self.cursorLength + amount)
end

function TextInput:moveCursor(amount)
	if self:getLeftCursor() == self:getRightCursor() then
		self:setCursor(self.cursorIndex + amount, 0)
	else
		if self:getActiveCursor() == TextInput.CURSOR_LEFT then
			self:setCursor(self:getLeftCursor() + amount, 0)
		else
			self:setCursor(self:getRightCursor() + amount, 0)
		end
	end
end

function TextInput:keyDown(key, scan, isRepeat, ...)
	if key == 'left' then
		if self.isShiftDown > 0 then
			self:slideSelection(-1)
		else
			self:moveCursor(-1)
		end
	elseif key == 'right' then
		if self.isShiftDown > 0 then
			self:slideSelection(1)
		else
			self:moveCursor(1)
		end
	elseif key == 'home' then
		if self.isShiftDown > 0 then
			self:select(self.cursorIndex, 0)
		else
			self:setCursor(0)
		end
	elseif key == 'end' then
		if self.isShiftDown > 0 then
			self:select(self.cursorIndex, #self.text)
		else
			self:setCursor(#self.text)
		end
	elseif key == 'backspace' then
		if false then
		if self.cursorIndex + self.cursorLength == #self.text and
		   #self.text > 0
		then
			self.text = self.text:sub(1, #self.text - math.max(self.cursorLength, 1))
			self.onValueChanged(self, self.text)
		elseif self.cursorIndex > 1 then
			if self.cursorIndex > #self.text then
				self.text = self.text:sub(1, self.cursorIndex - 2)
			else
				self.text = self.text:sub(1, self.cursorIndex - 1) ..
			                self.text:sub(self.cursorIndex - 1 + math.max(self.cursorLength, 1))
			end
			self.onValueChanged(self, self.text)
			self:moveCursor(self:getLeftCursor() - 1)
		end end

		if self.cursorLength == 0 then
			self.text = self.text:sub(1, self.cursorIndex - 1) ..
			            self.text:sub(self.cursorIndex + 1)
			self.onValueChanged(self, self.text)
			self.cursorIndex = self.cursorIndex - 1
		else
			self.text = self.text:sub(1, self:getLeftCursor()) ..
			            self.text:sub(self:getRightCursor() + 1)
			self.onValueChanged(self, self.text)
		end
		self:setCursor(self:getLeftCursor(), 0)
	elseif (key == 'lshift' or key == 'rshift') and not isRepeat then
		self.isShiftDown = self.isShiftDown + 1
	elseif key == 'return' and not isRepeat then
		self.onSubmit(self, self.text)
	elseif key == 'tab' then
		return false
	end

	Widget.keyDown(self, key, scan, isRepeat, ...)
	return true
end

function TextInput:keyUp(key, ...)
	if key == 'lshift' or key == 'rshift' then
		self.isShiftDown = self.isShiftDown - 1
	end

	Widget.keyUp(self, key, ...)
end

function TextInput:type(text, ...)
	local left = self:getLeftCursor()
	local right = self:getRightCursor()

	self.text = self.text:sub(1, self:getLeftCursor()) ..
	            text ..
	            self.text:sub(self:getRightCursor() + 1)
	self.onValueChanged(self, self.text)
	self:setCursor(self:getLeftCursor() + 1, 0)

	Widget.type(self, text, ...)
end

return TextInput
