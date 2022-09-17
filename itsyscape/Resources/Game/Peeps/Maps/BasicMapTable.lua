--------------------------------------------------------------------------------
-- Resources/Game/Peeps/Maps/BasicMapTable.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Map = require "ItsyScape.Peep.Peeps.Map"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"

local MapTable = Class(Map)
MapTable.UI_GROUP = {
	"SailingItinerary"
}

function MapTable:new(resource, name, ...)
	Map.new(self, resource, name or 'BasicMapTable', ...)

	self:addPoke('save')
	self:addPoke('sail')
end

function MapTable:onLoad(filename, arguments, layer)
	Map.onLoad(self, filename, arguments, layer)

	local gameDB = self:getDirector():getGameDB()
	local seaChart = gameDB:getRecord("MapSeaChart", {
		Map = Utility.Peep.getMapResource(self)
	})

	local playerAnchor
	if not arguments.playerAnchor then
		Log.warn("No player anchor provided to map table; defaulting to Rumbridge Port.")
		playerAnchor = "Rumbridge_Port"
	else
		playerAnchor = arguments.playerAnchor
	end

	self.returnAnchor = arguments.returnAnchor or "Anchor_MapTable"

	if seaChart then
		local map = Utility.Peep.getMap(self)

		local sailingMapLocations = gameDB:getRecords("SailingMapLocation", {
			SeaChart = seaChart:get("SeaChart")
		})

		local playerMapLocation = gameDB:getRecord("SailingMapLocation", {
			SeaChart = seaChart:get("SeaChart"),
			Resource = gameDB:getResource(playerAnchor, "SailingMapAnchor")
		})

		for i = 1, #sailingMapLocations do
			local sailingMapLocation = sailingMapLocations[i]

			local tileCenter = map:getTileCenter(
				sailingMapLocation:get("AnchorI"),
				sailingMapLocation:get("AnchorJ"))
			local prop = Utility.spawnPropAtPosition(
				self,
				"Sailing_MapAnchor_Default",
				tileCenter.x,
				tileCenter.y,
				tileCenter.z,
				0)
			if prop then
				prop:getPeep():listen('finalize', function(peep)
					peep:pushPoke('assignMapLocation', sailingMapLocation, playerMapLocation)
				end)
			else
				Log.warn("Couldn't spawn map anchor prop for location '%s'.", sailingMapLocations[i]:get("Resource").name)
			end
		end

		do
			local player = Utility.Peep.getPlayer(self)
			local lastDestination = Sailing.Itinerary.getLastDestination(player)
			if not lastDestination then
				Sailing.Itinerary.addDestination(player, playerMapLocation)
			end
		end

		self.returnMap = playerMapLocation:get("Map").name
	end

	local playerModel = Utility.Peep.getPlayerModel(self)
	playerModel:changeCamera('MapTable')

	local player = Utility.Peep.getPlayer(self)
	player:listen('travel', self.onPlayerTravel, self)
	player:addBehavior(DisabledBehavior)
	Utility.UI.closeAll(player)
	Utility.UI.openGroup(player, MapTable.UI_GROUP)
end

function MapTable:onSail()
	local player = Utility.Peep.getPlayer(self)

	if not Sailing.Itinerary.isReadyToSail(player) then
		local game = self:getDirector():getGameInstance()
		local gameDB = self:getDirector():getGameDB()
		local message = gameDB:getResource("Message_Sailing_LastDestinationNotPort", "KeyItem")
		local requirements = { Utility.getActionConstraintResource(game, message) }

		Utility.UI.openInterface(
			player,
			"Notification",
			false,
			{ requirements = requirements })
		return
	end

	Sailing.Orchestration.start(player)
end

function MapTable:onSave()
	local stage = self:getDirector():getGameInstance():getStage()
	local player = Utility.Peep.getPlayer(self)

	stage:movePeep(player, self.returnMap, self.returnAnchor)
end

function MapTable:onPlayerTravel(player, e)
	local map = Utility.Peep.getMapResource(self)
	if e.to ~= map.name then
		local playerModel = Utility.Peep.getPlayerModel(player)
		playerModel:changeCamera('Default')

		player:silence('travel', self.onPlayerTravel)
		player:removeBehavior(DisabledBehavior)

		Utility.UI.closeAll(player)
		Utility.UI.openGroup(player, Utility.UI.Groups.WORLD)
	end
end

return MapTable
