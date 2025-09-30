--------------------------------------------------------------------------------
-- Resources/Game/Props/Chest_Foreman/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ChestView = require "Resources.Game.Props.Common.ChestView"

local Chest = Class(ChestView)

Chest.TOP_DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "top.grain",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Chest_Foreman/Grain.png",

			properties = {
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0.5 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "top.cloth",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Chest_Foreman/Velvet.png",

			properties = {
				outlineThreshold = 0.5
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
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "top.plank",

		material = {
			shader = "Resources/Shaders/Decoration",
			texture = "Resources/Game/Props/Chest_Foreman/Planks.png",

			properties = {
				outlineThreshold = 0.5
			}
		}
	}
}

Chest.BOTTOM_DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "bottom.grain",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Chest_Foreman/Grain.png",

			properties = {
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0.5 }
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "bottom.cloth",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Chest_Foreman/Velvet.png",

			properties = {
				outlineThreshold = 0.5
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
		mesh = "Resources/Game/Props/Chest_Foreman/Model.lstatic",
		group = "bottom.plank",

		material = {
			shader = "Resources/Shaders/Decoration",
			texture = "Resources/Game/Props/Chest_Foreman/Planks.png",

			properties = {
				outlineThreshold = 0.5
			}
		}
	}
}

return Chest
