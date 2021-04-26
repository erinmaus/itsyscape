--------------------------------------------------------------------------------
-- Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/View.lua
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
	"Pillar_Stable",
	"Pillar_Stable"
}

Hypersphere.SCALES = {
	Vector.ONE,
	Vector.ONE
}

Hypersphere.OFFSETS = {
	Vector.ZERO,
	Vector.ZERO
}

function Hypersphere:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/Texture_Inactive.lua"
end

function Hypersphere:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/Model.lstatic"
end

return Hypersphere
