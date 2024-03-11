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

local function _getKnotInterval(a, b, alpha)
	return (a - b):getLength() ^ (0.5 * alpha)
end

local function _remap(a, b, c, d, u)
	return c:lerp(d, (u - a) / (b - a))
end

function Common.spline(t, p0, p1, p2, p3, alpha)
	alpha = alpha or 1

	local k0 = 0
	local k1 = _getKnotInterval(p0, p1, alpha)
	local k2 = _getKnotInterval(p1, p2, alpha) + k1
	local k3 = _getKnotInterval(p2, p3, alpha) + k2

	local u = k1 * (1 - t) + k2 * t

	local A1 = _remap(k0, k1, p0, p1, u)
	local A2 = _remap(k1, k2, p1, p2, u)
	local A3 = _remap(k2, k3, p2, p3, u)
	local B1 = _remap(k0, k2, A1, A2, u)
	local B2 = _remap(k1, k3, A2, A3, u)

	return _remap(k1, k2, B1, B2, u)
end

return Common
