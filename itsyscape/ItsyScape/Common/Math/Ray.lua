--------------------------------------------------------------------------------
-- ItsyScape/Common/Math/Ray.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Ray type, composed of an origin and direction.
local Ray = Class()

-- Constructs a ray with the specified origin and direction.
--
-- * origin defaults to (0, 0, 0) if unprovided.
-- * direction defaults to (0, 0, 1) in unprovided; is also normalized
function Ray:new(origin, direction)
	self.origin = origin or Vector()
	self.direction = (direction or Vector(0, 0, 1)):getNormal()
end

-- Returns a point distance units along the ray.
function Ray:project(distance)
	return self.origin + self.direction * distance
end

-- Checks if the ray intersects the triangle (v1, v2, v3).
--
-- Returns true and the point (Vector) of collision, false otherwise.
function Ray:hitTriangle(v1, v2, v3)
	-- http://www.lighthouse3d.com/tutorials/maths/ray-triangle-intersection/
	local E = 0.01
	local p = self.origin
	local d = self.direction
	local e1, e2, h, s, q
	local a, f, u, v, t
	
	e1 = v2 - v1
	e2 = v3 - v1

	h = d:cross(e2)
	a = e1:dot(h)

	if math.abs(a) < E then
		return false
	end

	f = 1 / a
	s = p - v1
	u = f * s:dot(h)

	if u < 0 or u > 1 then
		return false
	end

	q = s:cross(e1)
	v = f * d:dot(q)

	if v < 0 or u + v > 1 then
		return false
	end

	t = f * e2:dot(q)
	if t > E then
		return true, p + d * t
	end

	return false
end

-- Checks if the ray intersects the AABB (min, max).
--
-- Returns true and the point (Vector) of collision, false otherwise.
function Ray:hitBounds(min, max)
	-- https://tavianator.com/fast-branchless-raybounding-box-intersections/
	local inverseDirection = 1 / self.direction
	local tMin, tMax

	local tx1 = (min.x - self.origin.x) * inverseDirection.x
	local tx2 = (max.x - self.origin.x) * inverseDirection.x
 
	local tMin = math.min(tx1, tx2)
	local tMax = math.max(tx1, tx2)
 
	local ty1 = (min.y - self.origin.y) * inverseDirection.y
	local ty2 = (max.y - self.origin.y) * inverseDirection.y
 
	tMin = math.max(tMin, math.min(ty1, ty2))
	tMax = math.min(tMax, math.max(ty1, ty2))
 
	local tz1 = (min.z - self.origin.z) * inverseDirection.z
	local tz2 = (max.z - self.origin.z) * inverseDirection.z
 
	tMin = math.max(tMin, math.min(tz1, tz2))
	tMax = math.min(tMax, math.max(tz1, tz2))
 
	if tMax >= tMin and tMin >= 0 then
		return true, self.origin + self.direction * tMin
	else
		return false
	end
end

return Ray
