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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"
local PlayerBehavior = require "ItsyScape.Peep.Behaviors.PlayerBehavior"
local HighChambersYendorCommon = require "Resources.Game.Peeps.HighChambersYendor.Common"

local HighChambersYendor = Class(Map)

function HighChambersYendor:new(resource, name, ...)
	Map.new(self, resource, name or 'HighChambersYendor_Floor2', ...)
end

function HighChambersYendor:onFinalize(director, game)
	self:initMiniboss()

	HighChambersYendorCommon.initLever(self, "HighChambersYendor_Lever2")
end

function HighChambersYendor:initMiniboss()
	local director = self:getDirector()
	local hits = director:probe(
		self:getLayerName(),
		Probe.resource("Peep", "HighChambersYendor_RatKing"))
	if #hits >= 1 then
		hits[1]:listen('die', self.giveMinibossLoot, self, hits[1])

		Log.info("Found Rat King miniboss.")
	end
end

function HighChambersYendor:giveMinibossLoot(ratKing)
	local director = self:getDirector()
	local gameDB = director:getGameDB()

	local chest = gameDB:getRecord("MapObjectLocation", {
		Name = "RatKingRewardChest",
		Map = Utility.Peep.getMapResource(self)
	})

	if chest then
		chest = director:probe(
			self:getLayerName(),
			Probe.mapObject(chest:get("Resource")))[1]

		if chest then
			local status = ratKing:getBehavior(CombatStatusBehavior)
			for peep in pairs(status.damage) do
				local isPlayer = peep:hasBehavior(PlayerBehavior)
				if isPlayer then
					chest:poke('materialize', {
						count = math.random(20, 40),
						dropTable = gameDB:getResource("HighChambersYendor_RatKing_Rewards", "DropTable"),
						peep = peep,
						chest = chest
					})

					Log.info("Rat King loot materialized for player '%s'.", peep:getName())
				end
			end
		end
	end
end

return HighChambersYendor
