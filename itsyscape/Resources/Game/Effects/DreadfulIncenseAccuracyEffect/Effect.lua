--------------------------------------------------------------------------------
-- Resources/Game/Effects/DreadfulIncenseAccuracyEffect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Increases the accuracy by roughly 50%, additive, for both the attacker vs
-- opponent and opponent vs attacker.
--
-- In actuality, it increases the accuracy roll by half of the defense roll for
-- both parties.
local DreadfulIncenseCombatEffect = Class(CombatEffect)
DreadfulIncenseCombatEffect.DURATION = 90

function DreadfulIncenseCombatEffect:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function DreadfulIncenseCombatEffect:applySelfToAttack(roll)
	local accuracyRoll = roll:getMaxAttackRoll()
	local defenseRoll = roll:getMaxDefenseRoll()
	local newAccuracyRoll = accuracyRoll + defenseRoll / 2

	roll:setMaxAttackRoll(newAccuracyRoll)
end

function DreadfulIncenseCombatEffect:applyTargetToAttack(roll)
	local accuracyRoll = roll:getMaxAttackRoll()
	local defenseRoll = roll:getMaxDefenseRoll()
	local newAccuracyRoll = accuracyRoll + defenseRoll / 2

	roll:setMaxAttackRoll(newAccuracyRoll)
end

return DreadfulIncenseCombatEffect
