--------------------------------------------------------------------------------
-- Resources/Game/Props/KitchenSink_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local KitchenSink = Class(SimpleStaticView)

KitchenSink.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/KitchenSink_Default/Model.lstatic",
		group = "sink.tub",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/KitchenSink_Default/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "74898e",
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
		mesh = "Resources/Game/Props/KitchenSink_Default/Model.lstatic",
		group = "sink.pipe",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/KitchenSink_Default/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "25292d",
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
		mesh = "Resources/Game/Props/KitchenSink_Default/Model.lstatic",
		group = "sink.pipe.valve",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/KitchenSink_Default/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "3771c8",
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
		mesh = "Resources/Game/Props/KitchenSink_Default/Model.lstatic",
		group = "sink.legs",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/KitchenSink_Default/Grain.png",

			properties = {
				outlineThreshold = -0.01,
				color = "3771c8",
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/KitchenSink_Default/Model.lstatic",
		group = "sink.water",

		material = DecorationMaterial("Resources/Game/Water/LightFoamyWater1/Material.lua"):replace(DecorationMaterial({
			uniforms = {
				scape_YOffset = { "float", 0.1 },
				scape_SkyColor = { "color", "ffffff", 0.25 },
				scape_NearFoamDepth = { "float", 0, 0.05 },
				scape_FarFoamDepth = { "float", 0.25, 0.1 },
				scape_WaterDepth = { "float", 0.5, 0.25 },
				scape_WindDirection = { "float", -1, 0, -1 },
				scape_WindSpeed = { "float", 2 },
				scape_WindPattern = { "float", 5, 10, 15 },
			},
			properties = {
				alpha = 0.8
			}
		}))
	},
}

return KitchenSink
