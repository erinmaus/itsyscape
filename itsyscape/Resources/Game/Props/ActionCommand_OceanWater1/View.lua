--------------------------------------------------------------------------------
-- Resources/Game/Props/ActionCommand_OceanWater1/View.lua
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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView2"
local StaticGreeble = require "Resources.Game.Props.Common.Greeble.StaticGreeble"

local Water = Class(SimpleStaticView)

Water.GREEBLE = {
	{
		type = StaticGreeble,
		config = {
			MESH = "Resources/Game/Props/ActionCommand_OceanWater1/Model.lstatic",
			GROUP = "water",
			MATERIAL = DecorationMaterial("Resources/Game/Water/LightFoamyWater1/Material.lua"):replace(DecorationMaterial({
				uniforms = {
					scape_YOffset = { "float", 0.25 },
					scape_SkyColor = { "color", "e3f2ff", 0.25 },
					scape_NearFoamDepth = { "float", 0, 0.5 },
					scape_FarFoamDepth = { "float", 0.25, 0.5 },
					scape_WaterDepth = { "float", 0.5, 1.0 },
					scape_WindDirection = { "float", -1, 0, -1 },
					scape_WindSpeed = { "float", 2 },
					scape_WindPattern = { "float", 5, 10, 15 },
				},
				properties = {
					alpha = 0.8,
					isFullLit = true,
					isZWriteDisabled = true
				}
			}))
		},

		transform = {
			scale = Vector(15 / 16, 15 / 16, 15 / 16)
		}
	}
}

return Water
