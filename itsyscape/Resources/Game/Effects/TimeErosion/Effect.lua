--------------------------------------------------------------------------------
-- Resources/Game/Effects/TimeErosion/Effect.lua
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
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

-- Increases the defense bonuses and defense level by 10%-50%, scaled on
-- Faith level (topping out at 50% at level 50). The boosted Faith level is
-- used, thus if Faith is drained the effect is worse (and if Faith is boosted,
-- the effect is better).
--
-- Only applies to attacks targeting ranged defenses.
local TimeErosion = Class(PrayerCombatEffect)

function TimeErosion:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function TimeErosion:applyTargetToAttack(roll)
	local defenseBonus = roll:getDefenseBonus()
	local defenseBonusType = roll:getDefenseBonusType()
	if defenseBonusType == 'DefenseRanged' then
		local state = roll:getTarget():getState()
		local faithLevel = roll:count("Skill", "Faith", { ['skill-as-level'] = true })
		local scale = math.min(faithLevel, 50) / 50 * 0.4 + 0.1

		roll:setDefenseBonus(defenseBonus * scale)
		roll:setDefenseLevel(roll:getDefenseLevel() * scale)
	end
end

return TimeErosion
