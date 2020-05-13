--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Vector.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

-- Three-dimensional vector type.
local Vector, Metatable = Class()

-- Constructs a new three-dimensional vector from the provided components.
--
-- Values default to x. If x is not provided, values default to 0.
--
-- Thus Vector(1) gives { 1, 1, 1 }, Vector() gives { 0, 0, 0 },
-- and Vector(1, 2) gives { 1, 2, 1 }.
function Vector:new(x, y, z)
	self.x = x or 0
	self.y = y or x or 0
	self.z = z or x or 0
end

-- Returns the x, y, z components as a tuple.
function Vector:get()
	return self.x, self.y, self.z
end

-- Calculates and returns the dot product of two vectors.
function Vector:dot(other)
	return self.x * other.x + self.y * other.y + self.z * other.z
end

-- Returns a vector with the minimum components of both vectors.
function Vector:min(other)
	return Vector(
		math.min(self.x, other.x),
		math.min(self.y, other.y),
		math.min(self.z, other.z))
end

-- Returns a vector with the maximum components of both vectors.
function Vector:max(other)
	return Vector(
		math.max(self.x, other.x),
		math.max(self.y, other.y),
		math.max(self.z, other.z))
end

function Vector.transformBounds(min, max, transform)
	local corners = {
		Vector(min.x, min.y, min.z),
		Vector(max.x, min.y, min.z),
		Vector(min.x, max.y, min.z),
		Vector(min.x, min.y, max.z),
		Vector(max.x, max.y, min.z),
		Vector(max.x, min.y, max.z),
		Vector(min.x, max.y, max.z),
		Vector(max.x, max.y, max.z)
	}

	local min, max = Vector(math.huge), Vector(-math.huge)
	for i = 1, #corners do
		local corner = corners[i]
		corner = Vector(transform:transformPoint(corner.x, corner.y, corner.z))
		min = min:min(corner)
		max = max:max(corner)
	end

	return min, max
end

-- Linearly interpolates this vector with other.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Returns the interpolated vector.
function Vector:lerp(other, delta)
	delta = math.min(math.max(delta, 0.0), 1.0)
	local result = Vector()
	result.x = other.x * delta + self.x * (1 - delta)
	result.y = other.y * delta + self.y * (1 - delta)
	result.z = other.z * delta + self.z * (1 - delta)
	return result
end

-- Calculates the cross product of two vectors.
function Vector:cross(other)
	local s = self.y * other.z - self.z * other.y
	local t = self.z * other.x - self.x * other.z
	local r = self.x * other.y - self.y * other.x

	return Vector(s, t, r)
end

-- Gets the length (i.e., magnitude) of the vector, squared.
function Vector:getLengthSquared()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

-- Gets the length (i.e., magnitude) of the vector.
function Vector:getLength()
	return math.sqrt(self:getLengthSquared())
end

-- Returns a normal of the vector.
function Vector:getNormal()
	local length = self:getLength()
	if length == 0 then
		return self
	else
		return self / self:getLength()
	end
end

-- Adds two vectors or a vector and a scalar.
--
-- If 'a' is a scalar, 'a' added to each component of 'b' and vice versa for
-- 'b'.
function Metatable.__add(a, b)
	local result = Vector()

	if type(a) == 'number' then
		result.x = a + b.x
		result.y = a + b.y
		result.z = a + b.z
	elseif type(b) == 'number' then
		result.x = a.x + b
		result.y = a.y + b
		result.z = a.z + b
	else
		result.x = a.x + b.x
		result.y = a.y + b.y
		result.z = a.z + b.z
	end

	return result
end

-- Subtructs a vector or a vector and a scalar.
--
-- If 'a' is a scalar, the returned vector is { a, a, a } - { b.x, b.y, b.z }
-- and vice versa for 'b'.
function Metatable.__sub(a, b)
	local result = Vector()

	if type(a) == 'number' then
		result.x = a - b.x
		result.y = a - b.y
		result.z = a - b.z
	elseif type(b) == 'number' then
		result.x = a.x - b
		result.y = a.y - b
		result.z = a.z - b
	else
		result.x = a.x - b.x
		result.y = a.y - b.y
		result.z = a.z - b.z
	end

	return result
end

-- Multiplies two vectors or a vector and a scalar.
--
-- If 'a' is a scalar, 'a' multiplied with each component of 'b' and vice versa
-- for 'b'.
function Metatable.__mul(a, b)
	local result = Vector()

	if type(a) == 'number' then
		result.x = a * b.x
		result.y = a * b.y
		result.z = a * b.z
	elseif type(b) == 'number' then
		result.x = a.x * b
		result.y = a.y * b
		result.z = a.z * b
	else
		result.x = a.x * b.x
		result.y = a.y * b.y
		result.z = a.z * b.z
	end

	return result
end


-- Divides a vector or a vector and a scalar.
--
-- If 'a' is a scalar, the returned vector is { a, a, a } / { b.x, b.y, b.z }
-- and vice versa for 'b'.
function Metatable.__div(a, b)
	local result = Vector()

	if type(a) == 'number' then
		result.x = a / b.x
		result.y = a / b.y
		result.z = a / b.z
	elseif type(b) == 'number' then
		result.x = a.x / b
		result.y = a.y / b
		result.z = a.z / b
	else
		result.x = a.x / b.x
		result.y = a.y / b.y
		result.z = a.z / b.z
	end

	return result
end

-- Negates a vector.
--
-- Returns { -x, -y, -z }.
function Metatable.__unm(a)
	return Vector(-a.x, -a.y, -a.z)
end

function Metatable.__pow(a, b)
	local result = Vector()

	if type(a) == 'number' then
		result.x = a ^ b.x
		result.y = a ^ b.y
		result.z = a ^ b.z
	elseif type(b) == 'number' then
		result.x = a.x ^ b
		result.y = a.y ^ b
		result.z = a.z ^ b
	else
		result.x = a.x ^ b.x
		result.y = a.y ^ b.y
		result.z = a.z ^ b.z
	end

	return result
end

function Metatable.__eq(a, b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

-- Some useful vector constants.
Vector.ZERO   = Vector(0, 0, 0)
Vector.ONE    = Vector(1, 1, 1)
Vector.UNIT_X = Vector(1, 0, 0)
Vector.UNIT_Y = Vector(0, 1, 0)
Vector.UNIT_Z = Vector(0, 0, 1)
Vector.PLANE_XZ = Vector(1, 0, 1)

return Vector
