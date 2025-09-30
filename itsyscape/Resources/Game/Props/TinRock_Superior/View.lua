--------------------------------------------------------------------------------
-- Resources/Game/Props/TinRock_Superior/View.lua
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

local SuperiorTinRockView = Class(RockView)

function SuperiorTinRockView:getRockMaterial()
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

function SuperiorTinRockView:getOreTextureFilename()
	return "Resources/Game/Props/TinRock_Superior/Ore.png"
end

function SuperiorTinRockView:getRockTextureFilename()
	return "Resources/Game/Props/TinRock_Superior/Ore.png"
end

function SuperiorTinRockView:getOreModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4_Superior.lstatic", "ore"
end

function SuperiorTinRockView:getRockModelFilename()
	return "Resources/Game/Props/Common/Rock/Rock4_Superior.lstatic", "rock"
end

return SuperiorTinRockView
