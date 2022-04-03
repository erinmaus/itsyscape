--------------------------------------------------------------------------------
-- ItsyScape/Peep/WaitCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"
local CommandQueue = require "ItsyScape.Peep.CommandQueue"

local WaitCommand = Class(Command)

-- Constructs a new wait command.
--
-- A wait command waits for 'duration' seconds.
--
-- 'interruptible' controls if the command can be interrupted. It defaults to
-- true.
function WaitCommand:new(duration, interruptible, relative)
	if relative ~= nil and not relative then
		duration = duration - love.timer.getTime()
	end

	self.duration = duration
	print('duration', self.duration)
	self.currentDuration = 0

	if interruptible == nil then
		self.interruptible = true
	else
		if interruptible then
			self.interruptible = true
		else
			self.interruptible = false
		end
	end
end

function WaitCommand:getIsInterruptible()
	return self.interruptible
end

function WaitCommand:getIsFinished()
	return self.currentDuration >= self.duration
end

function WaitCommand:onBegin(peep)
	self.currentDuration = 0
end

function WaitCommand:onEnd(peep)
	-- Nothing.
end

function WaitCommand:onInterrupt(peep)
	-- Nothing.
end

function WaitCommand:update(delta)
	self.currentDuration = self.currentDuration + delta
end

return WaitCommand
