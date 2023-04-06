--------------------------------------------------------------------------------
-- Resources/Game/Effects/FireStrike/Effect.lua
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

local FireStrike = Class(CombatEffect)

FireStrike.DURATION_STRONG = 10
FireStrike.DEBUFF_STRONG   = 0.2

FireStrike.DURATION_WEAK   = 5
FireStrike.DEBUFF_WEAK     = 0.1

function FireStrike:new()
	CombatEffect.new(self)

	self:boost(false)
end

function FireStrike:boost(strong)
	if strong then
		self.debuffDuration = self.DURATION_STRONG
		self.debuffStrength = self.DEBUFF_STRONG
	else
		self.debuffDuration = self.DURATION_WEAK
		self.debuffStrength = self.DEBUFF_WEAK
	end

	self:setDuration(self.debuffDuration)
end

function FireStrike:getDescription()
	return string.format("%d%%", self.debuffStrength * 100)
end

function FireStrike:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function FireStrike:applyTargetToDamage(roll)
	roll:setMinHit(math.floor(roll:getMinHit() * (1 + self.debuffStrength)))
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.debuffStrength)))
end

return FireStrike
