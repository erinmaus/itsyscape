--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/VineBlockV2.lua
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

local VineBlock = Class(Block)

VineBlock.GROUP = Block.GROUP_BENDY

VineBlock.SATURATION = 3

VineBlock.DIRT_NOISE = Noise {
	scale = 12,
	octaves = 2,
	attenuation = 0.5
}

VineBlock.VINE_LOWER_THRESHOLD = 0.45
VineBlock.VINE_UPPER_THRESHOLD = 0.55
VineBlock.VINE_NOISE = Noise {
	scale = 23,
	octaves = 2,
	attenuation = 0
}

VineBlock.DIRT_THRESHOLD = 0.35

VineBlock.MIN_OFFSET = -0.25
VineBlock.MAX_OFFSET = 0.25
VineBlock.OFFSET_NOISE = Noise {
	scale = 12363,
	octaves = 2,
	attenuation = -2
}

VineBlock.FEATURES = {
	"vine1"
}

VineBlock.FEATURE_NOISE = Noise {
	scale = 12363,
	octaves = 1,
	attenuation = 0
}

VineBlock.COLORS = {
	Color.fromHexString("abc837")
}

VineBlock.MIN_SCALE = 1.5
VineBlock.MAX_SCALE = 2.5

VineBlock.MIN_ROTATION = -math.pi
VineBlock.MAX_ROTATION = math.pi
VineBlock.ROTATION_NOISE = Noise {
	scale = 117,
	octaves = 2,
	attenuation = 0
}

VineBlock.COLOR_NOISE = Noise {
	offset = Vector(0.5, 0, 0.5),
	scale = 123,
	octaves = 1,
	attenuation = 0
}

function VineBlock:bind()
	self._colors = Noise.UniformSampler(self.COLOR_NOISE)
	self._offsets = Noise.UniformSampler(self.OFFSET_NOISE)
	self._features = Noise.UniformSampler(self.FEATURE_NOISE)
	self._rotations = Noise.UniformSampler(self.ROTATION_NOISE)
	self._dirt = Noise.UniformSampler(self.DIRT_NOISE)
	self._vine = Noise.UniformSampler(self.VINE_NOISE)
end

function VineBlock:cache(tileSet, map, i, j, tileSetTile, mapTile)
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
			local rotationX = self._rotations:sample3D(noiseX, noiseZ, 1)
			local rotationY = self._rotations:sample3D(noiseX, noiseZ, 2)
			local rotationZ = self._rotations:sample3D(noiseX, noiseZ, 3)
			local feature = self._features:sample2D(noiseX, noiseZ)
			local vine = self._vine:sample2D(noiseX, noiseZ)

			local g = {
				x = absoluteX,
				z = absoluteZ,
				offsetX = offsetX,
				offsetZ = offsetZ,
				rotationX = rotationX,
				rotationY = rotationY,
				rotationZ = rotationZ,
				color = color,
				dirt = dirt,
				feature = feature,
				vine = vine
			}

			self:addCache(i, j, map:getWidth(), map:getHeight(), x, z, self.SATURATION, self.SATURATION, g)
		end
	end
end

function VineBlock:emit(drawType, tileSet, map, i, j, tileSetTile, mapTile)
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
			local vine = g.vine

			if vine >= self.VINE_LOWER_THRESHOLD and vine <= self.VINE_UPPER_THRESHOLD then
				local delta = math.sin((dirt - self.DIRT_THRESHOLD) / (1 - self.DIRT_THRESHOLD) * math.pi * 2)
				local scale = delta >= 0 and math.lerp(self.MIN_SCALE, self.MAX_SCALE, delta) or 0
				local color = self.COLORS[self._colors:index(g.color, #self.COLORS)]
				local absoluteX = g.x + self._offsets:range(g.offsetX, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local absoluteZ = g.z + self._offsets:range(g.offsetZ, self.MIN_OFFSET, self.MAX_OFFSET) * map:getCellSize()
				local rotationX = self._rotations:range(g.rotationX, self.MIN_ROTATION, self.MAX_ROTATION)
				local rotationY = self._rotations:range(g.rotationY, self.MIN_ROTATION, self.MAX_ROTATION)
				local rotationZ = self._rotations:range(g.rotationZ, self.MIN_ROTATION, self.MAX_ROTATION)
				local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, rotationY) * Quaternion.fromAxisAngle(Vector.UNIT_X, rotationX)

				local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)
				local feature = self.FEATURES[self._features:index(g.feature, #self.FEATURES)]

				self:addFeature(
					feature,
					Vector(absoluteX, absoluteY, absoluteZ),
					rotation:getNormal(),
					--Quaternion.IDENTITY,
					Vector(scale),
					color)
			end
		end
	end
end

return VineBlock
