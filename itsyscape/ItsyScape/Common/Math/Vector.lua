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
local Pool = require "ItsyScape.Common.Math.Pool"

-- Three-dimensional vector type.
local BaseVector, Metatable = Class()
local Vector = Pool.wrap(BaseVector)

-- Constructs a new three-dimensional vector from the provided components.
--
-- Values default to x. If x is not provided, values default to 0.
--
-- Thus Vector(1) gives { 1, 1, 1 }, Vector() gives { 0, 0, 0 },
-- and Vector(1, 2) gives { 1, 2, 1 }.
function BaseVector:new(x, y, z)
	self.x = x or 0
	self.y = y or x or 0
	self.z = z or x or 0
end

function BaseVector:keep()
	-- Nothing
end

function BaseVector:copy(other)
	other.x = self.x
	other.y = self.y
	other.z = self.z
end

-- Returns the x, y, z components as a tuple.
function BaseVector:get()
	return self.x, self.y, self.z
end

function BaseVector:abs()
	self:compatible()
	return Vector(math.abs(self.x), math.abs(self.y), math.abs(self.z))
end

function BaseVector:floor()
	self:compatible()
	return Vector(math.floor(self.x), math.floor(self.y), math.floor(self.z))
end

function BaseVector:ceil()
	self:compatible()
	return Vector(math.ceil(self.x), math.ceil(self.y), math.ceil(self.z))
end

-- Calculates and returns the dot product of two vectors.
function BaseVector:dot(other)
	self:compatible(other)
	return self.x * other.x + self.y * other.y + self.z * other.z
end

function BaseVector:reflect(normal)
	self:compatible(normal)
	local dot = self:dot(normal)
	return self - 2.0 * normal * dot
end

function BaseVector:project(other)
	self:compatible(other)
	return self:dot(other) / other:dot(other) * other
end

-- Returns a vector with the minimum components of both vectors.
function BaseVector:min(other)
	self:compatible(other)
	return Vector(
		math.min(self.x, other.x),
		math.min(self.y, other.y),
		math.min(self.z, other.z))
end

-- Returns a vector with the maximum components of both vectors.
function BaseVector:max(other)
	self:compatible(other)
	return Vector(
		math.max(self.x, other.x),
		math.max(self.y, other.y),
		math.max(self.z, other.z))
end

function BaseVector:clamp(min, max)
	self:compatible(min)
	self:compatible(max)
	min:compatible(max)

	return self:min(max):max(min)
end

function Vector:transform(transform)
	if not transform then
		return self
	end

	return Vector(transform:transformPoint(self.x, self.y, self.z))
end

function Vector.transformBounds(min, max, transform)
	min:compatible(max)

	if not transform then
		return min, max
	end

	local corners = {
		min.x, min.y, min.z,
		max.x, min.y, min.z,
		min.x, max.y, min.z,
		min.x, min.y, max.z,
		max.x, max.y, min.z,
		max.x, min.y, max.z,
		min.x, max.y, max.z,
		max.x, max.y, max.z
	}

	local minX, minY, minZ = math.huge, math.huge, math.huge
	local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

	for i = 1, #corners, 3 do
		local pX, pY, pZ = unpack(corners, i)
		local tX, tY, tZ = transform:transformPoint(pX, pY, pZ)

		minX = math.min(tX, minX)
		minY = math.min(tY, minY)
		minZ = math.min(tZ, minZ)

		maxX = math.max(tX, maxX)
		maxY = math.max(tY, maxY)
		maxZ = math.max(tZ, maxZ)
	end

	return Vector(minX, minY, minZ), Vector(maxX, maxY, maxZ)
end

-- Linearly interpolates this vector with other.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Returns the interpolated vector.
function BaseVector:lerp(other, delta)
	self:compatible(other)

	delta = math.min(math.max(delta, 0.0), 1.0)
	local result = Vector()
	result.x = other.x * delta + self.x * (1 - delta)
	result.y = other.y * delta + self.y * (1 - delta)
	result.z = other.z * delta + self.z * (1 - delta)
	return result
end

-- Calculates the cross product of two vectors.
function BaseVector:cross(other)
	self:compatible(other)

	local s = self.y * other.z - self.z * other.y
	local t = self.z * other.x - self.x * other.z
	local r = self.x * other.y - self.y * other.x

	return Vector(s, t, r)
end

function Vector:distance(other)
	local difference = self - other
	return difference:getLength()
end

-- Gets the length (i.e., magnitude) of the vector, squared.
function BaseVector:getLengthSquared()
	self:compatible()

	return self.x * self.x + self.y * self.y + self.z * self.z
end

-- Gets the length (i.e., magnitude) of the vector.
function BaseVector:getLength()
	local lengthSquared = self:getLengthSquared()
	if lengthSquared == 0 then
		return 0
	else
		return math.sqrt(self:getLengthSquared())
	end
end

-- Returns a normal of the vector.
function BaseVector:getNormal()
	local length = self:getLength()
	if length == 0 then
		return self
	else
		return self / self:getLength()
	end
end

function BaseVector:direction(other)
	self:compatible()
	other:compatible()

	return (other - self):getNormal()
end

-- Adds two vectors or a vector and a scalar.
--
-- If 'a' is a scalar, 'a' added to each component of 'b' and vice versa for
-- 'b'.
function Metatable.__add(a, b)
	local result = Vector()

	if type(a) == 'number' then
		b:compatible()
		result.x = a + b.x
		result.y = a + b.y
		result.z = a + b.z
	elseif type(b) == 'number' then
		a:compatible()
		result.x = a.x + b
		result.y = a.y + b
		result.z = a.z + b
	else
		a:compatible(b)
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
		b:compatible()
		result.x = a - b.x
		result.y = a - b.y
		result.z = a - b.z
	elseif type(b) == 'number' then
		a:compatible()
		result.x = a.x - b
		result.y = a.y - b
		result.z = a.z - b
	else
		a:compatible(b)
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
		b:compatible()
		result.x = a * b.x
		result.y = a * b.y
		result.z = a * b.z
	elseif type(b) == 'number' then
		a:compatible()
		result.x = a.x * b
		result.y = a.y * b
		result.z = a.z * b
	else
		a:compatible(b)
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
		b:compatible()
		result.x = a / b.x
		result.y = a / b.y
		result.z = a / b.z
	elseif type(b) == 'number' then
		a:compatible()
		result.x = a.x / b
		result.y = a.y / b
		result.z = a.z / b
	else
		a:compatible(b)
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
	a:compatible()
	return Vector(-a.x, -a.y, -a.z)
end

function Metatable.__pow(a, b)
	local result = Vector()

	if type(a) == 'number' then
		b:compatible()
		result.x = a ^ b.x
		result.y = a ^ b.y
		result.z = a ^ b.z
	elseif type(b) == 'number' then
		a:compatible()
		result.x = a.x ^ b
		result.y = a.y ^ b
		result.z = a.z ^ b
	else
		a:compatible(b)
		result.x = a.x ^ b.x
		result.y = a.y ^ b.y
		result.z = a.z ^ b.z
	end

	return result
end

function Metatable.__eq(a, b)
	a:compatible(b)
	return a.x == b.x and a.y == b.y and a.z == b.z
end

-- Some useful vector constants.
Vector.ZERO   = Vector(0, 0, 0)
Vector.ONE    = Vector(1, 1, 1)
Vector.UNIT_X = Vector(1, 0, 0)
Vector.UNIT_Y = Vector(0, 1, 0)
Vector.UNIT_Z = Vector(0, 0, 1)
Vector.PLANE_XZ = Vector(1, 0, 1)
Vector.PLANE_XY = Vector(1, 1, 0)

return Vector
