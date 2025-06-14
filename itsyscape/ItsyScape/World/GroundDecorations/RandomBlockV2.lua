--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/RandomBlock.lua
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
local Noise = require "ItsyScape.Graphics.Noise"

local RandomBlock = Class(Block)

RandomBlock.ROTATIONS = {
	Quaternion.IDENTITY,
	Quaternion.Y_90,
	Quaternion.Y_180,
	Quaternion.Y_279
}

RandomBlock.ROTATION_NOISE = Noise {
	scale = 11723,
	octaves = 1,
	attenuation = 0
}

RandomBlock.MIN_OFFSET = -0.25
RandomBlock.MAX_OFFSET = 0.25
RandomBlock.OFFSET_NOISE = Noise {
	scale = 23163,
	octaves = 2,
	attenuation = -2
}

RandomBlock.FEATURE_THRESHOLD = 0.5

RandomBlock.FEATURES = {}

RandomBlock.FEATURE_NOISE = Noise {
	scale = 12363,
	octaves = 1,
	attenuation = 0
}

RandomBlock.SATURATION = 2

RandomBlock.COLORS = {
	Color.fromHexString("ffffff")
}

RandomBlock.COLOR_NOISE = Noise {
	offset = Vector(0.5, 0, 0.5),
	scale = 123,
	octaves = 1,
	attenuation = 0
}

function RandomBlock:bind()
	self._rotations = Noise.UniformSampler(self.ROTATION_NOISE)
	self._colors = Noise.UniformSampler(self.COLOR_NOISE)
	self._offsets = Noise.UniformSampler(self.OFFSET_NOISE)
	self._features = Noise.UniformSampler(self.FEATURE_NOISE)
end

function RandomBlock:_getCache(i, j, row)
	local cacheRow = self._cache[j]
	local cell = cacheRow and cacheRow[i]
	local value = cell and cell[row]

	return value
end

function RandomBlock:_setCache(i, j, row, value)
	local cacheRow = self._cache[j] or {}
	local cell = cacheRow[i] or {}
	cell[row] = value

	cacheRow[i] = cell
	self._cache[j] = cacheRow
end

function RandomBlock:cache(tileSet, map, i, j, tileSetTile, mapTile)
	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())

	for x = 1, self.SATURATION do
		for z = 1, self.SATURATION do
			local absoluteX = topLeft.x + ((x - 1) / math.max(self.SATURATION - 1, 1)) * map:getCellSize()
			local absoluteZ = topLeft.z + ((z - 1) / math.max(self.SATURATION - 1, 1)) * map:getCellSize()

			local noiseX = absoluteX / (map:getWidth() * map:getCellSize())
			local noiseZ = absoluteZ / (map:getHeight() * map:getCellSize())

			local color = self._colors:sample2D(noiseX, noiseZ)
			local rotation = self._rotations:sample2D(noiseX, noiseZ)
			local offsetX = self._offsets:sample3D(noiseX, noiseZ, 1)
			local offsetZ = self._offsets:sample3D(noiseX, noiseZ, 2)
			local feature = self._features:sample2D(noiseX, noiseZ)

			local g = {
				x = absoluteX,
				z = absoluteZ,
				offsetX = offsetX,
				offsetZ = offsetZ,
				color = color,
				rotation = rotation,
				feature = feature
			}

			self:addCache(i, j, map:getWidth(), map:getHeight(), x, z, self.SATURATION, self.SATURATION, g)
		end
	end
end

function RandomBlock:emit(method, tileSet, map, i, j, tileSetTile, mapTile)
	if method == "cache" then
		self:cache(tileSet, map, i, j, tileSetTile, mapTile)
		return
	end

	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())
	topLeft.y = map:getInterpolatedHeight(topLeft.x, topLeft.z)

	for x = 1, self.SATURATION do
		for z = 1, self.SATURATION do
			local g = self:getCache(i, j, map:getWidth(), map:getHeight(), x, z, self.SATURATION, self.SATURATION)
			local feature = self._features:uniform(g.feature)

			if feature >= self.FEATURE_THRESHOLD then
				local delta = (feature - self.FEATURE_THRESHOLD) / (1 - self.FEATURE_THRESHOLD)
				local color = self.COLORS[self._colors:index(g.color, #self.COLORS)]
				local absoluteX = g.x + self._offsets:range(g.offsetX, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local absoluteZ = g.z + self._offsets:range(g.offsetZ, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)
				local feature = self.FEATURES[math.clamp(math.floor(delta * #self.FEATURES) + 1, 1, #self.FEATURES)]

				self:addFeature(
					feature,
					Vector(absoluteX, absoluteY, absoluteZ),
					Quaternion.IDENTITY,
					Vector(1),
					color)
			end
		end
	end
end

return RandomBlock
