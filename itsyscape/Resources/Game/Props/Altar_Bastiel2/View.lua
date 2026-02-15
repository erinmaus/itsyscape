--------------------------------------------------------------------------------
-- Resources/Game/Props/Altar_Bastiel2/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Altar = Class(SimpleStaticView)

Altar.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Altar_Bastiel2/Model.lstatic",
		group = "marble",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Altar_Bastiel2/Marble.png",

			properties = {
				color = "a4b4ca",
				outlineThreshold = 0.2
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Altar_Bastiel2/Model.lstatic",
		group = "metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Altar_Bastiel2/Metal.png",

			properties = {
				color = "b99346",
				outlineThreshold = 0.2,
				isReflectiveOrRefractive = true,
				reflectionPower = 0.5,
				reflectionDistance = 1,
				roughness = 0
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Altar_Bastiel2/Model.lstatic",
		group = "cloth1",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Altar_Bastiel2/Velvet.png",

			properties = {
				color = "3f4d60",
				outlineThreshold = 0.2
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Altar_Bastiel2/Model.lstatic",
		group = "cloth2",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Altar_Bastiel2/Velvet.png",

			properties = {
				color = "b99346",
				outlineThreshold = 0.2
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
			}
		}
	}
}

return Altar
