--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_TrickShotDaze/Effect.lua
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

-- Lowers self accuracy and damage roll by a flat 10% for 30 seconds.
local Daze = Class(CombatEffect)
Daze.DURATION = 30

function Daze:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function Daze:applySelfToAttack(roll)
	local attackRoll = roll:getMaxAttackRoll() * 0.9
	roll:setMaxAttackRoll(attackRoll)
end

function Daze:applySelfToDamage(roll)
	roll:setDamageMultiplier(roll:getDamageMultiplier() * 0.9)
end

return Daze
