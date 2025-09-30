--------------------------------------------------------------------------------
-- Resources/Game/TileSets/YendorianJungle/Ground.lua
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
	moss = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Moss%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Moss%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Moss%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.5,

		COLORS = {
			Color.fromHexString("7d8776"),
			Color.fromHexString("5d6954"),
			Color.fromHexString("2f342a"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("523931")
	},

	sand = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Sand%d@Specular.png",
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
			Color.fromHexString("d3b794")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("d3b794"),
	},

	mud = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/ViziersRock2/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/ViziersRock2/Sand%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.5,

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
			Color.fromHexString("523931"),
			Color.fromHexString("aa7766"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("523931"),
	},

	dirt = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.5,

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
			Color.fromHexString("aa7766")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("aa7766"),
	},

	dirt_dark = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 1.2,
		MAX_SCALE = 1.4,

		ROTATION_NOISE = Noise {
			scale = 13,
			octaves = 2,
			attenuation = 0
		},

		COLORS = {
			Color.fromHexString("523931")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("523931"),
	}
}
