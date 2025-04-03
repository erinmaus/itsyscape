--------------------------------------------------------------------------------
-- Resources/Game/Effects/Tutorial_NoKill/Effect.lua
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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

-- Prevents killing foe.
local NoKill = Class(CombatEffect)

function NoKill:new(activator)
	CombatEffect.new(self)
end

function NoKill:getBuffType()
	return Effect.BUFF_TYPE_NONE
end

function NoKill:applySelfToDamage(roll)
	local target = roll:getTarget()
	local status = target and target:getBehavior(CombatStatusBehavior)
	if status then
		roll:setMinHit(math.min(math.max(status.currentHitpoints - 1, 0), roll:getMinHit() - roll:getMaxHitBoost()))
		roll:setMaxHit(math.min(math.max(status.currentHitpoints - 1, 0), roll:getMaxHit() - roll:getMinHitBoost()))

		if roll:getMaxHit() == 0 then
			roll:setMaxHitBoost(0)
			roll:setMinHitBoost(0)
			roll:setDamageMultiplier(0)
		end
	end
end

return NoKill
