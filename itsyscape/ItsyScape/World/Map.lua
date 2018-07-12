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
local StringBuilder = require "ItsyScape.Common.StringBuilder"
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

	return i, j
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

-- Deserializes the Map.
function Map.loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local t = setfenv(chunk, {})() or { width = 1, height = 1, cellSize = 2, tiles = { {} } }

	local result = Map(t.width or 1, t.height or 1, t.cellSize or 2)
	local index = 1
	for j = 1, result.height do
		for i = 1, result.width do
			local inputTile = (t.tiles or {})[index] or {}
			local outputTile = result:getTile(i, j)

			outputTile.topLeft = inputTile.topLeft or 1
			outputTile.topRight = inputTile.topRight or 1
			outputTile.bottomLeft = inputTile.bottomLeft or 1
			outputTile.bottomRight = inputTile.bottomRight or 1

			outputTile.edge = inputTile.edge or 2
			outputTile.flat = inputTile.flat or 1
			for _, decal in ipairs(inputTile.decals or {}) do
				table.insert(outputTile.decals, decal)
			end

			for flag in pairs(inputTile.flags or {}) do
				outputTile:setFlag(flag)
			end

			for key, value in pairs(inputTile.data or {}) do
				outputTile:setData(key, value)
			end

			index = index + 1
		end
	end

	return result
end

-- Serializes the Map.
function Map:toString()
	local r = StringBuilder()

	r:pushLine("{")
	do
		r:pushIndent(1)
		r:pushFormatLine("width = %d,", self.width)
		r:pushIndent(1)
		r:pushFormatLine("height = %d,", self.height)
		r:pushIndent(1)
		r:pushFormatLine("cellSize = %d,", self.cellSize)

		r:pushIndent(1)
		r:pushLine("tiles =")
		r:pushIndent(1)
		r:pushLine("{")

		local tiles = {}
		for j = 1, self.height do
			for i = 1, self.width do
				local tile = self:getTile(i, j)
				table.insert(tiles, tile)
			end
		end

		for i = 1, #tiles do
			local tile = tiles[i]

			r:pushIndent(2)
			r:pushLine("{")
			do
				r:pushIndent(3)
				r:pushFormatLine(
					"topLeft = %d, topRight = %d, bottomLeft = %d, bottomRight = %d,",
					tile.topLeft, tile.topRight, tile.bottomLeft, tile.bottomRight)

				r:pushIndent(3)
				r:pushFormatLine(
					"edge = %d, flat = %d, decals = { %s },",
					tile.edge, tile.flat, table.concat(tile.decals, ", "))

				r:pushIndent(3)
				r:pushLine("data =")
				r:pushIndent(3)
				r:pushLine("{")
				for key, value in tile:iterateData() do
					local v
					if type(value) == 'string' then
						v = StringBuilder.stringify(value, "%q")
					elseif type(value) ~= 'table' then
						v = StringBuilder.stringify(value)
					else
						-- TODO
						v = "nil --[[ table ]]"
					end
					
					r:pushFormatLine("[%q] = %s", key, v)
				end
				r:pushIndent(3)
				r:pushLine("},")

				r:pushIndent(3)
				r:pushLine("flags =")
				r:pushIndent(3)
				r:pushLine("{")
				for flag in tile:iterateFlags() do
					r:pushFormatLine("[%q] = true", flag)
				end
				r:pushIndent(3)
				r:pushLine("},")
			end
			r:pushIndent(2)
			r:pushLine("},")
		end
		r:pushIndent(1)
		r:pushLine("}")
	end
	r:pushLine("}")

	return r:toString()
end

return Map
