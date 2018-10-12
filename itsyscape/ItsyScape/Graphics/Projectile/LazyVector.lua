--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Projectile/LazyVector.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local LazyVector, Metatable = Class()

LazyVector.Vector = function(x, y, z)
	local r = Vector(x, y, z)
	local result = LazyVector()
	result:setGetter(function() return r end)
	return result
end

function LazyVector:new()
	self.getter = function()
		return Vector.ZERO
	end
end

function LazyVector:setGetter(value)
	self.getter = value or self.getter
end

function LazyVector:getGetter()
	return self.getter
end

function LazyVector:getValue()
	return self.getter()
end

local getValue = function(value)
	if Class.isType(value, LazyVector) then
		return value:getValue()
	else
		return value
	end
end

function Metatable.__add(a, b)
	local result = LazyVector()
	result:setGetter(function()
		return getValue(a) + getValue(b)
	end)

	return result
end

function Metatable.__sub(a, b)
	local result = LazyVector()
	result:setGetter(function()
		return getValue(a) - getValue(b)
	end)

	return result
end

function Metatable.__mul(a, b)
	local result = LazyVector()
	result:setGetter(function()
		return getValue(a) * getValue(b)
	end)

	return result
end

function Metatable.__div(a, b)
	local result = LazyVector()
	result:setGetter(function()
		return getValue(a) / getValue(b)
	end)

	return result
end

function Metatable.__unm(a)
	local result = LazyVector()
	result:setGetter(function()
		return -getValue(a)
	end)

	return result
end

return LazyVector
