--------------------------------------------------------------------------------
-- ItsyScape/Game/RPC/State.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
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

local _CURRENT_STATE = nil
function State.getCurrentState()
	return _CURRENT_STATE
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

	function type._METATABLE.__persist(obj, state)
		local r = {
			typeName = result.typeName,
			__persist = true
		}
		result.provider:serialize(obj, r, state)

		return r
	end
end

local function isPrimitive(v)
	v = type(v)
	return v == "nil" or v == "number" or v == "string" or v == "boolean"
end

local function isTable(value)
	return type(value) == 'table' and not getmetatable(value)
end

local function serialize(self, obj)
	if type(obj) == 'table' then
		metatable = getmetatable(obj)
		if metatable then
			assert(metatable.__persist, "table with metatable does not have persist hook")

			return metatable.__persist(obj, self)
		else
			local result = {}
			for key, value in pairs(obj) do
				assert(type(key) ~= "table", "tables as keys not supported")
				assert(type(value) ~= "function", "function serialization not supported")
				result[key] = serialize(self, value)
			end

			return result
		end
	end

	return obj
end

local function deserialize(self, obj)
	if type(obj) == 'table' then
		if obj.__persist then
			local t = self.typeNames[obj.typeName]
			return t.provider:deserialize(obj, self)
		else
			-- Deserialize in place
			for key, value in pairs(obj) do
				obj[key] = deserialize(self, value)
			end

			return obj
		end
	end

	return obj
end

function State:deserialize(obj)
	local result = buffer.decode(obj)
	return deserialize(self, result)
end

function State:serialize(obj)
	local result = serialize(self, obj)
	return buffer.encode(result)
end

return State
