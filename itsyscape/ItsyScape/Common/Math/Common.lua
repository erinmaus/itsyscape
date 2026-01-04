--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Common.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"

local Common = {}
function Common.decomposeTransform(transform)
	local m11, m21, m31, m41,
	      m12, m22, m32, m42,
	      m13, m23, m33, m43,
	      m14, m24, m34, m44 = transform:getMatrix("column")

	local t, q
	if m33 < 0 then
		if m11 > m22 then
			t = 1 + m11 - m22 - m33;
			q = Quaternion(t, m12 + m21, m31 + m13, m23 - m32);
		else
			t = 1 - m11 + m22 - m33;
			q = Quaternion(m12 + m21, t, m23 + m32, m31 - m13);
		end
	else
		if m11 < -m22 then
			t = 1 - m11 - m22 + m33;
			q = Quaternion(m31 + m13, m23 + m32, t, m12 - m21);
		else
			t = 1 + m11 + m22 + m33;
			q = Quaternion(m23 - m32, m31 - m13, m12 - m21, t);
		end
	end

	q.x = q.x * (0.5 / math.sqrt(t))
	q.y = q.y * (0.5 / math.sqrt(t))
	q.z = q.z * (0.5 / math.sqrt(t))
	q.w = q.w * (0.5 / math.sqrt(t))

	return Vector(m41, m42, m43), q
end

function Common.projectPointOnLineSegment(a, b, p)
	local distanceSquared = (a - b):getLengthSquared()
	if distanceSquared == 0 then
		return p
	end

	local pMinusA = p - a
	local bMinusA = b - a
	local t = math.clamp(pMinusA:dot(bMinusA) / distanceSquared)

	return a + bMinusA * t, t
end

function Common.transformPointFromPlaneToAxis(point, normal, d, otherAxis)
	otherAxis = otherAxis or Vector.UNIT_Z

	local rotation = Quaternion.fromVectors(normal, otherAxis):getNormal()

	local distance = Vector.dot(normal, point) + d
	local projectedPoint = point - distance * normal

	return rotation:transformVector(projectedPoint)
end

function Common.side(a, b, c, bias)
    local left = (a.z - c.z) * (b.x - c.x)
    local right = (a.x - c.x) * (b.z - c.z)
    local result = left - right

	local sign
	if result > 0 + (bias or 0) then
		sign = 1
	elseif result < 0 - (bias or 0) then
		sign = -1
	else
		sign = 0
	end

	return sign, result
end

function Common.makeTranslationTransform(translation, transform)
	transform = transform or love.math.newTransform()

	local m11, m12, m13, m14 = 1, 0, 0, translation.x
	local m21, m22, m23, m24 = 0, 1, 0, translation.y
	local m31, m32, m33, m34 = 0, 0, 1, translation.z
	local m41, m42, m43, m44 = 0, 0, 0, 1

	transform:setMatrix(
		m11, m12, m13, m14,
		m21, m22, m23, m24,
		m31, m32, m33, m34,
		m41, m42, m43, m44)

	return transform
end

function Common.makeRotationTransform(rotation, transform)
	transform = transform or love.math.newTransform()

	local m11, m12, m13, m14 = 1, 0, 0, 0
	local m21, m22, m23, m24 = 0, 1, 0, 0
	local m31, m32, m33, m34 = 0, 0, 1, 0
	local m41, m42, m43, m44 = 0, 0, 0, 1

	local qxx = rotation.x * rotation.x
	local qyy = rotation.y * rotation.y
	local qzz = rotation.z * rotation.z
	local qxz = rotation.x * rotation.z
	local qxy = rotation.x * rotation.y
	local qyz = rotation.y * rotation.z
	local qwx = rotation.w * rotation.x
	local qwy = rotation.w * rotation.y
	local qwz = rotation.w * rotation.z

	m11 = 1 - 2 * (qyy + qzz)
	m12 = 2 * (qxy + qwz)
	m13 = 2 * (qxz - qwy)

	m21 = 2 * (qxy - qwz)
	m22 = 1 - 2 * (qxx + qzz)
	m23 = 2 * (qyz + qwx)

	m31 = 2 * (qxz + qwy)
	m32 = 2 * (qyz - qwx)
	m33 = 1 - 2 * (qxx + qyy)

	transform:setMatrix(
		m11, m12, m13, m14,
		m21, m22, m23, m24,
		m31, m32, m33, m34,
		m41, m42, m43, m44)

	return transform
end

function Common.makeScaleTransform(scale, transform)
	transform = transform or love.math.newTransform()

	local m11, m12, m13, m14 = scale.x, 0, 0, 0
	local m21, m22, m23, m24 = 0, scale.y, 0, 0
	local m31, m32, m33, m34 = 0, 0, scale.z, 0
	local m41, m42, m43, m44 = 0, 0, 0, 1

	transform:setMatrix(
		m11, m12, m13, m14,
		m21, m22, m23, m24,
		m31, m32, m33, m34,
		m41, m42, m43, m44)

	return transform
end

function Common.makeTransform(position, rotation, scale, offset)
	position = position or Vector.ZERO
	rotation = rotation or Quaternion.IDENTITY
	scale = scale or Vector.ONE
	offset = offset or Vector.ZERO

	local transform = love.math.newTransform()
	transform:translate(offset:get())
	transform:translate(position:get())
	transform:scale(scale:get())
	transform:applyQuaternion(rotation:get())
	transform:translate((-offset):get())

	return transform
end

return Common
