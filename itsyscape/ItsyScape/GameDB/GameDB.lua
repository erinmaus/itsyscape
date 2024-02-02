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
local BrochureWrapper = require "ItsyScape.GameDB.BrochureWrapper"

local GameDB = Class()

local function createGameDBInputs()
	local t = {
		"Resources/Game/DB/Init.lua"
	}

	for _, item in ipairs(love.filesystem.getDirectoryItems("Resources/Game/Maps/")) do
		local f1 = "Resources/Game/Maps/" .. item .. "/DB/Main.lua"
		local f2 = "Resources/Game/Maps/" .. item .. "/DB/Default.lua"
		if love.filesystem.getInfo(f1) then
			table.insert(t, f1)
		elseif love.filesystem.getInfo(f2) then
			table.insert(t, f2)
		end
	end

	return t
end

function GameDB.create(inputFilename, outputFilename)
	local _load = love.filesystem.load
	local _setfenv = setfenv

	local S = Sandbox()
	S.include = setfenv(function(filename)
		local chunk, e = _load(filename)
		if e then
			S.Game.getGame().Error(e)
		end
		_setfenv(chunk, S)

		local s, r = pcall(chunk)
		if not s then
			S.Game.getGame().Error(r)
		end

		return r
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
	S.Log = require "ItsyScape.Common.Log"
	S.debug = require "debug"

	local p = pairs
	S.spairs = function(t)
		local keys = {}
		for key in p(t) do
			if type(key) == "string" then
				table.insert(keys, key)
			end
		end

		table.sort(keys)
		local index = 0

		return function()
			index = index + 1
			local key = keys[index]
			local value = t[key]
			return key, value
		end
	end

	local game
	do
		local inputs
		if type(inputFilename) == 'string' then
			inputs = { inputFilename }
		elseif type(inputFilename) == 'table' then
			inputs = inputFilename
		else
			inputs = createGameDBInputs()
		end

		for i = 1, #inputs do
			local chunk, e = love.filesystem.load(inputs[i])
			if not chunk then
				Log.warn("Could not compile input '%s': %s", inputs[i], e)
			else
				chunk = setfenv(chunk, S)
				local s, r = pcall(chunk)
				if not s then
					Log.warn("Couldn't run input '%s': %s", inputs[i], r)
				end
			end
		end

		game = S.Game.getGame()
	end

	local brochure = Mapp.Brochure(outputFilename or ":memory:")
	brochure:create()

	local s, r = pcall(game.instantiate, game, brochure)
	if not s then
		Log.error("Error instantiating GameDB: %s", r)
	end

	return GameDB(brochure, game:getRecordDefinitions(), game:getMeta()), game:getErrors()
end

function GameDB:new(brochure, definitions, meta)
	self.brochure = BrochureWrapper(brochure, meta)
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
	-- local before = love.timer.getTime()
	-- local definition = self:getRecordDefinition(name)
	-- if not definition then
	-- 	return {}
	-- end

	-- local query = Mapp.Query(definition)
	-- for k, v in pairs(t) do
	-- 	query:set(k, v)
	-- end
	-- local after = love.timer.getTime()

	-- --Log.info(">>> getRecords query %f", (after - before) * 1000)

	-- before = love.timer.getTime()
	-- local r = self.brochure:select(definition, query, limit, t)
	-- after = love.timer.getTime()
	-- --Log.info(">>> getRecords select %f", (after - before) * 1000)

	return self.brochure:selectMeta(name, t, limit)
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
