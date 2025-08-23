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

		COLORS = {
			Color.fromHexString("8a916f"),
			Color.fromHexString("729168"),
			Color.fromHexString("7c7d50"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("a38265")
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
			Color.fromHexString("d6aa83")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("a38265"),
	},

	mud = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/ViziersRock2/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/ViziersRock2/Sand%d@Specular.png",
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
			Color.fromHexString("d6c083"),
			Color.fromHexString("efe6cd"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("d6c083"),
	},

	dirt = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianUnderground1/Dirt%d@Outline.png",
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
			Color.fromHexString("6c5d53")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("6c5d53"),
	}
}
