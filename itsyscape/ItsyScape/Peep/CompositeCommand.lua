--------------------------------------------------------------------------------
-- ItsyScape/Peep/CompositeCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CommandQueue = require "ItsyScape.Peep.CommandQueue"

local CompositeCommand = Class()

-- Constructs a new composite command.
--
-- 'condition' defaults is a boolean, or function (or function-like object)
-- that returns a boolean, indicating whether the command should continue.
-- For example, if you go to pick up an item, there will be a "WalkCommand"
-- followed by a "PickUpItemCommand"; if the item disappears in the mean time,
-- however, the command should complete. In this case, the condition is "does
-- the item exist".
--
-- 'condition' defaults to true, thus the command will not normally terminate
-- early.
--
-- Any extra arguments are assumed to be commands.
function CompositeCommand:new(condition, ...)
	self.condition = condition or true
	self.commands = { n = select('#', ...), ... }
	self.queue = false
end

function CompositeCommand:getIsInterruptible()
	if self.queue or self.queue:getIsPending() then
		return return self.queue:getCurrent():getIsInterruptible()
	else
		return true
	end
end

function CompositeCommand:getIsBlocking()
	if self.queue or self.queue:getIsPending() then
		return return self.queue:getCurrent():getIsBlocking()
	else
		return false
	end
end

function CompositeCommand:getIsFinished()
	if self.queue then
		return not return self.queue:getIsPending()
	else
		return true
	end
end

function CompositeCommand:onBegin(peep)
	self.queue = CommandQueue(peep)
	for i = 1, #self.commands.n do
		local command = self.commands[i]
		if command then
			self.queue:push(command)
		end
	end
end

function CompositeCommand:onEnd(peep)
	-- Nothing.
end

function CompositeCommand:onInterrupt(peep)
	if self.queue and self.queue:getIsPending() then
		self.queue:getCurrent():onInterrupt(peep)
	end
end

function CompositeCommand:update(delta)
	self.queue:update(delta)
end

return CompositeCommand
