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
RandomEvent.PLAYER_ACCELERATION_MODIFIER = 25
RandomEvent.SHIP_SCALE = Vector.ONE / 5

RandomEvent.SPEED_BRAKE      = -1
RandomEvent.SPEED_ACCELERATE = 1

RandomEvent.DIRECTON_LEFT    = -1
RandomEvent.DIRECTON_RIGHT   = 1

function RandomEvent:onLoad(...)
	Map.onLoad(self, ...)

	self:onStart()
end

function RandomEvent:onStart()
	local player = Utility.Peep.getPlayer(self)
	local playerShip = Utility.Peep.getMapScript(player)

	self:preparePlayerShip(player, playerShip)
	player:addBehavior(DisabledBehavior)

	self.direction = Vector(-1, 0, 0)

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

	self.playerDirection = 0
	self.playerSpeed = 0
	self.playerRotation = Quaternion.IDENTITY
	self.playerVelocity = Vector.ZERO

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
	local position = ship:getBehavior(PositionBehavior)
	position.offset = Vector(0, 1.5, 0)
	position.layer = self:getLayer()

	local _, scale = ship:addBehavior(ScaleBehavior)
	scale.scale = RandomEvent.SHIP_SCALE

	local map = self:getDirector():getMap(ship:getLayer())
	local _, origin = ship:addBehavior(OriginBehavior)
	origin.origin = Vector(map:getWidth(), 0, map:getHeight())

	ship:addBehavior(MovementBehavior)

	local shipStats = Sailing.Ship.getStats(player)
	local clampedShipSpeed = math.max(shipStats["Speed"], 200)
	local maxSpeed = clampedShipSpeed / RandomEvent.PLAYER_SPEED_MODIFIER
	local maxAcceleration = clampedShipSpeed / RandomEvent.PLAYER_ACCELERATION_MODIFIER

	local movement = ship:getBehavior(MovementBehavior)
	movement.maxSpeed = maxSpeed
	movement.maxAcceleration = maxAcceleration
	movement.decay = 0.05
end

function RandomEvent:onPlayerShipChangeDirection(player, ship, direction)
	self.playerDirection = self.playerDirection + direction
end

function RandomEvent:onPlayerShipChangeSpeed(player, ship, direction)
	self.playerSpeed = self.playerSpeed + direction
end

function RandomEvent:update(director, game)
	Map.update(self, director, game)

	local player = Utility.Peep.getPlayer(self)
	local playerShip = Utility.Peep.getMapScript(player)

	local clampedPlayerSpeed = math.max(self.playerSpeed, 0)

	local playerRotationStep = Quaternion.fromAxisAngle(Vector.UNIT_Y, math.pi / 8 * game:getDelta() * self.playerDirection * clampedPlayerSpeed)
	self.playerRotation = (self.playerRotation * playerRotationStep):getNormal()

	local movement = playerShip:getBehavior(MovementBehavior)
	local accelerationNormal = Quaternion.transformVector(
		self.playerRotation,
		-Vector.UNIT_X)
	local accelerationStep = accelerationNormal * movement.maxAcceleration * clampedPlayerSpeed
	movement.acceleration = movement.acceleration + accelerationStep

	local clampedVelocity = movement.velocity * Vector(1, 0, 1)
	if clampedVelocity:getLength() > 0.1 then
		self.direction = clampedVelocity:getNormal()
	end

	local rotation = playerShip:getBehavior(RotationBehavior)
	rotation.rotation = Quaternion.lookAt(
		self.direction,
		Vector.ZERO) * Quaternion.Y_90
end

return RandomEvent
