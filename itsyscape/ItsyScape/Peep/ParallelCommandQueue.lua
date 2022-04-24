--------------------------------------------------------------------------------
-- ItsyScape/Peep/ParallelCommandQueue.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local CommandQueue = require "ItsyScape.Peep.CommandQueue"

local ParallelCommandQueue = Class(CommandQueue)

function ParallelCommandQueue:push(command, clear)
	CommandQueue.push(self, command, clear)
	command:onBegin(self:getPeep())
end

function ParallelCommandQueue:interrupt(command)
	CommandQueue.interrupt(self, command)
	command:onBegin(self:getPeep())
end

function ParallelCommandQueue:update(delta)
	local completed = {}
	for i = 1, #self.queue do
		local command = self.queue[i]

		command:update(delta, self:getPeep())
		if command:getIsFinished() then
			command:onEnd(self:getPeep())
			table.insert(completed, command)
		end
	end

	for i = 1, #completed do
		for j = 1, #self.queue do
			if self.queue[j] == completed[i] then
				table.remove(self.queue, j)
				break
			end
		end
	end
end

return ParallelCommandQueue
