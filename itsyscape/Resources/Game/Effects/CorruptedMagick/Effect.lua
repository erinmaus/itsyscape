--------------------------------------------------------------------------------
-- Resources/Game/Effects/CorruptedMagick/Effect.lua
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

local CorruptedMagick = Class(CombatEffect)

CorruptedMagick.MIN_LEVEL = 40
CorruptedMagick.MAX_LEVEL = 70
CorruptedMagick.MIN_BOOST = 0.2
CorruptedMagick.MAX_BOOST = 0.3
CorruptedMagick.DEBUFF    = 0.5

function CorruptedMagick:new()
	CombatEffect.new(self)
end

function CorruptedMagick:getBoost()
	local state = self:getPeep():getState()
	local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
	return Utility.Combat.calcBoost(faithLevel, self.MIN_LEVEL, self.MAX_LEVEL, self.MIN_BOOST, self.MAX_BOOST)
end

function CorruptedMagick:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function CorruptedMagick:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function CorruptedMagick:applySelfToAttack(roll)
	local stat = roll:getAccuracyStat()
	if stat == "Magic" then
		roll:setMaxAttackRoll(math.floor(roll:getMaxAttackRoll() * (1 + self:getBoost())))
	end
end

function CorruptedMagick:applySelfToDamage(roll)
	local stat = roll:getDamageStat()
	if stat == "Wisdom" then
		roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self:getBoost())))
	end
end

function CorruptedMagick:applyTargetToAttack(roll)
	roll:setMaxDefenseRoll(math.floor(roll:getMaxDefenseRoll() * self.DEBUFF))
end

function CorruptedMagick:applyTargetToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * (1 + self.DEBUFF)))
end

return CorruptedMagick
