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
			local isEqual = deepEquals(a[key], b[key])
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
	local success, type = pcall(require, typeName)
	if not success then
		return false, nil
	end

	return Class.isClass(type), type
end

function State:registerTypeProvider(typeName, provider)
	local isType, type = self:verifyIsClass(typeName)
	if not isType then
		Log.error("Type name '%s' is not a type.", typeName)
		return
	end

	local result = {
		provider = provider,
		typeName = typeName,
		type = type
	}

	self.types[type] = result
	self.typeNames[typeName] = result
end

function State:serializePrimitive(value)
	local typeName = type(value)

	if not State.PRIMITIVES[typeName] then
		Log.error("Type '%s' is not a primitive; cannot serialize.", typeName)
		return nil
	end

	return {
		typeName = typeName,
		value = value
	}
end

function State:isPrimitive(value)
	local typeName = type(value)
	return State.PRIMITIVES[typeName] == true
end

function State:isClass(value)
	return Class.isClass(value)
end

function State:isTable(value)
	return type(value) == 'table' and not getmetatable(value)
end

function State:deserialize(obj)
	exceptions = exceptions or {}

	local typeName = obj.typeName

	if typeName == "nil" then
		return nil
	elseif typeName == "number" or typeName == "string" or typeName == "boolean" then
		return obj.value
	elseif typeName == "table" then
		local value = obj.value

		local result = {}
		for i = 1, #value do
			local pair = value[i]
			local key = self:deserialize(pair.key)
			local value = self:deserialize(pair.value)

			result[key] = value
		end

		return result
	else
		local t = self.typeNames[typeName]

		if t then
			return t:deserialize(obj, state)
		end
	end

	error("Could not deserialize object.")
end

function State:serialize(obj, exceptions)
	if self:isPrimitive(obj) then
		return self:serializePrimitive(value)
	end

	local isClass = Class.isClass(obj)
	if isClass then
		local t = Class.getType(obj)
		if not self.types[t] then
			Log.error("Type '%s' is not registered.", t._DEBUG.shortName)
			return nil
		else
			if exceptions[obj] then
				Log.warn("Recursive object. Will probably die over the wire.")
				return exceptions[obj]
			end

			local result = { typeName = t.typeName }
			t.provider:serialize(obj, result, self, exceptions)

			exceptions[obj] = result
		end
	end

	local isTable = self:isTable(obj)
	if isTable then
		if exceptions[obj] then
			Log.warn("Recursive object. Will probably die over the wire.")
			return exceptions[obj]
		end

		local result = { typeName = 'table', value = {} }
		for key, value in pairs(obj) do
			local k = self:serialize(key, exceptions)
			local v = self:serialize(value, exceptions)

			if k == nil then
				Log.error("Could not serialize key '%s' (type: %s)", tostring(k), type(k))
			end

			if v == nil then
				Log.error("Could not serialize value '%s' (type: %s)", tostring(v), type(v))
			end

			if k and v then
				table.insert(result.value, {
					key = self:serialize(key, exceptions),
					value = self:serialize(value, exceptions)
				})
			end
		end

		exceptions[obj] = result
		return result
	end

	Log.error("Unsupported object of type %s.", type(obj))
	return nil
end

return State
