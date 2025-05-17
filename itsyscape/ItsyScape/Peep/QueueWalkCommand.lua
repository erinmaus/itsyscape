--------------------------------------------------------------------------------
-- ItsyScape/Peep/QueueWalkCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Command = require "ItsyScape.Peep.Command"

local QueueWalkCommand = Class(Command)

function QueueWalkCommand:new(callback, n, interruptible)
    self.callback = callback
    self.n = n

    self.callback:register(self._onFinish, self)
    self.isDone = false

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

function QueueWalkCommand:_onFinish()
    self.isDone = true
end

function QueueWalkCommand:getIsInterruptible()
	return self.interruptible
end

function QueueWalkCommand:getIsFinished()
    return self.isDone
end

function QueueWalkCommand:onBegin()
	self.currentDuration = 0
end

function QueueWalkCommand:onEnd()
	Log.info("Took %.2f ms to calculate walk.", self.currentDuration * 1000)
end

function QueueWalkCommand:onInterrupt()
	Utility.Peep.cancelWalk(self.n)
end

function QueueWalkCommand:update(delta)
	self.currentDuration = self.currentDuration + delta
end

return QueueWalkCommand
