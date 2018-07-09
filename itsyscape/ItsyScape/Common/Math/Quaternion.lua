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

-- Four-dimensional quaternion type.
local Quaternion, Metatable = Class()

-- Creates a quaternion from an axis and angle.
function Quaternion.fromAxisAngle(axis, angle)
	local angleSine = math.sin(angle)
	local angleCosine = math.cos(angle)

	local xyz = axis:getNormal() * angleSine
	local w = angleCosine

	return Quaternion(xyz.x, xyz.y, xyz.z, w)
end

-- Constructs a new three-dimensional quaternion from the provided components.
--
-- Values default to x, except for w. If x is not provided, values default to 0.
-- If w is not provided, then it defaults to 1.
--
-- Thus Quaternion(1) gives { 1, 1, 1, 1 }, Quaternion() gives { 0, 0, 0, 1 },
-- and Quaternion(1, 2) gives { 1, 2, 1, 1 }.
function Quaternion:new(x, y, z, w)
	self.x = x or 0
	self.y = y or x or 0
	self.z = z or x or 0
	self.w = w or 1
end

-- Linearly interpolates this quaternion with other.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Returns the interpolated quaternion.
function Quaternion:lerp(other, delta)
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
function Quaternion:slerp(other, delta)
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
function Quaternion:getLengthSquared()
	return self.x * self.x + self.y * self.y + self.z * self.z
end

-- Gets the length (i.e., magnitude) of the quaternion.
function Quaternion:getLength()
	return math.sqrt(self:getLengthSquared())
end

-- Returns a normal of the quaternion.
function Quaternion:getNormal()
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

-- Adds two quaternions.
function Metatable.__add(a, b)
	local result = Quaternion()

	result.x = a.x + b.x
	result.y = a.y + b.y
	result.z = a.z + b.z
	result.w = a.w + b.w

	return result
end

-- Multiplies two quaternions.
function Metatable.__mul(a, b)
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
	return Quaternion(-a.x, -a.y, -a.z, a.w)
end

-- Some useful quaternion constants.
Quaternion.IDENTITY = Quaternion(0, 0, 0, 1)

return Quaternion
