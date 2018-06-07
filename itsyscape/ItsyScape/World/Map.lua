--------------------------------------------------------------------------------
-- ItsyScape/World/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tile = require "ItsyScape.World.Tile"

-- Map type. Stores tiles.
local Map = Class()

-- Constructs a new stage with the provided dimensions.
--
-- * Values default to 1 if not provided.
-- * Values are clamped to at least 1.
-- * Values are floored to the nearest integer.
--
-- The initial map is flat.
function Map:new(width, height, cellSize)
	width = math.floor(math.max(width or 1, 1))
	height = math.floor(math.max(height or 1, 1))
	cellSize = math.floor(math.max(cellSize or 1, 1))

	self.width = width
	self.height = height
	self.cellSize = cellSize

	self.tiles = {}
	for j = 1, height do
		for i = 1, width do
			self.tiles[j * self.width + i] = Tile()
		end
	end
end

function Map:getWidth()
	return self.width
end

function Map:getHeight()
	return self.height
end

function Map:getCellSize()
	return self.cellSize
end

-- Gets the tile at (i, j).
--
-- If i or j are outside the bounds of the heightmap, they are clamped to the
-- nearest extent (1 or [width, height]).
--
-- Any fractional portion of i or j is discarded.
--
-- Returns a tuple of (tile, i, j), where i and j are the clamped indices.
function Map:getTile(i, j)
	i = math.floor(i)
	j = math.floor(j)

	if i < 1 then
		i = 1
	elseif i > self.width then
		i = self.width
	end

	if j < 1 then
		j = 1
	elseif j > self.height then
		j = self.height
	end

	return self.tiles[j * self.width + i], i, j
end

-- Gets the tile position at (x, *, z).
--
-- Returns (nil, nil) if (x, z) are out of bounds.
function Map:toTile(x, z)
	local i = math.floor(x / self.cellSize) + 1
	local j = math.floor(z / self.cellSize) + 1

	if i < 0 or j < 0 or i > self.width or j > self.height then
		return nil, nil
	else
		return i, j
	end
end

-- Gets a tile at (x, *, z).
--
-- If x or z are outside the bounds of the heightmap, they are clamped to the
-- nearest extent (0 or [width * self.cellSize, height * self.cellSize]).
--
-- Returns a tuple of (tile, i, j), where i and j are the indices of the tile
-- in the map.
function Map:getTileAt(x, z)
	local i = math.floor(x / self.cellSize) + 1
	local j = math.floor(z / self.cellSize) + 1
	return self:getTile(i, j)
end

-- Gets the center of the tile at (i, j).
--
-- i and j are not clamped.
--
-- Returns a Vector with the center of the tile in world space.
function Map:getTileCenter(i, j)
	local x = (i - 0.5) * self.cellSize
	local z = (j - 0.5) * self.cellSize
	local y = self:getInterpolatedHeight(x, z)

	return Vector(x, y, z)
end

-- Gets the interpolated height at (x, z).
--
-- If x or z are outside the bounds, they are clamped to the nearest tile.
--
-- Returns the height.
function Map:getInterpolatedHeight(x, z)
	x = x / self.cellSize
	z = z / self.cellSize

	local tile = self:getTile(x + 1, z + 1)
	if tile then
		return tile:getInterpolatedHeight(x - math.floor(x), z - math.floor(z))
	end

	return 0
end

Map.RAY_TEST_RESULT_TILE = 1
Map.RAY_TEST_RESULT_POSITION = 2
Map.RAY_TEST_RESULT_I = 3
Map.RAY_TEST_RESULT_J = 4

-- Tests for a collision with the ray.
--
-- Returns an array of elements in the form { tile, position, i, j } of each
-- tile hit, where i and j are the tile indices.
--
-- If the array is empty, then no tiles were hit...
function Map:testRay(ray)
	local hitTiles = {}
	for j = 1, self.height do
		for i = 1, self.width do
			local tile = self:getTile(i, j)
			local success, point = tile:testRay(ray, i, j, self.cellSize)
			if success then
				table.insert(hitTiles, { tile, point, i, j })
			end
		end
	end

	return hitTiles
end

return Map
