--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/IsCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local IsCombatTarget = B.Node("IsCombatTarget")
IsCombatTarget.PEEP = B.Reference()
IsCombatTarget.TARGET = B.Reference()

function IsCombatTarget:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local target = state[self.TARGET]
	if not target then
		return B.Status.Failure
	end

	local peepTarget = peep:getBehavior(CombatTargetBehavior)
	peepTarget = peepTarget and peepTarget.actor
	peepTarget = peepTarget and peepTarget:getPeep()

	if peepTarget == target then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsCombatTarget
