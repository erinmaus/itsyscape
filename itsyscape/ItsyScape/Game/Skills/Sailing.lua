--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Sailinglua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Utility = require "ItsyScape.Game.Utility"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Sailing = {}

-- This scales a distance from map units to "pseudo-kilometers".
Sailing.DISTANCE_SCALE = 70

function Sailing.getDistanceBetweenLocations(fromLocation, toLocation)
	local fromI, fromJ = fromLocation:get("AnchorI"), fromLocation:get("AnchorI")
	local toI, toJ = toLocation:get("AnchorI"), toLocation:get("AnchorI")
	local realityWarpMultiplier = 1 + toLocation:get("RealityWarpDistanceMultiplier")

	local distance = math.sqrt(((fromI - toI) ^ 2 + (fromJ - toJ) ^ 2)) * realityWarpMultiplier
	return distance * Sailing.DISTANCE_SCALE
end

Sailing.Orchestration = {}
Sailing.Orchestration.START_INDEX = 1

function Sailing.Orchestration.isInProgress(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local statusStorage = storage:getSection("Status")
	return statusStorage:get("started") or false
end

function Sailing.Orchestration.start(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local statusStorage = storage:getSection("Status")

	statusStorage:set("index", Sailing.Orchestration.START_INDEX)
	statusStorage:set("currentDistance", 0)
	statusStorage:set("started", true)

	Sailing.Orchestration.step(peep)
end

function Sailing.Orchestration.step(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local statusStorage = storage:getSection("Status")

	local currentIndex = statusStorage:get("index") or Sailing.Orchestration.START_INDEX
	local currentDistance = statusStorage:get("currentDistance") or 0

	local stats = Sailing.Ship.getStats(peep)
	local distanceRoll = math.random(stats["Speed"], 2 * stats["Speed"])

	currentDistance = currentDistance + distanceRoll
	statusStorage:set("currentDistance", currentDistance)
	Log.info("Travelled %d km towards next step (total distance %d km).", distanceRoll, currentDistance)

	local _, currentLocation = Sailing.Itinerary.getDestination(peep, currentIndex)
	local _, targetLocation = Sailing.Itinerary.getDestination(peep, currentIndex + 1)
	local targetDistance = Sailing.getDistanceBetweenLocations(currentLocation, targetLocation)


	if currentDistance > targetDistance then
		Sailing.Orchestration.arriveNext(peep)
	else
		Sailing.Orchestration.randomEvent(peep)
	end
end

function Sailing.Orchestration.randomEvent(peep)
	--Log.info("Random events are not yet implemented; continue voyage!")
	--Sailing.Orchestration.step(peep)
	local stage = peep:getDirector():getGameInstance():getStage()
	stage:movePeep(peep, "Ship_Player1?map=Sailing_RandomEvent_RumbridgeNavyScout,i=32,j=32", "Anchor_Spawn")
end

function Sailing.Orchestration.arriveNext(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local statusStorage = storage:getSection("Status")

	local currentIndex = statusStorage:get("index")
	local nextIndex = currentIndex + 1

	statusStorage:set("index", nextIndex)
	statusStorage:set("currentDistance", 0)

	local _, destinationLocation = Sailing.Itinerary.getDestination(peep, nextIndex)

	local isDone = not Sailing.Orchestration.isInProgress(peep)
	if isDone then
		while storage:length() > 0 do
			storage:removeSection(storage:length())
		end
		statusStorage:set("started", false)

		Log.info("Arrived at final port.")
	end

	local stage = peep:getDirector():getGameInstance():getStage()
	stage:movePeep(peep, destinationLocation:get("Map").name, "Anchor_Spawn")
end


Sailing.Ship = {}
Sailing.Ship.SLOTS = {
	"Hull",
	"Rigging",
	"Helm",
	"Sail",
	"Cannon",
	"Storage",
	"Figurehead"
}

function Sailing.Ship.getStats(peep)
	local storage = peep:getDirector():getPlayerStorage(peep):getRoot()

	local stats = {}
	for i = 1, #Sailing.Ship.SLOTS do
		local item = Sailing.Ship.SLOTS[i]
		local itemStorage = storage:getSection("Ship"):getSection(item)
		local resourceName = itemStorage:get("resource")

		if not resourceName then
			itemStorage:set("resource", defaultResource)
			resourceName = defaultResource
		end

		local gameDB = peep:getDirector():getGameDB()
		local resource = gameDB:getResource(resourceName, "SailingItem")
		if resource then
			local record = gameDB:getRecord("SailingItemStats", { Resource = resource })
			if record then
				for i = 1, #ShipStatsBehavior.BASE_STATS do
					local stat = ShipStatsBehavior.BASE_STATS[i]
					local value = record:get(stat)

					stats[stat] = (stats[stat] or 0) + value
				end
			end
		end

		local propResourceName = itemStorage:get("prop")
		if propResourceName then
			local propResource = gameDB:getResource(propResourceName, "Prop")
			if propResource then
				local cannonRecord = gameDB:getRecord("Cannon", { Resource = propResource })

				if cannonRecord then
					stats["OffenseRange"] = cannonRecord:get("Range")
					stats["OffenseMinDamage"] = cannonRecord:get("MinDamage")
					stats["OffenseMaxDamage"] = cannonRecord:get("MaxDamage")
				end
			end
		end
	end

	return stats
end

Sailing.Itinerary = {}
function Sailing.Itinerary.hasItinerary(peep)
	return Sailing.Itinerary.getStorage(peep):length() > 1
end

function Sailing.Itinerary.getStorage(peep)
	local director = peep:getDirector()
	local rootStorage = director:getPlayerStorage(peep):getRoot()
	local itineraryStorage = rootStorage:getSection("Sailing"):getSection("Itinerary")

	return itineraryStorage
end

function Sailing.Itinerary.addDestination(peep, mapLocation, lang)
	local gameDB = peep:getDirector():getGameDB()
	local mapAnchor = mapLocation:get("Resource")
	local destination = {
		id = mapAnchor.name,
		seaChart = mapLocation:get("SeaChart").name,
		name = Utility.getName(mapAnchor, gameDB, lang),
		description = Utility.getDescription(mapAnchor, gameDB, lang)
	}

	local storage = Sailing.Itinerary.getStorage(peep)
	storage:getSection(storage:length() + 1):set(destination)
end

function Sailing.Itinerary.getDestination(peep, index)
	local storage = Sailing.Itinerary.getStorage(peep)
	if index < 1 or index > storage:length() then
		return nil, nil, nil
	end

	local destinationStorage = storage:get(index)
	local gameDB = peep:getDirector():getGameDB()
	local anchorResource = gameDB:getResource(destinationStorage:get("id"), "SailingMapAnchor")
	local seaChartResource = gameDB:getResource(destinationStorage:get("seaChart"), "SailingSeaChart")
	local mapLocation = gameDB:getRecord("SailingMapLocation", {
		SeaChart = seaChartResource,
		Resource = anchorResource
	})

	return anchorResource, mapLocation, seaChartResource
end

function Sailing.Itinerary.getLastDestination(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local lastDestinationIndex = storage:length()
	return Sailing.Itinerary.getDestination(peep, lastDestinationIndex)
end

function Sailing.Itinerary.isReadyToSail(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local length = storage:length()

	-- Early out - no itinerary.
	if length <= 0 then
		return false
	end

	local _, lastDestinationLocation = Sailing.Itinerary.getLastDestination(peep)
	
	local isPortCondition = lastDestinationLocation:get("IsPort") ~= 0
	local atLeastTwoDestinationsCondition = length > 1

	return isPortCondition and atLeastTwoDestinationsCondition 
end

return Sailing
