--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Rezz.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Rezz = B.Node("Rezz")
Rezz.PEEP = B.Reference()

function Rezz:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	peep:poke("resurrect")

	local status = peep:getBehavior(CombatStatusBehavior)
	if status and not status.dead then
		status.currentHitpoints = math.max(status.maximumHitpoints, status.currentHitpoints)

		return B.Status.Success
	end

	return B.Status.Failure
end

return Rezz
