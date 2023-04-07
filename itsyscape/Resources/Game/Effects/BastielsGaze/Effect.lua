--------------------------------------------------------------------------------
-- Resources/Game/Effects/BastielsGaze/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Weapon = require "ItsyScape.Game.Weapon"
local Effect = require "ItsyScape.Peep.Effect"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

local BastielsGaze = Class(PrayerCombatEffect)

BastielsGaze.MIN_LEVEL = 30
BastielsGaze.MAX_LEVEL = 60
BastielsGaze.MIN_BOOST = 0.1
BastielsGaze.MAX_BOOST = 0.2

function BastielsGaze:new()
	PrayerCombatEffect.new(self)
end

function BastielsGaze:getDescription()
	return string.format("%d%%", self:getBoost() * 100)
end

function BastielsGaze:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function BastielsGaze:applyToSelfWeaponCooldown(peep, cooldown)
	return cooldown * (1 - self:getBoost())
end

return BastielsGaze
