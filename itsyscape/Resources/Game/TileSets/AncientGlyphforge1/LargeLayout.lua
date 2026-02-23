--------------------------------------------------------------------------------
-- Resources/Game/TileSets/AncientGlyphforge1/LargeLayout.lua
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

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Grass%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Grass%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Grass%d@Outline.png",
		NUM_SAMPLES = 4,

		DIRT_THRESHOLD = 0,

		COLORS = {
			Color.fromHexString("ffffff")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("1f4629")
	},

	mud = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Sand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Sand%d@Specular.png",
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
			Color.fromHexString("7b6453"),
			Color.fromHexString("7b6453"),
			Color.fromHexString("53463f"),
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("44414c"),
	},

	rock = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Rock%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Rock%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/AncientGlyphforge1/Rock%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0.3,

		MIN_OFFSET = -16,
		MAX_OFFSET = 16,
		MIN_SCALE = 0.4,
		MAX_SCALE = 0.7,

		SAMPLE_NOISE = Grass.SAMPLE_NOISE {
			scale = 7237
		},

		ROTATION_NOISE = Grass.ROTATION_NOISE {
			scale = 6363
		},

		COLORS = {
			Color.fromHexString("ffffff")
		},

		DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("40332b"),
	}
}
