--------------------------------------------------------------------------------
-- ItsyScape/Common/Class.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = {}
Class.ABSTRACT = function()
	error("method is abstract", 2)
end

-- Returns true if a is a Class instance, false otherwise.
function Class.isClass(a)
	return Class.getType(a) ~= nil
end

-- Returns the type of a, or nil if a is not a Class instance.
function Class.getType(a)
	a = getmetatable(a) or {}
	a = a.__type or {}

	if a and getmetatable(a) and getmetatable(a).__c == Class then
		return a
	end

	return nil
end

-- Returns true if a (the object) is exactly the type of b (a type), or false
-- otherwise.
function Class.isType(a, b)
	a = Class.getType(a)

	if a == b then
		return true
	end

	return false
end

-- Returns true if a (an object) is a compatible type to b (a type), or false
-- otherwise.
function Class.isCompatibleType(a, b)
	a = Class.getType(a)

	local t = a
	while t ~= nil do
		if t == b then
			return true
		else
			t = getmetatable(t).__parent
		end
	end

	return false
end

-- Returns true if a (a type) is derived from b (a type), or is b; returns false
-- otherwise.
function Class.isDerived(a, b)
	local t = a
	while t ~= nil do
		if t == b then
			return true
		else
			t = getmetatable(t).__parent
		end
	end

	return false
end

-- Creates a class, optionally from a parent.
--
-- To add a property or method to the class, add add the property or method to
-- the returned class definition. Same for overriding properties or methods.
--
-- Returns the class definition and the metatable.
local function __call(self, parent)
	local C = Class

	local Type = { __index = parent or {}, __parent = parent, __c = Class }
	local Class = setmetatable({}, Type)
	local Metatable = { __index = Class, __type = Class }
	Class._METATABLE = Metatable
	Class._PARENT = parent or false
	Class._DEBUG = {}

	do
		local debug = require "debug"
		local log = require "ItsyScape.Common.Log" -- Class has higher priority than Log so the Log global might not be available

		local info = debug.getinfo(2, "Sl")
		if info then
			local shortClassName = info.source:match("^.*/(.*).lua$") or info.source
			local lineNumber = info.currentline

			Class._DEBUG.lineNumber = lineNumber
			Class._DEBUG.filename = info.source
			Class._DEBUG.shortName = string.format("%s:%d", shortClassName, lineNumber)

			log.debug("Created class '%s' (%s:%d).", Class._DEBUG.shortName, Class._DEBUG.filename, Class._DEBUG.lineNumber)
		end
	end

	-- Propagate metamethods.
	--
	-- This should only include standard Lua metamethods but oh well.
	if parent then
		for k, v in pairs(parent._METATABLE) do
			if type(k) == 'string' and type(v) == 'function' then
				Metatable[k] = v
			end
		end
	end

	function Type.__call(self, ...)
		local result = setmetatable({}, Metatable)
		function result:getType()
			return Class
		end

		function result:isType(type)
			return self:getType() == type
		end

		function result:isCompatibleType(type)
			return C.isCompatibleType(self, type)
		end

		function result:getDebugInfo()
			return Class._DEBUG
		end

		if Class.new then
			Class.new(result, ...)
		end

		return result
	end

	return Class, Metatable
end

return setmetatable(Class, { __call = __call })
