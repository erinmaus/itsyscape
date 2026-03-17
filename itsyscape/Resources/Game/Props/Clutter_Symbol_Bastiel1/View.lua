--------------------------------------------------------------------------------
-- Resources/Game/Props/Clutter_Symbol_Bastiel1/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Symbol = Class(SimpleStaticView)

Symbol.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Clutter_Symbol_Bastiel1/Model.lstatic",
		group = "feather",

		material = {
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/Clutter_Symbol_Bastiel1/Detail.png",

			properties = {
				color = "b99346",
				outlineThreshold = 0.2
			},

			uniforms = {
				scape_NumLayers = { "integer", 1 },
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/Clutter_Symbol_Bastiel1/Metal.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/Clutter_Symbol_Bastiel1/SpecularMetal.lua" },
				scape_WallHackWindow = { "float", 0, 0, 0, 0 }
			}
		}
	}
}

return Symbol
