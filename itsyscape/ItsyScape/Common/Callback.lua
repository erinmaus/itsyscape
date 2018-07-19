--------------------------------------------------------------------------------
-- ItsyScape/Common/Callback.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Callback type. A callback contains a list of methods to invoke. It offers
-- some extra functionality to smooth things over.
local Callback, Metatable = Class()

Callback.DEFAULT_ERROR_HANDLER = function(message)
	error(message)
end

-- Creates a new, empty Callback.
function Callback:new()
	self.handlers = {}
	self.errorHandler = Callback.DEFAULT_ERROR_HANDLER
	self.yield = false
	self.index = 1
end

-- Invokes the handler.
--
-- All arguments passed to this method (sans the self parameter) are also passed
-- to the handlers.
--
-- There is no guarantee to the order the handlers are called.
--
-- If the yield flag is set, then this method yields the return value of each
-- handler before calling the next. See Callback.setYeld for more.
--
-- If an error occurs when calling a handler, the error handler is invoked. The
-- default error handler simply propagates the error.
function Callback:invoke(...)
	local args = { n = select('#', ...), ... }

	for handler, h in pairs(self.handlers) do
		local function callHandler()
			local prefixArgs = h[1]
			local concatArgs = { n = args.n + prefixArgs.n }
			for i = 1, prefixArgs.n do
				concatArgs[i] = prefixArgs[i]
			end
			for i = 1, args.n do
				concatArgs[i + prefixArgs.n] = args[i]
			end
			return handler(unpack(concatArgs, 1, concatArgs.n))
		end

		local success, result = xpcall(callHandler, debug.traceback)
		if not success then
			local continue = self.errorHandler(result)
			if not continue then
				break
			end
		else
			if self.yield then
				coroutine.yield(result)
			end
		end
	end
end

-- Registers a handler.
--
-- handler is a function that is called when the callback is invoked. Any
-- arguments passed to Callback.invoke are propagated to the handler.
--
-- Any extra arguments are passed to the handler when invoked before the arguments
-- to invoke. In essence, take the extra arguments here as the 'prefix' and the
-- arguments to invoke as 'suffix', thus handler(unpack(prefix), unpack(suffix)).
function Callback:register(handler, ...)
	self.handlers[handler] = { { n = select('#', ...), ... } }
end

-- Unregisters a handler.
function Callback:unregister(handler)
	self.handlers[handler] = nil
end

-- Sets if the callback should yield after invoking a handler.
--
-- The callback will yield after invoking a handler.
--
-- By default, this value is false.
function Callback:setYield(value)
	if value then
		self.yield = true
	else
		self.yield = false
	end
end

-- Gets the yield value. See Callback.setYield.
function Callback:getYield()
	return self.yield
end

-- Gets the error handler.
--
-- The default handler is Callback.DEFAULT_ERROR_HANDLER.
function Callback:getErrorHandler()
	return self.errorHandler or Callback.DEFAULT_ERROR_HANDLER
end

-- Sets the error handler.
--
-- If an error occurs in a handler, func is called with the error message.
--
-- Returns the old error handler.
function Callback:setErrorHandler(func)
	local oldErrorHandler = self.errorHandler or Callback.DEFAULT_ERROR_HANDLER

	if func then
		self.errorHandler = func
	else
		self.errorHandler = Callback.DEFAULT_ERROR_HANDLER
	end

	return oldErrorHandler
end

-- Syntactic sugar for Callback:invoke(...).
--
-- See Callback.invoke for behavior.
function Metatable:__call(...)
	self:invoke(...)
end

return Callback
