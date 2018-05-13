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

function TextInput:new()
	Widget.new(self)
	self.cursorIndex = 1
	self.cursorLength = 0
	self.isShiftDown = 0
end

function TextInput:getCursor()
	return self.cursorIndex, self.cursorLength
end

function TextInput:getLeftCursor()
	return self.cursorIndex
end

function TextInput:getRightCursor()
	return self.cursorIndex + self.cursorLength
end

function TextInput:setCursor(index, length)
	index = index or 1
	length = length or 0

	self.cursorIndex = math.max(math.min(index, #self.text), 1)
	self.cursorLength = math.max(math.min(index + length, #self.text) - index, 0)
end

function TextInput:select(a, b)
	local left = math.min(a, b)
	local right = math.max(a, b)

	self:setCursor(left, right - left)
end

function TextInput:slideSelection(amount)
	if amount < 0 then
		if self.cursorIndex > 1 then
			self.cursorIndex = self.cursorIndex - 1
			self.cursorLength = self.cursorLength + 1
		end
	elseif amount > 0 then
		if self.cursorIndex + self.cursorLength < #self.text then
			self.cursorLength = self.cursorLength + 1
		end
	end
end

function TextInput:moveCursor(amount)
	self:setCursor(self.cursorIndex + amount, 0)
end

function TextInput:keyPress(key, scan, isRepeat, ...)
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
			self:select(1, self:getRightCursor())
		else
			self:setCursor(1)
		end
	elseif key == 'end' then
		if self.isShiftDown > 0 then
			self:select(self:getLeftCursor(), #self.text)
		else
			self:setCursor(#self.text)
		end
	elseif key == 'backspace' then
		if self.cursorIndex + self.cursorLength == #self.text and
		   #self.text > 0
		then
			self.text = self.text:sub(1, #self.text - math.max(self.cursorLength, 1))
		elseif self.cursorIndex > 1 then
			self.text = self.text:sub(1, self.cursorIndex - 1) +
			            self.text:sub(self.cursorIndex - 1 + math.max(self.cursorLength, 1))
			self:moveCursor(self:getLeftCursor() - 1)
		end
	elseif (key == 'lshift' or key == 'rshift') and not isRepeat then
		self.isShiftDown = self.isShiftDown + 1
	elseif key == 'tab' then
		return false
	end

	Widget.keyPress(self, key, scan, isRepeat, ...)
	return true
end

function TextInput:keyRelease(key, ...)
	if key == 'lshift' or key == 'rshift' then
		self.isShiftDown = self.isShiftDown - 1
	end

	Widget.keyRelease(self, key, ...)
end

function TextInput:type(text, ...)
	self.text = self.text:sub(0, self:getLeftCursor()) +
	            text +
	            self.text:sub(self:getRightCursor())
	self:setCursor(self:getLeftCursor() + 1)

	Widget.type(self, text, ...)
end

return TextInput
