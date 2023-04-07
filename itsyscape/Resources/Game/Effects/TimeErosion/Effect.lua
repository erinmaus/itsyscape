--------------------------------------------------------------------------------
-- Resources/Game/Effects/TimeErosion/Effect.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Effect = require "ItsyScape.Peep.Effect"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

local TimeErosion = Class(PrayerCombatEffect)

function TimeErosion:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function TimeErosion:applyToTargetWeaponCooldown(target, cooldown)
	return cooldown * 1.1
end

return TimeErosion
