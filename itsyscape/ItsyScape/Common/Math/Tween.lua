--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Tween.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local Tween = {}

function Tween.linear(t)
	return t
end

function Tween.sineEaseIn(t)
	return math.sin(t * math.pi / 2 - math.pi / 2) + 1
end

function Tween.sineEaseOut(t)
	return math.sin(t * math.pi / 2)
end

function Tween.sineEaseInOut(t)
	return (math.sin(t * math.pi / 2 - math.pi / 2) + 1) / 2
end

function Tween.powerEaseIn(t, power)
	return t ^ power
end

function Tween.powerEaseOut(t, power)
	local sign
	if power % 2 == 0 then
		sign = -1
	else
		sign = 1
	end

	return sign * ((t - 1) ^ power + sign)
end

function Tween.powerEaseInOut(t, power)
	t = t * 2

	if t < 1 then
		return Tween.powerEaseIn(t, power) / 2
	end

	local sign
	if power % 2 == 0 then
		sign = -1
	else
		sign = 1
	end

	return sign / 2 * ((t - 2) ^ power + sign * 2)
end

local function out(func)
	return function(t) return 1 - (func(1 - t)) end
end

local function inOut(func)
	return function(t)
		if t < 0.5 then
			return 0.5 * func(t * 2)
		else
			return 1 - 0.5 * func(2 - t * 2)
		end
	end
end

function Tween.expEaseIn(t)
	return 2 ^ ((t - 1) * 10)
end

Tween.expEaseOut = out(Tween.expEaseIn)

Tween.expEaseInOut = inOut(Tween.expEaseIn)

function Tween.bounceIn(t)
	local bounceConst1 = 2.75
	local bounceConst2 = bounceConst1 ^ 2

	t = 1 - t

	if t < 1 / bounceConst1 then
		return 1 - bounceConst2 * t * t
	elseif t < 2 / bounceConst1 then
		return 1 - bounceConst2 * (t - 1.5 / bounceConst1) ^ 2 + 0.75
	elseif t < 2.5 / bounceConst1 then
		return 1 - bounceConst2 * (t - 2.225 / bounceConst2) ^ 2 + 0.9375
	else
		return 1 - bounceConst2 * (t - 2.625 / bounceConst1) ^ 2 + 0.984375
	end
end

Tween.bounceOut = out(Tween.bounceIn)
Tween.bounceInOut = inOut(Tween.bounceIn)

return Tween
