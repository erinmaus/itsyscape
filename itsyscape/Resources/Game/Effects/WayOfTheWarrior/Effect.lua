--------------------------------------------------------------------------------
-- Resources/Game/Effects/WayOfTheWarrior/Effect.lua
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

local WayOfTheWarrior = Class(PrayerCombatEffect)

function WayOfTheWarrior:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function WayOfTheWarrior:getDescription()
	return "10%"
end

function WayOfTheWarrior:applySelfToAttack(roll)
	roll:setAccuracyBonus(roll:getAccuracyBonus() * 1.1)
	roll:setAttackLevel(roll:getAttackLevel() * 1.1)
end

function WayOfTheWarrior:applySelfToDamage(roll)
	roll:setBonus(roll:getBonus() * 1.1)
	roll:setLevel(roll:getLevel() * 1.1)
end

return WayOfTheWarrior
