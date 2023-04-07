--------------------------------------------------------------------------------
-- Resources/Game/Effects/MetalSkin/Effect.lua
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

local MetalSkin = Class(PrayerCombatEffect)
MetalSkin.MIN_LEVEL = 1
MetalSkin.MAX_LEVEL = 50
MetalSkin.MIN_BOOST = 0.1
MetalSkin.MAX_BOOST = 0.5

function MetalSkin:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function MetalSkin:getDescription()
	return string.format("%d%%", (self:getBoost() * 100))
end

function MetalSkin:applyTargetToAttack(roll)
	local boost = self:getBoost()

	roll:setDefenseBonus(roll:getDefenseBonus() * (1 + boost))
	roll:setDefenseLevel(roll:getDefenseLevel() * (1 + boost))
end

return MetalSkin
