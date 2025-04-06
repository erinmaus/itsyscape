--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/WillAttackFirst.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Config = require "ItsyScape.Game.Config"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local WillAttackFirst = B.Node("WillAttackFirst")
WillAttackFirst.PEEP = B.Reference()
WillAttackFirst.TARGET = B.Reference()
WillAttackFirst.ALLOW_TIE = B.Reference()

function WillAttackFirst:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local target = state[self.TARGET]
	if not target then
		target = peep:getBehavior(CombatTargetBehavior)
		target = target and target.actor
		target = target and target:getPeep()
	end

	if not target then
		return B.Status.Failure
	end

	local allowTie = state[self.ALLOW_TIE]

	local tickDurationSeconds = Config.get("Combat", "TICK_DURATION_SECONDS")

	local peepCooldown = peep:getBehavior(AttackCooldownBehavior)
	peepCooldown = peepCooldown and peepCooldown.cooldown or 0
	peepCooldown = math.floor(peepCooldown / tickDurationSeconds) * tickDurationSeconds

	local targetCooldown = target:getBehavior(AttackCooldownBehavior)
	targetCooldown = targetCooldown and targetCooldown.cooldown or 0
	targetCooldown = math.floor(targetCooldown / tickDurationSeconds) * tickDurationSeconds

	if peepCooldown < targetCooldown or (allowTie and math.abs(peepCooldown - targetCooldown) <= tickDurationSeconds) then
		return B.Status.Success
	end

	return B.Status.Failure
end

return WillAttackFirst
