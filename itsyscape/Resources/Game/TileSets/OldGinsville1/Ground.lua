--------------------------------------------------------------------------------
-- Resources/Game/TileSets/OldGinsville1/Ground.lua
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
local GroundDecorations = require "ItsyScape.World.GroundDecorationsV2"
local Block = require "ItsyScape.World.GroundDecorations.Block"
local WoodBlock = require "ItsyScape.World.GroundDecorations.WoodBlockV2"
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlockV2"
local RandomBlock = require "ItsyScape.World.GroundDecorations.RandomBlockV2"

local OldGinsvilleGround = Class(GroundDecorations)

function OldGinsvilleGround:new()
	GroundDecorations.new(self, "OldGinsville1")

	self:registerTile("wood", WoodBlock:Bind(self) {
		LARGE_FEATURES = {
			"plank.large.1",
			"plank.large.1",
			"plank.large.1",
			"plank.large.1",
			"plank.large.1",
			"plank.large.1",
			"plank.large.2",
			"plank.large.2",
			"plank.large.2",
			"plank.large.2",
			"plank.large.2",
			"plank.large.2",
			"plank.large.3",
			"plank.large.3",
			"plank.large.4",
			"plank.large.4",
			"plank.large.5",
			"plank.large.5",
			"plank.large.6",
			"plank.large.6",
		},

		COLORS = {
			Color.fromHexString("2c2520"),
			Color.fromHexString("2c2520"),
			Color.fromHexString("2c2520"),
			Color.fromHexString("3a312a"),
			Color.fromHexString("3a312a"),
			Color.fromHexString("483d35"),
			Color.fromHexString("483d35")
		}
	})

	self:registerTile("grass", GrassBlock:Bind(self) {
		DIRT_THRESHOLD = 0.2,

		SATURATION = 4,

		COLORS = {
			Color.fromHexString("4c4441"),
			Color.fromHexString("4c4441"),
			Color.fromHexString("4c4441"),
			Color.fromHexString("4c4441"),
			Color.fromHexString("424c41"),
			Color.fromHexString("424c41"),
		},

		MIN_OFFSET = -1.5,
		MAX_OFFSET = 1.5,

		FEATURES = {
			"grass1",
			"grass2",
			"grass3",
			"grass4",
			"grass5",
		}
	})

	self:registerTile("moss", GrassBlock:Bind(self) {
		DIRT_THRESHOLD = 0.2,

		SATURATION = 3,

		COLORS = {
			Color.fromHexString("424c41"),
			Color.fromHexString("424c41"),
			Color.fromHexString("424c41"),
			Color.fromHexString("424c41"),
			Color.fromHexString("2a3829"),
			Color.fromHexString("2a3829"),
		},

		MIN_OFFSET = -1.5,
		MAX_OFFSET = 1.5,

		FEATURES = {
			"grass1",
			"grass2",
			"grass3",
			"grass4",
			"grass5",
		}
	})

	self:registerTile("mud", GrassBlock:Bind(self) {
		DIRT_THRESHOLD = 0.2,

		SATURATION = 2,

		COLORS = {
			Color.fromHexString("4c4441"),
			Color.fromHexString("4c4441"),
			Color.fromHexString("4c4441"),
			Color.fromHexString("2e2927"),
			Color.fromHexString("2e2927"),
			Color.fromHexString("2e2927"),
		},

		MIN_OFFSET = -1.5,
		MAX_OFFSET = 1.5,

		FEATURES = {
			"grass1",
			"grass2",
			"grass3",
			"grass4",
			"grass5",
		}
	})

	self:registerTile("sand", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0.3,
		SATURATION = 2,

		ROTATIONS = {
			Quaternion.IDENTITY,
			Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * (1 / 6)),
			Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * (2 / 6)),
			Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * (3 / 6)),
			Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * (4 / 6)),
			Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi * (5 / 6)),
		},

		FEATURES = {
			"shell1",
			"shell1",
			"shell2",
			"shell2",
			"shell3",
			"shell3",
			"shell4",
			"shell4",
			"shell4"
		}
	})

	self:registerTile("stone", RandomBlock:Bind(self) {
		GROUP = Block.GROUP_SHINY,

		FEATURE_THRESHOLD = 0,
		SATURATION = 1,

		MIN_SCALE = 1,
		MAX_SCALE = 1,
		MIN_OFFSET = 0.5,
		MAX_OFFSET = 0.5,

		FEATURES = {
			"bricks1",
			"bricks2",
			"bricks3",
			"bricks4"
		},

		COLORS = {
			Color.fromHexString("4c4441")
		}
	})
end

return OldGinsvilleGround
