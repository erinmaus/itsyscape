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
function BaseQuaternion.fromAxisAngle(axis, angle)
	axis:compatible()

	local halfAngle = angle * 0.5
	local halfAngleSine = math.sin(halfAngle)
	local halfAngleCosine = math.cos(halfAngle)

	local xyz = axis:getNormal() * halfAngleSine
	local w = halfAngleCosine

	return Quaternion(xyz.x, xyz.y, xyz.z, w)
end

local E = 0.00001
function BaseQuaternion.lookAt(source, target, up)
	source:compatible(target)
	source:compatible(up)
	target:compatible(up)

	up = up or -Vector.UNIT_Z

	local forward = (target - source):getNormal()

	local dot = forward:dot(up)
	local angle = math.acos(dot)
	local axis = up:cross(forward):getNormal()
	return BaseQuaternion.fromAxisAngle(axis, angle):getNormal()
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
function BaseQuaternion:slerp(other, delta)
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

	local result = Quaternion()

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

function BaseQuaternion:inverse()
	local lengthSquared = self:getLengthSquared()
	if length == 0 then
		return self
	end

	local inverseLengthSquared = 1 / lengthSquared
	return Quaternion(
		-self.x * inverseLengthSquared,
		-self.y * inverseLengthSquared,
		-self.z * inverseLengthSquared,
		self.w * inverseLengthSquared)
end

function BaseQuaternion:transformVector(vector)
	self:compatible(vector)

	local v = Quaternion(vector.x, vector.y, vector.z, 0)
	local normal = self:getNormal()
	local conjugate = -normal
	local result = Vector((normal * v * conjugate):get())
	local a = collectgarbage("count")

	return result
end

function BaseQuaternion:getEulerXYZ()
	self:compatible()

	local x = math.atan2(2.0 * (self.y * self.z + self.w * self.x) , self.w * self.w - self.x * self.x - self.y * self.y + self.z * self.z)
	local y = math.asin(-2.0 * (self.x * self.z - self.w * self.y))
	local z = math.atan2(2.0 * (self.x * self.y + self.w * self.z) , self.w * self.w + self.x * self.x - self.y * self.y - self.z * self.z)

	return x, y, z
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

-- Multiplies two quaternions.
function Metatable.__mul(a, b)
	a:compatible(b)

	local result = Quaternion()
	result.x =  a.x * b.w + a.y * b.z - a.z * b.y + a.w * b.x
	result.y = -a.x * b.z + a.y * b.w + a.z * b.x + a.w * b.y
	result.z =  a.x * b.y - a.y * b.x + a.z * b.w + a.w * b.z
	result.w = -a.x * b.x - a.y * b.y - a.z * b.z + a.w * b.w

	return result
end

-- Creates the conjugate of a quaternion.
--
-- Returns { -x, -y, -z, w }.
function Metatable.__unm(a)
	a:compatible()
	return Quaternion(-a.x, -a.y, -a.z, a.w)
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
