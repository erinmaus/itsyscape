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
	self.hint = ""
end

function TextInput:getHint()
	return self.hint
end

function TextInput:setHint(value)
	self.hint = value or ""
end

function TextInput:focus(...)
	self.cursorIndex = #self:getText()
	self.cursorLength = 0

	if _MOBILE then
		local x, y = self:getAbsolutePosition()
		local w, h = self:getSize()
		love.keyboard.setTextInput(true)
	end

	Widget.focus(self, ...)
end

function TextInput:blur(...)
	self.cursorIndex = 1
	self.cursorLength = 0

	if _MOBILE then
		love.keyboard.setTextInput(false)
	end

	Widget.blur(self, ...)
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
	return utf8.sub(self:getText(), i, j)
end

function TextInput:_getTextLength()
	return utf8.len(self:getText())
end

function TextInput:keyDown(key, scan, isRepeat, ...)
	local text
	if key == "v" then
		local isMacOSPaste = love.system.getOS() == "OS X" and (love.keyboard.isDown("lgui") or love.keyboard.isDown("rgui"))
		local isStandardPaste = love.system.getOS() ~= "OS X" and (love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl"))

		if isMacOSPaste or isStandardPaste then
			text = love.system.getClipboardText():gsub("[\n\r\t]", "")
			self:typeText(text, true)
		end
	elseif key == 'left' then
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
			self:select(self.cursorIndex, self:_getTextLength())
		else
			self:setCursor(self:_getTextLength())
		end
	elseif key == "delete" then
		if self.cursorLength == 0 then
			text = self:_subText(1, self.cursorIndex + 1) ..
			       self:_subText(self.cursorIndex + 2)
		else
			text = self:_subText(1, self:getLeftCursor() + 1) ..
			       self:_subText(self:getRightCursor() + 1)
		end

		self:setCursor(self:getLeftCursor(), 0)
	elseif key == 'backspace' then
		if self.cursorLength == 0 then
			text = self:_subText(1, self.cursorIndex) ..
			            self:_subText(self.cursorIndex + 1)
			self.cursorIndex = self.cursorIndex - 1
		elseif self.cursorLength == self:_getTextLength() then
			text = ""
		else
			text = self:_subText(1, self:getLeftCursor() + 1) ..
			       self:_subText(self:getRightCursor() + 1)
		end

		self:setCursor(self:getLeftCursor(), 0)
	elseif (key == 'lshift' or key == 'rshift') and not isRepeat then
		self.isShiftDown = self.isShiftDown + 1
	elseif key == 'return' and not isRepeat then
		self:blur()
		self:onSubmit(self:getText())
	end

	if text then
		self:valueChanged(text)
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

function TextInput:valueChanged(value)
	self:setText(value)
	self:onValueChanged(self:getText())
end

function TextInput:typeText(text, isPaste)
	local left = self:getLeftCursor()
	local right = self:getRightCursor()

	local text = self:_subText(1, self:getLeftCursor() + 1) ..
	             text ..
	             self:_subText(self:getRightCursor() + 1)

	self:valueChanged(text)

	if isPaste then
		self.cursorIndex = self:getLeftCursor() + utf8.len(text)
	else
		self.cursorIndex = self:getLeftCursor() + 1
	end

	self.cursorLength = 0
end

function TextInput:type(text, ...)
	self:typeText(text, false)

	Widget.type(self, text, ...)
end

return TextInput
