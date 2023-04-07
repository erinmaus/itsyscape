--------------------------------------------------------------------------------
-- Resources/Game/Effects/DoubleBladedSword/Effect.lua
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
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

local DoubleBladedSword = Class(CombatEffect)

DoubleBladedSword.MIN_LEVEL = 40
DoubleBladedSword.MAX_LEVEL = 70
DoubleBladedSword.MIN_BOOST = 0.2
DoubleBladedSword.MAX_BOOST = 0.3
DoubleBladedSword.DEBUFF    = 0.5

function DoubleBladedSword:new()
	CombatEffect.new(self)
end

function DoubleBladedSword:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL, self.MAX_LEVEL, self.MIN_BOOST, self.MAX_BOOST)
end

function DoubleBladedSword:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function DoubleBladedSword:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function DoubleBladedSword:applySelfToAttack(roll)
	local stat = roll:getAccuracyStat()
	if stat == "Attack" then
		roll:setMaxAttackRoll(math.floor(roll:getMaxAttackRoll() * (1 + self:getBoost())))
	end
end

function DoubleBladedSword:applySelfToDamage(roll)
	local stat = roll:getDamageStat()
	if stat == "Strength" then
		roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self:getBoost())))
	end
end

function DoubleBladedSword:applyTargetToAttack(roll)
	roll:setMaxDefenseRoll(math.floor(roll:getMaxDefenseRoll() * self.DEBUFF))
end

function DoubleBladedSword:applyTargetToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.DEBUFF)))
end

return DoubleBladedSword
