--------------------------------------------------------------------------------
-- Resources/Game/Effects/GammonsGrace/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

-- Prevents damage from all archery attacks.
local GammonsGrace = Class(PrayerCombatEffect)
GammonsGrace.MIN_LEVEL = 45
GammonsGrace.MAX_LEVEL = 99
GammonsGrace.MIN_BOOST = 0.25
GammonsGrace.MAX_BOOST = 0.50

function GammonsGrace:new(activator)
	PrayerCombatEffect.new(self)
end

function GammonsGrace:enchant(peep)
	PrayerCombatEffect.enchant(self, peep)

	for effect in peep:getEffects(require "Resources.Game.Effects.PrisiumsProtection.Effect") do
		peep:removeEffect(effect)
	end

	for effect in peep:getEffects(require "Resources.Game.Effects.BastielsBarricade.Effect") do
		peep:removeEffect(effect)
	end
end

function GammonsGrace:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function GammonsGrace:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function GammonsGrace:applyTargetToDamage(roll)
	if roll:getStyle() == Weapon.STYLE_MELEE then
		roll:setMinHit(math.max(math.floor(roll:getMinHit() * (1 - self:getBoost()))), 1)
		roll:setMaxHit(math.max(math.floor(roll:getMaxHit() * (1 - self:getBoost()))), 1)
	end
end

return GammonsGrace
