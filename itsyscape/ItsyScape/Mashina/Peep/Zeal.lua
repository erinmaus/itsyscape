--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Zeal.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local ZealPoke = require "ItsyScape.Game.ZealPoke"
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local Zeal = B.Node("Zeal")
Zeal.PEEP = B.Reference()
Zeal.ZEAL = B.Reference()
Zeal.DIRECT = B.Reference()
Zeal.TYPE = B.Reference()
Zeal.T = B.Reference()

function Zeal:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local zeal = state[self.ZEAL] or 0
	local direct = state[self.DIRECT] or false

	if direct then
		local status = peep:getBehavior(CombatStatusBehavior)
		status.currentZeal = math.min(status.currentZeal + zeal, status.maximumZeal)
	else
		local zealPokeType = state[self.TYPE] or "Strategy"

		local zealPokeT = {}
		for k, v in pairs(state[self.T] or {}) do
			zealPokeT[k] = v
		end
		zealPokeT.zeal = zeal

		local constructor = ZealPoke["on" .. zealPokeType] or ZealPoke[zealPokeType]
		if not constructor then
			return B.Status.Failure
		end

		local event = constructor(zealPokeT)
		peep:poke("zeal", event)
	end

	return B.Status.Success
end

return Zeal
