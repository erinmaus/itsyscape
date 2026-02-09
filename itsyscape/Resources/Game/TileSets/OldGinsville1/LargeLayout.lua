--------------------------------------------------------------------------------
-- Resources/Game/TileSets/OldGinsville1/LargeLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Color = require "ItsyScape.Graphics.Color"
local Noise = require "ItsyScape.Graphics.Noise"
local Block = require "ItsyScape.World.TileSets.Block"
local Grass = require "ItsyScape.World.TileSets.Grass"

return {
	grass = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Grass%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Grass%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Grass%d@Outline.png",
		NUM_SAMPLES = 4,

		DIRT_THRESHOLD = 0.2,

		COLORS = {
			Color.fromHexString("ffffff")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("2e2927")
	},

	moss = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Moss%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Moss%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Moss%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.2,

		COLORS = {
			Color.fromHexString("424c41"),
			Color.fromHexString("2a3829"),
			Color.fromHexString("4c4441"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("2e2927")
	},

	sand = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Sand%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 1,
		MAX_SCALE = 1.2,

		ROTATION_NOISE = Noise {
			scale = 13,
			octaves = 2,
			attenuation = 0
		},

		COLORS = {
			Color.fromHexString("aa9574")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("aa9574"),
	},

	mud = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Sand%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.2,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 1,
		MAX_SCALE = 1.2,

		ROTATION_NOISE = Noise {
			scale = 13,
			octaves = 2,
			attenuation = 0
		},

		COLORS = {
			Color.fromHexString("44414c"),
			Color.fromHexString("44414c"),
			Color.fromHexString("433b5a"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("44414c"),
	},

	marble = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Stone%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Stone%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Stone%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.2,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 0.75,
		MAX_SCALE = 1,

		ROTATION_NOISE = Noise {
			scale = 7,
			octaves = 1,
			attenuation = 0
		},

		COLORS = {
			Color.fromHexString("ffffff")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("4c4441"),
	},

	dirt = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Dirt%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Dirt%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/OldGinsville1/Dirt%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.2,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 0.5,
		MAX_SCALE = 0.75,

		COLORS = {
			Color.fromHexString("ffffff")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("2e2927"),
	}
}
