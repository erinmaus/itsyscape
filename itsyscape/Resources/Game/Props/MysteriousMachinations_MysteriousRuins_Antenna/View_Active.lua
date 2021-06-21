--------------------------------------------------------------------------------
-- Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/View_Active.lua
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
	"Antenna_Powered1",
	"Antenna_Powered2",
	"Antenna_Powered3",
	"Antenna_Powered4",
	"Antenna_Powered5"
}

Antenna.SCALES = {
	Vector(2, 4, 2),
	Vector(2.1, 5, 2.1),
	Vector(1.9, 3.5, 1.9),
	Vector(2, 5, 2),
	Vector(2.1, 6, 2.1)
}

Antenna.OFFSETS = {
	Vector(0, 0.75, 0),
	Vector(0, 1.25, 0),
	Vector(0, 0.75, 0),
	Vector(0, 1.25, 0),
	Vector(0, 2, 0)
}

Antenna.STEP = 2

function Antenna:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/Texture_Active.lua"
end

function Antenna:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Antenna/Model.lstatic"
end

return Antenna
