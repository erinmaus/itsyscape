--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/GrassBlock.lua
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
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local GrassBlock = Class(Block)
GrassBlock.OCTAVES = 1
GrassBlock.SATURATION = 4
GrassBlock.THRESHOLD = 0.45
GrassBlock.FUDGE = 0.83
GrassBlock.COLOR = Color(0.5, 0.7, 0.1, 1.0)
GrassBlock.FEATURE = "grass"
GrassBlock.CLUMP_EDGE_Y_OFFSET_MAX = 0.35
GrassBlock.NOISE_CLUMP = NoiseBuilder.TILE {
	persistence = 10,
	scale = 6,
	octaves = 4,
	lacunarity = -3
}

GrassBlock.NOISE_TILE  = NoiseBuilder {
	persistence = 4,
	scale = 128,
	octaves = 1,
	lacunarity = 1
}

function GrassBlock:emit(tileSet, map, i, j, tileSetTile, mapTile)
	if #mapTile.decals > 0 then
		return
	end

	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())
	topLeft.y = map:getInterpolatedHeight(topLeft.x, topLeft.z)

	for x = 1, self.SATURATION do
		for z = 1, self.SATURATION do
			local absoluteX = topLeft.x + x / self.SATURATION * map:getCellSize()
			local absoluteZ = topLeft.z + z / self.SATURATION * map:getCellSize()
			local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)

			local noise1 = self.NOISE_CLUMP:sample3D(
				absoluteX / (map:getCellSize() * map:getWidth()),
				0,
				absoluteZ / (map:getCellSize() * map:getHeight()))
			local noise2 = self.NOISE_TILE:sample3D(
				absoluteX / (map:getCellSize() * map:getWidth()),
				0,
				absoluteZ / (map:getCellSize() * map:getHeight()))

			if noise1 > self.THRESHOLD and noise2 < self.THRESHOLD then
				local offsetX = self:noise(self.OCTAVES, absoluteX, absoluteY, absoluteZ, 0.25) * 2 - 1 + absoluteX
				local offsetZ = self:noise(self.OCTAVES, absoluteX, absoluteY, absoluteZ, 0.75) * 2 - 1 + absoluteZ
				local offsetY = map:getInterpolatedHeight(offsetX, offsetZ) - (1.0 - ((noise1 - self.THRESHOLD) / (1 - self.THRESHOLD))) * self.CLUMP_EDGE_Y_OFFSET_MAX
				print("offsetY", noise1, ((noise1 - self.THRESHOLD) / (1 - self.THRESHOLD)) * self.CLUMP_EDGE_Y_OFFSET_MAX)

				local scale = self:noise(self.OCTAVES, offsetX / self.FUDGE, offsetY / self.FUDGE, offsetZ / self.FUDGE, 0.5)
				scale = scale + 0.5
				local color = self:noise(self.OCTAVES, offsetX / self.FUDGE, offsetY / self.FUDGE, offsetZ / self.FUDGE, 0.25)
				color = (color + 1) / 2

				local rotation = (noise2 * 2 - 1) * (math.pi / 2)

				self:addFeature(
					self.FEATURE,
					Vector(offsetX, offsetY - 0.125, offsetZ),
					Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
					Vector(scale),
					self.COLOR * Color(color, color, color, 1))
			end
		end
	end
end

return GrassBlock
