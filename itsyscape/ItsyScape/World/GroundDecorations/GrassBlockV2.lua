--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/GrassBlockV2.lua
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

local GrassBlock = Class(Block)

GrassBlock.GROUP = Block.GROUP_BENDY

GrassBlock.SATURATION = 6

GrassBlock.DIRT_NOISE = Noise {
	scale = 12,
	octaves = 2,
	attenuation = 0.5
}

GrassBlock.DIRT_THRESHOLD = 0.35

GrassBlock.MIN_OFFSET = -0.25
GrassBlock.MAX_OFFSET = 0.25
GrassBlock.OFFSET_NOISE = Noise {
	scale = 117,
	octaves = 2,
	attenuation = -2
}


GrassBlock.FEATURES = {
	"grass1",
	"grass2",
	"grass3",
	"grass4",
	"grass5"
}

GrassBlock.FEATURE_NOISE = Noise {
	scale = 12363,
	octaves = 1,
	attenuation = 0
}

GrassBlock.COLORS = {
	Color.fromHexString("558855"),
	Color.fromHexString("4c7a4c"),
	Color.fromHexString("5d805e"),
	Color.fromHexString("4f7252"),
	Color.fromHexString("49784d"),
	Color.fromHexString("3e6d3a"),
}

GrassBlock.MIN_SCALE = 1.5
GrassBlock.MAX_SCALE = 2.5

GrassBlock.COLOR_NOISE = Noise {
	offset = Vector(0.5, 0, 0.5),
	scale = 123,
	octaves = 1,
	attenuation = 0
}

function GrassBlock:bind()
	self._colors = Noise.UniformSampler(self.COLOR_NOISE)
	self._offsets = Noise.UniformSampler(self.OFFSET_NOISE)
	self._features = Noise.UniformSampler(self.FEATURE_NOISE)
	self._dirt = Noise.UniformSampler(self.DIRT_NOISE)
end

function GrassBlock:cache(tileSet, map, i, j, tileSetTile, mapTile)
	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())

	for x = 1, self.SATURATION do
		for z = 1, self.SATURATION do
			local absoluteX = topLeft.x + ((x - 1) / (self.SATURATION - 1)) * map:getCellSize()
			local absoluteZ = topLeft.z + ((z - 1) / (self.SATURATION - 1)) * map:getCellSize()

			local noiseX = absoluteX / (map:getWidth() * map:getCellSize())
			local noiseZ = absoluteZ / (map:getHeight() * map:getCellSize())

			local dirt = self._dirt:sample2D(noiseX, noiseZ)
			local color = self._colors:sample2D(noiseX, noiseZ)
			local offsetX = self._offsets:sample3D(noiseX, noiseZ, 1)
			local offsetZ = self._offsets:sample3D(noiseX, noiseZ, 2)
			local feature = self._features:sample2D(noiseX, noiseZ)

			local g = {
				x = absoluteX,
				z = absoluteZ,
				offsetX = offsetX,
				offsetZ = offsetZ,
				color = color,
				dirt = dirt,
				feature = feature
			}

			self:addCache(i, j, map:getWidth(), map:getHeight(), x, z, self.SATURATION, self.SATURATION, g)
		end
	end
end

function GrassBlock:emit(drawType, tileSet, map, i, j, tileSetTile, mapTile)
	if #mapTile.decals > 0 then
		return
	end

	if drawType == "cache" then
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
			local dirt = self._dirt:uniform(g.dirt)

			if dirt >= self.DIRT_THRESHOLD then
				local delta = math.sin((dirt - self.DIRT_THRESHOLD) / (1 - self.DIRT_THRESHOLD) * math.pi * 2)
				local scale = delta >= 0 and math.lerp(self.MIN_SCALE, self.MAX_SCALE, delta) or 0
				local color = self.COLORS[self._colors:index(g.color, #self.COLORS)]
				local absoluteX = g.x + self._offsets:range(g.offsetX, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local absoluteZ = g.z + self._offsets:range(g.offsetZ, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)
				local feature = self.FEATURES[self._features:index(g.feature, #self.FEATURES)]

				self:addFeature(
					feature,
					Vector(absoluteX, absoluteY - 0.125, absoluteZ),
					Quaternion.IDENTITY,
					Vector(scale),
					color)
			end
		end
	end
end

return GrassBlock
