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

	return nil
end

function Color:toHexString(includeAlpha, prefix)
	prefix = prefix or ""

	if includeAlpha then
		return string.format("%s%02x%02x%02x%02x", prefix, self.r * 255, self.g * 255, self.b * 255, self.a * 255)
	end
		
	return string.format("%s%02x%02x%02x", prefix, self.r * 255, self.g * 255, self.b * 255)
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
function Color:get(multiplier)
	multiplier = multiplier or 1

	return self.r * multiplier, self.g * multiplier, self.b * multiplier, self.a * multiplier
end

function Color:shiftHSL(h, s, l)
	h = h or 0
	s = s or 0
	l = l or 0

	local currentH, currentS, currentL = self:toHSL()

	h = h + currentH
	s = math.clamp(currentS + s)
	l = math.clamp(currentL + l)

	return Color.fromHSL(h, s, l)
end

function Color:setHSL(h, s, l)
	local currentH, currentS, currentL = self:toHSL()

	h = h or currentH
	s = s or currentS
	l = l or currentL

	return Color.fromHSL(h, s, l)
end

function Color.fromHSL(h, s, l)
	local w = (h % 1) * 6
	local c = (1 - math.abs(2 * l - 1)) * s
	local x = c * (1 - math.abs(w % 2 - 1))
	local m = l - c / 2

	local r, g, b = m, m, m
	if w < 1 then
		r = r + c
		g = g + x
	elseif w < 2 then
		r = r + x
		g = g + c
	elseif w < 3 then
		g = g + c
		b = b + x
	elseif w < 4 then
		g = g + x
		b = b + c
	elseif w < 5 then
		b = b + c
		r = r + x
	else
		b = b + x
		r = r + c
	end

	return Color(r, g, b)
end

function Color:toHSL()
	local r, g, b = self:get()

	local max, min = math.max(r, g, b), math.min(r, g, b)
	if max == min then return 0, 0, min end

	local l, d = max + min, max - min
	local s = d / (l > 1 and (2 - l) or l)
	l = l / 2

	local h
	if max == r then
		h = (g - b) / d
		if g < b then h = h + 6 end
	elseif max == g then
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end

	return h / 6, s, l
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

function Metatable.__eq(a, b)
	if type(a) == 'number' then
		return math.floor(b.r * 255) == math.floor(a * 255) and math.floor(b.g * 255) == math.floor(a * 255) and math.floor(b.b * 255) == math.floor(a * 255) and math.floor(b.a * 255) == math.floor(a * 255)
	elseif type(b) == 'number' then
		return math.floor(a.r * 255) == math.floor(b * 255) and math.floor(a.g * 255) == math.floor(b * 255) and math.floor(a.b * 255) == math.floor(b * 255) and math.floor(a.a * 255) == math.floor(b * 255)
	else
		return math.floor(a.r * 255) == math.floor(b.r * 255) and math.floor(a.g * 255) == math.floor(b.g * 255) and math.floor(a.b * 255) == math.floor(b.b * 255) and math.floor(a.a * 255) == math.floor(b.a * 255)
	end

	return false
end

-- Inverts a color.
function Metatable.__unm(a)
	return 1.0 - a
end

return Color
