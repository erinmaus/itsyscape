--------------------------------------------------------------------------------
-- ItsyScape/Game/Variables.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local json = require("json")
local Class = require ("ItsyScape.Common.Class")

local function get(targetKey, otherKey, otherValue, ...)
	if otherKey == nil then
		return nil
	end

	if otherKey == targetKey then
		return otherValue
	end

	return get(targetKey, ...)
end

local Variables = Class()
Variables.DEFAULT = "_"

Variables.PathParameter = Class()
function Variables.PathParameter:new(name, defaultValue)
	assert(type(name) ~= "nil")
	assert(name ~= Variables.DEFAULT, "name cannot be `Variables.DEFAULT`")

	self.name = name
	self.defaultValue = self.defaultValue
end

function Variables.PathParameter:getName()
	return self.name
end

function Variables.PathParameter:getDefaultValue()
	return self.defaultValue
end

Variables.Path = Class()
function Variables.Path:new(...)
	self.elements = { ... }
	self.n = select("#", ...)
end

function Variables.Path:get(root, ...)
	local current = root
	for i = 1, self.n do
		local key = self.elements[i]
		if Class.isCompatibleType(key, Variables.PathParameter) then
			local newKey = get(key:getName(), ...)
			key = newKey == nil and key:getDefaultValue() or newKey
		end

		current = current[key]
		if current == nil then
			return get(Variables.DEFAULT, ...)
		end
	end

	return current
end

function Variables:new(filename)
	self.filename = filename
	self.modifiedTime = -1
	self.paths = {}

	self:_tryUpdate()
end

local cache = {}
function Variables.load(filename)
	if not cache[filename] then
		cache[filename] = Variables(filename)
		cache[filename]:_tryUpdate()
	end

	return cache[filename]
end

function Variables.update()
	for _, variables in pairs(cache) do
		variables:_tryUpdate()
	end
end

function Variables:_updatePaths()
	table.clear(self.paths)

	local paths = self.root["$paths"]
	if paths then
		for name, components in pairs(paths) do
			local result = {}

			for _, component in ipairs(components) do
				local variable = component:match("^%$(.+)$")
				if variable then
					table.insert(result, Variables.PathParameter(variable))
				else
					table.insert(result, component)
				end
			end

			self.paths[name] = Variables.Path(unpack(result))
		end
	end
end

function Variables:_tryUpdate()
	local info = love.filesystem.getInfo(self.filename)
	if info and info.modifiedTime ~= self.modifiedTime then
		self.exists = true
		self.root = json.decode(love.filesystem.read(self.filename))
		self.modifiedTime = info.modtime or -1

		self:_updatePaths()
	else
		self.exists = false
		self.root = {}
		self.modifiedTime = -1
	end
end

function Variables:path(path)
	local result = self.paths[path]
	if not result then
		error(string.format("unknown path for config '%s': '%s'", self.filename, path))
	end

	return result
end

function Variables:get(path, ...)
	if path == nil then
		return self.root
	end

	return path:get(self.root, ...)
end

return Variables
