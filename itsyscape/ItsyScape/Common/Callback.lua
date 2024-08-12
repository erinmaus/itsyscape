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

-- Binds arguments to a function via the callback mechanism and returns it.
function Callback.bind(func, ...)
	local result = Callback(true)
	result:register(func, ...)

	return result
end

-- Creates a new, empty Callback.
function Callback:new(doesReturn)
	self.handlers = {}
	self.doesReturn = doesReturn == nil and true or doesReturn
end

-- local function concatArgs(prefixArgs, postfixArgs)
-- 	local concatArgs = {}

-- 	for i = 1, prefixArgs.n do
-- 		concatArgs[i] = prefixArgs[i]
-- 	end

-- 	for i = 1, postfixArgs.n do
-- 		concatArgs[prefixArgs.n + i] = postfixArgs[i]
-- 	end

-- 	concatArgs.n = prefixArgs.n + postfixArgs.n

-- 	return concatArgs
-- end

-- Invokes the handler.
--
-- All arguments passed to this method (sans the self parameter) are also passed
-- to the handlers.
--
-- There is no guarantee to the order the handlers are called.
function Callback:invoke(...)
	--local postfixArgs = { n = select('#', ...), ... }
	local results = { n = 0 }

	for handler, h in pairs(self.handlers) do
		--local args = concatArgs(h, postfixArgs)

		if self.doesReturn then
			local r = { h(...) }
			local n = table.maxn(r)

			for i = 1, n do
				table.insert(results, r[i])
			end

			results.n = results.n + n
		else
			h(...)
		end
	end

	return unpack(results, 1, results.n)
end

local function make_evil_callback(method, ...)
    if select("#", ...) == 0 then
        return method
    end

    local n = {}
    for i = 1, select("#", ...) do
        table.insert(n, "t" .. tostring(i))
    end

    local args = table.concat(n, ",")
    local evil_func = string.format([[
        return function(func, %s)
            return function(...)
                return func(%s, ...)
            end
        end]], args, args)

    local result = loadstring(evil_func)()
    return result(method, ...)
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
	if handler then
		--self.handlers[handler] = { n = select('#', ...), ... }
		self.handlers[handler] = make_evil_callback(handler, ...)
	end
end

-- Unregisters a handler.
function Callback:unregister(handler)
	if handler then
		self.handlers[handler] = nil
	end
end

-- Syntactic sugar for Callback:invoke(...).
--
-- See Callback.invoke for behavior.
function Metatable:__call(...)
	return self:invoke(...)
end

return Callback
