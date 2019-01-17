--------------------------------------------------------------------------------
-- Resources/Game/Maps/IsabelleIsland_AbandonedMine/Peep.lua
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

local Mine = Class(Map)

function Mine:new(resource, name, ...)
	Map.new(self, resource, name or 'Mine', ...)
end

function Mine:ready(director, game)
	Map.ready(self, director, game)

	self:initTorches()
end

function Mine:getTorches()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local torches = gameDB:getRecords("MapObjectGroup", {
		MapObjectGroup = "HighChambersYendor_Torch",
		Map = Utility.Peep.getMap(self)
	})

	local result = {}
	for i = 1, #torches do
		local torch = director:probe(
			self:getLayerName(),
			Probe.mapObject(torches[i]:get("MapObject")))[1]
		if torch then
			table.insert(result, torch)
		end
	end

	return result
end

function Mine:initTorches()
	self.torchesLit = 0

	local torches = self:getTorches()
	for i = 1, #torches do
		torches[i]:poke('snuff')
		torches[i]:listen('light', self.onLightTorch, self)
		torches[i]:listen('snuff', self.onSnuffTorch, self)
	end
end

function Mine:onLightTorch()
	self.torchesLit = self.torchesLit + 1
	if self.torchesLit >= #self:getTorches() then
		Log.info("All torches lit, opening High Chambers of Yendor.")
		self:openEntrance()
	end
end

function Mine:onSnuffTorch()
	self.torchesLit = math.max(self.torchesLit - 1, 0)
end

function Mine:openEntrance()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	Utility.spawnMapObjectAtAnchor(
		self,
		"HighChambersYendor_Entrance",
		"Anchor_HighChambersYendor",
		0)
end

return Mine
