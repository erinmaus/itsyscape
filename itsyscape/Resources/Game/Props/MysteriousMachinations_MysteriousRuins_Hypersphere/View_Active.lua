--------------------------------------------------------------------------------
-- Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Hypersphere/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Shape4DView = require "Resources.Game.Props.Common.Shape4DView"

local Hypersphere = Class(Shape4DView)

Hypersphere.GROUPS = {
	"Hypersphere_Powered1",
	"Hypersphere_Powered2",
	"Hypersphere_Powered3"
}

Hypersphere.SCALES = {
	Vector(2),
	Vector(2.5),
	Vector(1.5)
}

Hypersphere.STEP = 2

Hypersphere.OFFSET_TWEEN = Tween.constantZero
Hypersphere.OFFSETS = {
	Vector(0, 2.5, 0),
	Vector(0, 2.5, 0),
	Vector(0, 2.5, 0)
}

function Hypersphere:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Hypersphere/Texture_Active.lua"
end

function Hypersphere:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Hypersphere/Model.lstatic"
end

return Hypersphere
