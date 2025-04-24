--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/DistanceMoved.lua
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

local DistanceMoved = B.Node("DistanceMoved")
DistanceMoved.PEEP = B.Reference()
DistanceMoved.RESULT = B.Reference()
DistanceMoved.LAST_POSITION = B.Local()
DistanceMoved.CURRENT_DISTANCE = B.Local()

function DistanceMoved:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local lastPosition = state[self.LAST_POSITION] or Utility.Peep.getAbsolutePosition(peep)
	local currentPosition = Utility.Peep.getAbsolutePosition(peep)

	local distance = currentPosition:distance(lastPosition)
	state[self.CURRENT_DISTANCE] = (state[self.CURRENT_DISTANCE] or 0) + distance
	state[self.LAST_POSITION] = currentPosition

	state[self.RESULT] = state[self.CURRENT_DISTANCE]

	return B.Status.Success
end

function DistanceMoved:deactivated(mashina, state)
	state[self.CURRENT_DISTANCE] = nil
	state[self.LAST_POSITION] = nil
end

function DistanceMoved:activated(mashina, state)
	state[self.CURRENT_DISTANCE] = nil
	state[self.LAST_POSITION] = nil
end

return DistanceMoved
