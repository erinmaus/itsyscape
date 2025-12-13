--------------------------------------------------------------------------------
-- Resources/Game/Props/LifeSupportProcessor/View.lua
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

local Processor = Class(SimpleStaticView)

Processor.DESCRIPTION = {
	{
		mesh = "Resources/Game/Props/LifeSupportProcessor/Model.lstatic",
		group = "purifier.metal",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/LifeSupportProcessor/Metal.png",

			properties = {
				outlineThreshold = -0.01,
				color = "a692b9",
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
		mesh = "Resources/Game/Props/LifeSupportProcessor/Model.lstatic",
		group = "purifier.glass",

		material = {
			shader = "Resources/Shaders/SpecularTriplanar",
			texture = "Resources/Game/Props/LifeSupportProcessor/Glass.png",

			properties = {
				isFullLit = true,
				isTranslucent = true,
				outlineThreshold = -1,
				color = "29a77b",
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

return Processor
