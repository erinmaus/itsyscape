--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadNumberInput.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local utf8 = require "utf8"
local Class = require "ItsyScape.Common.Class"
local TextInput = require "ItsyScape.UI.TextInput"

local GamepadNumberInput = Class(TextInput)

function GamepadNumberInput:new()
	TextInput.new(self)

	self.numDigits = 1
	self:setText("0")
end

function GamepadNumberInput:_setValueText(value)
	value = value:gsub("[^%d]", "")

	if utf8.len(value) > self.numDigits then
		local maxValue = 10 ^ self.numDigits - 1
		local currentValue = tonumber(value)
		if currentValue > maxValue then
			value = tostring(maxValue)
		end
	end

	if utf8.len(value) < self.numDigits then
		value = string.rep("0", self.numDigits - utf8.len(value)) .. value
	end

	self:setText(value)
end

function GamepadNumberInput:setNumDigits(value)
	self.numDigits = value or self.numDigits
	self:_setValueText(self:getText())
end

function GamepadNumberInput:getNumDigits()
	return self.numDigits
end

function GamepadNumberInput:setValue(value)
	self:_setValueText(tostring(value or "0"))
end

function GamepadNumberInput:getValue()
	return tonumber(self:getText()) or 0
end

function GamepadNumberInput:focus(reason)
	self:_tryPlaceCursor()
	TextInput.focus(self, reason)
end

function GamepadNumberInput:_tryPlaceCursor()
	local leftCursor = self:getLeftCursor()
	local rightCursor = self:getRightCursor()

	if leftCursor == rightCursor then
		local length = utf8.len(self:getText())
		if length == 0 then
			self:setText("0")
		end

		if self:getText() then
			self:setCursor(utf8.len(self:getText()) - 1, 1)
		end
	elseif leftCursor >= utf8.len(self:getText()) then
		self:setCursor(utf8.len(self:getText()) - 1, 1)
	elseif rightCursor - leftCursor > 1 then
		self:setCursor(leftCursor, 1)
	end
end

function GamepadNumberInput:gamepadDirection(directionX, directionY)
	self:_tryPlaceCursor()

	local leftCursor = self:getLeftCursor()
	if directionY ~= 0 then
		local digit = utf8.sub(self:getText(), leftCursor + 1, leftCursor + 2)
		digit = tonumber(digit) + math.sign(directionY)

		if digit < 0 then
			digit = 9
		elseif digit > 9 then
			digit = 0
		end

		self:typeText(tostring(digit))
		self:setCursor(leftCursor, 1)
		self:_setValueText(self:getText())
	end

	if directionX ~= 0 then
		leftCursor = leftCursor + math.sign(directionX)
		if leftCursor < 0 or leftCursor >= self.numDigits then
			TextInput.gamepadDirection(self, directionX, directionY)
			return
		end

		self:setCursor(leftCursor, 1)
	end

	-- We don't bubble onGamepadDirection if we consume it.
end

function GamepadNumberInput:typeText(text, isPaste)
	text = text:match("^%s*(.*)%s*$")
	if not text:match("^%d+$") then
		return
	end

	TextInput.typeText(self, text, isPaste)
end

return GamepadNumberInput
