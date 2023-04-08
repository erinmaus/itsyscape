--------------------------------------------------------------------------------
-- ItsyScape/UI/TextInput.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local utf8 = require "utf8"
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
	self.cursorIndex = 0
	self.cursorLength = 0
	self.isShiftDown = 0
	self.isMouseOver = false
	self.isPressed = false
end

function TextInput:focus(...)
	self.cursorIndex = #self:getText()
	self.cursorLength = 0

	Widget.focus(self, ...)
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

	self.cursorIndex = math.max(math.min(index, self:_getTextLength()), 0)
	self.cursorLength = math.max(math.min(self.cursorIndex + length, self:_getTextLength()) - self.cursorIndex, -self:_getTextLength())
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

function TextInput:_subText(i, j)
	if i then
		i = utf8.offset(self:getText(), i)
	end

	if j then
		j = utf8.offset(self:getText(), j)
	end

	return self:getText():sub(i, j)
end

function TextInput:_getTextLength()
	return utf8.len(self:getText())
end

function TextInput:keyDown(key, scan, isRepeat, ...)
	-- if key == 'left' then
	-- 	if self.isShiftDown > 0 then
	-- 		self:slideSelection(-1)
	-- 	else
	-- 		self:moveCursor(-1)
	-- 	end
	-- elseif key == 'right' then
	-- 	if self.isShiftDown > 0 then
	-- 		self:slideSelection(1)
	-- 	else
	-- 		self:moveCursor(1)
	-- 	end
	-- elseif key == 'home' then
	-- 	if self.isShiftDown > 0 then
	-- 		self:select(self.cursorIndex, 0)
	-- 	else
	-- 		self:setCursor(0)
	-- 	end
	-- elseif key == 'end' then
	-- 	if self.isShiftDown > 0 then
	-- 		self:select(self.cursorIndex, self:_getTextLength())
	-- 	else
	-- 		self:setCursor(self:_getTextLength())
	-- 	end
	-- elseif key == 'backspace' then
	if key == 'backspace' then
		self.cursorIndex = self.cursorIndex - 1
		if self.cursorIndex == 0 then
			self.cursorIndex = 0
			self:setText("")
		else
			self:setText(self:_subText(1, self:_getTextLength() - 1))
		end

		self.onValueChanged(self, self.text)

		-- if self.cursorIndex + self.cursorLength == self:_getTextLength() and
		--    self:_getTextLength() > 0
		-- then
		-- 	self.text = self:_subText(1, self:_getTextLength() - math.max(self.cursorLength, 1))
		-- 	self.onValueChanged(self, self.text)
		-- elseif self.cursorIndex > 1 then
		-- 	if self.cursorIndex > self:_getTextLength() then
		-- 		self.text = self:_subText(1, self.cursorIndex - 2)
		-- 	else
		-- 		self.text = self:_subText(1, self.cursorIndex - 1) ..
		-- 	                self:_subText(self.cursorIndex - 1 + math.max(self.cursorLength, 1))
		-- 	end
		-- 	self.onValueChanged(self, self.text)
		-- 	self:moveCursor(self:getLeftCursor() - 1)
		-- end end

		--if self:getLeftCursor() ~= 0 then
		-- if self.cursorLength == 0 then
		-- 	self.text = self:_subText(1, self.cursorIndex - 1) ..
		-- 	            self:_subText(self.cursorIndex + 1)
		-- 	self.onValueChanged(self, self.text)
		-- 	self.cursorIndex = self.cursorIndex - 1
		-- else
		-- 	self.text = self:_subText(1, self:getLeftCursor()) ..
		-- 	            self:_subText(self:getRightCursor() + 1)
		-- 	self.onValueChanged(self, self.text)
		-- end
		--end
		self:setCursor(self:getLeftCursor(), 0)
	-- elseif (key == 'lshift' or key == 'rshift') and not isRepeat then
	-- 	self.isShiftDown = self.isShiftDown + 1
	elseif key == 'return' and not isRepeat then
		self.onSubmit(self, self.text)
	-- elseif key == 'tab' then
	-- 	return false
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

	-- self.text = self:_subText(1, self:getLeftCursor()) ..
	--             text ..
	--             self:_subText(self:getRightCursor() + 1)
	self.text = self.text .. text
	self.onValueChanged(self, self.text)
	self:setCursor(self:getLeftCursor() + 1, 0)

	Widget.type(self, text, ...)
end

return TextInput
