--------------------------------------------------------------------------------
-- Resources/Game/Effects/BastielsBarricade/Effect.lua
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
local BastielsBarricade = Class(PrayerCombatEffect)
BastielsBarricade.MIN_LEVEL = 45
BastielsBarricade.MAX_LEVEL = 99
BastielsBarricade.MIN_BOOST = 0.25
BastielsBarricade.MAX_BOOST = 0.50

function BastielsBarricade:new(activator)
	PrayerCombatEffect.new(self)
end

function BastielsBarricade:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function BastielsBarricade:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function BastielsBarricade:applyTargetToDamage(roll)
	if roll:getStyle() == Weapon.STYLE_ARCHERY then
		roll:setMinHit(math.max(math.floor(roll:getMinHit() * (1 - self:getBoost()))), 1)
		roll:setMaxHit(math.max(math.floor(roll:getMaxHit() * (1 - self:getBoost()))), 1)
	end
end

return BastielsBarricade
