--------------------------------------------------------------------------------
-- Resources/Game/TileSets/YendorianJungle2/Ground.lua
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
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlockV2"
local RandomBlock = require "ItsyScape.World.GroundDecorations.RandomBlockV2"
local WoodBlock = require "ItsyScape.World.GroundDecorations.WoodBlockV2"

local YendorianJungleGround = Class(GroundDecorations)

function YendorianJungleGround:new()
	GroundDecorations.new(self, "YendorianJungle2")

	self:registerTile("wood", WoodBlock:Bind(self) {
		LARGE_FEATURES = {
			"plank.large.1",
			"plank.large.1",
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
			"plank.large.2",
			"plank.large.2",
			"plank.large.3",
			"plank.large.3",
			"plank.large.3",
			"plank.large.4",
			"plank.large.4",
			"plank.large.4",
			"plank.large.4",
			"plank.large.5",
			"plank.large.5",
			"plank.large.5",
			"plank.large.6",
			"plank.large.6",
			"plank.large.6"
		},

		COLORS = {
			Color.fromHexString("755643"),
			Color.fromHexString("755643"),
			Color.fromHexString("755643"),
			Color.fromHexString("694c39"),
			Color.fromHexString("694c39"),
			Color.fromHexString("96684a")
		}
	})

	self:registerTile("grass", GrassBlock:Bind(self) {
		COLORS = {
			Color.fromHexString("558855"),
			Color.fromHexString("4c7a4c"),
			Color.fromHexString("5d805e"),
			Color.fromHexString("4f7252"),
			Color.fromHexString("49784d"),
			Color.fromHexString("3e6d3a"),
			Color.fromHexString("463779"),
			Color.fromHexString("463779"),
			Color.fromHexString("463779")
		}
	})

	self:registerTile("sand", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0.3,
		SATURATION = 2,

		MIN_OFFSET = -1.5,
		MAX_OFFSET = 1.5,

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
			Color.fromHexString("bfa797")
		}
	})
end

return YendorianJungleGround
