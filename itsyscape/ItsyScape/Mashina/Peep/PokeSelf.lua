--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PokeSelf.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local PokeSelf = B.Node("PokeSelf")
PokeSelf.EVENT = B.Reference()
PokeSelf.POKE = B.Reference()
PokeSelf.ARGS = B.Reference()
PokeSelf.TIME = B.Reference()

function PokeSelf:update(mashina, state, executor)
	local event = state[self.EVENT]
	local poke = state[self.POKE]
	local args = state[self.ARGS]
	local time = state[self.TIME]

	if event then
		if type(poke) == 'function' then
			poke = poke(mashina, state, executor)
		end

		if type(args) == 'function' then
			args = { args(mashina, state, executor) }
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
			mashina:pushPoke(time, event, unpack(args, 1, table.maxn(a)))
		else
			mashina:poke(event, unpack(a, 1, table.maxn(a)))
		end

		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return PokeSelf
