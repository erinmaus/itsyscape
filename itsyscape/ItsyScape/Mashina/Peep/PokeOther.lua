--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PokeOther.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local PokeOther = B.Node("PokeOther")
PokeOther.PEEP = B.Reference()
PokeOther.EVENT = B.Reference()
PokeOther.POKE = B.Reference()
PokeOther.ARGS = B.Reference()
PokeOther.TIME = B.Reference()

function PokeOther:update(mashina, state, executor)
	local peep = state[self.PEEP]
	local event = state[self.EVENT]
	local poke = state[self.POKE]
	local args = state[self.ARGS]
	local time = state[self.TIME]

	if not peep then
		return B.Status.Failure
	end

	if event then
		if type(poke) == 'function' then
			poke = poke(peep, state, executor)
		end

		if type(args) == 'function' then
			args = { args(peep, state, executor) }
		end

		local a
		if args then
			if poke then
				a = { poke, unpack(args, 1, table.maxn(args)) }
			else
				a = args or {}
			end
		else
			a = { poke }
		end

		if time then
			peep:pushPoke(time, event, unpack(a, 1, table.maxn(a)))
		else
			peep:poke(event, unpack(a, 1, table.maxn(a)))
		end

		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return PokeOther
