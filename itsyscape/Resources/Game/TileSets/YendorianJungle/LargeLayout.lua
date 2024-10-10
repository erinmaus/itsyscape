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
	grass = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianGrass%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianGrass%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianGrass%d@Outline.png",
		NUM_SAMPLES = 2,
	},

	dirt_path = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianDirtPath%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianDirtPath%d@Specular.png",
		OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianDirtPath%d@Outline.png",
		NUM_SAMPLES = 3,

		DIRT_THRESHOLD = 0,

		MIN_OFFSET = -8,
		MAX_OFFSET = 8,
		MIN_SCALE = 0.7,
		MAX_SCALE = 0.9,

		COLORS = {
			Color.fromHexString("524842"),
			Color.fromHexString("5c4b40"),
			Color.fromHexString("54423b"),
		}
	},

	sand = Block.Bind(Grass) {
		SATURATION = 4,

		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianSand%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/YendorianJungle/TropicalYendorianSand%d@Specular.png",
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
	}
}
