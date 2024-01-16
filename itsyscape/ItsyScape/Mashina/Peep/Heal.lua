--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Heal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Heal = B.Node("Heal")
Heal.PEEP = B.Reference()
Heal.HITPOINTS = B.Reference()
Heal.ZEALOUS = B.Reference()

function Heal:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local hitpoints = state[self.HITPOINTS] or 0
	local zealous = state[self.ZEALOUS] or false

	local status = peep:getBehavior(CombatStatusBehavior)
	if status and hitpoints >= 1 then
		peep:poke("heal", {
			hitpoints = hitpoints,
			zealous = zealous
		})

		return B.Status.Success
	end

	return B.Status.Failure
end

return Heal
