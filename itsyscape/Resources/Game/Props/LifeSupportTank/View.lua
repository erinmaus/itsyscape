--------------------------------------------------------------------------------
-- Resources/Game/Props/LifeSupportTank/View.lua
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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Tank = Class(SimpleStaticView)

Tank.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/LifeSupportTank/Model.lstatic",
		group = "tank.metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/LifeSupportTank/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "a692b9",
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
		mesh = "Resources/Game/Props/LifeSupportTank/Model.lstatic",
		group = "tank.glass",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/LifeSupportTank/Glass.png",

			properties = {
				isFullLit = true,
				isTranslucent = true,
				outlineThreshold = -1,
				color = "b2c3cd",
				alpha = 0.5,
				glassThickness = 1,
				zBias = 0.25,
				isZWriteDisabled = true
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
		mesh = "Resources/Game/Props/LifeSupportTank/Model.lstatic",
		group = "tank.water",

		material = DecorationMaterial("Resources/Game/Water/DrakkensonGoo1/Material.lua"):replace(DecorationMaterial({
			uniforms = {
				scape_YOffset = { "float", 0.25 },
				scape_SkyColor = { "color", "9d3385", 0.25 },
				scape_NearFoamDepth = { "float", 0, 0.5 },
				scape_FarFoamDepth = { "float", 0.25, 0.5 },
				scape_WaterDepth = { "float", 0.5, 1.0 },
				scape_WindDirection = { "float", -1, 0, -1 },
				scape_WindSpeed = { "float", 2 },
				scape_WindPattern = { "float", 5, 10, 15 },
			},
			properties = {
				alpha = 0.8,
				roughness = 0,
				glassThickness = 1
			}
		}))
	},
}

return Tank
