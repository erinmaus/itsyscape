--------------------------------------------------------------------------------
-- Resources/Game/Effects/PathOfLight/Effect.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

local PathOfLight = Class(PrayerCombatEffect)
PathOfLight.MIN_LEVEL = 35
PathOfLight.MAX_LEVEL = 55
PathOfLight.MIN_BOOST = 0.1
PathOfLight.MAX_BOOST = 0.1

function PathOfLight:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function PathOfLight:enchant(peep)
	PrayerCombatEffect.enchant(self, peep)

	self._onInitiateAttack = function(_, attack, target)
		local damage = attack:getDamage()
		local prayerPointsDamage = math.floor(damage * self:getBoost() + 0.5)

		local status = peep:getBehavior(CombatStatusBehavior)
		if status then
			status.currentPrayer = math.min(status.currentPrayer + prayerPointsDamage, math.max(status.maximumPrayer, status.currentPrayer))
		end
	end

	peep:listen('initiateAttack', self._onInitiateAttack)
end

function PathOfLight:sizzle()
	self:getPeep():silence('initiateAttack', self._onInitiateAttack)

	PrayerCombatEffect.sizzle(self)
end

return PathOfLight
