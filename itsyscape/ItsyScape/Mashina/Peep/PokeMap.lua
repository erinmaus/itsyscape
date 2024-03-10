--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/PokeMap.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"

local PokeMap = B.Node("PokeMap")
PokeMap.MAP = B.Reference()
PokeMap.EVENT = B.Reference()
PokeMap.POKE = B.Reference()
PokeMap.ARGS = B.Reference()
PokeMap.TIME = B.Reference()

function PokeMap:update(mashina, state, executor)
	local event = state[self.EVENT]
	local poke = state[self.POKE]
	local args = state[self.ARGS]
	local time = state[self.TIME]

	local mapScript = state[self.MAP] or Utility.Peep.getMapScript(mashina)

	if mapScript then
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
			mapScript:pushPoke(time, event, unpack(a, 1, table.maxn(a)))
		else
			mapScript:poke(event, unpack(a, 1, table.maxn(a)))
		end

		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return PokeMap
