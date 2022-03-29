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
Brick.SCALE = Vector.ONE
Brick.FEATURE = "brick"
Brick.NUM_FEATURES = 2

function Brick:emit(tileSet, map, i, j, tileSetTile, mapTile)
	local center = map:getTileCenter(i, j)
	local noise = self:noise(self.OCTAVES, center.x, center.y, center.z)
	if noise > self.THRESHOLD then
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
	rotation = (rotation * 2 - 1) * (math.pi / 8)

	colorScale = (colorScale + 1) / 2

	self:addFeature(
		self.FEATURE .. texture,
		center,
		Quaternion.fromAxisAngle(Vector.UNIT_Y, rotation),
		self.SCALE,
		self.COLOR * Color(colorScale, colorScale, colorScale, 1))
end

return Brick
