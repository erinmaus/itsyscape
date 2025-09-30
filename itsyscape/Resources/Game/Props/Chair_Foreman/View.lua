--------------------------------------------------------------------------------
-- Resources/Game/Props/Chair_Foreman/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Chair = Class(SimpleStaticView)

Chair.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Chair_Foreman/Model.lstatic",
		group = "grain",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Chair_Foreman/Grain.png",

			properties = {
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Chair_Foreman/Model.lstatic",
		group = "solid",

		material = {
			shader = "Resources/Shaders/Solid",
			texture = false,

			properties = {
				color = "523931",
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_Specular = { "float", 0.25 }
			}
		}
	}
}

return Chair
