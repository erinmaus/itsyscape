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
function Class.isType(a)
	return Class.getType(a) ~= nil
end

-- Returns the type of a, or nil if a is not a Class instance.
function Class.getType(a)
	a = getmetatable(a)
	if a and a.__c == Class then
		return a.__type
	end

	return nil
end

-- Returns true if a is exactly the type of b, or false otherwise.
function Class.isType(a, b)
	a = getmetatable(a) or {}
	b = getmetatable(b) or {}
	if a.__c == Class and b.__c == Class then
		if a.__type == b.__type then
			return true
		end
	end

	return false
end

-- Returns true if a is a compatible type to b, or false otherwise.
function Class.isCompatibleType(a, b)
	a = getmetatable(a) or {}
	b = getmetatable(b) or {}
	if a.__c == Class and b.__c == Class then
		local t = a.__type
		while t ~= nil do
			if t == b.__type then
				return true
			else
				t = getmetatable(t).__parent
			end
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
	local Type = { __index = parent or {}, __parent = parent, __c = Class }
	local Class = setmetatable({}, Type)
	local Metatable = { __index = Class, __type = Class }

	function Type.__call(self, ...)
		local result = setmetatable({}, Metatable)
		function result:getType()
			return Class
		end

		function result:isType(type)
			return Class == self:getType()
		end

		function result:isCompatibleType(type)
			local currentType = self:getType()
			while currentType ~= nil do
				if currentType == type then
					return true
				end

				currentType = getmetatable(currentType).__parent
			end

			return false
		end

		if Class.new then
			Class.new(result, ...)
		end

		return result
	end

	return Class, Metatable
end

return setmetatable(Class, { __call = __call })
