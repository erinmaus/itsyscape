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
local Vector = require "ItsyScape.Common.Math.Vector"

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

function Ray:closest(point)
	local v = point - self.origin
	local dot = v:dot(self.direction)
	if dot == 0 then
		return nil, self.origin
	end

	return dot > 0, self:project(dot)
end

function Ray:side(point)
	local v = point - self.origin
	local dot = v:dot(self.direction)

	if dot < 0 then
		return -1
	elseif dot > 0 then
		return 1
	else
		return 0
	end
end

function Ray:intersect(other)
	local da = self.origin
	local db = other.origin
	local dc = other.origin - self.origin

	if Vector.dot(dc, Vector.cross(da, db)) ~= 0 then
		return false
	end

	local lengthSquared = Vector.cross(da, db):getLengthSquared()
	if lengthSquared == 0 then
		return false
	end

	local s = Vector.dot(Vector.cross(dc, db), Vector.cross(da, db)) / lengthSquared
	local t = Vector.dot(Vector.cross(dc, da), Vector.cross(da, db)) / lengthSquared

	if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
		local point = self.origin + da * s
		local success = self:closest(point) and other:closest(point)

		return success, point
	end
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
function Ray:hitBounds(min, max, transform)
	local r
	if transform then
		local MathCommon = require "ItsyScape.Common.Math.Common"
		local inverse = transform:inverse()

		local _, rotation = MathCommon.decomposeTransform(inverse)
		local p = Vector(inverse:transformPoint(self.origin:get()))
		local d = rotation:transformVector(self.direction):getNormal()

		r = Ray(p, d)
	else
		r = self
	end

	-- https://tavianator.com/fast-branchless-raybounding-box-intersections/
	local inverseDirection = 1 / r.direction
	local tMin, tMax

	local tx1 = (min.x - r.origin.x) * inverseDirection.x
	local tx2 = (max.x - r.origin.x) * inverseDirection.x
 
	local tMin = math.min(tx1, tx2)
	local tMax = math.max(tx1, tx2)
 
	local ty1 = (min.y - r.origin.y) * inverseDirection.y
	local ty2 = (max.y - r.origin.y) * inverseDirection.y
 
	tMin = math.max(tMin, math.min(ty1, ty2))
	tMax = math.min(tMax, math.max(ty1, ty2))
 
	local tz1 = (min.z - r.origin.z) * inverseDirection.z
	local tz2 = (max.z - r.origin.z) * inverseDirection.z
 
	tMin = math.max(tMin, math.min(tz1, tz2))
	tMax = math.min(tMax, math.max(tz1, tz2))
 
	if tMax >= tMin and tMin >= 0 then
		return true, r.origin + r.direction * tMin
	else
		return false
	end
end

return Ray
