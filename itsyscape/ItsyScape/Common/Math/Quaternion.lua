--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Quaternion.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Pool = require "ItsyScape.Common.Math.Pool"
local Vector = require "ItsyScape.Common.Math.Vector"

-- Four-dimensional quaternion type.
local BaseQuaternion, Metatable = Class()
local Quaternion = Pool.wrap(BaseQuaternion)

-- Creates a quaternion from an axis and angle.
function BaseQuaternion.fromAxisAngle(axis, angle, result)
	axis:compatible()

	local halfAngle = angle * 0.5
	local halfAngleSine = math.sin(halfAngle)
	local halfAngleCosine = math.cos(halfAngle)

	local xyz = axis:getNormal() * halfAngleSine
	local w = halfAngleCosine

	result = result or Quaternion()
	return result:from(xyz.x, xyz.y, xyz.z, w)
end

local E = 0.00001
do
	local F = Vector()
	local R = Vector()
	local U = Vector()

	function BaseQuaternion.lookAt(source, target, up, result)
		source:compatible(target)
		source:compatible(up)
		target:compatible(up)

		result = result or Quaternion()

		up = up or Vector.UNIT_Y

		-- From https://stackoverflow.com/a/52551983

		source:direction(target, F)
		up:cross(F, R):normalize(R)
		F:cross(R, U):normalize(U)

		local trace = R.x + U.y + F.z
		if trace > 0 then
			local s = 0.5 / math.sqrt(trace + 1)
			result.x = (U.z - F.y) * s
			result.y = (F.x - R.z) * s
			result.z = (R.y - U.x) * s
			result.w = 0.25 / s
		end

		if R.x > U.y and R.x > F.z then
			local s = 2 * math.sqrt(1 + R.x - U.y - F.z)
			result.x = 0.25 * s
			result.y = (U.x + R.y) / s
			result.z = (F.x + R.z) / s
			result.w = (U.z - F.y) / s
		end

		if U.y > F.z then
			local s = 2 * math.sqrt(1 + U.y - R.x - F.z)
			result.x = (U.x + R.y) / s
			result.y = 0.25 * s
			result.z = (F.y + U.z) / s
			result.w = (F.x - R.z) / s
		end
		
		do
			local s = 2 * math.sqrt(1 + F.z - R.x - U.y)
			result.x = (F.x + R.z) / s
			result.y = (F.y + U.z) / s
			result.z = 0.25 * s
			result.w = (R.y - U.x) / s
		end

		return result
	end
end

function BaseQuaternion.fromVectors(source, target)
	local dot = source:getNormal():dot(target:getNormal())
	local halfCos = math.sqrt((1 + dot) / 2)
	local halfSin = math.sqrt((1 - dot) / 2)
	local cross = source:cross(target):getNormal() * halfSin
	return Quaternion(cross.x, cross.y, cross.z, halfCos)
end

-- Constructs a new three-dimensional quaternion from the provided components.
--
-- Values default to x, except for w. If x is not provided, values default to 0.
-- If w is not provided, then it defaults to 1.
--
-- Thus Quaternion(1) gives { 1, 1, 1, 1 }, Quaternion() gives { 0, 0, 0, 1 },
-- and Quaternion(1, 2) gives { 1, 2, 1, 1 }.
function BaseQuaternion:new(x, y, z, w)
	self.x = x or 0
	self.y = y or x or 0
	self.z = z or x or 0
	self.w = w or 1
end

function BaseQuaternion:from(x, y, z, w)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0
	self.w = w or 1

	return self
end

function BaseQuaternion:keep()
	-- Nothing
end

function BaseQuaternion:copy(other)
	other.x = self.x
	other.y = self.y
	other.z = self.z
	other.w = self.w
end

-- Returns the x, y, z, w (in that order) components as a tuple.
function BaseQuaternion:get()
	return self.x, self.y, self.z, self.w
end

-- Linearly interpolates this quaternion with other.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Returns the interpolated quaternion.
function BaseQuaternion:lerp(other, delta)
	delta = math.min(math.max(delta, 0.0), 1.0)
	local deltaQuat = Quaternion(delta, delta, delta, delta)
	local inverseDeltaQuat = Quaternion(1 - delta, 1 - delta, 1 - delta, 1 - delta)

	return other * deltaQuat + self * inverseDeltaQuat
end

-- Returns the SLERP (spherical linear interpolation) of self to other by delta.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Implementation borrowed from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/index.htm
function BaseQuaternion:slerp(other, delta, result)
	self:compatible(other)

	-- Clamp delta.
	delta = math.min(math.max(delta, 0.0), 1.0)

	-- Calculate angle between quaternions.
	local dot = self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w

	local theta = math.acos(dot)
	local sine = math.sin(1 - theta * theta)
	local c1, c2
	if theta > 0 then
		c1 = math.sin((1.0 - delta) * theta) / sine
		c2 = math.sin(delta * theta) / sine
	else
		c1 = 1 - delta
		c2 = delta
	end

	local result = result or Quaternion()

	if dot < 0 then
		result.x = self.x * c1 - other.x * c2
		result.y = self.y * c1 - other.y * c2
		result.z = self.z * c1 - other.z * c2
		result.w = self.w * c1 - other.w * c2
	else
		result.x = self.x * c1 + other.x * c2
		result.y = self.y * c1 + other.y * c2
		result.z = self.z * c1 + other.z * c2
		result.w = self.w * c1 + other.w * c2
	end

	return result
end

-- Gets the length (i.e., magnitude) of the quaternion, squared.
function BaseQuaternion:getLengthSquared()
	self:compatible()

	return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w
end

-- Gets the length (i.e., magnitude) of the quaternion.
function BaseQuaternion:getLength()
	return math.sqrt(self:getLengthSquared())
end

do
	local q = Quaternion()
	local v = Vector()

	function BaseQuaternion:distance(other)
		self:conjugate(q):product(other, q)
		v:from(q.x, q.y, q.z)
		return 2 * math.atan2(v:getLength(), q.w)
	end
end

function BaseQuaternion:normalize(result)
	result = result or Quaternion()

	local length = self:getLength()
	if length == 0 then
		return result:from(0, 0, 0, 0)
	else
		local inverseLength = 1 / length
		return result:from(
			self.x * inverseLength,
			self.y * inverseLength,
			self.z * inverseLength,
			self.w * inverseLength)
	end
end

-- Returns a normal of the quaternion.
function BaseQuaternion:getNormal()
	local length = self:getLength()
	if length == 0 then
		return self
	else
		local inverseLength = length
		return Quaternion(
			self.x / inverseLength,
			self.y / inverseLength,
			self.z / inverseLength,
			self.w / inverseLength)
	end
end

function BaseQuaternion:inverse(result)
	local lengthSquared = self:getLengthSquared()
	if length == 0 then
		return self
	end

	result = result or Quaternion()

	local inverseLengthSquared = 1 / lengthSquared
	return result:from(
		-self.x * inverseLengthSquared,
		-self.y * inverseLengthSquared,
		-self.z * inverseLengthSquared,
		self.w * inverseLengthSquared)
end

do
	local normal = Quaternion()
	local v = Quaternion()
	local conjugate = Quaternion()
	local q = Quaternion()

	function BaseQuaternion:transformVector(vector, result)
		self:compatible(vector)

		result = result or Vector()

		v:from(vector.x, vector.y, vector.z, 0)
		self:normalize(normal)
		normal:conjugate(conjugate)

		normal:product(v, q):product(conjugate, q)
		return result:from(q.x, q.y, q.z)
	end
end

do
	local rx, ry, rz = Quaternion(), Quaternion(), Quaternion()
	function BaseQuaternion.fromEulerXYZ(x, y, z, result)
		result = result or Quaternion()

		Quaternion.fromAxisAngle(Vector.UNIT_X, x, rx)
		Quaternion.fromAxisAngle(Vector.UNIT_Y, y, ry)
		Quaternion.fromAxisAngle(Vector.UNIT_Z, z, rz)

		return rz:product(ry, result):product(rx, result):normalize(result)
	end
end

function BaseQuaternion:getDebugEulerXYZ()
	local x, y, z = self:getEulerXYZ()
	return math.deg(x), math.deg(y), math.deg(z)
end

function BaseQuaternion:getEulerXYZ()
	self:compatible()

	local x = math.atan2(2.0 * (self.y * self.z + self.w * self.x) , self.w * self.w - self.x * self.x - self.y * self.y + self.z * self.z)
	local y = math.asin(math.clamp(-2.0 * (self.x * self.z - self.w * self.y), -1, 1))
	local z = math.atan2(2.0 * (self.x * self.y + self.w * self.z) , self.w * self.w + self.x * self.x - self.y * self.y - self.z * self.z)

	return x, y, z
end

do
	local rotationAxis = Vector()
	local projection = Vector()
	local d = 0
	local twistConjugate = Quaternion()

	function BaseQuaternion:decomposeAxis(axis, twist, swing)
		self:compatible(direction)

		local rotationAxis = Vector(self.x, self.y, self.z)
		local projection, d = rotationAxis:project(axis)

		local sign = math.sign(d)

		twist = twist or Quaternion()
		twist:from(
			sign * projection.x,
			sign * projection.y,
			sign * projection.z,
			sign * self.w)
		twist:conjugate(twistConjugate)

		swing = swing or Quaternion()
		swing:product(twistConjugate, swing)

		return swing, twist
	end
end

-- Adds two quaternions.
function Metatable.__add(a, b)
	a:compatible(b)

	local result = Quaternion()
	result.x = a.x + b.x
	result.y = a.y + b.y
	result.z = a.z + b.z
	result.w = a.w + b.w

	return result
end

function BaseQuaternion:add(other, result)
	result = result or Quaternion()
	result:from(
		a.x + b.x,
		a.y + b.y,
		a.z + b.z,
		a.w + b.w)

	return result
end

function BaseQuaternion:product(other, result)
	local a = self
	local b = other

	result = result or Quaternion()
	result:from(
		a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x,
		-a.x * b.z + a.y * b.w + a.z * b.x + a.w * b.y,
		a.x * b.y - a.y * b.x + a.z * b.w + a.w * b.z,
		-a.x * b.x - a.y * b.y - a.z * b.z + a.w * b.w)
	return result
end

-- Multiplies two quaternions.
function Metatable.__mul(a, b)
	a:compatible(b)

	local result = Quaternion()
	return a:product(b, result)
end

-- Creates the conjugate of a quaternion.
--
-- Returns { -x, -y, -z, w }.
function Metatable.__unm(a)
	a:compatible()
	return Quaternion(-a.x, -a.y, -a.z, a.w)
end

function BaseQuaternion:conjugate(result)
	result = result or Quaternion()
	return result:from(-self.x, -self.y, -self.z, self.w)
end

function Metatable.__eq(a, b)
	a:compatible(b)
	return a.x == b.x and a.y == b.y and a.z == b.z and a.w == b.w
end

-- Some useful quaternion constants.
Quaternion.IDENTITY = Quaternion(0, 0, 0, 1)

Quaternion.X_90 = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi / 2)
Quaternion.X_180 = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi)
Quaternion.X_270 = Quaternion.fromAxisAngle(Vector.UNIT_X, math.pi + math.pi / 2)

Quaternion.Y_90 = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi / 2)
Quaternion.Y_180 = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi)
Quaternion.Y_270 = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi + math.pi / 2)

Quaternion.Z_90 = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi / 2)
Quaternion.Z_180 = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi)
Quaternion.Z_270 = Quaternion.fromAxisAngle(Vector.UNIT_Z, math.pi + math.pi / 2)

return Quaternion
