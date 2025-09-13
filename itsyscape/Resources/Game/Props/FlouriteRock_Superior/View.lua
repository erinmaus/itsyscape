--------------------------------------------------------------------------------
-- Resources/Game/Props/FlouriteRock_Superior/View.lua
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

local SuperiorFlouriteRockView = Class(RockView)

function SuperiorFlouriteRockView:getRockMaterial()
	return RockView.getRockMaterial(self):replace(DecorationMaterial({
		shader = "Resources/Shaders/SpecularStaticModel",

		properties = {
			isReflectiveOrRefractive = true,
			reflectionPower = 1,
			reflectionDistance = 1,
			roughness = 0.5
		}
	}))
end

function SuperiorFlouriteRockView:getOreTextureFilename()
	return "Resources/Game/Props/FlouriteRock_Superior/Ore.png"
end

function SuperiorFlouriteRockView:getRockTextureFilename()
	return "Resources/Game/Props/FlouriteRock_Superior/Ore.png"
end

function SuperiorFlouriteRockView:getOreModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4_Superior.lstatic", "ore"
end

function SuperiorFlouriteRockView:getRockModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4_Superior.lstatic", "rock"
end

return SuperiorFlouriteRockView
