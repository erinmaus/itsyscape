--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/WoodBlockBlock.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Block = require "ItsyScape.World.GroundDecorations.Block"

local WoodBlock = Class(Block)

WoodBlock.TYPE_NONE   = "none"
WoodBlock.TYPE_SMALL  = "small"
WoodBlock.TYPE_MEDIUM = "med"
WoodBlock.TYPE_LARGE  = "large"

WoodBlock.NUM_SMALL = 2
WoodBlock.SMALL_WIDTH = 1

WoodBlock.NUM_MEDIUM = 2
WoodBlock.MEDIUM_WIDTH = 2

WoodBlock.NUM_LARGE = 2
WoodBlock.LARGE_WIDTH = 3

WoodBlock.FEATURE_FORMAT = "%s.%s.%d"
WoodBlock.FEATURE = "plank"

WoodBlock.WIDTH = 2

WoodBlock.NUM_ROWS = 4

WoodBlock.COLORS = {
	Color.fromHexString("614433"),
	Color.fromHexString("734f38"),
	Color.fromHexString("54362b"),
}

WoodBlock.MIN_ROTATION = -math.pi / 128
WoodBlock.MAX_ROTATION = math.pi / 128

WoodBlock.USE_TILE_COLOR = true

WoodBlock.WOOD = { wood = true }

function WoodBlock:bind()
	self._cache = {}
end

function WoodBlock:_getCache(i, j, row)
	local cacheRow = self._cache[j]
	local cell = cacheRow and cacheRow[i]
	local value = cell and cell[row]

	return value
end

function WoodBlock:_setCache(i, j, row, value)
	local cacheRow = self._cache[j] or {}
	local cell = cacheRow[i] or {}
	cell[row] = value

	cacheRow[i] = cell
	self._cache[j] = cacheRow
end

function WoodBlock:cache(tileSet, map, i, j, tileSetTile, mapTile)
end

function WoodBlock:emit(method, tileSet, map, i, j, tileSetTile, mapTile)
	if method == "cache" then
		return
	end

	print(">>>>", i, j)
	local rng = love.math.newRandomGenerator(i, j)
	for row = 1, self.NUM_ROWS do
		local isNextBlockWood = false
		do
			local nextI = i + 1
			if nextI <= map:getWidth() then
				local nextMapTile = map:getTile(nextI, j)
				local nextTileName = tileSet:getTileProperty(nextMapTile.flat, "name")
				isNextBlockWood = self.WOOD[nextTileName] == true
			end
		end

		local isFarBlockWood = false
		do
			local farI = i + 2
			if farI <= map:getWidth() then
				local farMapTile = map:getTile(farI, j)
				local farTileName = tileSet:getTileProperty(farMapTile.flat, "name")
				isFarBlockWood = self.WOOD[farTileName] == true
			end
		end

		local isPreviousBlockWood = false
		do
			local previousI = i - 1
			if previousI >= 1 then
				local previousMapTile = map:getTile(previousI, j)
				local previousTileName = tileSet:getTileProperty(previousMapTile.flat, "name")
				isPreviousBlockWood = self.WOOD[previousTileName] == true
			end
		end

		local isTopBlockWood = false
		do
			local topJ = j - 1
			if topJ >= 1 then
				local topMapTile = map:getTile(i, topJ)
				local topTileName = tileSet:getTileProperty(topMapTile.flat, "name")
				isTopBlockWood = self.WOOD[topTileName] == true
			end
		end

		local previousCell = isPreviousBlockWood and self:_getCache(i - 1, j, row)
		local previousWidth = previousCell and previousCell.width or 0

		local nextWidth
		if isNextBlockWood then
			nextWidth = self.LARGE_WIDTH
		else
			nextWidth = self.WIDTH - previousWidth
		end
		nextWidth = nextWidth

		local currentWidth = 0
		local lastType = previousCell and previousCell.type or nil
		while previousWidth < self.WIDTH and currentWidth < self.WIDTH do
			local baseTypes
			if isNextBlockWood and isFarBlockWood then
				baseTypes = { self.TYPE_SMALL, self.TYPE_MEDIUM, self.TYPE_LARGE }
			else
				local maxWidth = nextWidth - currentWidth
				if maxWidth >= self.LARGE_WIDTH then
					baseTypes = { self.TYPE_SMALL, self.TYPE_MEDIUM, self.TYPE_LARGE }
				elseif maxWidth >= self.MEDIUM_WIDTH then
					baseTypes = { self.TYPE_SMALL, self.TYPE_MEDIUM }
				elseif maxWidth >= self.SMALL_WIDTH then
					baseTypes = { self.TYPE_SMALL }
				else
					baseTypes = {}
				end
			end

			local lastTypes = {}
			do
				if lastType then
					lastTypes[lastType] = true
				end

				if row == 1 and isTopBlockWood then
					local topCell = self:_getCache(i, j - 1, self.NUM_ROWS)
					if topCell then
						lastTypes[topCell.type] = true
					end
				else
					local topCell = self:_getCache(i, j, row - 1)
					if topCell then
						lastTypes[topCell.type] = true
					end
				end
			end

			local types = {}
			for _, t in ipairs(baseTypes) do
				if not lastTypes[t] then
					table.insert(types, t)
				end
			end

			if #types == 0 then
				if #baseTypes == 0 then
					break
				end

				types = baseTypes
			end

			local t = types[rng:random(1, #types)]
			local index
			local width

			if t == self.TYPE_LARGE then
				width = self.LARGE_WIDTH
				index = rng:random(1, self.NUM_LARGE)
			elseif t == self.TYPE_MEDIUM then
				width = self.MEDIUM_WIDTH
				index = rng:random(1, self.NUM_MEDIUM)
			else
				width = self.SMALL_WIDTH
				index = rng:random(1, self.NUM_SMALL)
			end

			local color = self.COLORS[rng:random(1, #self.COLORS)]
			if self.USE_TILE_COLOR then
				color = color * Color(
					mapTile.red * (tileSetTile.colorRed or 1),
					mapTile.green * (tileSetTile.colorGreen or 1),
					mapTile.blue * (tileSetTile.colorColor or 1),
					1)
			end

			local rotation = math.lerp(self.MIN_ROTATION, self.MAX_ROTATION, rng:random())

			local center = Vector(
				width / 2 + currentWidth + previousWidth + (i - 1) * map:getCellSize(),
				0,
				((row - 0.5) / self.NUM_ROWS + (j - 1)) * map:getCellSize())
			center.y = map:getInterpolatedHeight(center.x, center.z)

			print("", ">>> add", t, "w", width, "row", row, "max", nextWidth)

			self:addFeature(
				self.FEATURE_FORMAT:format(self.FEATURE, t, index),
				center,
				Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
				Vector.ONE,
				color)

			currentWidth = currentWidth + width
			lastType = t
		end

		self:_setCache(i, j, row, { width = (currentWidth + previousWidth) - self.WIDTH, type = lastType })
		print("", ">>> set", currentWidth)
	end
end

return WoodBlock
