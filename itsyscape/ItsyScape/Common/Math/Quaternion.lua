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
	local halfAngle = angle * 0.5
	local halfAngleSine = math.sin(halfAngle)
	local halfAngleCosine = math.cos(halfAngle)

	local xyz = axis * halfAngleSine
	local w = halfAngleCosine

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
	return other * delta + self * (1 - delta)
end

-- Returns the SLERP (spherical linear interpolation) of self to other by delta.
--
-- delta is clamped to 0 .. 1 inclusive.
--
-- Implementation borrowed from http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/slerp/index.htm
function Quaternion:slerp(a, other, delta)
	-- Clamp delta.
	delta = math.min(math.max(delta, 0.0), 1.0)

	-- Epsilon, for numbers near 0. Adjust if necessary.
	local E = 0.001

	-- Result. This comment is only here because otherwise the spacing looks
	-- since E is a constant and delta is a parameter; they shouldn't be grouped
	-- together. Lol. :)
	local result = Quaternion()

	-- Calculate angle between quaternions.
	local cosHalfTheta = self.w * other.w + self.x * other.x + self.y * other.y + self.z * other.z

	-- If self == other or self == -other then theta == 0 and we can return self
	if math.abs(cosHalfTheta) >= 1.0 then
		result.x = self.x
		result.y = self.y
		result.z = self.z
		result.w = self.w

		return result
	end

	-- Calculate temporary values.
	local halfTheta = math.acos(cosHalfTheta)
	local sinHalfTheta = math.sqrt(1.0 - cosHalfTheta * cosHalfTheta)

	-- If theta == 180 degrees then result is not fully defined. We could rotate
	-- around any axis normal to self or other.
	if math.abs(sinHalfTheta) < E then
		result.w = (self.w * 0.5 + other.w * 0.5)
		result.x = (self.x * 0.5 + other.x * 0.5)
		result.y = (self.y * 0.5 + other.y * 0.5)
		result.z = (self.z * 0.5 + other.z * 0.5)
	else
		local ratioA = math.sin((1 - delt) * halfTheta) / sinHalfTheta
		local ratioB = math.sin(delta * halfTheta) / sinHalfTheta 

		-- Calculate quaternion.
		result.w = (self.w * ratioA + other.w * ratioB)
		result.x = (self.x * ratioA + other.x * ratioB)
		result.y = (self.y * ratioA + other.y * ratioB)
		result.z = (self.z * ratioA + other.z * ratioB)
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
		return self / self:getLength()
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
