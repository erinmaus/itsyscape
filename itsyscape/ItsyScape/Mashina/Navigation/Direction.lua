--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/Move.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local Direction = B.Node("Direction")
Direction.PEEP = B.Reference()
Direction.TARGET = B.Reference()
Direction.RESULT = B.Reference()

function Direction:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	local target = state[self.TARGET] or mashina

	if peep == target then
		return B.Status.Failure
	end

	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local targetPosition = Utility.Peep.getAbsolutePosition(target)

	state[self.RESULT] = peepPosition:direction(targetPosition)

	return B.Status.Success
end

return Direction
