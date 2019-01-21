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
local AccuracyEffect = require "ItsyScape.Peep.Effects.AccuracyEffect"

-- Increases the accuracy by roughly 50%, additive, for both the attacker vs
-- opponent and opponent vs attacker.
--
-- In actuality, it increases the accuracy roll by half of the defense roll for
-- both parties.
local DreadfulIncenseAccuracyEffect = Class(AccuracyEffect)
DreadfulIncenseAccuracyEffect.DURATION = 90

function DreadfulIncenseAccuracyEffect:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function DreadfulIncenseAccuracyEffect:applySelf(roll)
	local accuracyRoll = roll:getMaxAttackRoll()
	local defenseRoll = roll:getMaxDefenseRoll()

	accuracyRoll = accuracyRoll + defenseRoll / 2

	roll:setMaxAttackRoll(accuracyRoll)
end

function DreadfulIncenseAccuracyEffect:applyTarget(roll)
	local accuracyRoll = roll:getMaxAttackRoll()
	local defenseRoll = roll:getMaxDefenseRoll()

	accuracyRoll = accuracyRoll + defenseRoll / 2

	roll:setMaxAttackRoll(accuracyRoll)
end

return DreadfulIncenseAccuracyEffect
