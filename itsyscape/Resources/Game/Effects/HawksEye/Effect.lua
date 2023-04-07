--------------------------------------------------------------------------------
-- Resources/Game/Effects/HawksEye/Effect.lua
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

local HawksEye = Class(PrayerCombatEffect)

function HawksEye:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function HawksEye:applyToSelfWeaponRange(peep, range)
	return range + 1.5
end

return HawksEye
