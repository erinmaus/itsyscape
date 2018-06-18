--------------------------------------------------------------------------------
-- ItsyScape/Peep/CommandQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

-- Command queue implementation.
--
-- A command queue handles executing logical commands that affect a single Peep.
--
-- For example, walking is a Command, as are attacking, making items, and so on.
--
-- For complex Commands, ideally one should use a CompositeCommand. This creates
-- sub-queues.
local CommandQueue = Class()

-- Constructs a new CommandQueue for 'peep'.
function CommandQueue:new(peep)
	assert(peep, "peep cannot be nil, aaah")

	self.peep = peep
	self.queue = {}
	self.lastCommand = false
end

-- Gets the Peep this queue belongs to.
function CommandQueue:getPeep()
	return self.peep
end

-- Returns true if the queue is empty, false otherwise.
function CommandQueue:getIsEmpty()
	return #self.queue == 0
end

-- Returns true if the queue has pending commands, false otherwise.
function CommandQueue:getIsPending()
	return #self.queue > 0
end

-- Gets the current command in the queue.
function CommandQueue:getCurrent()
	return self.queue[1]
end

-- Pushes 'command' unto the queue.
--
-- If the current command is blocking, nothing happens and this method returns
-- false. Otherwise, pushes the command unto the queue and returns true.
--
-- If 'clear' is true, and there are other pending commands, these other pending
-- commands are cleared.
function CommandQueue:push(command, clear)
	if self:getIsPending() then
		local currentCommand = self.queue[1]
		if currentCommand:getIsBlocking() then
			return false
		end

		if clear then
			self:flush()
		end
	end

	table.insert(self.queue, command)
	return true
end

-- Interrupts the current command with the new 'command'.
--
-- If the current command is un-interruptible, nothing happens and this method
-- returns false. Otherwise, interrupts the current command and returns true.
--
-- Clears all pending commands if successful.
--
-- Returns true if the request was successful, false otherwise.
function CommandQueue:interrupt(command)
	if self:getIsPending() then
		local currentCommand = self.queue[1]
		if not currentCommand:getIsInterruptible() then
			return false
		end

		currentCommand:onInterrupt(self.peep)
	end

	self.queue = { command }
	return true
end

-- Tries to interrupt the current command, and failing that, pushes the command.
--
-- 'clear' corresponds to 'clear' in CommandQueue.push.
--
-- Returns true if either action was successful, false otherwise.
function CommandQueue:interruptOrPush(command, clear)
	return self:interrupt(command) or self:push(command, clear)
end

-- Flushes all pending commands.
--
-- The current command is not touched.
--
-- The pending commands are not executed.
function CommandQueue:flush()
	while #self.queue > 1 do
		table.remove(self.queue, #self.queue)
	end
end

-- Flushes all pending events and interrupts the current command.
--
-- Returns true if the current command, if any, could be interrupted, false
-- otherwise.
function CommandQueue:clear()
	self:flush()

	if self:getIsPending() then
		local currentCommand = self.queue[1]
		if not currentCommand:getIsInterruptible() then
			return false
		end

		currentCommand:onInterrupt(self.peep)
		
		self.queue = {}
	end
end

-- Updates the command queue.
--
-- 'delta' is the time, in seconds, since last update. This should be 1 / TICKS,
-- where TICKS is the number of ticks per second. Game ticks are constant;
-- see ItsyScape.Game.Model.Game.getTicks and ItsyScape.Game.Model.Game.getDelta.
function CommandQueue:update(delta)
	if self:getIsPending() then
		-- Execute as many commands as possible.
		--
		-- Imagine it in the context of [R...E]: if you click on X herbs in one
		-- tick, you'll clean all X herbs (where X is >= 1) in that tick. (Aside:
		-- there is some upper limit to [R...E] to the number of actions that can
		-- be performed on one tick).
		--
		-- For most commands, there is some wait. For example, picking up an
		-- item: the player has to walk to the tile (unknown time), then pick up
		-- the item (instant). However, if the player is on the tile and picks
		-- up multiple items in the same tick, then all items should be picked
		-- up.
		local currentCommand
		repeat
			currentCommand = self.queue[1]
			if currentCommand ~= self.lastCommand then
				self.lastCommand = currentCommand

				if currentCommand then
					currentCommand:onBegin(self.peep)
				end
			end

			if currentCommand then
				currentCommand:update(delta, self.peep)

				if currentCommand:getIsFinished() then
					-- Handle the case where the current command switches to
					-- blocking from non-blocking.
					--
					-- This can happen with a CompositeCommand.
					if currentCommand:getIsBlocking() then
						self:flush()
					end

					currentCommand:onEnd(self.peep)
					table.remove(self.queue, 1)
				end
			end
		until currentCommand == nil or currentCommand:getIsPending()
	end
end

return CommandQueue
