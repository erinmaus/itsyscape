--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/HasCombatTarget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"

local HasCombatTarget = B.Node("HasCombatTarget")
HasCombatTarget.PEEP = B.Reference()
HasCombatTarget.TARGET = B.Reference()

function HasCombatTarget:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local peepTarget = peep:getBehavior(CombatTargetBehavior)
	peepTarget = peepTarget and peepTarget.actor
	peepTarget = peepTarget and peepTarget:getPeep()

	if peepTarget then
		state[self.TARGET] = peepTarget
		return B.Status.Success
	end

	state[self.TARGET] = nil
	return B.Status.Failure
end

return HasCombatTarget
