--------------------------------------------------------------------------------
-- ItsyScape/Peep/CallbackCommand.lua
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

local CallbackCommand = Class(Command)

-- Constructs a new wait command.
--
-- A wait command simply calls a function.
function CallbackCommand:new(func, ...)
	self.func = func
	self.arguments = { n = select('#', ...), ... }
	self.isFinished = false
end

function CallbackCommand:getIsInterruptible()
	return true
end

function CallbackCommand:getIsFinished()
	return self.isFinished
end

function CallbackCommand:onBegin(peep)
	self.func(unpack(self.arguments, 1, self.arguments.n))
	self.isFinished = true
end

return CallbackCommand
