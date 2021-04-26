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

local Pillar = Class(Shape4DView)

Pillar.GROUPS = {
	"Pillar_Stable",
	"Pillar_Unstable1",
	"Pillar_Unstable2",
	"Pillar_Unstable3",
	"Pillar_Unstable4",
	"Pillar_Unstable5",
	"Pillar_Unstable6"
}

Pillar.SCALE_TWEEN = Tween.constantZero
Pillar.SCALES = {
	Vector.ONE,
	Vector.ONE,
	Vector.ONE,
	Vector.ONE,
	Vector.ONE,
	Vector.ONE,
	Vector.ONE
}

Pillar.STEP = 3.5

Pillar.OFFSET_TWEEN = Tween.constantZero
Pillar.OFFSETS = {
	Vector.ZERO,
	Vector.ZERO,
	Vector.ZERO,
	Vector.ZERO,
	Vector.ZERO,
	Vector.ZERO,
	Vector.ZERO
}

function Pillar:getTextureFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/Texture.lua"
end

function Pillar:getModelFilename()
	return "Resources/Game/Props/MysteriousMachinations_MysteriousRuins_Pillar/Model.lstatic"
end

function Pillar:load()
	Shape4DView.load(self)

	local scales = {}
	for i = 1, #self.GROUPS do
		scales[i] = self.GROUPS[i]
	end

	self.GROUPS = {}
	while #scales > 0 do
		local index = math.random(#scales)
		table.insert(self.GROUPS, scales[index])
		table.remove(scales, index) 
	end

	self.time = math.random() * self.STEP
end

return Pillar
