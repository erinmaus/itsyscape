--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/TimeOut.lua
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

local TimeOut = B.Node("TimeOut")
TimeOut.MAX_DURATION = B.Reference()
TimeOut.MIN_DURATION = B.Reference()
TimeOut.DURATION = B.Reference()
TimeOut.CURRENT_TIME = B.Local()
TimeOut.CURRENT_DURATION = B.Local()

function TimeOut:update(mashina, state, executor)
	local start = state[self.CURRENT_TIME]
	local current = love.timer.getTime()
	local difference = current - start
	local duration = state[self.CURRENT_DURATION] or 0
	
	if difference < duration then
		return B.Status.Working
	end

	return B.Status.Success
end

function TimeOut:activated(mashina, state, executor)
	state[self.CURRENT_TIME] = love.timer.getTime()
	state[self.CURRENT_DURATION] = state[self.DURATION] or math.random(
		state[self.MIN_DURATION],
		state[self.MAX_DURATION])
end

function TimeOut:deactivated(mashina, state, executor)
	state[self.CURRENT_TIME] = nil
	state[self.CURRENT_DURATION] = nil
end

return TimeOut
