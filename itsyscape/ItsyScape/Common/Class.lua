--------------------------------------------------------------------------------
-- ItsyScape/Common/Class.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

-- Creates a class, optionally from a parent.
--
-- To add a property or method to the class, add add the property or method to
-- the returned class definition. Same for overriding properties or methods.
--
-- Returns the class definition and the metatable.
local function Class(parent)
	local Type = { __index = parent or {}, __parent = parent }
	local Class = setmetatable({}, Type)
	local Metatable = { __index = Class, __type = Class }

	function Type.__call(...)
		local result = setmetatable({}, Metatable)
		function result:getType()
			return Type
		end

		function result:isType(type)
			return Type == self:getType()
		end

		function result:isCompatibleType(type)
			local currentType = self:getType()
			while currentType ~= nil do
				if currentType == type then
					return true
				end

				currentType = currentType.__parent
			end

			return false
		end

		if Class.new then
			Class.new(result, select(2, ...))
		end

		return result
	end

	return Class, Metatable
end

return Class
