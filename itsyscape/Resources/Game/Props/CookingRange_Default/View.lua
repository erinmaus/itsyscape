--------------------------------------------------------------------------------
-- Resources/Game/Props/CookingRange_Default/View.lua
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
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local CookingRange = Class(SimpleStaticView)

CookingRange.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.detail",

		material = {
			shader = "Resources/Shaders/StaticModel",
			texture = "Resources/Game/Props/CookingRange_Default/Detail.png",

			properties = {
				color = "ffffff",
				outlineThreshold = 0.5
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.bottom",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/CookingRange_Default/Metal.png",

			properties = {
				color = "74898e",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.top",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/CookingRange_Default/Metal.png",

			properties = {
				color = "74898e",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.door",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/CookingRange_Default/Metal.png",

			properties = {
				color = "626e78",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.pit",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/CookingRange_Default/Metal.png",

			properties = {
				color = "74898e",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.screws",

		material = {
			shader = "Resources/Shaders/Solid",
			texture = false,

			properties = {
				color = "25292d",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/CookingRange_Default/Model.lstatic",
		group = "range.hinges",

		material = {
			shader = "Resources/Shaders/Solid",
			texture = false,

			properties = {
				color = "25292d",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_Specular = { "float", 1 }
			}
		}
	}
}

CookingRange.GREEBLE = {
	{
		type = FlameGreeble,
		config = {
			INNER_RADIUS = 0.5,
			OUTER_RADIUS = 0.25,
			PARTICLE_SCALE = 1,
			INNER_FLAME_SPEED = 0.3,
			OUTER_FLAME_SPEED = 0.2,
		},
		transform = {
			translation = Vector(0.65, 0.15, 0)
		}
	},
	{
		type = FlickerGreeble,
		config = {
			COLORS = {
				Color(1)
			}
		},
		transform = {
			translation = Vector(0.65, 0.15, 0)
		}
	}
}

return CookingRange
