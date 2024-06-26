--------------------------------------------------------------------------------
-- ItsyScape/World/GroundDecorations/BrickBlock.lua
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

local Brick = Class(Block)
Brick.OCTAVES = 8
Brick.THRESHOLD = 0.45
Brick.FUDGE = 0.33
Brick.Y_OFFSET = 0.25
Brick.COLOR = Color(1, 0, 0, 1)
Brick.USE_TILE_COLOR = false
Brick.ROTATION_RANGE = math.pi / 8
Brick.SCALE = Vector.ONE
Brick.FEATURE = "brick"
Brick.NUM_FEATURES = 2
Brick.ONLY_FLAT = true
Brick.EXCLUDE_DECALS = true

function Brick:emit(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(self.OCTAVES, center.x, center.y, center.z)
	if noise > self.THRESHOLD then
		return
	end

	if (mapTile.topLeft ~= mapTile.topRight or
	   mapTile.topLeft ~= mapTile.bottomLeft or
	   mapTile.topLeft ~= mapTile.bottomRight) and
	   self.ONLY_FLAT
	then
		return
	end

	if self.EXCLUDE_DECALS and (#mapTile.decals > 1 or next(mapTile.mask) ~= nil) then
		return
	end

	local center = map:getTileCenter(i, j)
	local texture = self:noise(self.OCTAVES, center.x, center.y, center.z, 0.25)
	texture = math.ceil(texture * self.NUM_FEATURES)
	local colorScale = self:noise(self.OCTAVES, center.x, center.y, center.z)
	local noise = self:noise(self.OCTAVES, 
		center.x / self.FUDGE,
		center.y / self.FUDGE,
		center.z / self.FUDGE)

	center = center - Vector.UNIT_Y * noise * self.Y_OFFSET

	local rotation = self:noise(
		self.OCTAVES,
		center.x, center.y, center.z)
	rotation = (rotation * 2 - 1) * self.ROTATION_RANGE

	colorScale = (colorScale + 1) / 2

	local color
	if self.USE_TILE_COLOR then
		color = Color(
			mapTile.red * (tileSetTile.colorRed or 1),
			mapTile.green * (tileSetTile.colorGreen or 1),
			mapTile.blue * (tileSetTile.colorColor or 1),
			1)
	else
		color = self.COLOR
	end

	self:addFeature(
		self.FEATURE .. texture,
		center,
		Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
		self.SCALE,
		color * Color(colorScale, colorScale, colorScale, 1))
end

return Brick
