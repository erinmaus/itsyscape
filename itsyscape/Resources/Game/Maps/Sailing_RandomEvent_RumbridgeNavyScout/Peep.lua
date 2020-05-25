--------------------------------------------------------------------------------
-- Resources/Game/Maps/Sailing_RandomEvent_RumbridgeNavyScout/Peep.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Ray = require "ItsyScape.Common.Math.Ray"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local PlayerShipInventoryStateProvider = require "ItsyScape.Game.PlayerShipInventoryStateProvider"
local Curve = require "ItsyScape.Game.Curve"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local AttackPoke = require "ItsyScape.Peep.AttackPoke"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ScaleBehavior = require "ItsyScape.Peep.Behaviors.ScaleBehavior"
local Map = require "ItsyScape.Peep.Peeps.Map"

local RandomEvent = Class(Map)
RandomEvent.PLAYER_SPEED_MODIFIER = 50
RandomEvent.NPC_SPEED_MODIFIER    = 75

RandomEvent.PLAYER_ACCELERATION_MODIFIER = 25
RandomEvent.NPC_ACCELERATION_MODIFIER    = 25

RandomEvent.SHIP_SCALE = Vector.ONE / 5
RandomEvent.NPC_CANNON_MAX_DISTANCE = 6

RandomEvent.PLAYER_DAMAGE_MODIFIER = 1.25
RandomEvent.NPC_DAMAGE_MODIFIER = 0.75

RandomEvent.SPEED_BRAKE      = -1
RandomEvent.SPEED_ACCELERATE = 1

RandomEvent.DIRECTON_LEFT    = -1
RandomEvent.DIRECTON_RIGHT   = 1

RandomEvent.NPC_STOP_DISTANCE = 2

RandomEvent.SHIP_PUSH_STEP    = 1 / 20

RandomEvent.FLEE_DISTANCE = 20

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

RandomEvent.Ship = Class()
function RandomEvent.Ship:new(mapScript)
	self.ship = mapScript
	self.directionNormal = Vector(-1, 0, 0)
	self.direction = 0
	self.rotation = Quaternion.IDENTITY
	self.speed = 0
	self.shape = {}
end

function RandomEvent.Ship:prepare(director, layer, i, j)
	local map = director:getMap(self.ship:getLayer())
	if not map then
		return
	end

	local position = self.ship:getBehavior(PositionBehavior)
	position.position = map:getTileCenter(i, j)
	position.offset = Vector(0, 1.5, 0)
	position.layer = layer

	local _, scale = self.ship:addBehavior(ScaleBehavior)
	scale.scale = RandomEvent.SHIP_SCALE

	local _, origin = self.ship:addBehavior(OriginBehavior)
	origin.origin = Vector(map:getWidth(), 0, map:getHeight())

	local _, offset = self.ship:addBehavior(MapOffsetBehavior)
	offset.offset = Vector(-map:getWidth(), 0, -map:getHeight())

	self.ship:addBehavior(MovementBehavior)

	-- This is ugly, but this is based on the dimensions of the visible boat.
	-- TODO: Compute visible boat dimensions.
	local width = (map:getWidth() - 5.5) * map:getCellSize()
	local height = (map:getHeight() - 4) * map:getCellSize()
	local radius = height / 2 * scale.scale.z
	local numCircles = width / height * 2
	for i = 1, numCircles do
		local cellSize = width / numCircles
		local circle = {
			x =  i / numCircles * width - radius - width / 2,
			y = 0,
			radius = math.sqrt(radius)
		}

		table.insert(self.shape, circle)
	end

	self.radius = width / 2
end

function RandomEvent.Ship:steer(delta, direction, clampedPlayerSpeed)
	local angle = math.pi / 8 * delta * direction * clampedPlayerSpeed
	local rotationStep = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
	self.rotation = (self.rotation * rotationStep):getNormal()
end

function RandomEvent.Ship:update(delta)
	local clampedPlayerSpeed = math.max(self.speed, 0)

	self:steer(delta, self.direction, clampedPlayerSpeed)

	local movement = self.ship:getBehavior(MovementBehavior)
	local accelerationNormal = Quaternion.transformVector(
		self.rotation,
		-Vector.UNIT_X)
	local accelerationStep = accelerationNormal * movement.maxAcceleration * clampedPlayerSpeed
	movement.acceleration = movement.acceleration + accelerationStep

	self.directionNormal = accelerationNormal

	local rotation = self.ship:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.lookAt(
		self.directionNormal,
		Vector.ZERO) * Quaternion.Y_90
end

function RandomEvent.Ship:handleIslandCollisions(islands)
	local director = self.ship:getDirector()
	if not director then
		return
	end

	local map, position
	do
		local p = self.ship:getBehavior(PositionBehavior)

		map = director:getMap(p.layer)
		position = p.position
	end

	if not map then
		return
	end

	local direction
	do
		local rotation = self.ship:getBehavior(RotationBehavior)
		direction = Quaternion.transformVector(
			self.rotation,
			-Vector.UNIT_X)
	end

	local currentTile, currentI, currentJ = map:getTileAt(position.x, position.z)
	local bowTile, bowI, bowJ = map:getTileAt(
		position.x + direction.x * map:getCellSize(),
		position.z + direction.z * map:getCellSize())

	for i = 1, #islands do
		local island = islands[i]
		local islandCenter = island.position * Vector.PLANE_XZ
		local radius = island.radius * map:getCellSize()
		local radiusSquared = radius ^ 2

		local difference = position * Vector.PLANE_XZ - islandCenter
		local distanceSquared = difference:getLengthSquared()
		if distanceSquared < radiusSquared then
			local p = self.ship:getBehavior(PositionBehavior)
			local y = p.position.y * Vector.UNIT_Y
			p.position = islandCenter + difference / math.sqrt(distanceSquared) * radius + y

			local centerPoint = position
			local forwardPoint = centerPoint + direction * map:getCellSize()
			local originPoint = islandCenter
			local steerDirection = getDirection(centerPoint, forwardPoint, originPoint)
			self:steer(1 / 20, steerDirection, 1)
		end
	end
end

function RandomEvent.Ship:isColliding(other)
	local otherTransform = Utility.Peep.getTransform(other.ship)
	local selfTransform = Utility.Peep.getTransform(self.ship)

	for i = 1, #other.shape do
		local otherCircle = other.shape[i]
		local otherCircleX, _, otherCircleY = otherTransform:transformPoint(otherCircle.x, 0, otherCircle.y)
		local otherCircleRadius = otherCircle.radius

		for j = 1, #self.shape do
			local selfCircle = self.shape[j]
			local selfCircleX, _, selfCircleY = selfTransform:transformPoint(selfCircle.x, 0, selfCircle.y)
			local selfCircleRadius = selfCircle.radius

			do
				local differenceX = (otherCircleX - selfCircleX) ^ 2
				local differenceY = (otherCircleY - selfCircleY) ^ 2
				local radiusSumSquared = (otherCircleRadius + selfCircleRadius) ^ 2

				if differenceX + differenceY <= radiusSumSquared then
					return true
				end
			end
		end
	end

	return false
end

function RandomEvent.Ship:handleShipCollision(other)
	local selfPositionBehavior = self.ship:getBehavior(PositionBehavior)
	local otherPositionBehavior = other.ship:getBehavior(PositionBehavior)

	local didCollide = false
	while self:isColliding(other) do
		local selfPosition = selfPositionBehavior.position * Vector.PLANE_XZ
		local otherPosition = otherPositionBehavior.position * Vector.PLANE_XZ

		local difference = selfPosition - otherPosition
		local normal = difference:getNormal()

		local selfPush = (normal * RandomEvent.SHIP_PUSH_STEP)
		local otherPush = (-normal * RandomEvent.SHIP_PUSH_STEP)

		selfPositionBehavior.position = selfPositionBehavior.position + selfPush
		otherPositionBehavior.position = otherPositionBehavior.position + otherPush

		didCollide = true
	end

	if didCollide then
		self.ship:poke('hit', AttackPoke({
			weaponType = 'ship',
			damage = 0
		}))
		other.ship:poke('hit', AttackPoke({
			weaponType = 'ship',
			damage = 0
		}))
	end
end

function RandomEvent.Ship:tryFire(otherShip)
	local director = self.ship:getDirector()
	local gameDB = director:getGameDB()
	local selfMapResource = Utility.Peep.getResource(self.ship)
	local otherPosition = Utility.Peep.getPosition(otherShip.ship)
	local selfPosition = Utility.Peep.getPosition(self.ship)
	local selfForward = self.rotation:transformVector(-Vector.UNIT_X) + selfPosition

	local hits = director:probe(
		self.ship:getLayerName(),
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

			local isLayer
			do
				local peepMapResource = Utility.Peep.getMapResource(peep)
				isLayer = peepMapResource.id.value == selfMapResource.id.value
			end

			return isLayer and isCannon
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
		local mapTransform = Utility.Peep.getMapTransform(map)
		local position = hits[i]:getBehavior(PositionBehavior).position
		positions[i] = Vector(mapTransform:transformPoint(position:get()))
	end

	local canFire = {}
	local distances = {}
	for i = 1, #hits do
		local distance = (positions[i] * Vector.PLANE_XZ - otherPosition * Vector.PLANE_XZ):getLength()
		local isCloseEnough = distance <= cannons[i]:get("Range")

		local cannonSide = getDirection(selfPosition, selfForward, positions[i])
		local shipSide = getDirection(selfPosition, selfForward, otherPosition)
		local isSameSide = cannonSide == shipSide

		canFire[i] = isCloseEnough and isSameSide
		distances[i] = distance
	end

	local actions = {}
	for i = 1, #hits do
		actions[i] = false

		local resource = Utility.Peep.getResource(hits[i])
		local peepActions = Utility.getActions(
			self.ship:getDirector():getGameInstance(), resource, 'world')
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
			distance = distances[i],
			action = actions[i]
		}
	end

	return result
end

function RandomEvent.Ship:fire(otherShip, fireProbe, player)
	fireProbe = fireProbe or self:tryFire(otherShip)

	local stage = self.ship:getDirector():getGameInstance():getStage()
	local otherPosition = Utility.Peep.getPosition(otherShip.ship) + Vector.UNIT_Y
	local selfPosition = Utility.Peep.getPosition(self.ship) + Vector.UNIT_Y

	for i = 1, #fireProbe do
		local details = fireProbe[i]
		if details.canFire then
			local cannonReady = details.peep:canFire()

			local canFire = cannonReady
			if player and canFire then
				canFire = details.action:canPerform(player:getState(), player) and
				          details.action:transfer(player:getState(), player)
			end

			local damageMultiplier
			if player then
				damageMultiplier = RandomEvent.PLAYER_DAMAGE_MODIFIER
			else
				damageMultiplier = RandomEvent.NPC_DAMAGE_MODIFIER
			end

			if canFire and cannonReady then
				local ray = Ray(details.position, (otherPosition - details.position):getNormal())
				stage:fireProjectile(
					details.cannon:get("Cannonball").name .. "_Small",
					ray.origin,
					ray:project(details.cannon:get("Range")))
				
				local attackPoke = AttackPoke({
					weaponType = 'cannon',
					damage = math.floor(math.random(details.cannon:get("MinDamage"), details.cannon:get("MaxDamage")) * damageMultiplier),
					aggressor = Utility.Peep.getMapScript(self.ship)
				})
				otherShip.ship:poke('hit', attackPoke)

				details.peep:poke('cooldown')

				Log.info("BOOM! Fired a cannon, dealing %d damage.", attackPoke:getDamage())
			else
				Log.info("Can't fire cannon: out of supplies or requirements not met.")
			end
		end
	end
end

function RandomEvent:onLoad(...)
	Map.onLoad(self, ...)

	local gameDB = self:getDirector():getGameDB()
	local player = Utility.Peep.getPlayer(self)

	local scout = gameDB:getResource("RandomEvent_RumbridgeNavyScout", "SailingShip") 
	local _, ship = Utility.Map.spawnShip(
		self,
		"Ship_NPC1",
		self:getLayer(),
		32,
		24,
		2.25)
	ship:pushPoke('customize', scout)
	ship:listen('sunk', self.onEnd, self, 'ko')
	ship:listen('sink', self.onNPCShipSink, self)
	self.npcShip = RandomEvent.Ship(ship)
	self:prepareNPCShip(player, ship, 32, 24)

	Utility.UI.openInterface(player, "BossHUD", false)

	self:onStart()
	self:pullIslands()
end

function RandomEvent:pullIslands()
	local gameDB = self:getDirector():getGameDB()
	local mapResource = Utility.Peep.getMapResource(self)
	local records = gameDB:getRecords("SailingRandomEventIsland", {
		Map = mapResource
	})

	self.islands = {}
	for i = 1, #records do
		local record = records[i]
		local island = {
			position = Vector(
				record:get("PositionX"),
				record:get("PositionY"),
				record:get("PositionZ")),
			radius = record:get("Radius")
		}

		table.insert(self.islands, island)
	end
end

function RandomEvent:onStart()
	local player = Utility.Peep.getPlayer(self)
	local playerShip = Utility.Peep.getMapScript(player)
	self.playerShip = RandomEvent.Ship(playerShip)
	playerShip:listen('sink', self.onEnd, 'sunk')

	self:preparePlayerShip(player, playerShip, 32, 32)
	player:addBehavior(DisabledBehavior)

	self.shipProvider = PlayerShipInventoryStateProvider(player)
	player:getState():addProvider("Item", self.shipProvider)

	local function directionCallback(direction)
		return function(action)
				if action == 'pressed' then
					self:onPlayerShipChangeDirection(player, playerShip, direction)
				else
					self:onPlayerShipChangeDirection(player, playerShip, -direction)
				end
			end
	end

	local function speedCallback(direction)
		return function(action)
			if action == 'pressed' then
				self:onPlayerShipChangeSpeed(player, playerShip, direction)
			else
				self:onPlayerShipChangeSpeed(player, playerShip, -direction)
			end
		end
	end

	local function openCallback()
		return not self:wasPoofed()
	end

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"PLAYER_1_MOVE_UP", speedCallback(1), openCallback)

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"PLAYER_1_MOVE_DOWN", speedCallback(-1), openCallback)

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"PLAYER_1_MOVE_LEFT", directionCallback(1), openCallback)

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"PLAYER_1_MOVE_RIGHT", directionCallback(-1), openCallback)

	local function fireCallback(action)
		self:onPlayerShipFire(action)
	end

	Utility.UI.openInterface(
		player,
		"KeyboardAction",
		false,
		"SAILING_ACTION_PRIMARY", fireCallback, openCallback)
end

function RandomEvent:onEnd(action)
	local player = Utility.Peep.getPlayer(self)
	local sailingLevel = player:getState():count("Skill", "Sailing", { ['skill-as-level'] = true, ['skill-unboosted'] = true })

	local xp
	if action == 'flee' then
		Log.info("Fleed!")
		xp = Curve.xpForResource(Curve.NORMAL_RESOURCE_CURVE, sailingLevel)
	elseif action == 'ko' then
		Log.info("It's a KO!")
		xp = Curve.xpForResource(Curve.ELITE_RESOURCE_CURVE, sailingLevel)
	elseif action == 'sunk' then
		Log.info("YOU SUNK!")
		xp = Curve.xpForResource(Curve.NORMAL_RESOURCE_CURVE, math.max(sailingLevel - 20, 1))
	else
		Log.warn("Unknown end condition.")
		xp = 1
	end

	Log.info("Got %d Sailing XP.", xp)
	player:getState():give("Skill", "Sailing", xp)
	player:removeBehavior(DisabledBehavior)

	Sailing.Orchestration.step(player)
end

function RandomEvent:onNPCShipSink()
	self.isNPCSunk = true
end

function RandomEvent:preparePlayerShip(player, ship, i, j)
	self.playerShip:prepare(self:getDirector(), self:getLayer(), i, j)

	local shipStats = Sailing.Ship.getStats(player)
	local clampedShipSpeed = math.max(shipStats["Speed"], 200)
	local maxSpeed = clampedShipSpeed / RandomEvent.PLAYER_SPEED_MODIFIER
	local maxAcceleration = clampedShipSpeed / RandomEvent.PLAYER_ACCELERATION_MODIFIER

	local movement = ship:getBehavior(MovementBehavior)
	movement.maxSpeed = maxSpeed
	movement.maxAcceleration = maxAcceleration
	movement.decay = 0.05
end

function RandomEvent:prepareNPCShip(player, ship, i, j)
	self.npcShip:prepare(self:getDirector(), self:getLayer(), i, j)

	local shipStats = Sailing.Ship.getStats(player)
	local clampedShipSpeed = math.max(shipStats["Speed"], 200)
	local maxSpeed = clampedShipSpeed / RandomEvent.NPC_SPEED_MODIFIER
	local maxAcceleration = clampedShipSpeed / RandomEvent.NPC_ACCELERATION_MODIFIER

	local movement = ship:getBehavior(MovementBehavior)
	movement.maxSpeed = maxSpeed
	movement.maxAcceleration = maxAcceleration
	movement.decay = 0.05
end

function RandomEvent:onPlayerShipChangeDirection(player, ship, direction)
	self.playerShip.direction = self.playerShip.direction + direction
end

function RandomEvent:onPlayerShipChangeSpeed(player, ship, direction)
	self.playerShip.speed = self.playerShip.speed + direction
end

function RandomEvent:onPlayerShipFire(action)
	if action == 'pressed' then
		self.playerShip:fire(self.npcShip, nil, Utility.Peep.getPlayer(self))
	end
end

function RandomEvent:updatePlayerShip(delta)
	self.playerShip:update(delta)
	self.playerShip:handleIslandCollisions(self.islands)
end

function RandomEvent:updateNPCShip(delta)
	self.npcShip:update(delta)
	self.npcShip:handleIslandCollisions(self.islands)

	local isReady = self.npcShip.ship:getDirector()
	if not isReady then
		return
	end

	if self.isNPCSunk then
		self.npcShip.speed = 0
		return
	end

	local npcShipPosition
	do
		local position = self.npcShip.ship:getBehavior(PositionBehavior)
		npcShipPosition = position.position
	end

	local playerShipPosition
	do
		local position = self.playerShip.ship:getBehavior(PositionBehavior)
		local rotation = self.playerShip.ship:getBehavior(RotationBehavior)

		local adjustedRotation = rotation.rotation * Quaternion.Y_90

		local position1 = position.position + adjustedRotation:transformVector(-Vector.UNIT_X * 5)
		local position2 = position.position + adjustedRotation:transformVector(Vector.UNIT_X * 5)

		local distance1 = (position1 - npcShipPosition):getLengthSquared()
		local distance2 = (position2 - npcShipPosition):getLengthSquared()

		if distance1 < distance2 then
			playerShipPosition = position1
		else
			playerShipPosition = position2
		end
	end

	local npcShipForward = self.npcShip.rotation:transformVector(-Vector.UNIT_X)

	self.npcShip.direction = -getDirection(
		npcShipPosition,
		npcShipForward + npcShipPosition,
		playerShipPosition,
		1)

	local distance = (playerShipPosition - npcShipPosition):getLength()
	if distance <= RandomEvent.NPC_STOP_DISTANCE then
		self.npcShip.speed = 0
	else
		self.npcShip.speed = 1
	end

	local fireProbe = self.npcShip:tryFire(self.playerShip)
	local canFire
	do
		for i = 1, #fireProbe do
			canFire	= canFire or (fireProbe[i].canFire and fireProbe[i].distance < RandomEvent.NPC_CANNON_MAX_DISTANCE)
		end

		canFire	= canFire and math.random(100) > 90
	end

	if canFire then
		self.npcShip:fire(self.playerShip, fireProbe)
	end
end

function RandomEvent:update(director, game)
	Map.update(self, director, game)

	self:updatePlayerShip(game:getDelta())
	self:updateNPCShip(game:getDelta())
	self.playerShip:handleShipCollision(self.npcShip)

	local playerShipPosition = Utility.Peep.getPosition(self.playerShip.ship)
	local npcShipPosition = Utility.Peep.getPosition(self.npcShip.ship)
	local distance = (playerShipPosition - npcShipPosition):getLength()
	if distance > RandomEvent.FLEE_DISTANCE then
		self:onEnd('flee')
	end
end

return RandomEvent
