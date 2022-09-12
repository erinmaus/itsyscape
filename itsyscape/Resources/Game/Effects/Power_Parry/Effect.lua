--------------------------------------------------------------------------------
-- Resources/Game/Effects/Power_Parry/Effect.lua
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
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

-- Prevents damage from the next melee attack.
local Parry = Class(CombatEffect)
Parry.DURATION = 10

function Parry:new(activator)
	CombatEffect.new(self)
end

function Parry:getBuffType()
	return Effect.BUFF_TYPE_POSITIVE
end

function Parry:applyTargetToDamage(roll)
	local target = self:getPeep():getBehavior(CombatTargetBehavior)
	target = target and target.actor
	if target and target:getPeep() == roll:getSelf() then 
		roll:setMaxHit(0)
		roll:setMinHit(0)

		self:getPeep():removeEffect(self)
	end
end

return Parry
