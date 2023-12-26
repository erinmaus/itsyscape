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
PokeSelf.TIME = B.Reference()

function PokeSelf:update(mashina, state, executor)
	local event = state[self.EVENT]
	local poke = state[self.POKE]
	local time = state[self.TIME]

	if event then
		if type(poke) == 'function' then
			poke = poke(mashina, state, executor)
		end

		if time then
			mashina:pushPoke(time, event, poke)
		else
			mashina:poke(event, poke)
		end

		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return PokeSelf
