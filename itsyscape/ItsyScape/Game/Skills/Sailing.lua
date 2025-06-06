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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Item = require "ItsyScape.Game.Item"
local Utility = require "ItsyScape.Game.Utility"
local ICannon = require "ItsyScape.Game.Skills.ICannon"
local Color = require "ItsyScape.Graphics.Color"
local Peep = require "ItsyScape.Peep.Peep"
local MapPeep = require "ItsyScape.Peep.Peeps.Map"
local Probe = require "ItsyScape.Peep.Probe"
local FishBehavior = require "ItsyScape.Peep.Behaviors.FishBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SailingResourceBehavior = require "ItsyScape.Peep.Behaviors.SailingResourceBehavior"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipCrewMemberBehavior = require "ItsyScape.Peep.Behaviors.ShipCrewMemberBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"
local PathFinder = require "ItsyScape.World.PathFinder"
local PathNode = require "ItsyScape.World.PathNode"

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

function Sailing.getShip(peep)
	local instance = Utility.Peep.getInstance(peep)
	local mapGroup = instance:getMapGroup(Utility.Peep.getLayer(peep))
	local baseLayer = instance:getGlobalLayerFromLocalLayer(mapGroup)
	local mapScript = instance:getMapScriptByLayer(baseLayer)

	if mapScript:hasBehavior(ShipMovementBehavior) then
		return mapScript
	end

	return nil
end

function Sailing.getDirectionFromPoints(a, b, c, bias)
	local result = ((b.x - a.x) * (c.z - a.z) - (b.z - a.z) * (c.x - a.x))

	-- This bias prevents 'jittering' when result is close to zero.
	-- Otherwise, the ship will jitter between +/-.
	local sign
	if result > 0 + (bias or 0) then
		sign = 1
	elseif result < 0 - (bias or 0) then
		sign = -1
	else
		sign = 0
	end

	return sign, result
end

function Sailing.getDirection(ship, targetPosition, bias)
	local shipPosition = Utility.Peep.getPosition(ship)
	local rotation, normal
	do
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		rotation = shipMovement and shipMovement.rotation or Quaternion.IDENTITY
		normal = shipMovement and shipMovement.steerDirectionNormal or -Vector.UNIT_X
	end

	local shipForward = rotation:transformVector(normal)
	return Sailing.getDirectionFromPoints(shipPosition, shipPosition + shipForward, targetPosition, bias)
end

function Sailing._offsetVectorFromShip(position, target)
	local shipSize = Sailing.getShipSize(target)
	local size = Vector()

	if math.abs(position.x) > 0 then
		size.x = shipSize.x / 2 * math.sign(position.x)
	end

	if math.abs(position.z) > 0 then
		size.z = shipSize.z / 2 * math.sign(position.z)
	end

	return position + size
end

function Sailing.getShipTarget(ship, target, offset)
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

		if offset then
			local shipMovement = target:getBehavior(ShipMovementBehavior)
			local rotation = Utility.Peep.getRotation(target)

			if Class.isCompatibleType(offset, Ray) then
				if shipMovement then
					local r = shipMovement.rotation
					offset = Ray(
						r:transformVector(Sailing._offsetVectorFromShip(offset.origin, target)),
						r:transformVector(offset.direction):getNormal())
				else
					offset = Ray(
						rotation:transformVector(offset.origin),
						rotation:transformVector(offset.direction):getNormal())
				end
			elseif Class.isCompatibleType(offset, Vector) then
				if shipMovement then
					offset = shipMovement.rotation:getNormal():transformVector(Sailing._offsetVectorFromShip(offset, target))
				else
					offset = rotation:transformVector(offset)
				end
			end
		end
	else
		position = nil
	end

	local targetPosition
	if position then
		position = position * Vector.PLANE_XZ

		if Class.isCompatibleType(offset, Ray) then
			targetPosition = position + offset.origin
		elseif Class.isCompatibleType(offset, Vector) then
			targetPosition = position + offset
		else
			targetPosition = position
		end

		targetPosition = targetPosition * Vector.PLANE_XZ
	end


	return position, offset, targetPosition
end

-- This is the normal the ship is heading in, NOT the steer direction normal.
-- The steer direction normal is the axis on which 1 or -1 is projected to steer the ship.
function Sailing.getShipForward(ship)
	if Class.isCompatibleType(ship, Peep) then
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		if shipMovement then
			return shipMovement.rotation:transformVector(shipMovement.steerDirectionNormal):getNormal()
		end
	end

	return nil
end

function Sailing.getShipBow(ship, length)
	if Class.isCompatibleType(ship, Peep) then
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		if shipMovement then
			local direction = shipMovement.rotation:transformVector(shipMovement.steerDirectionNormal):getNormal()
			length = (length or shipMovement.length) / 2

			return direction * length
		end

		local rotation = Utility.Peep.getRotation(ship):getNormal()
		local size = Utility.Peep.getSize(ship)
		return rotation:transformVector(Vector(0, 0, size.z / 2))
	end

	return nil
end

function Sailing.getShipSize(ship)
	local shipMovement = ship:getBehavior(ShipMovementBehavior)
	if shipMovement then
		-- todo take into account steer normal
		return Vector(shipMovement.length, 0, shipMovement.beam)
	end

	return Utility.Peep.getSize(ship)
end

function Sailing.getShipStern(ship, length)
	if Class.isCompatibleType(ship, Peep) then
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		if shipMovement then
			local direction = shipMovement.rotation:transformVector(shipMovement.steerDirectionNormal):getNormal()
			length = (length or shipMovement.length) / 2

			return direction * -length
		end

		local rotation = Utility.Peep.getRotation(ship):getNormal()
		local size = Utility.Peep.getSize(ship)
		return rotation:transformVector(Vector(0, 0, -size.z / 2))
	end

	return nil
end

function Sailing.getShipStarboard(ship, beam)
	if Class.isCompatibleType(ship, Peep) then
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		if shipMovement then
			local direction = shipMovement.rotation:transformVector(shipMovement.opposingSteerDirectionNormal):getNormal()
			beam = (beam or shipMovement.beam) / 2

			return direction * beam
		end

		local rotation = Utility.Peep.getRotation(ship):getNormal()
		local size = Utility.Peep.getSize(ship)
		return rotation:transformVector(Vector(size.x / 2, 0, 0))
	end

	return nil
end

function Sailing.getShipPort(ship, beam)
	if Class.isCompatibleType(ship, Peep) then
		local shipMovement = ship:getBehavior(ShipMovementBehavior)
		if shipMovement then
			local direction = shipMovement.rotation:transformVector(shipMovement.opposingSteerDirectionNormal):getNormal()
			beam = (beam or shipMovement.beam) / 2

			return direction * -beam
		end

		local rotation = Utility.Peep.getRotation(ship):getNormal()
		local size = Utility.Peep.getSize(ship)
		return rotation:transformVector(Vector(-size.x / 2, 0, 0))
	end

	return nil
end

function Sailing.calcCannonMinHit(level, bonus)
	return math.max(math.ceil((level + 50) * (bonus + 64) / 640), 1)
end

function Sailing.calcCannonMaxHit(level, bonus)
	return math.max(math.ceil((level + 50) * ((bonus + 64) ^ 1.2) / 640), 1)
end

function Sailing.probeShipCannons(ship, targetPosition, targetNormal, direction, always)
	local director = ship:getDirector()
	local gameDB = director:getGameDB()

	local _, movement = ship:addBehavior(ShipMovementBehavior)
	local selfPosition = Utility.Peep.getPosition(ship)
	local selfForward = movement.rotation:transformVector(movement.steerDirectionNormal) + selfPosition

	local hits = director:probe(
		ship:getLayerName(),
		Probe.layer(ship:getLayer()),
		function(peep)
			local isCannon
			do
				local resource = Utility.Peep.getResource(peep)
				if resource then
					local cannonRecord = gameDB:getRecord("Cannon", {
						Resource = resource
					})

					if cannonRecord then
						isCannon = true
					else
						isCannon = false
					end
				end
			end

			return isCannon
		end)

	local cannons = {}
	for i = 1, #hits do
		local hit = hits[i]
		local resource = Utility.Peep.getResource(hit)
		cannons[i] = gameDB:getRecord("Cannon", {
			Resource = resource
		})
	end

	local positions = {}
	for i = 1, #hits do
		local map = Utility.Peep.getMapScript(hits[i])
		local mapTransform = map and Utility.Peep.getMapTransform(map)
		local position = Utility.Peep.getPosition(hits[i])
		positions[i] = mapTransform and Vector(mapTransform:transformPoint(position:get())) or position
	end

	local canFire = {}
	local distances = {}
	local side = {}
	for i = 1, #hits do
		local isCloseEnough, shipSide
		if targetPosition and targetNormal then
			local origin = targetPosition * Vector.PLANE_XZ
			local v = (positions[i] * Vector.PLANE_XZ) - origin
			local d = v:dot(targetNormal)
			local p = targetPosition + d * targetNormal

			local distance = (positions[i] * Vector.PLANE_XZ - p):getLength()
			isCloseEnough = distance <= cannons[i]:get("Range")
			shipSide = Sailing.getDirection(ship, targetPosition)
		elseif targetPosition then
			local distance = ((positions[i] - targetPosition) * Vector.PLANE_XZ):getLength()
			isCloseEnough = distance <= cannons[i]:get("Range")
			shipSide = Sailing.getDirection(ship, targetPosition)
		elseif direction then
			isCloseEnough = true
			shipSide = targetPosition
		end

		local cannonSide = Sailing.getDirection(ship, positions[i])
		local isSameSide = cannonSide == shipSide

		canFire[i] = (isCloseEnough or always) and isSameSide
		distances[i] = distance
		side[i] = isSameSide
	end

	local actions = {}
	for i = 1, #hits do
		actions[i] = false

		local resource = Utility.Peep.getResource(hits[i])
		local peepActions = Utility.getActions(ship:getDirector():getGameInstance(), resource, 'world')
		for j = 1, #peepActions do
			if peepActions[j].instance:is('fire') then
				actions[i] = peepActions[j].instance
				break
			end
		end
	end

	local result = {}
	for i = 1, #hits do
		result[i] = {
			peep = hits[i],
			cannon = cannons[i],
			position = positions[i],
			canFire = canFire[i],
			isSameSide = side[i],
			distance = distances[i],
			action = actions[i]
		}
	end

	return result
end

function Sailing.fireShipCannons(ship, fireProbe)
	local director = ship:getDirector()
	local crew = director:probe(ship:getLayerName(), Probe.layer(ship:getLayer()), Probe.crew(ship))

	local hits = 0
	for i = 1, #fireProbe do
		local details = fireProbe[i]

		if details.canFire then
			table.sort(crew, function(a, b)
				local aPosition = Utility.Peep.getAbsolutePosition(a)
				local bPosition = Utility.Peep.getAbsolutePosition(b)

				return (aPosition - details.position):getLengthSquared() < (bPosition - details.position):getLengthSquared()
			end)

			for index, crewMember in ipairs(crew) do
				local cannonReady = details.peep:canFire()

				local canFire = cannonReady
				if canFire then
					canFire = details.action:canPerform(crewMember:getState()) and
					          details.action:canTransfer(crewMember:getState())
				end

				if canFire and cannonReady then
					if details.action:perform(crewMember:getState(), crewMember, details.peep) then
						hits = hits + 1
						Log.info("BOOM! '%s' is gonna fire a cannon!", crewMember:getName())

						table.remove(crew, index)
						break
					end
				end
			end
		end
	end

	return hits
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

Sailing.Ship.SIZE_GALLEON    = "Galleon"
Sailing.Ship.SIZE_BRIGANTINE = "Brigantine"
Sailing.Ship.SIZE_SLOOP      = "Sloop"

function Sailing.Ship.getNPCCustomizations(game, shipResource)
	local gameDB = game:getGameDB()

	if type(shipResource) == "string" then
		shipResource = gameDB:getResource(shipResource, "SailingShip")
	end

	if not shipResource then
		return {}
	end

	local result = {}
	local sailingItems = gameDB:getRecords("ShipSailingItem", { Ship = shipResource })
	for _, inputSailingItem in ipairs(sailingItems) do
		local sailingItem = {
			colors = {
				{ inputSailingItem:get("Red1"), inputSailingItem:get("Green1"), inputSailingItem:get("Blue1") },
				{ inputSailingItem:get("Red2"), inputSailingItem:get("Green2"), inputSailingItem:get("Blue2") }
			},

			isColorCustomized = inputSailingItem:get("IsColorCustomized") ~= 0,

			itemGroup = inputSailingItem:get("ItemGroup"),
			slot = inputSailingItem:get("Slot"),
			index = inputSailingItem:get("Index"),

			sailingItemID = inputSailingItem:get("SailingItem").name,
			props = {}
		}

		local props = gameDB:getRecords("ShipSailingItemPropHotspot", { SailingItem = inputSailingItem:get("SailingItem") })
		for _, prop in ipairs(props) do
			sailingItem.props[prop:get("Slot")] = prop:get("Prop").name
		end

		table.insert(result, sailingItem)
	end

	return result
end

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

Sailing.Navigation = {}

Sailing.Navigation.PathFinder = Class(PathFinder)

function Sailing.Navigation.PathFinder:new(nodes, ship)
	PathFinder.new(self, PathFinder.AStar(self))

	self.nodes = nodes
	self.ship = ship

	self.edges = {}
	self.neighborEdges = {}

	self.edgeIDs = {}
	self.edgeID = 0
end

function Sailing.Navigation.PathFinder:getNeighbors(edge, goal)
	if self.neighborEdges[edge.id] then
		return self.neighborEdges[edge.id]
	end

	local neighbors = {}
	for _, neighbor in ipairs(edge.node.neighbors) do
		table.insert(neighbors, self:makeEdge(self.nodes[neighbor], edge, goal))
	end

	self.neighborEdges[edge.id] = neighbors
	return neighbors
end

function Sailing.Navigation.PathFinder:getID(edge)
	local parentID = edge.parent and edge.parent.node.id or 0

	local parents = self.edgeIDs[parentID]
	if not parents then
		parents = {}
		self.edgeIDs[parentID] = parents
	end

	local id = parents[edge.node.id]
	if not id then
		self.edgeID = self.edgeID + 1
		id = self.edgeID

		parents[edge.node.id] = id
	end

	return id
end

function Sailing.Navigation.PathFinder:getCost(edge)
	return edge.cost
end

function Sailing.Navigation.PathFinder:getScore(edge)
	return edge.score
end

function Sailing.Navigation.PathFinder:makeEdge(node, parent, goal)
	local edge = {
		id = #self.edges + 1,
		parent = parent,
		node = node,
		score = 0,
		cost = (parent and parent.cost or 0)
	}

	table.insert(self.edges, edge)

	if goal then
		edge.score = self:getDistance(node.position, goal)

		if parent then
			edge.cost = edge.cost + self:getDistance(self:getLocation(edge), self:getLocation(parent))
		end
	end

	return edge
end

function Sailing.Navigation.PathFinder:getEdge(location)
	for _, edge in ipairs(self.edges) do
		if edge.node.position == location and not edge.parent then
			return edge
		end
	end

	local closest
	local closestDistance = math.huge
	for _, node in ipairs(self.nodes) do
		local distance = (location - node.position):getLengthSquared()
		if distance < closestDistance then
			closest = node
			closestDistance = distance
		end
	end

	return self:makeEdge(closest)
end

function Sailing.Navigation.PathFinder:getLocation(edge)
	return edge.node.position
end

function Sailing.Navigation.PathFinder:getDistance(a, b)
	return (a - b):getLength()
end

function Sailing.Navigation.PathFinder:sameLocation(a, b)
	return a == b
end

function Sailing.Navigation.PathFinder:materialize(edge)
	return PathNode(edge.node.position.x, edge.node.position.z)
end

function Sailing.Navigation.PathFinder:getParent(edge)
	return edge.parent
end

Sailing.Navigation.SHIP_NAVIGATION_POINTS = {
	Vector(-1, 0, -1),
	Vector(0, 0, -1),
	Vector(1, 0, -1),
	Vector(1, 0, 0),
	Vector(1, 0, 1),
	Vector(0, 0, 1),
	Vector(-1, 0, 1),
	Vector(-1, 0, 0)
}

function Sailing.Navigation.getNavigationPoints(ship, sizeOffset)
	local shipSize = Sailing.getShipSize(ship)
	shipSize = shipSize + sizeOffset * 2
	local halfShipSize = shipSize / 2

	local shipMovement = ship:getBehavior(ShipMovementBehavior)
	local rotation = shipMovement and shipMovement.rotation or Quaternion.IDENTITY

	local result = {}
	for _, inputPoint in ipairs(Sailing.Navigation.SHIP_NAVIGATION_POINTS) do
		local outputPoint = rotation:transformVector(inputPoint * halfShipSize)
		table.insert(result, outputPoint)
	end

	return result
end

function Sailing.Navigation.buildNodes(ship, target, offset)
	local director = ship:getDirector()

	local layer
	do
		position = ship:getBehavior(PositionBehavior)
		layer = position and position.layer
		layer = layer or Utility.Peep.getLayer(ship)
	end

	local otherShips = director:probe(
		ship:getLayerName(),
		Probe.layer(layer),
		Probe.component(ShipMovementBehavior))

	local _, _, targetPosition = Sailing.getShipTarget(ship, target, offset)
	if not targetPosition then
		return nil
	end

	local shipMovementCortex = director:getCortex("ShipMovement")
	if not shipMovementCortex then
		return nil
	end

	local shipPosition = Utility.Peep.getPosition(ship) * Vector.PLANE_XZ
	local shipSize = Sailing.getShipSize(ship)
	shipSize = Vector(math.max(shipSize.x, shipSize.z))

	local nodes = {
		{ id = 1, position = shipPosition, neighbors = {} },
		{ id = 2, position = targetPosition, neighbors = {} }
	}
	for otherShipIndex, otherShip in ipairs(otherShips) do
		local otherShipPoints = Sailing.Navigation.getNavigationPoints(otherShip, shipSize)

		local startIndex = #nodes
		for _, otherShipPoint in ipairs(otherShipPoints) do
			local node = {
				id = #nodes + 1,
				shipIndex = otherShipIndex,
				groupID = otherShip:getTally(),
				position = otherShipPoint,
				neighbors = {}
			}

			table.insert(nodes, node)
		end

		for indexOffset = 1, #otherShipPoints do
			local index = startIndex + indexOffset
			local node = nodes[index]

			local previousNeighorIndexOffset = indexOffset - 1
			if previousNeighorIndexOffset <= 0 then
				previousNeighorIndexOffset = #otherShipPoints
			end

			local nextNeighorIndexOffset = indexOffset + 1
			if nextNeighorIndexOffset > #otherShipPoints then
				nextNeighorIndexOffset = 1
			end

			local previousNeighorNode = nodes[startIndex + previousNeighorIndexOffset]
			local nextNeighorNode = nodes[startIndex + nextNeighorIndexOffset]
			table.insert(node.neighbors, previousNeighorNode.id)
			table.insert(node.neighbors, nextNeighorNode.id)
		end
	end

	-- Ew, n ^ 2. If this is a performance issue, we'll need to optimize.
	for i, selfNode in ipairs(nodes) do
		for j, otherNode in ipairs(nodes) do
			if j > i and (selfNode.groupID == nil or otherNode.groupID == nil or selfNode.groupID ~= otherNode.groupID) then
				local ray = Ray(selfNode.position, selfNode.position:direction(otherNode.position))
				local selfDistanceToOther = (selfNode.position - otherNode.position):getLengthSquared()

				local hasCollision = false
				for _, otherShip in ipairs(otherShips) do
					local nearPoint = shipMovementCortex:projectRayAgainstShip(otherShip, ray)
					if nearPoint then
						local selfDistanceToNear = (selfNode.position - nearPoint):getLengthSquared()

						if selfDistanceToNear <= selfDistanceToOther then
							hasCollision = true
							break
						end
					end
				end

				if not hasCollision then
					table.insert(selfNode.neighbors, otherNode.id)
					table.insert(otherNode.neighbors, selfNode.id)
				end
			end
		end
	end

	return nodes, otherShips
end

function Sailing.Navigation.navigate(nodes)
	local path = Sailing.Navigation.PathFinder(nodes):find(nodes[1].position, nodes[2].position)
	if not path or path:getNumNodes() == 0 then
		return nil
	end

	local result = {}
	for i = 1, path:getNumNodes() do
		local node = path:getNodeAtIndex(i)
		table.insert(result, Vector(node.i, 0, node.j))
	end

	return result
end

Sailing.Ocean = {}

function Sailing.Ocean.hasOcean(peep)
	local instance = Utility.Peep.getInstance(peep)
	local mapScript = instance:getBaseMapScript()
	local ocean = mapScript and mapScript:hasBehavior(OceanBehavior)

	return not not ocean
end

function Sailing.Ocean.getPositionRotation(peep)
	local game = peep:getDirector():getGameInstance()

	local position = peep:getBehavior(PositionBehavior)
	local layer = position and position.layer

	if not layer then
		local instance = Utility.Peep.getInstance(peep)
		layer = instance:getBaseLayer()
	end

	local mapScript = Utility.Peep.getInstance(peep):getMapScriptByLayer(layer)
	local ocean = mapScript and mapScript:getBehavior(OceanBehavior)

	-- Beam (width) needs to be projected out a bit, otherwise
	-- the ship/fish/whatever will rotate too violently.
	local beam
	if peep:hasBehavior(ShipMovementBehavior) then
		beam = peep:getBehavior(ShipMovementBehavior).beam * 2
	elseif peep:hasBehavior(SizeBehavior) then
		beam = peep:getBehavior(SizeBehavior).size.x * 2
	end

	local peepLeft = Sailing.getShipPort(peep, beam)
	local peepForward = Sailing.getShipBow(peep)
	local peepBackward = Sailing.getShipStern(peep)

	local windDirection, windSpeed, windPattern = Utility.Map.getWind(game, layer)

	local worldPosition = Utility.Peep.getPosition(peep)
	worldPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(worldPosition.x, -(ocean and ocean.offset or 1), worldPosition.z),
		Vector(worldPosition.x, 0, worldPosition.z))
	local worldPositionXZ = Vector(worldPosition.x, 0, worldPosition.z)

	local worldLeftPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(peepLeft.x, -(ocean and ocean.offset or 1), peepLeft.z) + worldPositionXZ,
		Vector(peepLeft.x, 0, peepLeft.z) + worldPositionXZ)

	local worldForwardPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(peepForward.x, -(ocean and ocean.offset or 1), peepForward.z) + worldPositionXZ,
		Vector(peepForward.x, 0, peepForward.z) + worldPositionXZ)

	local worldBackwardPosition = Utility.Map.transformWorldPositionByWave(
		ocean and ocean.time or 0,
		windSpeed * (ocean and ocean.windSpeedMultiplier or 1),
		windDirection,
		windPattern * (ocean and ocean.windPatternMultiplier or Vector(2, 4, 8)),
		Vector(peepBackward.x, -(ocean and ocean.offset or 1), peepBackward.z) + worldPositionXZ,
		Vector(peepBackward.x, 0, peepBackward.z) + worldPositionXZ)

	local normal
	do
		local s = worldForwardPosition - worldLeftPosition
		local t = worldBackwardPosition - worldForwardPosition
		normal = s:cross(t):getNormal()
	end

	local rotation = Quaternion.fromVectors(Vector.UNIT_Y, normal):getNormal()

	return worldPosition, rotation
end

Sailing.Cannon = {}

Sailing.Cannon.DEFAULT_SPEED     = 32
Sailing.Cannon.DEFAULT_GRAVITY   = Vector(0, -4, 0)
Sailing.Cannon.DEFAULT_DRAG      = 0.99
Sailing.Cannon.DEFAULT_TIMESTEP  = 1 / 10
Sailing.Cannon.DEFAULT_MAX_STEPS = 500

Sailing.Cannon.GLOBAL_MAX_STEPS = 2000

function Sailing.Cannon.getDefaultCannonballPathProperties()
	return {
		speed = Sailing.Cannon.DEFAULT_SPEED,
		speedOffset = 0,
		speedMultiplier = 1,

		gravity = Sailing.Cannon.DEFAULT_GRAVITY,
		gravityOffset = Vector(0),
		gravityMultiplier = Vector(1),

		drag = Sailing.Cannon.DEFAULT_DRAG,
		dragOffset = 0,
		dragMultiplier = 1,

		timestep = Sailing.Cannon.DEFAULT_TIMESTEP,
		timestepOffset = 0,
		timestepMultiplier = 1,

		maxSteps = Sailing.Cannon.DEFAULT_MAX_STEPS,
		maxStepsOffset = 0,
		maxStepsMultiplier = 1
	}
end

function Sailing.Cannon._getCannonballPathProperties(gameDB, resource)
	if not resource then
		return Sailing.Cannon.getDefaultCannonballPathProperties()
	end

	local pathRecord = gameDB:getRecord("CannonballPathProperties", { Resource = resource })
	if not pathRecord then
		return Sailing.Cannon.getDefaultCannonballPathProperties()
	end

	local speed = pathRecord:get("Speed")
	local speedOffset = pathRecord:get("SpeedOffset")
	local speedMultiplier = pathRecord:get("SpeedMultiplier")
	speedMultiplier = speedMultiplier == 0 and 1 or speedMultiplier

	local gravity = Vector(pathRecord:get("GravityX"), pathRecord:get("GravityY"), pathRecord:get("GravityX"))
	local gravityOffset = Vector(pathRecord:get("GravityOffsetX"), pathRecord:get("GravityOffsetY"), pathRecord:get("GravityOffsetX"))
	local gravityMultiplier = Vector(pathRecord:get("GravityMultiplierX"), pathRecord:get("GravityMultiplierY"), pathRecord:get("GravityMultiplierX"))
	gravityMultiplier = gravityMultiplier:getLength() == 0 and Vector(1)

	local drag = pathRecord:get("Drag")
	local dragOffset = pathRecord:get("DragOffset")
	local dragMultiplier = pathRecord:get("DragMultiplier")
	dragMultiplier = dragMultiplier == 0 and 1 or dragMultiplier

	local timestep = pathRecord:get("Timestep")
	local timestepOffset = pathRecord:get("TimestepOffset")
	local timestepMultiplier = pathRecord:get("TimestepMultiplier")
	timestepMultiplier = timestepMultiplier == 0 and 1 or timestepMultiplier

	local maxSteps = pathRecord:get("MaxSteps")
	local maxStepsOffset = pathRecord:get("MaxStepsOffset")
	local maxStepsMultiplier = pathRecord:get("MaxStepsMultiplier")
	maxStepsMultiplier = maxStepsMultiplier == 0 and 1 or maxStepsMultiplier

	return {
		speed = speed,
		speedOffset = speedOffset,
		speedMultiplier = speedMultiplier,

		gravity = gravity,
		gravityOffset = gravityOffset,
		gravityMultiplier = gravityMultiplier,

		drag = drag,
		dragOffset = dragOffset,
		dragMultiplier = dragMultiplier,

		timestep = timestep,
		timestepOffset = timestepOffset,
		timestepMultiplier = timestepMultiplier,

		maxSteps = maxSteps,
		maxStepsOffset = maxStepsOffset,
		maxStepsMultiplier = maxStepsMultiplier,
	}
end

function Sailing.Cannon._mergeCannonballPathProperties(...)
	local result = {}

	for i = 1, select("#", ...) do
		local properties = select(i, ...)

		result.speed = result.speed or properties.speed
		result.gravity = result.gravity or properties.gravity
		result.drag = result.drag or properties.drag
		result.timestep = result.timestep or properties.timestep
		result.maxSteps = result.maxSteps or properties.maxSteps

		result.speed = (result.speed + properties.speedOffset) * properties.speedMultiplier
		result.gravity = (result.gravity + properties.gravityOffset) * properties.gravityMultiplier
		result.drag = (result.drag + properties.dragOffset) * properties.dragMultiplier
		result.timestep = (result.timestep + properties.timestepOffset) * properties.timestepMultiplier
		result.maxSteps = (result.maxSteps + properties.maxStepsOffset) * properties.maxStepsMultiplier
	end

	return result
end

function Sailing.Cannon.getCannonballPathProperties(peep, cannon, ammo)
	local gameDB = peep:getDirector():getGameDB()
	local stage = peep:getDirector():getGameInstance():getStage()

	local cannonResource
	if type(cannon) == "string" then
		cannonResource = gameDB:getRecord(cannon, "SailingItem")
	elseif Class.isCompatibleType(cannon, Peep) then
		local sailingResource = cannon:getBehavior(SailingResourceBehavior)
		if sailingResource and sailingResource.resource then
			cannonResource = sailingResource.resource
		end
	elseif cannon then
		cannonResource = cannon
	end

	local ammoResource
	if type(cannon) == "string" then
		ammoResource = gameDB:getRecord(cannon, "SailingItem")
	elseif Class.isCompatibleType(ammo, Peep) then
		local sailingResource = ammo:getBehavior(SailingResourceBehavior)
		if sailingResource and sailingResource.resource then
			ammoResource = sailingResource.resource
		end
	elseif Class.isCompatibleType(ammo, Item) then
		local itemResource = gameDB:getRecord(ammo:getID(), "Item")
		local ammoRecord = gameDB:getRecord("ItemSailingItemMapping", { Item = itemResource })
		if ammoRecord then
			ammoResource = ammoRecord:get("SailingItem")
		end
	elseif ammo then
		ammoResource = ammo
	end

	local cannonProperties = Sailing.Cannon._getCannonballPathProperties(gameDB, cannonResource)
	local ammoProperties = Sailing.Cannon._getCannonballPathProperties(gameDB, ammoResource)

	return Sailing.Cannon._mergeCannonballPathProperties(cannonProperties, ammoProperties)
end

function Sailing.Cannon.buildCannonballPath(cannon, properties)
	local rotation, position

	if Class.hasInterface(cannon, ICannon) then
		rotation = cannon:getCannonDirection()
		position = cannon:getCannonPosition()
	else
		rotation = Quaternion.IDENTITY
		position = Utility.Peep.getAbsolutePosition(cannon)
	end

	local normal = rotation:transformVector(Vector.UNIT_Z)
	local speed = properties.speed or Sailing.Cannon.DEFAULT_SPEED
	local gravity = properties.gravity or Sailing.Cannon.DEFAULT_GRAVITY
	local drag = properties.drag or Sailing.Cannon.DEFAULT_DRAG
	local timestep = properties.timestep or Sailing.Cannon.DEFAULT_TIMESTEP
	local maxSteps = properties.maxSteps or Sailing.Cannon.DEFAULT_MAX_STEPS
	maxSteps = math.clamp(maxSteps, 1, Sailing.Cannon.GLOBAL_MAX_STEPS)

	local currentStep = 1
	local currentPosition = position
	local currentVelocity = normal * speed

	local path = { { i = 0, time = 0, position = currentPosition, velocity = currentVelocity } }
	while currentStep <= maxSteps and currentPosition.y > 0 do
		local velocityTimestep
		if drag <= 0 or drag >= 1 then
			velocityTimestep = 1
		else
			velocityTimestep = (drag ^ timestep - 1) / math.log(drag)
		end

		currentVelocity = currentVelocity + gravity * timestep
		currentPosition = currentPosition + currentVelocity * velocityTimestep

		if drag > 0 and drag < 1 then
			currentVelocity = currentVelocity * drag ^ timestep
		end

		local pathStep = {
			i = currentStep,
			time = currentStep * timestep,
			position = currentPosition,
			velocity = currentVelocity
		}

		table.insert(path, pathStep)

		currentStep = currentStep + 1
	end

	return path, currentStep * timestep
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
