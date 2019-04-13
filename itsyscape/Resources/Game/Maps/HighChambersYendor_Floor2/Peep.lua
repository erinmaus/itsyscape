--------------------------------------------------------------------------------
-- Resources/Game/Maps/HighChambersYendor_Floor2/Peep.lua
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

local HighChambersYendor = Class(Map)

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor2', ...)
end

function HighChambersYendor:onFinalize(director, game)
	self:initMiniboss()
end

function HighChambersYendor:initMiniboss()
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.resource("Peep", "HighChambersYendor_RatKing"))
	if #hits >= 1 then
		hits[1]:listen('die', self.giveMinibossLoot, self)

		Log.info("Found Rat King miniboss.")
	end
end

function HighChambersYendor:giveMinibossLoot()
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local chest = gameDB:getRecord("MapObjectLocation", {
		Name = "RatKingRewardChest",
		Map = Utility.Peep.getMap(self)
	})

	if chest then
		chest = director:probe(
			self:getLayerName(),
			Probe.mapObject(chest:get("Resource")))[1]

		if chest then
			chest:poke('materialize', {
				count = math.random(20, 40),
				dropTable = gameDB:getResource("HighChambersYendor_RatKing_Rewards", "DropTable"),
				peep = director:getGameInstance():getPlayer():getActor():getPeep(),
				chest = chest
			})

			Log.info("Rat King loot materialized.")
		end
	end
end

return HighChambersYendor
