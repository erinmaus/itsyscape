--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Color.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

-- Simple color class, with alpha.
local Color, Metatable = Class()

-- Constructs the color from components in the range 0 .. 1 inclusive.
--
-- Components default to 'r' or 1, except for alpha, which defaults to 1.
--
-- For example, Color(0.5) would return { 0.5, 0.5, 0.5, 1.0 } while
-- Color(0.5, 0.0) would return { 0.5, 0.0, 0.5, 1.0 } and Color() would return
-- { 1, 1, 1, 1 ].}
function Color:new(r, g, b, a)
	self.r = math.max(math.min(r or 1), 0)
	self.g = math.max(math.min(g or r or 1), 0)
	self.b = math.max(math.min(b or r or 1), 0)
	self.a = math.max(math.min(a or 1), 0)
end

function Color.fromHexString(color, alpha)
	local red, green, blue = color:match("(%x%x)(%x%x)(%x%x)")

	if red and green and blue then
		red = tonumber(red, 16) / 255
		green = tonumber(green, 16) / 255
		blue = tonumber(blue, 16) / 255

		return Color(red, green, blue, alpha or 1)
	end

	Log.error("Color '%s' not in hex string format.", color)
	return nil
end


-- Clamps the colors in the range of 0 .. 1 inclusive.
--
-- Returns the color.
function Color:clamp()
	self.r = math.max(math.min(self.r, 1), 0)
	self.g = math.max(math.min(self.g, 1), 0)
	self.b = math.max(math.min(self.b, 1), 0)
	self.a = math.max(math.min(self.a, 1), 0)
	return self
end

-- Lerps two colors by delta.
--
-- delta is clamped to 0 .. 1 inclusive.
function Color:lerp(other, delta)
	delta = math.max(math.min(delta, 1), 0)
	return self * (1 - delta) + other * delta
end

-- Gets the components of the color in the order red, green, blue, and alpha.
function Color:get()
	return self.r, self.g, self.b, self.a
end

-- Adds two colors, or a color and a scalar, clamping the result to 0 .. 1
-- inclusive.
function Metatable.__add(a, b)
	local result = Color()

	if type(a) == 'number' then
		result.r = a + b.r
		result.g = a + b.g
		result.b = a + b.b
		result.a = a + b.a
	elseif type(b) == 'number' then
		result.r = a.r + b
		result.g = a.g + b
		result.b = a.b + b
		result.a = a.a + b
	else
		result.r = a.r + b.r
		result.g = a.g + b.g
		result.b = a.b + b.b
		result.a = a.a + b.a
	end

	return result:clamp()
end

-- Subtracts two colors, or a color and a scalar, clamping the result to 0 .. 1
-- inclusive.
function Metatable.__sub(a, b)
	local result = Color()

	if type(a) == 'number' then
		result.r = a - b.r
		result.g = a - b.g
		result.b = a - b.b
		result.a = a - b.a
	elseif type(b) == 'number' then
		result.r = a.r - b
		result.g = a.g - b
		result.b = a.b - b
		result.a = a.a - b
	else
		result.r = a.r - b.r
		result.g = a.g - b.g
		result.b = a.b - b.b
		result.a = a.a - b.a
	end

	return result:clamp()
end

-- Multiplies two colors, or a color and a scalar, clamping the result to 0 .. 1
-- inclusive.
function Metatable.__mul(a, b)
	local result = Color()

	if type(a) == 'number' then
		result.r = a * b.r
		result.g = a * b.g
		result.b = a * b.b
		result.a = a * b.a
	elseif type(b) == 'number' then
		result.r = a.r * b
		result.g = a.g * b
		result.b = a.b * b
		result.a = a.a * b
	else
		result.r = a.r * b.r
		result.g = a.g * b.g
		result.b = a.b * b.b
		result.a = a.a * b.a
	end

	return result:clamp()
end

-- Divides two colors, or a color and a scalar, clamping the result to 0 .. 1
-- inclusive.
function Metatable.__div(a, b)
	local result = Color()

	if type(a) == 'number' then
		result.r = a / b.r
		result.g = a / b.g
		result.b = a / b.b
		result.a = a / b.a
	elseif type(b) == 'number' then
		result.r = a.r / b
		result.g = a.g / b
		result.b = a.b / b
		result.a = a.a / b
	else
		result.r = a.r / b.r
		result.g = a.g / b.g
		result.b = a.b / b.b
		result.a = a.a / b.a
	end

	return result:clamp()
end

-- Inverts a color.
function Metatable.__unm(a)
	return 1.0 - a
end

return Color
