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

function BaseVector:from(x, y, z)
	if x and y and z then
		self.x = x
		self.y = y
		self.z = z
	elseif x and y and not z then
		self.x = x
		self.y = y
		self.z = 0
	elseif x then
		self.x = x
		self.y = x
		self.z = x
	else
		self.x = 0
		self.y = 0
		self.z = 0
	end

	return self
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

function BaseVector:abs(result)
	self:compatible()
	result = result or Vector()
	return result:from(
		math.abs(self.x),
		math.abs(self.y),
		math.abs(self.z))
end

function BaseVector:floor(result)
	self:compatible()
	result = result or Vector()
	return result:from(
		math.floor(self.x),
		math.floor(self.y),
		math.floor(self.z))
end

function BaseVector:ceil(result)
	self:compatible()
	result = result or Vector()
	return result:from(
		math.ceil(self.x),
		math.ceil(self.y),
		math.ceil(self.z))
end

-- Calculates and returns the dot product of two vectors.
function BaseVector:dot(other)
	self:compatible(other)
	return self.x * other.x + self.y * other.y + self.z * other.z
end

do
	local dot = Vector()
	local TWO = Vector(2)

	function BaseVector:reflect(normal, result)
		self:compatible(normal)

		result = result or Vector()

		dot:from(self:dot(normal))
		return self:subtract(TWO:product(normal, result):product(dot, result), result)
	end
end

do
	local v1 = Vector()
	local v2 = Vector()

	function BaseVector:project(other, result)
		self:compatible(other)

		result = result or Vector()

		local d = self:dot(other)
		v2:from(other:getLengthSquared())
		v1:from(1 / d):product(v2, result):product(other, result)

		return result, d
	end
end

-- Returns a vector with the minimum components of both vectors.
function BaseVector:min(other, result)
	self:compatible(other)
	result = result or Vector()
	return result:from(
		math.min(self.x, other.x),
		math.min(self.y, other.y),
		math.min(self.z, other.z))
end

-- Returns a vector with the maximum components of both vectors.
function BaseVector:max(other, result)
	self:compatible(other)
	result = result or Vector()
	return result:from(
		math.max(self.x, other.x),
		math.max(self.y, other.y),
		math.max(self.z, other.z))
end

function BaseVector:clamp(min, max, result)
	self:compatible(min)
	self:compatible(max)
	min:compatible(max)

	result = result or Vector()
	return self:min(max, result):max(min, result)
end

function Vector:transform(transform, result)
	result = result or Vector()

	if not transform then
		return result:from(self.x, self.y, self.z)
	end

	result:from(transform:transformPoint(self.x, self.y, self.z))
	return result
end

function Vector:inverseTransform(transform, result)
	result = result or Vector()

	if not transform then
		return result:from(self.x, self.y, self.z)
	end

	result:from(transform:inverseTransformPoint(self.x, self.y, self.z))
	return result
end

function Vector.transformBounds(min, max, transform, resultMin, resultMax)
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

	resultMin = resultMin or Vector()
	resultMin:from(minX, minY, minZ)

	resultMax = resultMax or Vector()
	resultMax:from(maxX, maxY, maxZ)

	return resultMin, resultMax
end

-- Linearly interpolates this vector with other.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Returns the interpolated vector.
function BaseVector:lerp(other, delta, result)
	self:compatible(other)

	delta = math.min(math.max(delta, 0.0), 1.0)
	local result = result or Vector()
	return result:from(
		other.x * delta + self.x * (1 - delta),
		other.y * delta + self.y * (1 - delta),
		other.z * delta + self.z * (1 - delta))
end

-- Calculates the cross product of two vectors.
function BaseVector:cross(other, result)
	self:compatible(other)

	local result = result or Vector()
	return result:from(
		self.y * other.z - self.z * other.y,
		self.z * other.x - self.x * other.z,
		self.x * other.y - self.y * other.x)
end

do
	local difference = Vector()

	function Vector:distance(other)
		return self:subtract(other, difference):getLength()
	end
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


do
	local length = Vector()
	function BaseVector:normalize(result)
		result = result or Vector()

		local length = length:from(self:getLength())
		if length:get() == 0 then
			result:from(0)
		else
			length:from(1 / length:get())
			self:product(length, result)
		end

		return result
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

function BaseVector:difference(other)
	self:compatible()
	other:compatible()

	return other - self
end

function BaseVector:direction(other, result)
	result = result or Vector()

	self:compatible()
	other:compatible()

	local result = other - self --other:subtract(self, result)
	result:normalize(result)

	return result
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

function Vector:add(other, result)
	result = result or Vector()
	result.x = self.x + other.x
	result.y = self.y + other.y
	result.z = self.z + other.z
	return result
end

-- Subtracts a vector or a vector and a scalar.
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

function Vector:subtract(other, result)
	result = result or Vector()
	result.x = self.x - other.x
	result.y = self.y - other.y
	result.z = self.z - other.z
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

function Vector:product(other, result)
	result = result or Vector()
	result.x = self.x * other.x
	result.y = self.y * other.y
	result.z = self.z * other.z
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

function Vector:divide(other, result)
	result = result or Vector()
	result.x = self.x / other.x
	result.y = self.y / other.y
	result.z = self.z / other.z
	return result
end

-- Negates a vector.
--
-- Returns { -x, -y, -z }.
function Metatable.__unm(a)
	a:compatible()
	return Vector(-a.x, -a.y, -a.z)
end

function Vector:negate(result)
	result = result or Vector()
	result.x = -self.x
	result.y = -self.y
	result.z = -self.z
	return result
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

function Vector:power(other, result)
	result = result or Vector()
	result.x = self.x ^ other.x
	result.y = self.y ^ other.y
	result.z = self.z ^ other.z
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
