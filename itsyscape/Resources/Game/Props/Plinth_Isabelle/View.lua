--------------------------------------------------------------------------------
-- Resources/Game/Props/Plinth_Isabelle/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Plinth = Class(SimpleStaticView)

Plinth.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Plinth_Isabelle/Model.lstatic",
		group = "plinth.wood",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Plinth_Isabelle/Wood.png",

			properties = {
				outlineThreshold = 0.2
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
		mesh = "Resources/Game/Props/Plinth_Isabelle/Model.lstatic",
		group = "plinth.marble",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Plinth_Isabelle/Marble.png",

			properties = {
				outlineThreshold = 0.2,
				isReflectiveOrRefractive = true,
				reflectionPower = 0.5,
				reflectionDistance = 1,
				roughness = 0
			},

			uniforms = {
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Plinth_Isabelle/Model.lstatic",
		group = "plinth.gold",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Plinth_Isabelle/Metal.png",

			properties = {
				outlineThreshold = 0.2,
				color = "ffa100",
				isReflectiveOrRefractive = true,
				reflectionPower = 0.5,
				reflectionDistance = 1
			},

			uniforms = {
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		}
	},
}

return Plinth
