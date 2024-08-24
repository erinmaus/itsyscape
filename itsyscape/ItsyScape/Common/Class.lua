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

function Class.hasInterface(a, b)
	return Class.isClass(a) and not not Class.getType(a)._INTERFACES[b]
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

local function getType(self)
	return Class.getType(self)
end

local function isType(self, type)
	return self:getType() == type
end

local function isCompatibleType(self, type)
	return Class.isCompatibleType(self, type)
end

local function getDebugInfo(self)
	return self:getType()._DEBUG
end

local function __index(self, key)
	return self.__fields[key]
end

local function __newindex(self, key, value)
	if Class.hasInterface(value, Class.IPooled) then
		if not value:getIsPooled() then
			self.__fields[key] = value
		elseif currentValue and Class.isType(currentValue, Class.getType(value)) then
			self.__fields[key] = value:keep(currentValue)
		else
			self.__fields[key] = value:keep()
		end
	else
		self.__fields[key] = value
	end
end

local Common = {
	getType = getType,
	isType = isType,
	isCompatibleType = isCompatibleType,
	getDebugInfo = getDebugInfo
}

-- Creates a class, optionally from a parent.
--
-- To add a property or method to the class, add add the property or method to
-- the returned class definition. Same for overriding properties or methods.
--
-- Returns the class definition and the metatable.
local function __call(self, parent, stack, ...)
	local C = Class

	local Type = { __index = parent or Common, __parent = parent, __c = C }
	local Class = setmetatable({}, Type)
	local SelfMetatable = { __index = Class }
	local Metatable = { __index = __index, __newindex = __newindex, __type = Class }
	Class._METATABLE = Metatable
	Class._PARENT = parent or false
	Class._DEBUG = {}
	Class._INTERFACES = {}

	if parent then
		Class._INTERFACES[parent] = true
	end

	if type(stack) == "table" then
		Class._INTERFACES[stack] = true
		stack = nil
	end

	for i = 1, select("#", ...) do
		Class._INTERFACES[select(i, ...)] = true
	end

	do
		local debug = require "debug"
		local log = require "ItsyScape.Common.Log" -- Class has higher priority than Log so the Log global might not be available

		local info = debug.getinfo(2 + (stack or 0), "Sl")
		if info then
			local shortClassName = info.source:match("^.*/(.*/.*).lua$") or info.source
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
		local result = setmetatable({ __fields = setmetatable({}, SelfMetatable) }, Metatable)

		if Class.new then
			Class.new(result, ...)
		end

		return result
	end

	return Class, Metatable
end

Class = setmetatable(Class, { __call = __call })

Class.IPooled = Class()

function Class.IPooled:keep(other)
	return Class.ABSTRACT()
end

function Class.IPooled:getIsPooled()
	return Class.ABSTRACT()
end

Class.Table = Class()

function Class.Table._METATABLE:__pairs()
	return pairs(self.__fields)
end

function Class.Table._METATABLE:__ipairs()
	return ipairs(self.__fields)
end

return Class
