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

local Variables = Class()
Variables.RETURN = "_"

Variables.PathParameter = Class()
function Variables.PathParameter:new(name, defaultValue)
	assert(type(name) ~= "nil")
	assert(type(defaultValue) ~= "nil")
	assert(name ~= Variables.RETURN, "name cannot be `Variables.RETURN`")

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

function Variables:new(filename)
	self.filename = filename
	self.modifiedTime = -1

	self:_tryUpdate()
end

function Variables:_tryUpdate()
	local info = love.filesystem.getInfo(self.filename)
	if info and info.modifiedTime ~= self.modifiedTime then
		self.exists = true
		self.root = json.decode(love.filesystem.read(self.filename))
		self.modifiedTime = info.modtime or -1
	else
		self.root = {}
		self.modifiedTime = -1
	end
end

local function get(targetKey, otherKey, otherValue, ...)
	if otherKey == nil then
		return nil
	end

	if otherKey == targetKey then
		return otherValue
	end

	return get(targetKey, ...)
end

function Variables:get(path, ...)
	self:_tryUpdate()

	if path == nil then
		return self.root
	end

	local current = self.root
	for i = 1, path.n do
		local key = path.elements[i]
		if Class.isCompatibleType(key, Variables.PathParameter) then
			local newKey = get(key:getName(), ...)
			key = newKey == nil and key:getDefaultValue() or newKey
		end

		current = current[key]
		if current == nil then
			return get(Variables.RETURN, ...)
		end
	end
end

return Variables
