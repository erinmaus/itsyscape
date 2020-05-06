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
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local DisabledBehavior = require "ItsyScape.Peep.Behaviors.DisabledBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
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

RandomEvent.SPEED_BRAKE      = -1
RandomEvent.SPEED_ACCELERATE = 1

RandomEvent.DIRECTON_LEFT    = -1
RandomEvent.DIRECTON_RIGHT   = 1

RandomEvent.NPC_STOP_DISTANCE = 2

RandomEvent.Ship = Class()
function RandomEvent.Ship:new(mapScript)
	self.ship = mapScript
	self.directionNormal = Vector(-1, 0, 0)
	self.direction = 0
	self.rotation = Quaternion.IDENTITY
	self.speed = 0
end

function RandomEvent.Ship:prepare(director, layer)
	local position = self.ship:getBehavior(PositionBehavior)
	position.offset = Vector(0, 1.5, 0)
	position.layer = layer

	local _, scale = self.ship:addBehavior(ScaleBehavior)
	scale.scale = RandomEvent.SHIP_SCALE

	local map = director:getMap(self.ship:getLayer())
	local _, origin = self.ship:addBehavior(OriginBehavior)
	origin.origin = Vector(map:getWidth(), 0, map:getHeight())

	self.ship:addBehavior(MovementBehavior)
end

function RandomEvent.Ship:update(delta)
	local clampedPlayerSpeed = math.max(self.speed, 0)

	local angle = math.pi / 8 * delta * self.direction * clampedPlayerSpeed
	local rotationStep = Quaternion.fromAxisAngle(Vector.UNIT_Y, angle)
	self.rotation = (self.rotation * rotationStep):getNormal()

	local movement = self.ship:getBehavior(MovementBehavior)
	local accelerationNormal = Quaternion.transformVector(
		self.rotation,
		-Vector.UNIT_X)
	local accelerationStep = accelerationNormal * movement.maxAcceleration * clampedPlayerSpeed
	movement.acceleration = movement.acceleration + accelerationStep

	local clampedVelocity = movement.velocity * Vector(1, 0, 1)
	if clampedVelocity:getLength() > 1 then
		self.directionNormal = clampedVelocity:getNormal()
	end

	local rotation = self.ship:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.lookAt(
		self.directionNormal,
		Vector.ZERO) * Quaternion.Y_90
end

function RandomEvent:onLoad(...)
	Map.onLoad(self, ...)

	local gameDB = self:getDirector():getGameDB()
	local ship = gameDB:getResource("RandomEvent_RumbridgeNavyScout", "SailingShip")

	local _, ship = Utility.Map.spawnShip(
		self,
		"Ship_NPC1",
		self:getLayer(),
		32,
		16,
		2.25)
	ship:pushPoke('customize', ship)
	self.npcShip = RandomEvent.Ship(ship)
	self:prepareNPCShip(Utility.Peep.getPlayer(self), ship)

	self:onStart()
end

function RandomEvent:onStart()
	local player = Utility.Peep.getPlayer(self)
	local playerShip = Utility.Peep.getMapScript(player)
	self.playerShip = RandomEvent.Ship(playerShip)

	self:preparePlayerShip(player, playerShip)
	player:addBehavior(DisabledBehavior)

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

function RandomEvent:preparePlayerShip(player, ship)
	self.playerShip:prepare(self:getDirector(), self:getLayer())

	local shipStats = Sailing.Ship.getStats(player)
	local clampedShipSpeed = math.max(shipStats["Speed"], 200)
	local maxSpeed = clampedShipSpeed / RandomEvent.PLAYER_SPEED_MODIFIER
	local maxAcceleration = clampedShipSpeed / RandomEvent.PLAYER_ACCELERATION_MODIFIER

	local movement = ship:getBehavior(MovementBehavior)
	movement.maxSpeed = maxSpeed
	movement.maxAcceleration = maxAcceleration
	movement.decay = 0.05
end

function RandomEvent:prepareNPCShip(player, ship)
	self.npcShip:prepare(self:getDirector(), self:getLayer())

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

function RandomEvent:updatePlayerShip(delta)
	self.playerShip:update(delta)
end

local function getDirection(a, b, c)
	local result = ((b.x - a.x) * (c.z - a.z) - (b.z - a.z) * (c.x - a.x))

	if result > 0 then
		return 1
	elseif result < 0 then
		return -1
	else
		return 0
	end
end

function RandomEvent:updateNPCShip(delta)
	self.npcShip:update(delta)

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
		playerShipPosition)

	local distance = (playerShipPosition - npcShipPosition):getLength()
	if distance <= RandomEvent.NPC_STOP_DISTANCE then
		self.npcShip.speed = 0
	else
		self.npcShip.speed = 1
	end
end

function RandomEvent:update(director, game)
	Map.update(self, director, game)

	self:updatePlayerShip(game:getDelta())
	self:updateNPCShip(game:getDelta())
end

return RandomEvent
