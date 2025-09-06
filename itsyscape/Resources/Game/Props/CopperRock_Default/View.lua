--------------------------------------------------------------------------------
-- Resources/Game/Props/CopperRock_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local RockView = require "Resources.Game.Props.Common.RockView4"

local CopperRockView = Class(RockView)

function CopperRockView:getRockMaterial()
	return RockView.getRockMaterial(self):replace(DecorationMaterial({
		shader = false,

		uniforms = {
			scape_TriplanarScale = { "float", -0.5 }
		}
	}))
end

function CopperRockView:getOreTextureFilename()
	return "Resources/Game/Props/CopperRock_Default/Ore.png"
end

function CopperRockView:getRockTextureFilename()
	return "Resources/Game/Props/CopperRock_Default/Rock.png"
end

return CopperRockView
