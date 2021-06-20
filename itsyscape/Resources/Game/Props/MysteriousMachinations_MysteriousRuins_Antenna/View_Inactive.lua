--------------------------------------------------------------------------------
-- Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/View_Inactive.lua
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

local Antenna = Class(Shape4DView)

Antenna.GROUPS = {
	"Antenna_Unpowered",
	"Antenna_Unpowered",
	"Antenna_Unpowered",
	"Antenna_Unpowered",
	"Antenna_Unpowered"
}

Antenna.SCALES = {
	Vector(1, 4, 1),
	Vector(1.1, 5, 1.1),
	Vector(0.9, 3.5, 0.9),
	Vector(1, 5, 1),
	Vector(0, 0, 0)
}

Antenna.OFFSETS = {
	Vector(0, 0.75, 0),
	Vector(0, 1.25, 0),
	Vector(0, 0.75, 0),
	Vector(0, 1.25, 0),
	Vector(0, 2, 0)
}

Antenna.STEP = 4

function Antenna:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/Texture_Inactive.lua"
end

function Antenna:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/Model.lstatic"
end

return Antenna
