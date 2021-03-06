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
local Curve = require "ItsyScape.Game.Curve"
local Effect = require "ItsyScape.Peep.Effect"
local PrayerCombatEffect = require "ItsyScape.Peep.Effects.PrayerCombatEffect"

-- Increases minimum ranged damage by 10% of Faith level.
local BastielsGaze = Class(PrayerCombatEffect)

function BastielsGaze:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function BastielsGaze:applySelfToDamage(roll)
	local stat = roll:getDamageStat()
	if stat == "Dexterity" then
		local state = roll:getSelf():getState()
		local faithLevel = state:count("Skill", "Faith", { ['skill-as-level'] = true })
		local scale = math.floor(faithLevel * 0.1 + 0.5)

		roll:setMinHit(scale)
	end
end

return BastielsGaze
