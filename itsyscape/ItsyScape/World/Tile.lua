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
Tile.IMPASSABLE_FLAGS = {
	'impassable',
	'door'
}

Tile.EMPTY_ARGS = {}

function Tile:new(t)
	t = t or Tile.EMPTY_ARGS

	-- The edge texture index. Defaults to the first edge texture.
	self.edge = t.edge or 1

	-- The flat texture index. Defaults to the first flat texture.
	self.flat = t.flat or 1

	-- Decals. Corresponds to textures.
	self.decals = t.decals or {}

	-- The heights at the four corners of the tile.
	self.topLeft = t.topLeft or 0
	self.topRight = t.topRight or 0
	self.bottomLeft  = t.bottomLeft  or 0
	self.bottomRight = t.bottomRight or 0

	self.flags = t.flags or {}
	self.runtimeFlags = t.runtimeFlags or {}
	self.data = t.data or {}
	self.links = t.links or {}

	self.red = t.red or 1
	self.green = t.green or 1
	self.blue = t.blue or 1

	self.tileSetID = ""
end

function Tile:_getSerializedData()
	local result = {}
	for k, v in pairs(self.data) do
		if not Class.isClass(v) and not getmetatable(v) then
			result[k] = v
		end
	end

	return result
end

function Tile:serialize()
	return {
		edge = self.edge,
		flat = self.flat,
		decals = self.decals,
		topLeft = self.topLeft,
		topRight = self.topRight,
		bottomLeft = self.bottomLeft,
		bottomRight = self.bottomRight,
		flags = self.flags,
		runtimeFlags = self.runtimeFlags,
		data = self:_getSerializedData(),
		red = self.red,
		green = self.green,
		blue = self.blue,
		tileSetID = self.tileSetID
	}
end

function Tile:addLink(link)
	self.links[link] = true
end

function Tile:removeLink(link)
	self.links[link] = false
end

function Tile:iterateLinks()
	return pairs(self.links)
end

function Tile:pushFlag(flag)
	local depth = self.runtimeFlags[flag] or 0
	self.runtimeFlags[flag] = depth + 1
end

function Tile:popFlag(flag)
	local depth = self.runtimeFlags[flag] or 0
	if depth <= 1 then
		self.runtimeFlags[flag] = nil
	else
		self.runtimeFlags[flag] = depth - 1
	end
end

function Tile:setFlag(f)
	self.flags[tostring(f)] = true
end

function Tile:setRuntimeFlag(f)
	self.runtimeFlags[tostring(f)] = true
end

function Tile:unsetFlag(f)
	self.flags[tostring(f)] = nil
end

function Tile:unsetRuntimeFlag(f)
	self.runtimeFlags[tostring(f)] = nil
end

function Tile:hasFlag(f)
	f = tostring(f)
	return self.flags[f] == true or self.runtimeFlags[f]
end

function Tile:iterateFlags()
	local c = nil
	return function()
		c = next(self.flags, c)
		return c
	end
end

function Tile:getIsPassable(flags)
	flags = flags or Tile.IMPASSABLE_FLAGS

	for i = 1, #flags do
		local flag = flags[i]
		if self:hasFlag(flag) then
			return false
		end
	end

	return true
end

function Tile:setData(key, value)
	self.flags[tostring(key)] = value
end

function Tile:unsetData(key, value)
	self.flags[tostring(key)] = nil
end

function Tile:hasData(key, value)
	return self.flags[tostring(key)] ~= nil
end

function Tile:getData(key)
	return self.flags[tostring(key)]
end

function Tile:iterateData()
	local c = nil
	return function()
		c = next(self.data, c)
		return c, self.data[c]
	end
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

	local min = math.min(self.topLeft, self.topRight, self.bottomLeft, self.bottomRight)
	local max = math.max(self.topLeft, self.topRight, self.bottomLeft, self.bottomRight)

	return (max - min) / 2 + min
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
