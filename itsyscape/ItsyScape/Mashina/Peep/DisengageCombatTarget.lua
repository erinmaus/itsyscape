--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/DisengageCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local AggressiveBehavior = require "ItsyScape.Peep.Behaviors.AggressiveBehavior"
local CombatCortex = require "ItsyScape.Peep.Cortexes.CombatCortex2"

local DisengageCombatTarget = B.Node("DisengageCombatTarget")
DisengageCombatTarget.CURRENT_TARGET = B.Reference()

function DisengageCombatTarget:update(mashina, state, executor)
	local peep
	do
		local combatTarget = mashina:getBehavior(CombatTargetBehavior)
		peep = combatTarget and combatTarget.actor and combatTarget.actor:getPeep()
	end

	mashina:removeBehavior(CombatTargetBehavior)
	if not mashina:getCommandQueue(CombatCortex.QUEUE):interrupt() then
		return B.Status.Failure
	end

	local aggressive = mashina:getBehavior(AggressiveBehavior)
	if aggressive then
		peep = peep or aggressive.pendingTarget

		aggressive.pendingTarget = false
		aggressive.pendingResponseTime = 0
	end

	if not peep then
		return B.Status.Failure
	end

	state[self.CURRENT_TARGET] = peep
	return B.Status.Success
end

return DisengageCombatTarget
