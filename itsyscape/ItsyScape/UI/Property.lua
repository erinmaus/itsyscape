--------------------------------------------------------------------------------
-- ItsyScape/UI/Widget.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Property = Class()

-- A property is something that can be fetched from elsewhere.
--
-- A property is defined as a path. The syntax is pretty forgiving but is
-- something like this:
--
-- table1.table2[{reference}].value
--
-- The data would be in a format like:
-- {
--   table1 = {
--     table2 = {
--       { value = 1 },
--       { value = 2 }
--     }
--   }
-- }
--
-- 'reference' would then be a field in the p table (see Property.get).
function Property:new(path)
	self:fromPath(path or "")
end

-- Internal. Builds a path from the string.
function Property:fromPath(path)
	self.path = {}

	local IDENTIFIER = "(%w[%w%d]*)"
	local ARRAY = "^(%b[])"
	local REF = "%{(%w[%w%d]+)%}"
	local NUMBER = "(%d+)"
	local SEP = "%."

	local i, j = path:find(IDENTIFIER)
	while i and j do
		local key = path:sub(i, j)
		table.insert(self.path, function(t, p)
			return t[key]
		end)

		local remainder = path:sub(j + 1)
		local s, t = remainder:find(ARRAY)
		if s and t then
			local u, v = remainder:find(REF)
			if u and v then
				local ref = remainder:sub(u + 1, v - 1)
				table.insert(self.path, function(t, p)
					local r = p[ref]
					if r then
						return t[r]
					else
						return nil
					end
				end)
			else
				local u2, v2 = remainder:find(NUMBER)
				if u2 and v2 then
					local index = tonumber(remainder:sub(u2, v2))
					table.insert(self.path, function(t, p)
						return t[index]
					end)
				else
					error(string.format("unexpected value at %d", j + 1))
				end
			end
		end
		
		i, j = path:find(IDENTIFIER, j + (t or 0) + 1)
	end
end

-- Gets a value reference by the path from 't', using references from 'p' when
-- necessary. If the value is not found 'd' is returned.
function Property:get(t, p, d)
	p = p or {}

	local current = t
	for i = 1, #self.path do
		current = self.path[i](current, p)

		if current == nil then
			return d
		end
	end

	return current
end

return Property
