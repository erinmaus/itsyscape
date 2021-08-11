--------------------------------------------------------------------------------
-- Resources/Game/TileSets/EmptyRuins/Ground.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local GroundDecorations = require "ItsyScape.World.GroundDecorations"

local EmptyRuinsGround = Class(GroundDecorations)
EmptyRuinsGround.GRASS_SATURATION = 4
EmptyRuinsGround.GRASS_THRESHOLD  = 0.45
EmptyRuinsGround.GRASS_FUDGE = 0.83

function EmptyRuinsGround:new()
	GroundDecorations.new(self, "EmptyRuins")

	self:registerTile("grass", self.emitGrass)
end

function EmptyRuinsGround:emitGrass(tileSet, map, i, j, tileSetTile, mapTile)
	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())
	topLeft.y = map:getInterpolatedHeight(topLeft.x, topLeft.z)

	for x = 1, EmptyRuinsGround.GRASS_SATURATION do
		for z = 1, EmptyRuinsGround.GRASS_SATURATION do
			local absoluteX = topLeft.x + x / EmptyRuinsGround.GRASS_SATURATION * map:getCellSize()
			local absoluteZ = topLeft.z + z / EmptyRuinsGround.GRASS_SATURATION * map:getCellSize()
			local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)

			local noise = self:noise(
				absoluteX,
				absoluteY,
				absoluteZ)

			if noise < EmptyRuinsGround.GRASS_THRESHOLD then
				local offsetX = self:noise(absoluteX, absoluteY, absoluteZ, 0.25) * 2 - 1 + absoluteX
				local offsetZ = self:noise(absoluteX, absoluteY, absoluteZ, 0.75) * 2 - 1 + absoluteZ
				local offsetY = map:getInterpolatedHeight(offsetX, offsetZ)

				local scale = self:noise(offsetX / EmptyRuinsGround.GRASS_FUDGE, offsetY / EmptyRuinsGround.GRASS_FUDGE, offsetZ / EmptyRuinsGround.GRASS_FUDGE, 0.5)
				scale = scale + 0.5
				local color = self:noise(offsetX / EmptyRuinsGround.GRASS_FUDGE, offsetY / EmptyRuinsGround.GRASS_FUDGE, offsetZ / EmptyRuinsGround.GRASS_FUDGE, 0.25)
				color = (color + 1) / 2

				self:addFeature(
					"grass",
					Vector(offsetX, offsetY, offsetZ),
					Quaternion.IDENTITY,
					Vector(scale),
					Color(0.4 * color, 0.6 * color, 0.5 * color, 1.0))
			end
		end
	end
end

return EmptyRuinsGround
