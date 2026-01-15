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
local NTransform = require "nbunny.transform"

local Common = {}

function Common.makeInverseTransform(transform, result)
	result = result or transform
	NTransform.inverse(transform, result)
	return result
end

function Common.decomposeTransform(transform, translation, rotation)
	local m11, m21, m31, m41,
	      m12, m22, m32, m42,
	      m13, m23, m33, m43,
	      m14, m24, m34, m44 = transform:getMatrix("column")

	translation = translation or Vector()
	rotation = rotation or Quaternion()

	local t, q
	if m33 < 0 then
		if m11 > m22 then
			t = 1 + m11 - m22 - m33;
			rotation.x = t
			rotation.y = m12 + m21
			rotation.z = m31 + m13
			rotation.w = m23 - m32
		else
			t = 1 - m11 + m22 - m33;
			rotation.x = m12 + m21
			rotation.y = t
			rotation.z = m23 + m32
			rotation.w = m31 - m13
		end
	else
		if m11 < -m22 then
			t = 1 - m11 - m22 + m33;
			rotation.x = m31 + m13
			rotation.y = m23 + m32
			rotation.z = t
			rotation.w = m12 - m21
		else
			t = 1 + m11 + m22 + m33;
			rotation.x = m23 - m32
			rotation.y = m31 - m13
			rotation.z = m12 - m21
			rotation.w = t
		end
	end

	rotation.x = rotation.x * (0.5 / math.sqrt(t))
	rotation.y = rotation.y * (0.5 / math.sqrt(t))
	rotation.z = rotation.z * (0.5 / math.sqrt(t))
	rotation.w = rotation.w * (0.5 / math.sqrt(t))

	translation.x = m41
	translation.y = m42
	translation.z = m43

	return translation, rotation
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

function Common.makeOrthoTransform(left, right, bottom, top, near, far, transform)
	transform = transform or love.math.newTransform()

	print("left-right", left, right)
	print("bottom-top", bottom, top)
	print("near-far", near, far)

	local m11, m12, m13, m14 = 2 / (right - left), 0, 0, -(right + left) / (right - left)
	local m21, m22, m23, m24 = 0, 2 / (top - bottom), 0, -(top + bottom) / (top - bottom)
	local m31, m32, m33, m34 = 0, 0, -2 / (far - near), -(far + near) / (far - near)
	local m41, m42, m43, m44 = 0, 0, 0, 1

	transform:setMatrix(
		m11, m12, m13, m14,
		m21, m22, m23, m24,
		m31, m32, m33, m34,
		m41, m42, m43, m44)

	return transform
end

do
	local negatedOffset = Vector()
	local offsetTransform = love.math.newTransform()
	local translationTransform = love.math.newTransform()
	local rotationTransform = love.math.newTransform()
	local scaleTransform = love.math.newTransform()

	function Common.makeTransform(translation, rotation, scale, offset, result)
		result = result or love.math.newTransform()
		result:reset()

		if offset then
			Common.makeTranslationTransform(offset, offsetTransform)
			result:apply(offsetTransform)
		end

		if translation then
			Common.makeTranslationTransform(translation, translationTransform)
			result:apply(translationTransform)
		end

		if scale then
			Common.makeScaleTransform(scale, scaleTransform)
			result:apply(scaleTransform)
		end

		if rotation then
			Common.makeRotationTransform(rotation, rotationTransform)
			result:apply(rotationTransform)
		end

		if offset then
			offset:negate(negatedOffset)
			Common.makeTranslationTransform(negatedOffset, offsetTransform)
			result:apply(offsetTransform)
		end

		return transform
	end
end

return Common
