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
	"Hypersphere_Unpowered",
	"Hypersphere_Unpowered"
}

Hypersphere.SCALES = {
	Vector(2),
	Vector(2.1)
}

Hypersphere.OFFSETS = {
	Vector(0, 2.5, 0),
	Vector(0, 2.25, 0)
}

Hypersphere.STEP = 8

function Hypersphere:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Hypersphere/Texture_Inactive.lua"
end

function Hypersphere:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Hypersphere/Model.lstatic"
end

return Hypersphere
