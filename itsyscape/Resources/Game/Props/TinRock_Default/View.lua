--------------------------------------------------------------------------------
-- Resources/Game/Props/TinRock_Default/View.lua
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

local TinRockView = Class(RockView)

function TinRockView:getRockMaterial()
	return RockView.getRockMaterial(self):replace(DecorationMaterial({
		shader = false,

		uniforms = {
			scape_TriplanarScale = { "float", -0.6 }
		}
	}))
end

function TinRockView:getOreTextureFilename()
	return "Resources/Game/Props/TinRock_Default/Ore.png"
end

function TinRockView:getRockTextureFilename()
	return "Resources/Game/Props/TinRock_Default/Rock.png"
end

return TinRockView
