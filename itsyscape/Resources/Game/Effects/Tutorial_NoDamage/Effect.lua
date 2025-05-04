--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tutorial_NoDamage/Effect.lua
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
local CombatEffect = require "ItsyScape.Peep.Effects.CombatEffect"

-- Prevents dealing damage.
local NoDamage = Class(CombatEffect)

function NoDamage:new(activator)
	CombatEffect.new(self)
end

function NoDamage:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function NoDamage:applySelfToDamage(roll)
	roll:setDamageMultiplier(0)
end

return NoDamage
