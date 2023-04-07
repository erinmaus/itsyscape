--------------------------------------------------------------------------------
-- Resources/Game/Effects/IronWill/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

local IronWill = Class(PrayerCombatEffect)

IronWill.MIN_LEVEL = 20
IronWill.MAX_LEVEL = 70
IronWill.MIN_BOOST = 0.2
IronWill.MAX_BOOST = 0.3
IronWill.DEBUFF    = 0.5

function IronWill:new()
	PrayerCombatEffect.new(self)
end

function IronWill:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function IronWill:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function IronWill:applySelfToAttack(roll)
	roll:setMaxAttackRoll(math.floor(roll:getMaxAttackRoll() * (1 + self:getBoost())))
end

function IronWill:applySelfToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self:getBoost())))
end

function IronWill:applyTargetToAttack(roll)
	roll:setMaxDefenseRoll(math.floor(roll:getMaxDefenseRoll() * self.DEBUFF))
end

function IronWill:applyTargetToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.DEBUFF)))
end

return IronWill
