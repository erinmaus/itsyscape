--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tutorial_DoubleAccuracy/Effect.lua
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
local DoubleAccuracy = Class(CombatEffect)

function DoubleAccuracy:new(activator)
	CombatEffect.new(self)
end

function DoubleAccuracy:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function DoubleAccuracy:applySelfToAttack(roll)
	roll:setMaxAttackRoll(roll:getMaxAttackRoll() * 2)
end

return DoubleAccuracy
