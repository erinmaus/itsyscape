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
		local metatable = getmetatable(value)
		if metatable and metatable.__tostring then
			return metatable.__tostring(value, ...)
		elseif select('#', ...) == 1 then
			local format = select(1, ...)
			if type(format) == 'string' and format == '%t' then
				return StringBuilder.stringifyTable(value)
			end
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

local function isTableArray(t)
	local numIndices = 0
	local n = {}
	for index in pairs(t) do
		if type(index) == 'number' then
			n[index] = true
			numIndices = numIndices + 1
		end
	end

	return #n == numIndices and #n > 0
end

local function isTableStructure(t)
	for key in pairs(t) do
		if type(key) == 'string' then
			local match = key:match("^([%w_][%w%d_]*)$")
			if not match then
				return false
			end
		end
	end

	return true
end

local function isTableEmpty(t)
	return next(t) == nil
end

local function serializeObject(value, isStructure, isArray)
	if type(value) == 'number' then
		if not isArray then
			if value == math.huge then
				return "1 / 0", true
			elseif value == -math.huge then
				return "-(1 / 0)", true
			elseif value ~= value then -- nan (not a number)
				return "0 / 0", true
			elseif value - math.floor(value) > 0 then
				return StringBuilder.stringify(value, "%f"), true
			else
				return StringBuilder.stringify(value, "%d"), true
			end
		end
	elseif type(value) == 'string' then
		if isStructure then
			return value, false
		else
			return StringBuilder.stringify(value, "%q"), true
		end
	elseif type(value) == 'boolean' then
		if value then
			return "true", true
		else
			return "false", true
		end
	elseif type(value) == 'nil' then
		return "nil", true
	elseif type(value) == 'function' then
		return "function() end"
	else
		error(string.format("unhandled type %s", type(value)))
	end
end

function StringBuilder.stringifyTable(t, result, depth, exceptions)
	depth = depth or 0
	result = result or StringBuilder()
	exceptions = exceptions or {}

	exceptions[t] = true

	if isTableEmpty(t) then
		result:push("{}")
	else
		result:pushLine("{")

		local isStructure = isTableStructure(t)
		local isArray = isTableArray(t)
		
		for key, value in pairs(t) do
			local k, explicit = serializeObject(key, isStructure, isArray)
			if k then
				result:pushIndent(depth + 1)

				if explicit then
					result:pushFormat("[%s] =", k)
				else
					result:pushFormat("%s =", k)
				end

				if type(value) == 'table' then
					if exceptions[value] then
						error("recursive table")
					end

					if isTableEmpty(value) then
						result:push(" ", "{}")
					else
						result:pushLine()
						result:pushIndent(depth + 1)
						StringBuilder.stringifyTable(value, result, depth + 1, exceptions)
					end
				else
					result:push(" ")

					local v = serializeObject(value, false, false)
					result:push(v)
				end

				result:pushLine(",")
			end
		end

		if isArray then
			for i = 1, #t do
				local value = t[i]
				result:pushIndent(depth + 1)

				if type(value) == 'table' then
					if exceptions[value] then
						error("recursive table")
					end

					StringBuilder.stringifyTable(value, result, depth + 1, exceptions)
				else
					local v = serializeObject(value, false, false)
					result:push(v)
				end

				result:pushLine(",")
			end
		end

		result:pushIndent(depth)
		result:push("}")
	end

	return result:toString()
end

function StringBuilder:new()
	self.m = {}
	self.cache = false
	self.isDirty = true
end

function StringBuilder:push(...)
	local a = { n = select('#', ...), ... }
	for i = 1, a.n do
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
	if c == nil then
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
		self.isDirty = false
	end

	return self.cache
end

return StringBuilder
