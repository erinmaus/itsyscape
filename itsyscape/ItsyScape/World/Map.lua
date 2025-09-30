--------------------------------------------------------------------------------
-- ItsyScape/World/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local StringBuilder = require "ItsyScape.Common.StringBuilder"
local Ray = require "ItsyScape.Common.Math.Ray"
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
	return self:testRayWithCurves(ray)
end

function Map:testRayWithCurves(ray, ...)
	local hitTiles = {}
	for j = 1, self.height do
		for i = 1, self.width do
			local tile = self:getTile(i, j)
			local success, point = tile:testRayWithCurves(ray, i, j, self.cellSize, ...)
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

function Map:lineOfSightPassable(i1, j1, i2, j2, shoot, isDebug)
	if i1 == i2 and j1 == j2 then
		return true, i2, j2
	end

	local steep = math.abs(j2 - j1) > math.abs(i2 - i1)

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

	if isDebug then
		Log.info("Line of sight check from (%d, %d) to (%d, %d) engaged...", i1, j1, i2, j2)
	end

	while x ~= i2 do
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

			if isDebug then
				Log.info("Checking to see if peep can move to (%d, %d) from (%d, %d)...", i, j, pi, pj)
			end

			local di, dj = i - pi, j - pj
			if not self:canMove(pi, pj, di, dj, shoot, isDebug) then
				if isDebug then
					Log.info("Cannot move to (%d, %d) from (%d, %d)!", i, j, pi, pj)
				end

				return false, pi, pj
			end

			pi = i
			pj = j
		end
	end

	if isDebug then
		Log.info("Can move from (%d, %d) to (%d, %d)!", i1, j1, i2, j2)
	end

	return true, i2, j2
end

-- stepCallback is (map: Map, i: integer, j: integer, x: float, z: float, t: float) -> Boolean
-- where it returns something truthy to cancel or something falsey to cancel the ray cast
--
-- castRay returns the result from stepCallback, or false if there was no result
function Map:castRay(ray, stepCallback)
	local directionSignX = ray.direction.x > 0 and 1 or -1
	local directionSignZ = ray.direction.z > 0 and 1 or -1
	local tileOffsetI = (ray.direction.x > 0 and 1 or 0) - 1
	local tileOffsetJ = (ray.direction.z > 0 and 1 or 0) - 1

	local currentX, currentZ = ray.origin.x, ray.origin.z
	local _, tileI, tileJ = self:getTileAt(currentX, currentZ)
	local t = 0

	local result

	result = stepCallback(self, tileI, tileJ, currentX, currentZ, t)
	if result ~= nil then
		return result
	end

	if ray.direction.x ^ 2 + ray.direction.z ^ 2 > 0 then
		while tileI >= 1 and tileI <= self.width and tileJ >= 1 and tileJ <= self.height do
			local deltaX
			if ray.direction.x ~= 0 then
				deltaX = ((tileI + tileOffsetI) * self.cellSize - currentX) / ray.direction.x
			else
				deltaX = 0
			end

			local deltaZ
			if ray.direction.z ~= 0 then
				deltaZ = ((tileJ + tileOffsetJ) * self.cellSize - currentZ) / ray.direction.z
			else
				deltaZ = 0
			end

			local pt = t
			if deltaX < deltaZ and ray.direction.x ~= 0 then
				t = t + deltaX
				tileI = tileI + directionSignX
			else
				t = t + deltaZ
				tileJ = tileJ + directionSignZ
			end

			currentX = ray.origin.x + ray.direction.x * t
			currentZ = ray.origin.z + ray.direction.z * t

			result = stepCallback(self, tileI, tileJ, currentX, currentZ, t)
			if result ~= nil then
				return result
			end
		end
	end

	return nil
end

function Map:canMove(i, j, di, dj, shoot, isPassableFunc, isDebug)
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
		if ((left.topRight == tile.topLeft or left.bottomRight == tile.bottomLeft) or
			(shoot and left.topRight <= tile.topLeft and left.bottomRight <= tile.bottomLeft)) and
		   (isPassableFunc and isPassableFunc(self, i, j, i - 1, j) or (left:getIsPassable() or (left:hasFlag("shoot") and shoot))) and
		   (not left:hasFlag("wall-right") and not tile:hasFlag("wall-left"))
		then
			isLeftPassable = true
		else
			if isDebug then
				Log.info("Left (passable = %s, shoot = %s) elevation diff: top = %.2f, bottom = %.2f",
					Log.boolean(left:getIsPassable()), Log.boolean(left:hasFlag("shoot") and shoot),
					left.topRight - tile.topLeft, left.bottomRight - tile.bottomLeft)
			end

			isLeftPassable = false
		end
	end

	if di > 0 and i < self:getWidth() then
		local right = self:getTile(i + 1, j)
		if ((right.topLeft == tile.topRight or right.bottomLeft == tile.bottomRight) or
			(shoot and right.topLeft <= tile.topRight and right.bottomLeft <= tile.bottomRight)) and
		   (right:getIsPassable() or (right:hasFlag("shoot") and shoot)) and
		   (not right:hasFlag("wall-left") and not tile:hasFlag("wall-right"))
		then
			isRightPassable = true
		else
			if isDebug then
				Log.info("Right (passable = %s, shoot = %s) elevation diff: top = %.2f, bottom = %.2f",
					Log.boolean(right:getIsPassable()), Log.boolean(right:hasFlag("shoot") and shoot),
					right.topLeft - tile.topRight, right.bottomLeft - tile.bottomRight)
			end

			isRightPassable = false
		end
	end

	if dj < 0 and j > 1 then
		local top = self:getTile(i, j - 1)
		if ((top.bottomLeft == tile.topLeft or top.bottomRight == tile.topRight) or
			(shoot and top.bottomLeft <= tile.topLeft and top.bottomRight <= tile.topRight)) and
		   (top:getIsPassable() or (top:hasFlag("shoot") and shoot)) and
		   (not top:hasFlag("wall-bottom") and not tile:hasFlag("wall-top"))
		then
			isTopPassable = true
		else
			if isDebug then
				Log.info("Top (passable = %s, shoot = %s) elevation diff: left = %.2f, right = %.2f",
					Log.boolean(top:getIsPassable()), Log.boolean(top:hasFlag("shoot") and shoot),
					top.bottomLeft - tile.topLeft, top.bottomRight - tile.topRight)
			end

			isBottomPassable = false
		end
	end

	if dj > 0 and j < self:getHeight() then
		local bottom = self:getTile(i, j + 1)
		if ((bottom.topLeft == tile.bottomLeft or bottom.topRight == tile.bottomRight) or
			(shoot and bottom.topLeft <= tile.bottomLeft and bottom.topRight <= tile.bottomRight)) and
		   (bottom:getIsPassable() or (bottom:hasFlag("shoot") and shoot)) and
		   (not bottom:hasFlag("wall-top") and not tile:hasFlag("wall-bottom"))
		then
			isBottomPassable = true
		else
			if isDebug then
				Log.info("Bottom (passable = %s, shoot = %s) elevation diff: left = %.2f, right = %.2f",
					Log.boolean(bottom:getIsPassable()), Log.boolean(bottom:hasFlag("shoot") and shoot),
					bottom.topLeft - tile.bottomLeft, bottom.topRight - tile.bottomRight)
			end

			isBottomPassable = false
		end
	end

	if isDebug then
		Log.info(
			"Passable (%d, %d -> %d, %d): left = %s, right = %s, top = %s, bottom = %s",
			i, j, i + di, j + dj,
			tostring(isLeftPassable), tostring(isRightPassable), tostring(isTopPassable), tostring(isBottomPassable))
	end

	if math.abs(di) + math.abs(dj) > 1 then
		if di < 0 and dj < 0 and i > 1 and j > 1 then
			local topLeft = self:getTile(i - 1, j - 1)
			if (topLeft.bottomRight == tile.topLeft or (shoot and topLeft.bottomRight <= tile.topLeft)) and
			   (topLeft:getIsPassable({ 'impassable' }) or (topLeft:hasFlag("shoot") and shoot))
			then
				if isDebug then
					Log.info(
						"(%d, %d) top left = %.2f, (%d, %d) bottom right = %.2f, passable = %s",
						i, j, tile.topLeft, i + di, j + dj, topLeft.bottomRight, Log.boolean(isTopPassable and isBottomPassable))
				end

				return (isTopPassable and isLeftPassable)
			else
				if isDebug then
					Log.info("Cannot move to top left (%d, %d): passable = %s, shoot = %s, elevation diff = %.2f",
						i + di, j + dj,
						Log.boolean(topLeft:getIsPassable({ 'impassable' })),
						Log.boolean(topLeft:hasFlag("shoot") and shoot),
						topLeft.bottomRight - tile.topLeft)
				end

				return false
			end
		end

		if di < 0 and dj > 1 and i > 1 and j < self:getHeight() then
			local bottomLeft = self:getTile(i - 1, j + 1)
			if (bottomLeft.topRight == tile.bottomLeft or (shoot and bottomLeft.topRight <= tile.bottomLeft)) and
			   (bottomLeft:getIsPassable({ 'impassable' }) or (bottomLeft:hasFlag("shoot") and shoot))
			then
				if isDebug then
					Log.info(
						"(%d, %d) bottom left = %.2f, (%d, %d) top right = %.2f, passable = %s",
						i, j, tile.bottomLeft, i + di, j + dj, bottomLeft.topRight, Log.boolean(isBottomPassable and isLeftPassable))
				end

				return (isBottomPassable and isLeftPassable)
			else
				if isDebug then
					Log.info("Cannot move to bottom left (%d, %d): passable = %s, shoot = %s, elevation diff = %.2f",
						i + di, j + dj,
						Log.boolean(bottomLeft:getIsPassable({ 'impassable' })),
						Log.boolean(bottomLeft:hasFlag("shoot") and shoot),
						bottomLeft.topRight - tile.bottomLeft)
				end

				return false
			end
		end

		if di > 0 and dj < 0 and i < self:getWidth() and j > 1 then
			local topRight = self:getTile(i + 1, j - 1)
			if (topRight.bottomLeft == tile.topRight or (shoot and topRight.bottomLeft <= tile.topRight)) and
			   (topRight:getIsPassable({ 'impassable' }) or (topRight:hasFlag("shoot") and shoot))
			then
				if isDebug then
					Log.info(
						"(%d, %d) top right = %.2f, (%d, %d) bottom left = %.2f, passable = %s",
						i, j, tile.topRight, i + di, j + dj, topRight.bottomLeft, Log.boolean(isTopPassable and isRightPassable))
				end

				return (isTopPassable and isRightPassable)
			else
				if isDebug then
					Log.info("Cannot move to top right (%d, %d): passable = %s, shoot = %s, elevation diff = %.2f",
						i + di, j + dj,
						Log.boolean(topRight:getIsPassable({ 'impassable' })),
						Log.boolean(topRight:hasFlag("shoot") and shoot),
						topRight.bottomLeft - tile.topRight)
				end

				return false
			end
		end

		if di > 0 and dj > 0 and i < self:getWidth() and j < self:getHeight() then
			local bottomRight = self:getTile(i + 1, j + 1)
			if (bottomRight.topLeft == tile.bottomRight or (shoot and bottomRight.topLeft <= tile.bottomRight)) and
			   (bottomRight:getIsPassable({ 'impassable' }) or (bottomRight:hasFlag("shoot") and shoot))
			then
				if isDebug then
					Log.info(
						"(%d, %d) bottom right = %.2f, (%d, %d) top left = %.2f, passable = %s",
						i, j, tile.bottomRight, i + di, j + dj, bottomRight.topLeft, Log.boolean(isBottomPassable and isRightPassable))
				end

				return (isBottomPassable and isRightPassable)
			else
				if isDebug then
					Log.info("Cannot move to bottom right (%d, %d): passable = %s, shoot = %s, elevation diff = %.2f",
						i + di, j + dj,
						Log.boolean(bottomRight:getIsPassable({ 'impassable' })),
						Log.boolean(bottomRight:hasFlag("shoot") and shoot),
						bottomRight.topLeft - tile.bottomRight)
				end

				return false
			end
		end
	end

	return (isLeftPassable or isLeftPassable == nil) and
	       (isRightPassable or isRightPassable == nil) and
	       (isTopPassable or isTopPassable == nil) and
	       (isBottomPassable or isBottomPassable == nil)
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
		local t = buffer.decode(love.filesystem.read(cacheFilename))
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

				if tile.tileSetID ~= "" then
					r:pushIndent(3)
					r:pushFormatLine(
						"tileSetID = %q,",
						tile.tileSetID)
				end

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
