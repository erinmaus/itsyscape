--------------------------------------------------------------------------------
-- ItsyScape/Peep/Command.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Command = Class()

function Command:new()
	-- Nothing.
end

-- Returns a boolean indicating if the command can be interrupted (true) or not
-- (false).
--
-- An un-interruptible command (false value) will continue running until
-- Command.getIsFinished returns true.
function Command:getIsInterruptible()
	return true
end

-- Returns a boolean indicating if the command is blocking (true) or not (false).
--
-- If a command is blocking, then no commands can be queued after. See
-- CommandQueue.push.
function Command:getIsBlocking()
	return false
end

-- Returns true if the command has completed, false otherwise.
--
-- Once a command is completed, the next in the queue is executed.
function Command:getIsFinished()
	return true
end

-- Returns true if the command is pending, false otherwise.
--
-- This method is implemented in terms of getIsFinished. Override getIsFinished
-- instead.
function Command:getIsPending()
	return not self:getIsFinished()
end

-- Begins the command.
--
-- Called before the command is first updated.
function Command:onBegin(peep)
	-- Nothing.
end

-- Ends the command.
--
-- Called after the command is last updated.
function Command:onEnd(peep)
	-- Nothing.
end

-- Interrupts the command.
--
-- Called when the command is interrupted.
--
-- If interrupted, there will be no corresponding call to Command.onEnd. Thus,
-- onInterrupt should call onEnd if necessary (e.g., there is common ending
-- logic).
--
-- Even un-interruptible commands should handle this event gracefully. In
-- essence, after this method is called, the Peep should be in a consistent idle
-- state (assuming no other commands are in the queue).
function Command:onInterrupt(peep)
	-- Nothing.
end

-- Updates the command.
--
-- See CommandQueue.update.
function Command:update(delta, peep)
	-- Nothing.
end

return Command
