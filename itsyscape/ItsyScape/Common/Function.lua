--------------------------------------------------------------------------------
-- ItsyScape/Common/Function.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Function, Metatable = Class()

function Function:new(func, ...)
	self.func = func
	self.n = select("#", ...)
	self.args = { ... }
end

function Function:rebind(func, ...)
	self.func = func

	self.n = select("#", ...)
	for i = 1, self.n do
		self.args[i] = select(i, ...)
	end
end

local function _coroutine(func, ...)
	if coroutine.running() then
		coroutine.yield()
	end

	return func(...)
end

function Function:coroutine(...)
	local c = coroutine.create(_coroutine)
	coroutine.resume(c, self, ...)

	return c
end

function Metatable:__call(...)
	local n = select("#", ...)
	for i = 1, n do
		self.args[i + self.n] = select(i, ...)
	end
	return self.func(unpack(self.args, 1, self.n + n))
end

return Function
