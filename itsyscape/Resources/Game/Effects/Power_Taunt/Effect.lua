--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Taunt/Power.lua
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

-- Halves the accuracy of the opponent, while increasing their damage by 50%.
local Taunt = Class(CombatEffect)
Taunt.DURATION = 30

function Taunt:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Taunt:applySelfToAttack(roll)
	local accuracyRoll = roll:getMaxAttackRoll()
	local newAccuracyRoll = math.floor(accuracyRoll / 2)

	roll:setMaxAttackRoll(newAccuracyRoll)
end

function Taunt:applySelfToDamage(roll)
	roll:setMaxHit(math.floor(roll:getMaxHit() * 1.5 + 0.5))
end

return Taunt
