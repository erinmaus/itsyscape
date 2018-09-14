--------------------------------------------------------------------------------
-- ItsyScape/Game/Dialog/Executor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MirrorSandbox = require "ItsyScape.Common.MirrorSandbox"
local Message = require "ItsyScape.Game.Dialog.Message"

local Executor = Class()
function Executor.input(g)
	return function(t)
		return coroutine.yield('input', Message(t, g))
	end
end

function Executor.message(g)
	return function(t)
		local message = Message(t, g)
		return coroutine.yield('message', { message })
	end
end

function Executor.option(g)
	return function(t)
		return Message(t, g)
	end
end

function Executor.select(g)
	return function(t)
		local m = {}
		for i = 1, #t do
			m[i] = t[i]
		end

		return coroutine.yield('select', m)
	end
end

function Executor.speaker(g)
	return function(t)
		return coroutine.yield('speaker', t)
	end
end

function Executor:new(chunk)
	self.g, self.sandbox = MirrorSandbox()
	self.chunk = setfenv(chunk, self.g)
	self.logic = coroutine.create(self.chunk)

	self.sandbox.Utility = require "ItsyScape.Game.Utility"
	self.sandbox.xselect = select
	self.sandbox.input = Executor.input(self.g)
	self.sandbox.message = Executor.message(self.g)
	self.sandbox.option = Executor.option(self.g)
	self.sandbox.select = Executor.select(self.g)
	self.sandbox.speaker = Executor.speaker(self.g)
end

function Executor:getG()
	return self.g
end

function Executor:getS()
	return self.s
end

function Executor:step(...)
	return coroutine.resume(self.logic, ...)
end

return Executor
