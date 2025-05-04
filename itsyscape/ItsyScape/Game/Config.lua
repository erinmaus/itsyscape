--------------------------------------------------------------------------------
-- ItsyScape/Game/Config.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Variables = require "ItsyScape.Game.Variables"

local Config = Class()

Config.NAMES_CACHE = {}
Config.DEFAULT_OVERRIDE = {}

function Config.getOverride()
	return Variables.load("Player/Variables.json")
end

function Config.get(name, path, ...)
	if not Config.NAMES_CACHE[name] then
		local defaultFilename = string.format("Resources/Game/Variables/%s.json", name)
		Config.NAMES_CACHE[name] = defaultFilename
	end

	local override = Config.getOverride():get()[name] or Config.DEFAULT_OVERRIDE

	local filename = Config.NAMES_CACHE[name]
	local variables = Variables.load(filename)

	local path = variables:path(path)
	return path:get(override, Variables.DEFAULT, variables:get(path, ...), ...)
end

function Config.update()
	Variables.update()
end

return Config
