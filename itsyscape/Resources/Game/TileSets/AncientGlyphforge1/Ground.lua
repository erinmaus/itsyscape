--------------------------------------------------------------------------------
-- Resources/Game/TileSets/AncientGlyphforge1/Ground.lua
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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local GroundDecorations = require "ItsyScape.World.GroundDecorationsV2"
local Block = require "ItsyScape.World.GroundDecorations.Block"
local WoodBlock = require "ItsyScape.World.GroundDecorations.WoodBlockV2"
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlockV2"
local RandomBlock = require "ItsyScape.World.GroundDecorations.RandomBlockV2"

local OldGinsvilleGround = Class(GroundDecorations)

function OldGinsvilleGround:new()
	GroundDecorations.new(self, "AncientGlyphforge1")

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
			Color.fromHexString("3e2824"),
			Color.fromHexString("3e2824"),
			Color.fromHexString("3e2824"),
			Color.fromHexString("5b3630"),
			Color.fromHexString("5b3630"),
			Color.fromHexString("87463c"),
			Color.fromHexString("87463c")
		}
	})

	self:registerTile("grass", GrassBlock:Bind(self) {
		DIRT_THRESHOLD = 0,

		SATURATION = 4,

		COLORS = {
			Color.fromHexString("1f4629"),
			Color.fromHexString("1f4629"),
			Color.fromHexString("1f4629"),
			Color.fromHexString("1f4629"),
			Color.fromHexString("5a3761"),
			Color.fromHexString("5a3761"),
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

	self:registerTile("large_stone", RandomBlock:Bind(self) {
		GROUP = Block.GROUP_SHINY,

		FEATURE_THRESHOLD = 0,
		SATURATION = 1,

		MIN_SCALE = 1,
		MAX_SCALE = 1,
		MIN_OFFSET = 0.5,
		MAX_OFFSET = 0.5,

		FEATURES = {
			"tile.damaged1",
			"tile.damaged2",
			"tile.damaged3",
			"tile.damaged4",
			"tile.perfect"
		},

		COLORS = {
			Color.fromHexString("7b6453"),
			Color.fromHexString("7b6453"),
			Color.fromHexString("7b6453"),
			Color.fromHexString("53463f"),
			Color.fromHexString("53463f"),
			Color.fromHexString("40332b"),
			Color.fromHexString("40332b")
		}
	})

	self:registerTile("small_stone", RandomBlock:Bind(self) {
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
			Color.fromHexString("53463f")
		}
	})
end

return OldGinsvilleGround
