--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Sailing.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Vector = require "ItsyScape.Common.Math.Vector"
local Peep = require "ItsyScape.Peep.Peep"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipCrewMemberBehavior = require "ItsyScape.Peep.Behaviors.ShipCrewMemberBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Sailing = {}

-- New sailing stuff
function Sailing.setCaptain(ship, peep)
	local _, shipToPeepCaptain = ship:addBehavior(ShipCaptainBehavior)
	shipToPeepCaptain.peep = peep

	local _, peepToShipCaptain = peep:addBehavior(ShipCaptainBehavior)
	peepToShipCaptain.peep = ship
end

-- New sailing stuff
function Sailing.setCrewMember(ship, peep)
	local _, crewMember = peep:addBehavior(ShipCrewMemberBehavior)
	crewMember.ship = ship
end

local function getDirection(a, b, c, bias)
	local result = ((b.x - a.x) * (c.z - a.z) - (b.z - a.z) * (c.x - a.x))

	-- This bias prevents 'jittering' when result is close to zero.
	-- Otherwise, the ship will jitter between +/-.
	if result > 0 + (bias or 0) then
		return 1
	elseif result < 0 then
		return -1
	else
		return 0
	end
end

function Sailing.getDirection(ship, targetPosition, bias)
	local shipPosition = Utility.Peep.getPosition(ship)
	local rotation, normal
	do
		local movement = ship:getBehavior(ShipMovementBehavior)
		rotation = movement and movement.rotation or Quaternion.IDENTITY
		normal = movement and movement.steerDirectionNormal or -Vector.UNIT_X
	end

	local shipForward = rotation:transformVector(normal)
	return getDirection(shipPosition, shipPosition + shipForward, targetPosition, bias)
end

function Sailing.getShipTarget(ship, target)
	local position
	if type(target) == "string" then
		local p = ship:getBehavior(PositionBehavior)
		layer = p and p.layer
		layer = layer or Utility.Peep.getLayer(ship)

		local instance = Utility.Peep.getInstance(mashina)
		local mapScript = instance:getMapScriptByLayer(layer)
		local mapResouce = mapScript and Utility.Peep.getResource(mapScript)

		if not mapResouce then
			return B.Status.Failure
		end

		position = Vector(Utility.Map.getAnchorPosition(mashina:getDirector():getGameInstance(), mapResource, target))
	elseif Class.isCompatibleType(target, Vector) then
		position = target
	elseif Class.isCompatibleType(target, Peep) then
		position = Utility.Peep.getPosition(target)
	else
		position = nil
	end

	return position
end

function Sailing.getShipTarget(ship, target)
	local position
	if type(target) == "string" then
		local p = ship:getBehavior(PositionBehavior)
		layer = p and p.layer
		layer = layer or Utility.Peep.getLayer(ship)

		local instance = Utility.Peep.getInstance(ship)
		local mapScript = instance:getMapScriptByLayer(layer)
		local mapResouce = mapScript and Utility.Peep.getResource(mapScript)

		if not mapResouce then
			return B.Status.Failure
		end

		position = Vector(Utility.Map.getAnchorPosition(ship:getDirector():getGameInstance(), mapResource, target))
	elseif Class.isCompatibleType(target, Vector) then
		position = target
	elseif Class.isCompatibleType(target, Peep) then
		position = Utility.Peep.getPosition(target)
	else
		position = nil
	end

	return position
end

-- This is the normal the ship is heading in, NOT the steer direction normal.
-- The steer direction normal is the axis on which 1 or -1 is projected to steer the ship.
function Sailing.getShipDirectionNormal(ship)
	if Class.isCompatibleType(target, Peep) then
		local movement = ship:getBehavior(ShipMovementBehavior)
		if movement then
			return (movement.rotation * Quaternion.Y_90):transformVector(movement.steerDirectionNormal):getNormal()
		end
	end

	return nil
end

function Sailing.calcCannonMinHit(level, bonus)
	return math.max(math.ceil((level + 50) * (bonus + 64) / 640), 1)
end

function Sailing.calcCannonMaxHit(level, bonus)
	return math.max(math.ceil((level + 50) * ((bonus + 64) ^ 1.2) / 640), 1)
end

-- Old sailing stuff

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
	local isStarted = statusStorage:get("started") and statusStorage:get("index")
	local isPending = (statusStorage:get("index") or math.huge) < storage:length()

	return isStarted and isPending
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

	-- TODO: Restore when random events are fleshed out
	--if currentDistance > targetDistance then
		Sailing.Orchestration.arriveNext(peep)
	--else
	--	Sailing.Orchestration.randomEvent(peep)
	--end
end

function Sailing.Orchestration.randomEvent(peep)
	local _, lastDestination = Sailing.Itinerary.getLastDestination(peep)

	local stage = peep:getDirector():getGameInstance():getStage()

	local path = string.format(
		"Ship_Player1?map=%s,i=32,j=32,shore=%s,shoreAnchor=Anchor_Spawn",
		"Sailing_RandomEvent_RumbridgeNavyScout",
		lastDestination:get("Map").name)

	stage:movePeep(peep, path, "Anchor_Spawn")
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

		if resourceName then
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
	end

	return stats
end

function Sailing.Ship.getInventorySpace(peep)
	-- Haha, because it's PlayerStorage for the Storage ship slot!
	local storageStorage
	do
		local rootStorage = peep:getDirector():getPlayerStorage(peep):getRoot()
		storageStorage = rootStorage:getSection("Ship"):getSection("Storage")
	end
	
	local gameDB = peep:getDirector():getGameDB()
	local resourceName = storageStorage:get("resource")
	if not resourceName then
		return 0
	end

	local resource = gameDB:getResource(resourceName, "SailingItem")
	local record = gameDB:getRecord("SailingItemStats", { Resource = resource })
	if record then
		return record:get("Storage")
	end
end


Sailing.Itinerary = {}
function Sailing.Itinerary.hasItinerary(peep)
	local itinerary = Sailing.Itinerary.getStorage(peep)
	return itinerary and itinerary:length() > 1
end

function Sailing.Itinerary.getStorage(peep)
	if not peep then
		return
	end

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
	if storage then
		return Sailing.Itinerary.getDestination(peep, storage:length())
	end
end

function Sailing.Itinerary.isReadyToSail(peep)
	local storage = Sailing.Itinerary.getStorage(peep)
	local length = storage:length()

	-- Early out - no itinerary.
	if length <= 0 then
		return false
	end

	local _, lastDestinationLocation = Sailing.Itinerary.getLastDestination(peep)
	if not lastDestinationLocation then
		return false
	end
	
	local isPortCondition = lastDestinationLocation:get("IsPort") ~= 0
	local atLeastTwoDestinationsCondition = length > 1

	return isPortCondition and atLeastTwoDestinationsCondition 
end

return Sailing
