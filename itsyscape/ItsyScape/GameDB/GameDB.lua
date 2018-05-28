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

	local packages = {}
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
		local script = assert(loadstring(love.filesystem.read(inputFilename), inputFilename))
		local chunk = setfenv(script, S)
		chunk()

		game = S.Game.getGame()
	end

	local brochure = Mapp.Brochure(outputFilename or ":memory:")
	brochure:create()
	game:instantiate(brochure)

	return GameDB(brochure)
end

function GameDB:new(brochure)
	self.brochure = brochure
end

function GameDB:getBrochure()
	return self.brochure
end

return GameDB
