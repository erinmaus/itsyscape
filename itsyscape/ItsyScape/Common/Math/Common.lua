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
	      m14, m24, m34, m44 = transform:getMatrix()

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

	return a + bMinusA * t
end

return Common
