--------------------------------------------------------------------------------
-- ItsyScape/World/Tile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

-- Tile type.
--
-- Stores tile information.
local Tile = Class()

Tile.CREASE_FORWARD = 1
Tile.CREASE_BACKWARD = 2

function Tile:new()
	-- The edge texture index. Defaults to the first edge texture.
	self.edge = 1

	-- The flat texture index. Defaults to the first flat texture.
	self.flat = 1

	-- The heights at the four corners of the tile.
	self.topLeft = 0
	self.topRight = 0
	self.bottomLeft  = 0
	self.bottomRight = 0
end

function Tile:getCrease()
	if self.topLeft == self.bottomRight then
		return Tile.CREASE_FORWARD
	else
		return Tile.CREASE_BACKWARD
	end
end

function Tile:getCornerName(s, t)
	local prefix
	local suffix
	if s == 1 then
		suffix = 'Left'
	elseif s == 2 then
		suffix = 'Right'
	end

	if t == 1 then
		prefix = 'top'
	elseif t == 2 then
		prefix = 'bottom'
	end

	if prefix and suffix then
		return prefix .. suffix
	else
		return nil
	end
end

function Tile:getCorner(s, t)
	local corner = self:getCornerName(s, t)
	if corner then
		return self[corner]
	else
		return math.huge
	end
end

function Tile:clamp(s, t, value, direction, maxDistance)
	local corner = self:getCornerName(s, t)
	local n = self[corner] - value
	if math.abs(n) > maxDistance then
		if direction < 1 then
			self[corner] = value - maxDistance
		else
			self[corner] = value + maxDistance
		end
	end
end

function Tile:setCorner(s, t, value)
	local corner = self:getCornerName(s, t)
	local direction = self[corner] - value
	if corner then
		self[corner] = value

		local ns = (s % 2) + 1
		local nt = (t % 2) + 1
		self:clamp(ns, t, value, direction, 1)
		self:clamp(s, nt, value, direction, 1)
		self:clamp(ns, nt, value, direction, 2)
	end
end

-- Ensures the corners are not fractional (i.e., they are integers).
-- Similarly, ensures all heights are +/- 1 of the maximum.
function Tile:snapCorners(mode)
	mode = mode or 'max'

	self.topLeft = math.floor(self.topLeft)
	self.topRight = math.floor(self.topRight)
	self.bottomLeft = math.floor(self.bottomLeft)
	self.bottomRight = math.floor(self.bottomRight)

	local function snap(v, s, t)
		local reference
		if mode == 'max' then
			reference = math.max(v, s, t)
		elseif mode == 'min' then
			reference = math.min(v, s, t)
		else
			error("expected 'min' or 'max'", 2)
		end

		local difference = v - reference
		if math.abs(difference) > 1 then
			if difference < 0 then
				v = reference - 1
			else
				v = reference + 1
			end
		end

		return v
	end

	self.topLeft = snap(self.topLeft, self.topRight, self.bottomLeft)
	self.topRight = snap(self.topRight, self.topLeft, self.bottomRight)
	self.bottomLeft = snap(self.bottomLeft, self.topLeft, self.bottomRight)
	self.bottomRight = snap(self.bottomRight, self.bottomLeft, self.topRight)
end

-- Computes the interpolated height (y) at x%, z%.
--
-- 'x' and 'z' should be between 0 and 1 inclusive. They are clamped if not.
--
-- Returns the interpolated height.
function Tile:getInterpolatedHeight(x, z)
	x = math.min(math.max(x, 0), 1)
	z = math.min(math.max(z, 0), 1)

	local tz0 = self.topLeft
	local tz1 = self.topRight
	local tz2 = self.bottomLeft
	local tz3 = self.bottomRight

	if x + z < 1 then
		return tz0 + (tz1 - tz0) * x + (tz2 - tz0) * z
	else
		return tz3 + (tz1 - tz3) * (1 - z) + (tz2 - tz3) * (1 - x)
	end
end

-- Checks if the ray intersects the triangle.
--
-- * i, j represent the index of the tile in the stage.
-- * scale corresponds Stage's cellSize; in other words, it's the size of a tile
--   on the XZ plane.
--
-- Returns true and the point of collision if the ray intersects, false
-- otherwise.
function Tile:testRay(ray, i, j, scale)
	local topLeft = Vector((i - 1) * scale, self.topLeft, (j - 1) * scale)
	local topRight = Vector(i * scale, self.topRight, (j - 1) * scale)
	local bottomLeft = Vector((i - 1) * scale, self.bottomLeft, j * scale)
	local bottomRight = Vector(i * scale, self.bottomRight, j * scale)

	local success, point
	do
		local s1, p1 = ray:hitTriangle(topLeft, topRight, bottomRight)
		local s2, p2 = ray:hitTriangle(topLeft, bottomRight, bottomLeft)

		success = s1 or s2
		point = p1 or p2
	end

	return success, point
end

Tile.CORNERS = {
	{ name =     'topLeft', offsetX = -1, offsetY = -1 },
	{ name =    'topRight', offsetX =  0, offsetY = -1 },
	{ name =  'bottomLeft', offsetX = -1, offsetY =  0 },
	{ name = 'bottomRight', offsetX =  0, offsetY =  0 }
}

Tile.NEAREST_CORNER_RESULT_CORNER = 1
Tile.NEAREST_CORNER_RESULT_DISTANCE = 2


-- Finds the nearest corner to 'position'.
--
-- * i, j represent the index of the tile in the stage.
-- * scale corresponds Stage's cellSize; in other words, it's the size of a tile
--   on the XZ plane.
--
-- The tile's corners are transformed into world units and compared against
-- position.
--
-- Returns the closest corner, the distance to corner, and an array with
-- elements in the form { corner, distance }.
function Tile:findNearestCorner(position, i, j, scale)
	local corners = {}
	local bestDistance = math.huge
	local best = ''

	for k = 1, #Tile.CORNERS do
		local corner = Tile.CORNERS[k]
		local cornerPosition = Vector(
			(i + corner.offsetX) * scale,
			self[corner.name],
			(j + corner.offsetY) * scale)
		local distance = (position - cornerPosition):getLength()
		if distance < bestDistance then
			best = corner.name
		end

		table.insert(corners, { corner.name, distance })
	end

	return best, bestDistance, corners
end

Tile.EMPTY = Tile()

return Tile
