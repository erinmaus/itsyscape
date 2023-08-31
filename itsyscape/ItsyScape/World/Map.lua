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
			local tile = Tile()
			self.tiles[j * self.width + i] = tile
			tile:setData("x-map-i", i)
			tile:setData("x-map-j", j)
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

	local s = i
	local t = j

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

	return i, j, s, t
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
	local x = (math.floor(i + 0.5) - 0.5) * self.cellSize
	local z = (math.floor(j + 0.5) - 0.5) * self.cellSize
	local y = self:getInterpolatedHeight(x, z)

	return Vector(x, y, z)
end

-- Gets the interpolated height at (x, z).
--
-- If x or z are outside the bounds, they are clamped to the nearest tile.
--
-- Returns the height.
function Map:getInterpolatedHeight(x, z)
	local tile = self:getTileAt(x, z)

	x = x / self.cellSize
	z = z / self.cellSize

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

function Map:isOutOfBounds(x, z)
	local i = math.floor(x / self.cellSize) + 1
	local j = math.floor(z / self.cellSize) + 1

	if i < 1 or i > self:getWidth() or j < 1 or j > self:getHeight() then
		return true
	end

	return false
end

function Map:lineOfSightPassable(i1, j1, i2, j2, shoot)
	if i1 == i2 and j1 == j2 then
		return true
	end

	local steep = math.abs(j2 - j1) > math.abs(i2 - i1);

	if steep then
		i1, j1 = j1, i1
		i2, j2 = j2, i2
	end

	local dx = math.abs(i2 - i1)
	local dy = math.abs(j2 - j1)
	local error = math.floor(dx / 2)
	local ystep = (j1 < j2 and 1) or -1
	local xstep = (i1 < i2 and 1) or -1
	local y = j1
	local x = i1

	local pi, pj
	if steep then
		pi = y
		pj = x
	else
		pi = x
		pj = y
	end

	while x ~= (i2 + xstep) do
		error = error - dy
		if error < 0 then
			y = y + ystep
			error = error + dx
		end

		x = x + xstep

		do
			local i, j
			if steep then
				i = y
				j = x
			else
				i = x
				j = y
			end

			if not self:canMove(i, j, i - pi, j - pj, shoot) then
				return false
			end

			pi = i
			pj = j
		end
	end

	return true
end

function Map:canMove(i, j, di, dj, shoot)
	if math.abs(di) > 1 or math.abs(dj) > 1 then
		return false
	end

	if di == 0 and dj == 0 then
		return true
	end

	local tile = self:getTile(i, j)

	local isLeftPassable, isRightPassable
	local isTopPassable, isBottomPassable
	if di < 0 and i > 1 then
		local left = self:getTile(i - 1, j)
		if (left.topRight <= tile.topLeft or
		    left.bottomRight <= tile.bottomLeft) and
		   (left:getIsPassable() or (left:hasFlag("shoot") and shoot)) and
		   (not left:hasFlag("wall-right") and not tile:hasFlag("wall-left"))
		then
			isLeftPassable = true
		end
	end

	if di > 0 and i < self:getWidth() then
		local right = self:getTile(i + 1, j)
		if (right.topLeft <= tile.topRight or
		    right.bottomLeft <= tile.bottomRight) and
		   (right:getIsPassable() or (right:hasFlag("shoot") and shoot)) and
		   (not right:hasFlag("wall-left") and not tile:hasFlag("wall-right"))
		then
			isRightPassable = true
		end
	end

	if dj < 0 and j > 1 then
		local top = self:getTile(i, j - 1)
		if (top.bottomLeft <= tile.topLeft or
		    top.bottomRight <= tile.topRight) and
		   (top:getIsPassable() or (top:hasFlag("shoot") and shoot)) and
		   (not top:hasFlag("wall-bottom") and not tile:hasFlag("wall-top"))
		then
			isTopPassable = true
		end
	end

	if dj > 0 and j < self:getHeight() then
		local bottom = self:getTile(i, j + 1)
		if (bottom.topLeft <= tile.bottomLeft or
		    bottom.topRight <= tile.bottomRight) and
		   (bottom:getIsPassable() or (bottom:hasFlag("shoot") and shoot)) and
		   (not bottom:hasFlag("wall-top") and not tile:hasFlag("wall-bottom"))
		then
			isBottomPassable = true
		end
	end

	if math.abs(di) + math.abs(dj) > 1 then
		if di < 0 and dj < 0 and i > 1 and j > 1 then
			local topLeft = self:getTile(i - 1, j - 1)
			if topLeft.bottomRight <= tile.topLeft and
			   (topLeft:getIsPassable({ 'impassable' }) or (topLeft:hasFlag("shoot") and shoot))
			then
				return isTopPassable and isLeftPassable
			else
				return false
			end
		end

		if di < 0 and dj > 1 and i > 1 and j < self:getHeight() then
			local bottomLeft = self:getTile(i - 1, j + 1)
			if bottomLeft.topRight <= tile.bottomLeft and
			   (bottomLeft:getIsPassable({ 'impassable' }) or (bottomLeft:hasFlag("shoot") and shoot))
			then
				return isBottomPassable and isLeftPassable
			else
				return false
			end
		end

		if di > 0 and dj < 0 and i < self:getWidth() and j > 1 then
			local topRight = self:getTile(i + 1, j - 1)
			if topRight.bottomLeft <= tile.topRight and
			   (topRight:getIsPassable({ 'impassable' }) or (topRight:hasFlag("shoot") and shoot))
			then
				return isTopPassable and isRightPassable
			else
				return false
			end
		end

		if di > 0 and dj > 0 and i < self:getWidth() and j < self:getHeight() then
			local bottomRight = self:getTile(i + 1, j + 1)
			if bottomRight.topLeft <= tile.bottomRight and
			   (bottomRight:getIsPassable({ 'impassable' }) or (bottomRight:hasFlag("shoot") and shoot))
			then
				return isBottomPassable and isRightPassable
			else
				return false
			end
		end
	end

	return isLeftPassable or isRightPassable or isTopPassable or isBottomPassable
end

function Map.loadFromTable(t)
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
			outputTile.red = inputTile.red or 1
			outputTile.green = inputTile.green or 1
			outputTile.blue = inputTile.blue or 1

			outputTile.edge = inputTile.edge or 2
			outputTile.flat = inputTile.flat or 1
			outputTile.mask = inputTile.mask or {}
			for _, decal in ipairs(inputTile.decals or {}) do
				table.insert(outputTile.decals, decal)
			end

			for flag in pairs(inputTile.flags or {}) do
				outputTile:setFlag(flag)
			end

			for key, value in pairs(inputTile.data or {}) do
				outputTile:setData(key, value)
			end

			outputTile.tileSetID = inputTile.tileSetID or ""

			index = index + 1
		end
	end

	return result
end

function Map.loadFromString(value)
	local data = "return " .. value or ""
	local chunk = assert(loadstring(data))
	local t = setfenv(chunk, {})() or { width = 1, height = 1, cellSize = 2, tiles = { {} } }

	return Map.loadFromTable(t)
end

-- Deserializes the Map.
function Map.loadFromFile(filename)
	local cacheFilename = filename .. ".cache"
	local hasCache = love.filesystem.getInfo(cacheFilename)
	if hasCache then
		local chunk = assert(load(love.filesystem.read(cacheFilename)))
		local t = assert(setfenv(chunk, {})())

		return Map.loadFromTable(t)
	else
		return Map.loadFromString(love.filesystem.read(filename))
	end
end

function Map:serialize()
	local result = {
		width = self.width,
		height = self.height,
		cellSize = self.cellSize,
		tiles = {}
	}

	for j = 1, self.height do
		for i = 1, self.width do
			local tile = self:getTile(i, j)
			table.insert(result.tiles, tile:serialize())
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
					"red = %f, green = %f, blue = %f,",
					tile.red, tile.green, tile.blue)

				r:pushIndent(3)
				r:pushFormatLine(
					"edge = %d, flat = %d, decals = { %s },",
					tile.edge, tile.flat, table.concat(tile.decals, ", "))

				if next(tile.mask, nil) then
					r:pushIndent(3)

					local m = {}
					for key, value in pairs(tile.mask) do
						table.insert(m, { key = key, value = value })
					end

					table.sort(m, function(a, b) return a.key < b.key end)

					for index, mask in ipairs(m) do
						m[index] = string.format("[%d] = %d", mask.key, mask.value)
					end

					r:pushFormatLine("mask = { %s },", table.concat(m, ", "))
				end

				r:pushIndent(3)
				r:pushLine("data =")
				r:pushIndent(3)
				r:pushLine("{")
				for key, value in tile:iterateData() do
					if not key:match("^x%-") then
						local v
						if type(value) == 'string' then
							v = StringBuilder.stringify(value, "%q")
						elseif type(value) ~= 'table' then
							v = StringBuilder.stringify(value)
						else
							-- TODO
							v = "nil --[[ table ]]"
						end

						r:pushIndent(4)
						r:pushFormatLine("[%q] = %s,", key, v)
					end
				end
				r:pushIndent(3)
				r:pushLine("},")

				r:pushIndent(3)
				r:pushLine("flags =")
				r:pushIndent(3)
				r:pushLine("{")
				for flag in tile:iterateFlags() do
					if not flag:match("^x%-") then
						r:pushIndent(4)
						r:pushFormatLine("[%q] = true,", flag)
					end
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
