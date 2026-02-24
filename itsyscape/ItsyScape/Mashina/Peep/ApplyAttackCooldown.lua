--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/ApplyAttackCooldown.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Weapon = require "ItsyScape.Game.Weapon"
local Utility = require "ItsyScape.Game.Utility"
local AttackCooldownBehavior = require "ItsyScape.Peep.Behaviors.AttackCooldownBehavior"

local ApplyAttackCooldown = B.Node("ApplyAttackCooldown")
ApplyAttackCooldown.PEEP = B.Reference()

ApplyAttackCooldown.MIN_DURATION = B.Reference()
ApplyAttackCooldown.MAX_DURATION = B.Reference()
ApplyAttackCooldown.DURATION = B.Reference()

-- If true, will clear the cooldown.
-- If false, will ADD the calculated duration.
-- Defaults to false.
ApplyAttackCooldown.RESET = B.Reference()

-- Whether to round the min/max duration (i.e., integers only).
-- If true, will round. If false, duration can be decimal.
-- Defaults to false.
ApplyAttackCooldown.ROUND = B.Reference()

function ApplyAttackCooldown:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local duration = state[self.DURATION]
	if not duration then
		if state[self.MIN_DURATION] and state[self.MAX_DURATION] then
			local min = state[self.MIN_DURATION]
			local max = state[self.MAX_DURATION]

			duration = love.math.random() * (max - min) + min
			if state[self.ROUND] then
				duration = math.floor(duration + 0.5)
			end
		else
			local weapon = Utility.Peep.getEquippedWeapon(peep, true) or Weapon.UNARMED
			duration = weapon:getCooldown(peep)
		end
	end

	Log.info("Applying %0.2f cool down to '%s'.", duration, peep:getName())

	local cooldown = peep:getBehavior(AttackCooldownBehavior)
	if not cooldown then
		peep:addBehavior(AttackCooldownBehavior)

		cooldown = peep:getBehavior(AttackCooldownBehavior)
		cooldown.ticks = peep:getDirector():getGameInstance():getCurrentTime()
	elseif state[self.RESET] then
		cooldown.ticks = target:getDirector():getGameInstance():getCurrentTime()
		cooldown.cooldown = 0
	end

	cooldown.cooldown = cooldown.cooldown + duration

	return B.Status.Success
end

return ApplyAttackCooldown
