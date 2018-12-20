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

function PokeSelf:update(mashina, state, executor)
	local event = state[self.EVENT]
	local poke = state[self.POKE]

	if event then
		mashina:poke(event, poke)
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return PokeSelf
