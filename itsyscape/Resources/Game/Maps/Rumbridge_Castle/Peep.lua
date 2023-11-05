--------------------------------------------------------------------------------
-- Resources/Game/Maps/Rumbridge_Castle/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Map = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"

local Castle = Class(Map)

function Castle:new(resource, name, ...)
	Map.new(self, resource, name or 'RumbridgeCastle', ...)
end

function Castle:onFinalize(director, game)
	self:initSuperSupperSaboteur()
end

function Castle:initSuperSupperSaboteur()
	local director = self:getDirector()

	local chef = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("ChefAllon"))[1]
	if chef then
		chef:listen('acceptQuest', self.onAcceptSuperSupperSaboteur, self, chef)
	else
		Log.warn("Chef Allon not found; cannot init quest Super Supper Saboteur.")
	end
end

function Castle:onAcceptSuperSupperSaboteur(hex)
	local director = self:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local map = Utility.Peep.getMapResource(self)

	local namedMapAction = gameDB:getRecord("NamedMapAction", {
		Name = "StartSuperSupperSaboteur",
		Map = map
	})

	if not namedMapAction then
		Log.warn("Couldn't talk to Chef Allon after starting quest: named map action not found.")
	else
		local player = Utility.Peep.getPlayer(self)
		local action = Utility.getAction(game, namedMapAction:get("Action"))
		action.instance:perform(player:getState(), player, hex)
	end
end

return Castle
