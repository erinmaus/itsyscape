--------------------------------------------------------------------------------
-- Resources/Game/Props/Pew_OldGinsville1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Pew = Class(SimpleStaticView)

Pew.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Pew_OldGinsville1/Model.lstatic",
		group = "pew.grain",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Pew_OldGinsville1/Grain.png",

			properties = {
				outlineThreshold = -0.01	
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
		mesh = "Resources/Game/Props/Pew_OldGinsville1/Model.lstatic",
		group = "pew.velvet",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Pew_OldGinsville1/Velvet.png",

			properties = {
				color = "262e39",
				outlineThreshold = -0.01	
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
		mesh = "Resources/Game/Props/Pew_OldGinsville1/Model.lstatic",
		group = "pew.solid",

		material = {
			shader = "Resources/Shaders/Solid",
			texture = false,

			uniforms = {
				scape_Specular = { "float", 0 }
			},

			properties = {
				color = "4c4441",
				outlineThreshold = -0.01	
			}
		}
	}
}

return Pew
