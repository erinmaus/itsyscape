--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Interrupt.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local Utility = require "ItsyScape.Game.Utility"

local Interrupt = B.Node("Interrupt")
Interrupt.PEEP = B.Reference()
Interrupt.QUEUE = B.Reference()
Interrupt.EVERYTHING = B.Reference()

function Interrupt:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local everything = state[self.EVERYTHING]
	if everything then
		Utility.Peep.interrupt(peep)
	end

	local q = state[self.QUEUE]
	if peep:getCommandQueue(q):clear() then
		return B.Status.Success
	end

	return B.Status.Failure
end

return Interrupt
