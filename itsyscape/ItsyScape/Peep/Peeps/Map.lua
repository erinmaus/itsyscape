--------------------------------------------------------------------------------
-- ItsyScape/Peep/Peeps/Map.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"

local Map = Class(Peep)

function Map:new(resource, name, ...)
	Peep.new(self, name or 'Map', ...)

	Utility.Peep.setResource(self, resource)

	self:addPoke('load')
	self:addPoke('playerEnter')
	self:addPoke('playerLeave')

	self:listen('playerEnter', Map.showPlayerMapInfo)

	self.filename = ""
	self.arguments = {}
end

function Map:showPlayerMapInfo(player)
	local playerPeep = player:getActor():getPeep()

	local storage = self:getDirector():getPlayerStorage(playerPeep)
	if storage:getRoot():getSection("Location"):get("isTitleScreen") then
		return
	end

	local layer = Utility.Peep.getLayer(playerPeep)
	if layer ~= self:getLayer() then
		return
	end

	local resource = Utility.Peep.getResource(self)
	local name = Utility.getName(resource, self:getDirector():getGameDB())
	local description = Utility.getDescription(resource, self:getDirector():getGameDB())

	if resource and name and description then
		Utility.UI.closeAll(playerPeep, "MapInfo")

		Utility.UI.openInterface(
			playerPeep,
			"MapInfo",
			false,
			resource)
	end
end

function Map:getFilename()
	return self.filename
end

function Map:getArguments()
	return self.arguments
end

function Map:getLayer()
	return self.layer or 1
end

function Map:ready(director, game)
	Peep.ready(self, director, game)

	Utility.Peep.setNameMagically(self)
end

function Map:onLoad(filename, arguments, layer)
	self.filename = filename
	self.arguments = arguments
	self.layer = layer
end

function Map:onPlayerEnter(player)
	-- Nothing.
end

function Map:onPlayerLeave(player)
	-- Nothing.
end

return Map
