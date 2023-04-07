--------------------------------------------------------------------------------
-- Resources/Game/Effects/GammonsReckoning/Effect.lua
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

local GammonsReckoning = Class(PrayerCombatEffect)

function GammonsReckoning:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function GammonsReckoning:applySelfToDamage(roll)
	roll:setMinHit(math.floor(roll:getMaxHit() * 0.1 + 0.5))
end

return GammonsReckoning
