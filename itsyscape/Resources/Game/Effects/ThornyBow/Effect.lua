--------------------------------------------------------------------------------
-- Resources/Game/Effects/ThornyBow/Effect.lua
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

local ThornyBow = Class(CombatEffect)

ThornyBow.MIN_LEVEL = 40
ThornyBow.MAX_LEVEL = 70
ThornyBow.MIN_BOOST = 0.2
ThornyBow.MAX_BOOST = 0.3
ThornyBow.DEBUFF    = 0.5

function ThornyBow:new()
	CombatEffect.new(self)
end

function ThornyBow:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL, self.MAX_LEVEL, self.MIN_BOOST, self.MAX_BOOST)
end

function ThornyBow:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function ThornyBow:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function ThornyBow:applySelfToAttack(roll)
	local stat = roll:getAccuracyStat()
	if stat == "Archery" then
		roll:setMaxAttackRoll(math.floor(roll:getMaxAttackRoll() * (1 + self:getBoost())))
	end
end

function ThornyBow:applySelfToDamage(roll)
	local stat = roll:getDamageStat()
	if stat == "Dexterity" then
		roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self:getBoost())))
	end
end

function ThornyBow:applyTargetToAttack(roll)
	roll:setMaxDefenseRoll(math.floor(roll:getMaxDefenseRoll() * self.DEBUFF))
end

function ThornyBow:applyTargetToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.DEBUFF)))
end

return ThornyBow
