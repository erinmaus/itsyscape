--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Hit.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Hit = B.Node("Hit")
Hit.PEEP = B.Reference()
Hit.AGGRESSOR = B.Reference()
Hit.DAMAGE = B.Reference()

function Hit:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local damage = state[self.DAMAGE] or 0
	local zealous = state[self.ZEALOUS] or false

	local status = peep:getBehavior(CombatStatusBehavior)
	if status and damage >= 1 then
		peep:poke("hit", AttackPoke({
			damage = damage,
			aggressor = state[self.AGGRESSOR]
		}))

		return B.Status.Success
	end

	return B.Status.Failure
end

return Hit
