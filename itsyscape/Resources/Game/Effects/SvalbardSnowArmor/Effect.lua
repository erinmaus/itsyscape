--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_SvalbardSnowArmor/Effect.lua
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
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Lowers damage by 50% for 30 seconds. Can stack.
local SvalbardSnowArmor = Class(CombatEffect)
SvalbardSnowArmor.DURATION = 30

function SvalbardSnowArmor:new(activator)
	CombatEffect.new(self)

	self.damageDebuff = 0.5
end

function SvalbardSnowArmor:getBuffType()
	return Effect.BUFF_TYPE_NEGATIVE
end

function SvalbardSnowArmor:applySelfToDamage(roll)
	roll:setDamageMultiplier(roll:getDamageMultiplier() * 0.5)
end

return SvalbardSnowArmor
