--------------------------------------------------------------------------------
-- Resources/Game/Effects/PrisiumsWisdom/Effect.lua
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

local PrisiumsWisdom = Class(PrayerCombatEffect)
PrisiumsWisdom.MIN_LEVEL = 40
PrisiumsWisdom.MAX_LEVEL = 60
PrisiumsWisdom.MIN_BOOST = 0.1
PrisiumsWisdom.MAX_BOOST = 0.1

function PrisiumsWisdom:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function PrisiumsWisdom:enchant(peep)
	PrayerCombatEffect.enchant(self, peep)

	self._onInitiateAttack = function(_, attack, target)
		local damage = attack:getDamage()
		local prayerPointsDamage = math.floor(damage * self:getBoost() + 0.5)

		local status = target:getBehavior(CombatStatusBehavior)
		if status then
			status.currentPrayer = math.max(status.currentPrayer - prayerPointsDamage, 0)
		end
	end

	peep:listen('initiateAttack', self._onInitiateAttack)
end

function PrisiumsWisdom:sizzle()
	self:getPeep():silence('initiateAttack', self._onInitiateAttack)

	PrayerCombatEffect.sizzle(self)
end

return PrisiumsWisdom
