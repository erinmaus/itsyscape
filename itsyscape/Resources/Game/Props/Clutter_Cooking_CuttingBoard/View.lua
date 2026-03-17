--------------------------------------------------------------------------------
-- Resources/Game/Props/Clutter_Cooking_CuttingBoard/View.lua
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

local CuttingBoard = Class(SimpleStaticView)

CuttingBoard.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/Clutter_Cooking_CuttingBoard/Model.lstatic",
		group = "board",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/Clutter_Cooking_CuttingBoard/Wood.png",

			properties = {
				outlineThreshold = -0.01,
				color = "ffffff",
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
		mesh = "Resources/Game/Props/Clutter_Cooking_CuttingBoard/Model.lstatic",
		group = "knife",

		material = {
			shader = "Resources/Shaders/StaticModel",
			texture = "Resources/Game/Props/Clutter_Cooking_CuttingBoard/Knife.png",

			properties = {
				outlineThreshold = 0.5,
				color = "ffffff",
			}
		}
	}
}

return CuttingBoard
