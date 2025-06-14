--------------------------------------------------------------------------------
-- Resources/Game/TileSets/ViziersRock2/Ground.lua
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
local WoodBlock = require "ItsyScape.World.GroundDecorations.WoodBlockV2"
local GrassBlock = require "ItsyScape.World.GroundDecorations.GrassBlockV2"
local VineBlock = require "ItsyScape.World.GroundDecorations.VineBlockV2"
local RandomBlock = require "ItsyScape.World.GroundDecorations.RandomBlockV2"

local ViziersRockGround = Class(GroundDecorations)

function ViziersRockGround:new()
	GroundDecorations.new(self, "ViziersRock2")

	self:registerTile("wood", WoodBlock:Bind(self) {
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
		DIRT_THRESHOLD = 0.4,

		COLORS = {
			Color.fromHexString("7d3818"),
			Color.fromHexString("d17128"),
			Color.fromHexString("a3491f"),
		}
	})

	self:registerTile("sand", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0.3,
		SATURATION = 2,

		FEATURES = {
			"shell1",
			"shell2",
			"shell3",
			"shell4"
		}
	})

	self:registerTile("mud", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0.5,
		SATURATION = 2,

		FEATURES = {
			"garbage1",
			"garbage2",
			"garbage3",
			"garbage4"
		}
	})

	self:registerTile("stone", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0,
		SATURATION = 1,

		MIN_OFFSET = 0.5,
		MAX_OFFSET = 0.5,

		FEATURES = {
			"bricks1",
			"bricks2",
			"bricks3",
			"bricks4"
		},

		COLORS = {
			Color.fromHexString("505361")
		}
	})

	self:registerTile("stone_sewers", RandomBlock:Bind(self) {
		FEATURE_THRESHOLD = 0,
		SATURATION = 1,

		MIN_OFFSET = 0.5,
		MAX_OFFSET = 0.5,

		FEATURES = {
			"bricks1",
			"bricks2",
			"bricks3",
			"bricks4"
		},

		COLORS = {
			Color.fromHexString("614a39")
		}
	})
end

return ViziersRockGround
