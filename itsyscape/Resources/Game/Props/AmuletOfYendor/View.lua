--------------------------------------------------------------------------------
-- Resources/Game/Props/AmuletOfYendor/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local Color = require "ItsyScape.Graphics.Color"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local FlickerGreeble = require "Resources.Game.Props.Common.Greeble.FlickerGreeble"

local AmuletOfYendor = Class(SimpleStaticView)

AmuletOfYendor.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/AmuletOfYendor/Model.lstatic",
		group = "pillow",

		material = DecorationMaterial({
			shader = "Resources/Shaders/DetailDecorationSpecularMultiTriplanar",
			texture = "Resources/Game/Props/AmuletOfYendor/Pillow.png",
			uniforms = {
				scape_NumLayers = { "integer", 1 },
				scape_TriplanarScale = { "float", 0 },
				scape_TriplanarOffset = { "float", 0 },
				scape_TriplanarExponent = { "float", 0 },
				scape_TriplanarTexture = { "texture", "Resources/Game/Props/AmuletOfYendor/VelvetDetail.lua" },
				scape_TriplanarSpecularTexture = { "texture", "Resources/Game/Props/AmuletOfYendor/SpecularVelvetDetail.lua" },
				scape_SpecularWeight = { "float", 0.75 },
			},

			properties = {
				outlineThreshold = 0.5
			}
		})
	},
	{
		mesh = "Resources/Game/Props/AmuletOfYendor/Model.lstatic",
		group = "amulet",

		material = DecorationMaterial({
			shader = "Resources/Shaders/SpecularStaticModel",
			texture = "Resources/Game/Props/AmuletOfYendor/AmuletOfYendor.png",

			properties = {
				outlineThreshold = 0.5
			}
		})
	}
}

AmuletOfYendor.GREEBLE = {
	{
		type = FlickerGreeble,
		config = {
			MIN_ATTENUATION = 0.25,
			MAX_ATTENUATION = 0.5,

			OFFSET = Vector(0, 0.75, 0.75),

			COLORS = {
				Color(1, 0, 0, 1)
			}
		}
	}
}

return AmuletOfYendor
