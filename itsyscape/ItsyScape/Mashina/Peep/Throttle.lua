--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Throttle.lua
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

-- A check used to throttle logic.
local Throttle = B.Node("Throttle")
Throttle.MAX_DURATION = B.Reference()
Throttle.MIN_DURATION = B.Reference()
Throttle.DURATION = B.Reference()

function Throttle:update(mashina, state, executor)
	local start = self._start
	local current = love.timer.getTime()
	
	if start and start > current then
		return B.Status.Failure
	end

	local duration = state[self.DURATION] or love.math.random(
		state[self.MIN_DURATION],
		state[self.MAX_DURATION])
	self._start = love.timer.getTime() + duration

	return B.Status.Success
end

return Throttle
