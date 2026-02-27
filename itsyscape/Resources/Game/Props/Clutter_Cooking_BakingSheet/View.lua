--------------------------------------------------------------------------------
-- Resources/Game/Props/Clutter_Cooking_BakingSheet/View.lua
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

local BakingSheet = Class(SimpleStaticView)

BakingSheet.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Clutter_Cooking_BakingSheet/Model.lstatic",
		group = "metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Clutter_Cooking_BakingSheet/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "626e78",
			},

			uniforms = {
				scape_TriplanarScale = { "float", -0.5 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_SpecularWeight = { "float", 1 }
			}
		}
	}
}

return BakingSheet
