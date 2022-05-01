--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/State.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TypeProvider = require "ItsyScape.Game.RPC.TypeProvider"

local State = Class()
State.PRIMITIVES = {
	["nil"] = true,
	["number"] = true,
	["string"] = true,
	["boolean"] = true
}

function State.deepEquals(a, b)
	if a == b then
		return true
	end

	local typeA, typeB = type(a), type(b)

	if typeA ~= typeB then
		return false
	end

	if typeA ~= "table" then
		return false
	end

	for key, value in pairs(a) do
		if b[key] == nil then
			return false
		else
			local isEqual = State.deepEquals(a[key], b[key])
			if not isEqual then
				return false
			end
		end
	end

	for key in pairs(b) do
		if a[key] == nil then
			return false
		end
	end

	return true
end

function State:new()
	self.types = {}
	self.typeNames = {}
end

function State:verifyIsClass(typeName)
	local success, t = pcall(require, typeName)
	if not success then
		return false, nil
	end

	metatable = getmetatable(t)

	return type(metatable) == "table" and metatable.__c == Class, t
end

function State:registerTypeProvider(typeName, provider, alias)
	local isType, type = self:verifyIsClass(typeName)
	if not isType then
		Log.error("Type name '%s' is not a type.", typeName)
		return
	end

	local result = {
		provider = provider,
		typeName = alias or typeName,
		type = type
	}

	self.types[type] = result
	self.typeNames[typeName] = result

	if alias then
		self.typeNames[alias] = result
	end
end

local function isPrimitive(v)
	v = type(v)
	return v == "nil" or v == "number" or v == "string" or v == "boolean"
end

local function isTable(value)
	return type(value) == 'table' and not getmetatable(value)
end

function State:deserialize(obj)
	if type(obj) == "table" then
		local typeName = obj["$__typeName"]
		if typeName then
			local t = self.typeNames[typeName]
			if t then
				return t.provider:deserialize(obj, self)
			end
		end

		local result = {}
		for key, value in pairs(obj) do
			result[self:deserialize(key)] = self:deserialize(value)
		end

		return result
	else
		return obj
	end
end

function State:serialize(obj, exceptions)
	exceptions = exceptions or {}

	if isPrimitive(obj) then
		return obj
	end

	local isTable = isTable(obj)
	if isTable then
		if exceptions[obj] then
			return exceptions[obj]
		end

		local result = {}
		for key, value in pairs(obj) do
			result[self:serialize(key, exceptions)] = self:serialize(value, exceptions)
		end

		exceptions[obj] = result
		return result
	end

	local isClass = Class.isClass(obj)
	if isClass then
		local t = self.types[Class.getType(obj)]
		if not t then
			Log.error("Type '%s' is not registered.", obj:getDebugInfo().shortName)
			return nil
		else
			if exceptions[obj] then
				return exceptions[obj]
			end

			local result = { ["$__typeName"] = t.typeName }
			t.provider:serialize(obj, result, self, exceptions)

			exceptions[obj] = result

			return result
		end
	end

	Log.error("Unsupported object of type '%s'.", type(obj))
	return nil
end

return State
