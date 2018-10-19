--------------------------------------------------------------------------------
-- ItsyScape/Game/PlayerStorage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
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

function PlayerStorage.Section:removeSection(key)
	self.sections[key] = nil
end

function PlayerStorage.Section:set(key, value)
	if type(key) == 'number' then
		if key < 1 or key > self:length() then
			key = self:length() + 1
		end
	end

	if type(key) == 'table' then
		for k, v in pairs(key) do
			self:set(k, v)
		end
	elseif type(value) == 'table' then
		assert(type(key) == 'string' or type(key) == 'number', "key must be string or number")
		local section = self:getSection(key)
		for k, v in pairs(value) do
			section:set(k, v)
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
				table.remove(self.array, key)
				self.values[key] = nil
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
	return self.sections[key] or self.values[key]
end

function PlayerStorage.Section:iterateValues()
	return pairs(self.values)
end

function PlayerStorage.Section:iterateSections()
	return pairs(self.sections)
end

function PlayerStorage:new()
	self.root = PlayerStorage.Section("root")
end

function PlayerStorage:getRoot()
	return self.root
end

return PlayerStorage
