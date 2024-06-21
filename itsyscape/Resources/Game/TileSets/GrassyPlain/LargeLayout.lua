--------------------------------------------------------------------------------
-- Resources/Game/TileSets/GrassyPlain/Ground.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Block = require "ItsyScape.World.TileSets.Block"
local Grass = require "ItsyScape.World.TileSets.Grass"

return {
	grass = Block.Bind(Grass) {
		DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/GrassyPlain/TropicalYendorianGrass%d.png",
		SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/GrassyPlain/TropicalYendorianGrass%d@Specular.png",
		--OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/GrassyPlain/TropicalYendorianGrass%d@Outline.png",
		OUTLINE_SAMPLE_FILENAME = "",
		NUM_SAMPLES = 1,
		SATURATION = 3
	}
}
