--------------------------------------------------------------------------------
-- ItsyScape/GameDB/GameDB.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Sandbox = require "ItsyScape.Common.Sandbox"
local Mapp = require "ItsyScape.GameDB.Mapp"

local GameDB = Class()

function GameDB.create(inputFilename, outputFilename)
	local _load = love.filesystem.load
	local _setfenv = setfenv

	local S = Sandbox()
	S.include = setfenv(function(filename)
		local chunk = assert(_load(filename))
		_setfenv(chunk, S)
		return chunk()
	end, S)

	local packages = { ["debug"] = require "debug" }
	S.require = setfenv(function(filename)
		if not packages[filename] then
			local r = S.include(filename:gsub("%.", "/") .. ".lua")
			if r == nil then
				packages[filename] = true
			else
				packages[filename] = r
			end
		end

		return packages[filename]
	end, S)

	S.Mapp = require "ItsyScape.GameDB.Mapp"
	S.Action = S.require "ItsyScape.GameDB.Commands.Action"
	S.ActionCategory = S.require "ItsyScape.GameDB.Commands.ActionCategory"
	S.ActionType = S.require "ItsyScape.GameDB.Commands.ActionType"
	--S.Builder = S.require "ItsyScape.GameDB.Commands.Builder"
	S.Game = S.require "ItsyScape.GameDB.Commands.Game"
	S.Input = S.require "ItsyScape.GameDB.Commands.Input"
	S.Meta = S.require "ItsyScape.GameDB.Commands.Meta"
	S.Output = S.require "ItsyScape.GameDB.Commands.Output"
	S.Requirement = S.require "ItsyScape.GameDB.Commands.Requirement"
	S.Resource = S.require "ItsyScape.GameDB.Commands.Resource"
	S.ResourceType = S.require "ItsyScape.GameDB.Commands.ResourceType"

	local game
	do
		local inputs
		if type(inputFilename) == 'string' then
			inputs = { inputFilename }
		elseif type(inputFilename) == 'table' then
			inputs = inputFilename
		else
			error("exepcted filename or table of filenames")
		end

		for i = 1, #inputs do
			local script = assert(loadstring(love.filesystem.read(inputs[i]), inputs[i]))
			local chunk = setfenv(script, S)
			chunk()
		end

		game = S.Game.getGame()
	end

	local brochure = Mapp.Brochure(outputFilename or ":memory:")
	brochure:create()
	game:instantiate(brochure)

	return GameDB(brochure, game:getRecordDefinitions())
end

function GameDB:new(brochure, definitions)
	self.brochure = brochure
	self.definitions = {}

	for key, value in pairs(definitions) do
		if type(key) == 'string' then
			self.definitions[key] = value
		end
	end
end

function GameDB:getBrochure()
	return self.brochure
end

function GameDB:getRecordDefinition(name)
	return self.definitions[name]
end

function GameDB:getRecords(name, t, limit)
	local definition = self:getRecordDefinition(name)
	if not definition then
		return {}
	end

	local query = Mapp.Query(definition)
	for k, v in pairs(t) do
		query:set(k, v)
	end

	return self.brochure:select(definition, query, limit)
end

function GameDB:getRecord(name, t)
	return self:getRecords(name, t, 1)[1]
end

function GameDB:getResources(type)
	local resourceType = Mapp.ResourceType()
	if self.brochure:tryGetResourceType(type, resourceType) then
		return self.brochure:findResourcesByType(resourceType)
	end

	return function() return nil end
end

function GameDB:getResource(name, type)
	local resourceType = Mapp.ResourceType()
	if self.brochure:tryGetResourceType(type, resourceType) then
		for resource in self.brochure:findResourcesByNameAndType(name, resourceType) do
			return resource
		end
	end

	return nil
end

function GameDB:getAction(id)
	local id = Mapp.ID(tonumber(id))
	local action = Mapp.Action()
	if self.brochure:tryGetAction(id, action) then
		return action
	else
		return nil
	end
end

return GameDB
