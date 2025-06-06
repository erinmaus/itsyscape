--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerStorage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local serpent = require "serpent"
local Class = require "ItsyScape.Common.Class"

local PlayerStorage = Class()
PlayerStorage.Section = Class()

function PlayerStorage.Section:new(name)
	self.name = name
	self.array = {}
	self.values = {}
	self.sections = {}
end

function PlayerStorage.Section:getName()
	return self.name
end

function PlayerStorage.Section:length()
	return #self.array
end

function PlayerStorage.Section:getSection(key)
	if type(key) == 'number' then
		if key < 1 or key > self:length() then
			key = self:length() + 1
		end
	end

	assert(type(key) == 'string' or type(key) == 'number', "key must be string or number")

	if self.values[key] then
		error("value already exists with given key")
	end

	local section = self.sections[key]
	if not section then
		section = PlayerStorage.Section(key)
		self.sections[key] = section

		if type(key) == 'number' then
			self.array[key] = section
		end
	end

	return section
end

function PlayerStorage.Section:hasSection(key)
	return self.sections[key] ~= nil
end

function PlayerStorage.Section:unset(key)
	self:removeSection(key)

	if self.values[key] then
		self.values[key] = nil
	end
end

function PlayerStorage.Section:removeSection(key)
	if type(key) == 'number' then
		table.remove(self.array, key)
		table.remove(self.sections, key)
	else
		self.sections[key] = nil
	end
end

function PlayerStorage.Section:reset()
	self.sections = {}
	self.values = {}
	self.array = {}
end

function PlayerStorage.Section:set(key, value)
	if type(key) == 'number' then
		if key < 1 or key > self:length() then
			key = self:length() + 1
		end
	end

	if type(key) == 'table' then
		for i = #key, 1, -1 do
			self:removeSection(key)
		end

		for k, v in pairs(key) do
			if type(k) ~= 'number' and type(v) == 'table' then
				self:removeSection(k)
			end
		end

		for k, v in ipairs(key) do
			self:set(k, v)
		end

		for k, v in pairs(key) do
			if type(k) ~= 'number' then
				self:set(k, v)
			end
		end
	elseif type(value) == 'table' then
		assert(type(key) == 'string' or type(key) == 'number', "key must be string or number")
		local section = self:getSection(key)

		for k, v in ipairs(value) do
			section:set(k, v)
		end

		for k, v in pairs(value) do
			if type(k) ~= 'number' then
				section:set(k, v)
			end
		end
	elseif type(value) == 'string' or
		type(value) == 'number' or
		type(value) == 'nil' or
		type(value) == 'string' or
		type(value) == 'boolean'
	then
		if self.sections[key] then
			if value == nil then
				self.sections[key] = nil
			else
				error("section exists with name")
			end
		end

		if type(key) == 'number' then
			if value == nil then
				local oldLength = self:length()
				table.remove(self.array, key)

				if key == oldLength then
					self.values[oldLength] = nil
				else
					for i = key + 1, oldLength do
						self.values[i - 1] = self.values[i]
					end
				end
			else
				self.values[key] = value
				self.array[key] = value
			end
		else
			self.values[key] = value
		end
	else
		Log.error("can't set key '%s' (type %s) with value '%s' (of type %s)",
			tostring(key), type(key),
			tostring(value), type(value))
	end
end

function PlayerStorage.Section:get(key)
	if key == nil then
		local result = {}
		for key, value in self:iterateValues() do
			result[key] = value
		end

		for key, section in self:iterateSections() do
			result[key] = section:get()
		end

		return result
	else
		return self.sections[key] or self.values[key]
	end
end

function PlayerStorage.Section:hasValue(key)
	return self.values[key] ~= nil
end

function PlayerStorage.Section:iterateValues()
	return pairs(self.values)
end

function PlayerStorage.Section:iterateSections()
	return pairs(self.sections)
end

function PlayerStorage.Section:serialize()
	local result = { values = {}, sections = {} }
	for key, value in self:iterateValues() do
		result.values[key] = value
	end

	for key, section in self:iterateSections() do
		result.sections[key] = section:serialize()
	end

	return result
end

function PlayerStorage.Section:deserialize(t)
	t = t or { values = {}, sections = {} }
	t.values = t.values or {}
	t.sections = t.sections or {}

	for i = 1, #t.values do
		self:set(i, t.values[i])
	end

	for key, value in pairs(t.values or {}) do
		if type(key) ~= 'number' then
			self:set(key, value)
		end
	end

	for key, value in pairs(t.sections or {}) do
		local section = self:getSection(key)
		section:deserialize(value)
	end
end

function PlayerStorage.Section:toString()
	return serpent.block(self:serialize(), { comment = false })
end

function PlayerStorage:new()
	self.root = PlayerStorage.Section("root")
end

function PlayerStorage:getRoot()
	return self.root
end

function PlayerStorage:deserialize(t)
	if type(t) == 'string' then
		local r, e = loadstring('return ' .. t)
		if e then
			Log.error("Failed to deserialize player storage: %s", e)
		end

		r, e = pcall(setfenv(r, {}))
		if not r then
			Log.error("Failed to execute player storage: %s", e)
		else
			t = e
		end
	end

	t = t or {}
	self.root = PlayerStorage.Section("root")
	self.root:deserialize(t)
end

function PlayerStorage:serialize()
	return self.root:serialize()
end

function PlayerStorage:toString()
	return serpent.block(self:serialize(), { comment = false })
end

return PlayerStorage
