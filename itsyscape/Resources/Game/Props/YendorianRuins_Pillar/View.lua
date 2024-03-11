--------------------------------------------------------------------------------
-- Resources/Game/Props/YendorianRuins_Pillar/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SimpleStaticView = require "Resources.Game.Props.Common.SimpleStaticView"

local Pillar = Class(SimpleStaticView)
Pillar.TRANSLATION_OFFSET = 1.25
Pillar.TRANSLATION_MULTIPLIER = 1.05
Pillar.TRANSLATION_TIME = math.pi

function Pillar:getTextureFilename()
	return "Resources/Game/Props/YendorianRuins_Pillar/Texture.png"
end

function Pillar:getModelFilename()
	return "Resources/Game/Props/YendorianRuins_Pillar/Model.lstatic", "Pillar"
end

function Pillar:tick()
	SimpleStaticView.tick(self)

	local delta = math.clamp(math.sin(love.timer.getTime() * Pillar.TRANSLATION_TIME) * Pillar.TRANSLATION_MULTIPLIER, -1, 1)
	local y = delta * Pillar.TRANSLATION_OFFSET

	self.decoration:getTransform():setLocalTranslation(Vector(0, y, 0))
end

return Pillar
