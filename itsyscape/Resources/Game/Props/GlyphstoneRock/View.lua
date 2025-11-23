--------------------------------------------------------------------------------
-- Resources/Game/Props/GlyphstoneRock/View.lua
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

local Glyphstone = Class(RockView)

Glyphstone.SHAKE_TIME_SECONDS = 0
Glyphstone.ROCK_DEPLETED_DARKEN_PERCENT = 0.5

function Glyphstone:getOreMaterial()
	return nil
end

function Glyphstone:getRockMaterial()
	return RockView.getRockMaterial(self):replace(DecorationMaterial({
		shader = false,

		uniforms = {
			scape_TriplanarScale = { "float", -0.6 }
		}
	}))
end

function Glyphstone:getOreTextureFilename()
	return "Resources/Game/Props/GlyphstoneRock/Ore.png"
end

function Glyphstone:getRockTextureFilename()
	return "Resources/Game/Props/GlyphstoneRock/Rock.png"
end

return Glyphstone
