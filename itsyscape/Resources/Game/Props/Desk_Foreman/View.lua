--------------------------------------------------------------------------------
-- Resources/Game/Props/Desk_Foreman/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"

local Desk = Class(SimpleStaticView)

Desk.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Desk_Foreman/Model.lstatic",
		group = "plywood",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Desk_Foreman/Plywood.png",

			properties = {
				outlineThreshold = 0.5
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0, 0 },
				scape_TriplanarOffset = { "float", 0, 0 },
			}
		}
	},
	{
		mesh = "Resources/Game/Props/Desk_Foreman/Model.lstatic",
		group = "planks",

		material = {
			shader = "Resources/Shaders/Decoration",
			texture = "Resources/Game/Props/Desk_Foreman/Planks.png",

			properties = {
				outlineThreshold = 0.5
			}
		}
	}
}

return Desk
