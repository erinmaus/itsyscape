--------------------------------------------------------------------------------
-- Resources/Game/TileSets/RumbridgeMainland/Ground.lua
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

local RumbridgeMainlandGround = Class(GroundDecorations)
RumbridgeMainlandGround.GRASS_OCTAVES = 1
RumbridgeMainlandGround.GRASS_SATURATION = 4
RumbridgeMainlandGround.GRASS_THRESHOLD  = 0.45
RumbridgeMainlandGround.GRASS_FUDGE = 0.83
RumbridgeMainlandGround.GRASS_COLOR = Color(0.5, 0.7, 0.1, 1.0)

RumbridgeMainlandGround.FLOWER_RED_FUDGE = 0.78
RumbridgeMainlandGround.FLOWER_GREEN_FUDGE = 0.11
RumbridgeMainlandGround.FLOWER_BLUE_FUDGE = 0.49
RumbridgeMainlandGround.FLOWER_THRESHOLD = 0.2

RumbridgeMainlandGround.STONE_OCTAVES = 8
RumbridgeMainlandGround.STONE_THRESHOLD = 0.45
RumbridgeMainlandGround.STONE_FUDGE = 0.33
RumbridgeMainlandGround.STONE_Y_OFFSET = 0.25
RumbridgeMainlandGround.STONE_BLACK_COLOR = Color(0.2, 0.2, 0.2, 1.0)
RumbridgeMainlandGround.STONE_WHITE_COLOR = Color(0.7, 0.7, 0.7, 1.0)
RumbridgeMainlandGround.STONE_NUM_BRICK = 3

RumbridgeMainlandGround.PLANK_OCTAVES = 8
RumbridgeMainlandGround.PLANK_THRESHOLD = 0.45
RumbridgeMainlandGround.PLANK_FUDGE = 0.33
RumbridgeMainlandGround.PLANK_Y_OFFSET = 0.25
RumbridgeMainlandGround.PLANK_COLOR = Color(0.5, 0.3, 0.2, 1.0)
RumbridgeMainlandGround.PLANK_NUM_PLANK = 2

function RumbridgeMainlandGround:new()
	GroundDecorations.new(self, "RumbridgeMainland")

	self:registerTile("grass", self.emitGrass)
	self:registerTile("brick", self.emitStone)
	self:registerTile("wood", self.emitPlank)
end

function RumbridgeMainlandGround:placeBricks(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local texture = self:noise(RumbridgeMainlandGround.STONE_OCTAVES, center.x, center.y, center.z, 0.25)
	texture = math.ceil(texture * RumbridgeMainlandGround.STONE_NUM_BRICK + 0.5)
	local colorScale = self:noise(RumbridgeMainlandGround.STONE_OCTAVES, center.x, center.y, center.z)
	local noise = self:noise(RumbridgeMainlandGround.STONE_OCTAVES, 
		center.x / RumbridgeMainlandGround.STONE_FUDGE,
		center.y / RumbridgeMainlandGround.STONE_FUDGE,
		center.z / RumbridgeMainlandGround.STONE_FUDGE)

	center = center - Vector.UNIT_Y * noise * RumbridgeMainlandGround.STONE_Y_OFFSET

	local rotation = self:noise(
		RumbridgeMainlandGround.STONE_OCTAVES,
		center.x, center.y, center.z)
	rotation = (rotation * 2 - 1) * (math.pi / 8)

	local featureColor
	if i % 2 == 0 or j % 2 == 0 then
		featureColor = RumbridgeMainlandGround.STONE_BLACK_COLOR
	else
		featureColor = RumbridgeMainlandGround.STONE_WHITE_COLOR
	end

	colorScale = (colorScale + 1) / 2

	self:addFeature(
		"brick" .. texture,
		center,
		Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
		Vector.ONE,
		featureColor * Color(colorScale, colorScale, colorScale, 1))
end

function RumbridgeMainlandGround:placePlanks(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local texture = self:noise(RumbridgeMainlandGround.PLANK_OCTAVES, center.x, center.y, center.z, 0.25)
	texture = math.floor(texture * RumbridgeMainlandGround.PLANK_NUM_PLANK + 0.5)
	local colorScale = self:noise(RumbridgeMainlandGround.PLANK_OCTAVES, center.x, center.y, center.z)
	local noise = self:noise(RumbridgeMainlandGround.PLANK_OCTAVES, 
		center.x / RumbridgeMainlandGround.PLANK_FUDGE,
		center.y / RumbridgeMainlandGround.PLANK_FUDGE,
		center.z / RumbridgeMainlandGround.PLANK_FUDGE)

	center = center - Vector.UNIT_Y * noise * RumbridgeMainlandGround.PLANK_Y_OFFSET

	local rotation = self:noise(
		RumbridgeMainlandGround.PLANK_OCTAVES,
		center.x, center.y, center.z)
	rotation = (rotation * 2 - 1) * (math.pi / 8)

	local featureColor = RumbridgeMainlandGround.PLANK_COLOR

	colorScale = (colorScale + 1) / 2

	self:addFeature(
		"plank" .. texture,
		center,
		Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
		Vector.ONE,
		featureColor * Color(colorScale, colorScale, colorScale, 1))
end

function RumbridgeMainlandGround:emitStone(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(RumbridgeMainlandGround.STONE_OCTAVES, center.x, center.y, center.z)
	if noise < RumbridgeMainlandGround.STONE_THRESHOLD then
		self:placeBricks(tileSet, map, i, j, tileSetTile, mapTile)
	end
end

function RumbridgeMainlandGround:emitPlank(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(RumbridgeMainlandGround.STONE_OCTAVES, center.x, center.y, center.z)
	if noise < RumbridgeMainlandGround.PLANK_THRESHOLD then
		self:placePlanks(tileSet, map, i, j, tileSetTile, mapTile)
	end
end

function RumbridgeMainlandGround:emitGrass(tileSet, map, i, j, tileSetTile, mapTile)
	local topLeft = Vector(
		(i - 1) * map:getCellSize(),
		0,
		(j - 1) * map:getCellSize())
	topLeft.y = map:getInterpolatedHeight(topLeft.x, topLeft.z)

	for x = 1, RumbridgeMainlandGround.GRASS_SATURATION do
		for z = 1, RumbridgeMainlandGround.GRASS_SATURATION do
			local absoluteX = topLeft.x + x / RumbridgeMainlandGround.GRASS_SATURATION * map:getCellSize()
			local absoluteZ = topLeft.z + z / RumbridgeMainlandGround.GRASS_SATURATION * map:getCellSize()
			local absoluteY = map:getInterpolatedHeight(absoluteX, absoluteZ)

			local noise = self:noise(
				RumbridgeMainlandGround.GRASS_OCTAVES, 
				absoluteX,
				absoluteY,
				absoluteZ)

			local isFlower = noise < RumbridgeMainlandGround.FLOWER_THRESHOLD

			if noise < RumbridgeMainlandGround.GRASS_THRESHOLD then
				local offsetX = self:noise(RumbridgeMainlandGround.GRASS_OCTAVES, absoluteX, absoluteY, absoluteZ, 0.25) * 2 - 1 + absoluteX
				local offsetZ = self:noise(RumbridgeMainlandGround.GRASS_OCTAVES, absoluteX, absoluteY, absoluteZ, 0.75) * 2 - 1 + absoluteZ
				local offsetY = map:getInterpolatedHeight(offsetX, offsetZ)

				local scale = self:noise(RumbridgeMainlandGround.GRASS_OCTAVES, offsetX / RumbridgeMainlandGround.GRASS_FUDGE, offsetY / RumbridgeMainlandGround.GRASS_FUDGE, offsetZ / RumbridgeMainlandGround.GRASS_FUDGE, 0.5)
				scale = scale + 0.5
				local color = self:noise(RumbridgeMainlandGround.GRASS_OCTAVES, offsetX / RumbridgeMainlandGround.GRASS_FUDGE, offsetY / RumbridgeMainlandGround.GRASS_FUDGE, offsetZ / RumbridgeMainlandGround.GRASS_FUDGE, 0.25)
				color = (color + 1) / 2

				local rotation = (noise * 2 - 1) * (math.pi / 2)

				if isFlower then
					local red = self:noise(1, RumbridgeMainlandGround.FLOWER_RED_FUDGE * absoluteX, RumbridgeMainlandGround.FLOWER_RED_FUDGE * absoluteY)
					local green = self:noise(2, RumbridgeMainlandGround.FLOWER_GREEN_FUDGE * absoluteX, RumbridgeMainlandGround.FLOWER_GREEN_FUDGE * absoluteY)
					local blue = self:noise(4, RumbridgeMainlandGround.FLOWER_BLUE_FUDGE * absoluteX, RumbridgeMainlandGround.FLOWER_BLUE_FUDGE * absoluteY)

					self:addFeature(
						"flower",
						Vector(offsetX, offsetY, offsetZ),
						Quaternion.fromAxisAngle(Vector.UNIT_Y, -rotation),
						Vector(scale),
						Color(red * 0.3 + 0.5, green * 0.1 + 0.3, blue * 0.3 + 0.5, 1))
					self:addFeature(
						"stem",
						Vector(offsetX, offsetY, offsetZ),
						Quaternion.fromAxisAngle(Vector.UNIT_Y, -rotation),
						Vector(scale),
						RumbridgeMainlandGround.GRASS_COLOR * Color(color, color, color, 1))
				else
					self:addFeature(
						"grass",
						Vector(offsetX, offsetY, offsetZ),
						Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
						Vector(scale),
						RumbridgeMainlandGround.GRASS_COLOR * Color(color, color, color, 1))
				end
			end
		end
	end
end

return RumbridgeMainlandGround
