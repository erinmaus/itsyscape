--------------------------------------------------------------------------------
-- Resources/Game/Props/Furnace_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local FlameGreeble = require "Resources.Game.Props.Common.Greeble.FlameGreeble"
local SmokeGreeble = require "Resources.Game.Props.Common.Greeble.SmokeGreeble"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local Furnace = Class(SimpleStaticView)

Furnace.GREEBLE = {
	{
		type = FlameGreeble,

		transform = {
			translation = Vector(-1, 0.75, -0.5)
		},

		config = {
			FLAME_SCALE = Vector(2):keep(),
			FLAME_HEIGHT = 0.25,
			INNER_FLAME_SPEED = 0.1,
			OUTER_FLAME_SPEED = 0.2
		}
	},
	{
		type = FlameGreeble,

		transform = {
			translation = Vector(1, 0.75, -0.5)
		},

		config = {
			FLAME_SCALE = Vector(2):keep(),
			FLAME_HEIGHT = 0.25,
			INNER_FLAME_SPEED = 0.1,
			OUTER_FLAME_SPEED = 0.2
		}
	},
	{
		type = FlameGreeble,

		transform = {
			translation = Vector(0, 0.75, -0.5)
		},

		config = {
			FLAME_SCALE = Vector(2):keep(),
			FLAME_HEIGHT = 0.5,
			INNER_FLAME_SPEED = 0.2,
			OUTER_FLAME_SPEED = 0.3
		}
	},
	{
		type = SmokeGreeble,

		transform = {
			translation = Vector(0, 5, -0.5)
		},

		config = {
			SMOKE_SCALE = Vector(2),
			SMOKE_SPEED = 0.5,
			SMOKE_HEIGHT = 0
		}
	},
	{
		type = FlickerGreeble,

		transform = {
			translation = Vector(0, 1.5, 1)
		},

		config = {
			MIN_ATTENUATION = 8,
			MAX_ATTENUATION = 12,
			COLORS = {
				Color.fromHexString("ffd52a")
			}
		}
	}
}

Furnace.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Furnace_Default/Model.lstatic",
		group = "bricks",

		material = {
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/Furnace_Default/Bricks.png",
			uniforms = {
				scape_NumLayers = { "integer", 2 },
				scape_TriplanarScale = { "float", -0.25, 0.1 },
				scape_TriplanarOffset = { "float", 0, 0 },
				scape_TriplanarExponent = { "float", 0, 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/Furnace_Default/BricksDetail.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/Furnace_Default/SpecularBricksDetail.lua" },
				scape_SpecularWeight = { "float", 1 },
			},

			properties = {
				outlineThreshold = 0.5,
				color = "927552",
			}
		}

	},
	{
		mesh = "Resources/Game/Props/Furnace_Default/Model.lstatic",
		group = "metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Furnace_Default/Metal.png",

			properties = {
				outlineThreshold = 0.5,
				color = "42414b"
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0.5 }
			}
		}
	}
}

return Furnace
