--------------------------------------------------------------------------------
-- Resources/Game/Effects/WaterStrike/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Curve = require "ItsyScape.Game.Curve"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

local WaterStrike = Class(CombatEffect)

WaterStrike.DURATION_STRONG = 10
WaterStrike.DEBUFF_STRONG   = 0.8

WaterStrike.DURATION_WEAK   = 5
WaterStrike.DEBUFF_WEAK     = 0.9

function WaterStrike:new()
	CombatEffect.new(self)

	self:boost(false)
end

function WaterStrike:boost(strong)
	if strong then
		self.debuffDuration = self.DURATION_STRONG
		self.debuffStrength = self.DEBUFF_STRONG
	else
		self.debuffDuration = self.DURATION_WEAK
		self.debuffStrength = self.DEBUFF_WEAK
	end

	self:setDuration(self.debuffDuration)
end

function WaterStrike:getDescription()
	return string.format("%d%%", math.ceil((1 - self.debuffStrength) * 100))
end

function WaterStrike:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function WaterStrike:applySelfToAttack(roll)
	local attackRoll = roll:getMaxAttackRoll() * self.debuffStrength
	roll:setMaxAttackRoll(attackRoll)
end

return WaterStrike
