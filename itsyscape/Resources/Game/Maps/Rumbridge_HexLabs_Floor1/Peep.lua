--------------------------------------------------------------------------------
-- Resources/Game/Maps/HexLabs_Floor1West/Peep.lua
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

local HexLabs = Class(Map)

function HexLabs:new(resource, name, ...)
	Map.new(self, resource, name or 'HexLabs_Floor1', ...)
end

function HexLabs:onFinalize(director, game)
	self:initMysteriousMachinations()
end

function HexLabs:initMysteriousMachinations()
	local director = self:getDirector()

	local hex = director:probe(
		self:getLayerName(),
		Probe.namedMapObject("Hex"))[1]
	if hex then
		hex:listen('acceptQuest', self.onAcceptMysteriousMachinations, self, hex)
	else
		Log.warn("Hex not found; cannot init quest Mysterious Machinations.")
	end
end

function HexLabs:onAcceptMysteriousMachinations(hex)
	local director = self:getDirector()
	local game = director:getGameInstance()
	local gameDB = director:getGameDB()
	local map = Utility.Peep.getMapResource(self)

	local namedMapAction = gameDB:getRecord("NamedMapAction", {
		Name = "StartMysteriousMachinations",
		Map = map
	})

	if not namedMapAction then
		Log.warn("Couldn't talk to Hex after starting quest: named map action not found.")
	else
		local player = Utility.Peep.getPlayer(self)
		local action = Utility.getAction(game, namedMapAction:get("Action"))
		action.instance:perform(player:getState(), player, hex)
	end
end

return HexLabs
