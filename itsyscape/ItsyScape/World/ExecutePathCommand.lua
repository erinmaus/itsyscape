--------------------------------------------------------------------------------
-- ItsyScape/World/ExecutePathCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"

local ExecutePathCommand = Class(Command)

function ExecutePathCommand:new(path)
	Command.new(self)

	for i = 1, path:getNumNodes() do
		local node = path:getNodeAtIndex(i)
		node.onBegin:register(ExecutePathCommand.next, self)
	end

	self.path = path
	self.index = 1
end

function ExecutePathCommand:getIsFinished()
	return self.index > self.path:getNumNodes()
end

function ExecutePathCommand:next()
	self.index = self.index + 1
end

function ExecutePathCommand:onBegin(peep)
	self.path:activate(peep)
end

function ExecutePathCommand:onInterrupt(peep)
	self.path:getNodeAtIndex(self.index):interrupt(peep)
end

return ExecutePathCommand
