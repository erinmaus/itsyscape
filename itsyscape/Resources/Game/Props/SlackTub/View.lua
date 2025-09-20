--------------------------------------------------------------------------------
-- Resources/Game/Props/SlackTub/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local SlackTub = Class(SimpleStaticView)
SlackTub.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/SlackTub/Model.lstatic",
		group = "metal",
		material = DecorationMaterial({
			shader = "Resources/Shaders/SpecularMultiTriplanar",
			texture = "Resources/Game/Props/SlackTub/Metal.lua",

			uniforms = {
				scape_NumLayers = { "integer", 2 },
				scape_TriplanarScale = { "float", 0, 2 },
				scape_TriplanarOffset = { "float", -0.25, 0.1 },
				scape_TriplanarExponent = { "float", 0, 0 }
			},

			properties = {
				color = "42414b",
				reflectionPower = 0.5,
				reflectionDistance = 0.5,
				roughness = 1
			}
		})
	},
	{
		mesh = "Resources/Game/Props/SlackTub/Model.lstatic",
		group = "solid",
		material = DecorationMaterial({
			shader = "Resources/Shaders/Solid",

			properties = {
				color = "42414b",
				reflectionPower = 0.5,
				reflectionDistance = 0.5,
				roughness = 1
			}
		})
	},
	{
		mesh = "Resources/Game/Props/SlackTub/Model.lstatic",
		group = "water",
		material = DecorationMaterial("Resources/Game/Water/LightFoamyWater1/Material.lua"):replace(DecorationMaterial({
			uniforms = {
				scape_YOffset = { "float", 0.125 },
				scape_SkyColor = { "color", "e3f2ff", 0.25 },
				scape_NearFoamDepth = { "float", 0, 0.5 },
				scape_FarFoamDepth = { "float", 0.25, 0.5 },
				scape_WaterDepth = { "float", 0.5, 1.0 },
				scape_WindDirection = { "float", -1, 0, -1 },
				scape_WindSpeed = { "float", 2 },
				scape_WindPattern = { "float", 5, 10, 15 },
			},
			properties = {
				reflectionPower = 0.5,
				reflectionDistance = 0.5,
				roughness = 0
			}
		}))
	}
}

return SlackTub
