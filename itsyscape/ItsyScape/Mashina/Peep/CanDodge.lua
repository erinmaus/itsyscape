--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/CanDodge.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local DodgeCooldownBehavior = require "ItsyScape.Peep.Behaviors.DodgeCooldownBehavior"

local CanDodge = B.Node("CanDodge")
CanDodge.PEEP = B.Reference()

function CanDodge:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	if peep:hasBehavior(DodgeCooldownBehavior) then
		return B.Status.Failure
	end

	return B.Status.Success
end

return CanDodge
