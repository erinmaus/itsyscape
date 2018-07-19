--------------------------------------------------------------------------------
-- ItsyScape/Game/Curve.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Curve, CurveMetatable = Class()
Curve.MAX = 200

-- Constructs a new Curve, for things like XP.
--
-- The formula for the XP from level N - 1 to level N is as follows:
--
--  scale * base ^ (N / step) / divisor(N)
--
-- where N is the level.
--
-- 'divisor' is either a constant or a function that takes a single argument
-- (level) and returns a result. The result of divisor must be > 0.
function Curve:new(scale, step, base, divisor)
	self.scale = scale or 75
	self.step = step or 7
	self.base = base or 2

	divisor = divisor or 1
	if type(divisor) == 'number' then
		self.divisor = function(N)
			return divisor
		end
	else
		assert(type(divisor) == 'function', "expected constant or function for divisor")
		self.divisor = divisor
	end

	self.cache = { [0] = 0 }
end

-- Gets the scale value.
function Curve:getScale()
	return self.scale
end

-- Gets the step value.
function Curve:getStep()
	return self.step
end

-- Gets the base value.
function Curve:getBase()
	return self.base
end

-- Gets the divisor function.
function Curve:getDivisor()
	return self.divisor
end

-- Computes the value for 'level'.
function Curve:compute(level)
	level = math.max(math.floor(level - 1), 0)

	assert(level <= Curve.MAX, "level exceeds Curve.MAX")

	if not self.cache[level] then
		-- Premature optimization.
		local c, b, n, D = self.scale, self.base, self.step, self.divisor

		local maxCache = math.max(#self.cache, 1)
		local previousValue = self.cache[maxCache - 1] or 0

		for i = maxCache, level do
			local d = D(i)
			assert(d > 0, "divisor(N) must be greater than 0")

			local valueForLevel = c * b ^ (i / n) / math.max(D(i), 1)
			valueForLevel = math.floor(valueForLevel)

			local currentValue = previousValue + valueForLevel

			self.cache[i] = currentValue
			previousValue = currentValue
		end
	end

	return self.cache[level]
end

-- Computes the level for 'xp'.
--
-- Returns 'max' if xp exceeds 'max'. 'max' defaults to 99.
function Curve:getLevel(xp, max)
	max = math.min(max or 99, Curve.MAX)

	-- Starts at level 2, since we consider level 1 at 0 XP.
	for i = 2, max do
		local j = self:compute(i)
		if xp < j then
			return i - 1
		end
	end

	return max
end

-- Calls Curve.compute.
--
-- Allows treating a Curve as a function.
function CurveMetatable:__call(...)
	return self:compute(...)
end

Curve.XP_CURVE = Curve()
Curve.VALUE_CURVE = Curve(
	251,
	5.1,
	2,
	function(N) return math.max(1.07 ^ (-N / 10) * 20, 1) end)

return Curve
