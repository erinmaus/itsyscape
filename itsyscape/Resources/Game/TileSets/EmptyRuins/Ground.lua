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
EmptyRuinsGround.GRASS_COLOR = Color(0.4, 0.6, 0.5, 1.0)

EmptyRuinsGround.STONE_THRESHOLD = 0.45
EmptyRuinsGround.STONE_TYPE_FUDGE = 7.934058
EmptyRuinsGround.STONE_PURPLE_COLOR = Color(0.3, 0.3, 0.5, 1.0)
EmptyRuinsGround.STONE_GREEN_COLOR = Color(0.3, 0.5, 0.3, 1.0)
EmptyRuinsGround.STONE_SKULL_DECO = 0.35
EmptyRuinsGround.STONE_CRACK_DECO = 0.4
EmptyRuinsGround.STONE_BRICK_DECO = 1.0
EmptyRuinsGround.STONE_NUM_BRICK = 3

function EmptyRuinsGround:new()
	GroundDecorations.new(self, "EmptyRuins")

	self:registerTile("grass", self.emitGrass)
	self:registerTile("purple-stone", self.emitStone)
	self:registerTile("green-stone", self.emitStone)
end

function EmptyRuinsGround:placeSkull(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(center.x / 4, center.y / 4, center.z / 4)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, noise * math.pi * 2)
	self:addFeature("skull", center, rotation, Vector((noise + 1) * 2))
end

function EmptyRuinsGround:placeCrack(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local texture = math.floor(self:noise(center.x, center.y, center.z, 0.25) * EmptyRuinsGround.STONE_NUM_CRACK + 0.5)
	local noise = self:noise(center.x, center.y, center.z)
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Y, noise * math.pi * 2)
	self:addFeature("crack" .. texture, center, rotation)
end

function EmptyRuinsGround:placeBricks(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local texture = math.floor(self:noise(center.x, center.y, center.z, 0.25) * EmptyRuinsGround.STONE_NUM_BRICK + 0.5)
	local colorScale = (self:noise(center.x, center.y, center.z) + 1) / 2
	local noise = self:noise(center.x, center.y, center.z)

	local featureColor
	if tileSetTile.name == "purple-stone" then
		featureColor = EmptyRuinsGround.STONE_PURPLE_COLOR
	elseif tileSetTile.name == "green-stone" then
		featureColor = EmptyRuinsGround.STONE_GREEN_COLOR
	else
		Log.warn("Unhandled stone type: '%s'.", tileSetTile.name)
		featureColor = Color(1, 0, 0, 1)
	end

	self:addFeature(
		"brick" .. texture,
		center,
		Quaternion.IDENTITY,
		Vector.ONE,
		featureColor * Color(colorScale, colorScale, colorScale, 1))
end

function EmptyRuinsGround:emitStone(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(center.x, center.y, center.z)
	if noise < EmptyRuinsGround.STONE_THRESHOLD then
		self:placeBricks(tileSet, map, i, j, tileSetTile, mapTile)
	end
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
					EmptyRuinsGround.GRASS_COLOR * Color(color, color, color, 1))
			end
		end
	end
end

return EmptyRuinsGround
