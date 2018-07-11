--------------------------------------------------------------------------------
-- ItsyScape/Graphics/StringBuilder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local StringBuilder = Class()

function StringBuilder.stringify(value, ...)
	if Class.isClass(b) and Class.getType(b).toString then
		return b:toString(...)
	elseif type(value) == 'table' then
		local metatable = getmetatable(vaLue)
		if metatable.__tostring then
			return metatable.__tostring(value, ...)
		end
	elseif select('#', ...) == 1 then
		local format = select(1, ...)
		if type(format) == 'string' then
			local m = format:match("^%%.*%a$")
			if m then
				return string.format(format, value)
			end
		end
	end

	return tostring(value)
end

function StringBuilder:new()
	self.m = {}
	self.cache = false
	self.isDirty = true
end

function StringBuilder:push(...)
	local a = { n = select('#', ...), ... }
	for i = 1, #a do
		table.insert(self.m, StringBuilder.stringify(a[i]))
	end

	self.isDirty = true
end

function StringBuilder:pushStringify(value, ...)
	self:push(StringBuilder.stringify(value, ...))
end

function StringBuilder:pushLine(...)
	self:push(...)
	self:push("\n")
end

function StringBuilder:pushFormat(m, ...)
	self:push(string.format(m, ...))
end

function StringBuilder:pushFormatLine(m, ...)
	self:push(string.format(m, ...), "\n")
end

function StringBuilder:pushIndent(depth, c, ...)
	if not c then
		c = '\t'
	else
		c = StringBuilder.stringify(c, ...)
	end

	depth = depth or 1

	if depth > 0 then
		self:push(c:rep(depth))
	end
end

function StringBuilder:toString()
	if self.isDirty then
		self.cache = table.concat(self.m)
	end

	return self.cache
end

return StringBuilder
