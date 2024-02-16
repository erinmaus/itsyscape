--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/ShipMovementCortex.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local Cortex = require "ItsyScape.Peep.Cortex"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local MapOffsetBehavior = require "ItsyScape.Peep.Behaviors.MapOffsetBehavior"
local OceanBehavior = require "ItsyScape.Peep.Behaviors.OceanBehavior"
local OriginBehavior = require "ItsyScape.Peep.Behaviors.OriginBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local ShipMovementCortex = Class(Cortex)

ShipMovementCortex.Ship = Class()
ShipMovementCortex.Ship.MAX_ACCELERATION_DENOMINATOR = 45
ShipMovementCortex.Ship.MAX_SPEED_DENOMINATOR = 55
ShipMovementCortex.Ship.PUSH_STEP = 1 / 2

function ShipMovementCortex.Ship:new(peep)
	self.ship = peep
	self.shape = {}
end

function ShipMovementCortex.Ship:prepare()
	local director = self.ship:getDirector()
	local map = director:getMap(self.ship:getLayer())
	if not map then
		return
	end

	local _, origin = self.ship:addBehavior(OriginBehavior)
	origin.origin = Vector(map:getWidth(), 0, map:getHeight())

	local _, offset = self.ship:addBehavior(MapOffsetBehavior)
	offset.offset = Vector(-map:getWidth(), 0, -map:getHeight())

	local _, movement = self.ship:addBehavior(MovementBehavior)
	movement.noClip = true

	local width = (map:getWidth() - 5.5) * map:getCellSize()
	local height = (map:getHeight() - 4) * map:getCellSize()
	local radius = height / 2
	local numCircles = width / height * 2 + 1
	for i = 1, numCircles do
		local cellSize = width / numCircles
		local circle = {
			x =  i / numCircles * width - radius - width / 2,
			y = 0,
			radius = math.sqrt(radius * 1.25)
		}

		table.insert(self.shape, circle)
	end

	local _, shipMovement = self.ship:addBehavior(ShipMovementBehavior)
	shipMovement.length = map:getWidth() * map:getCellSize()
	shipMovement.beam = map:getHeight() * map:getCellSize()
end

function ShipMovementCortex.Ship:getRadius()
	local director = self.ship:getDirector()
	local map = director:getMap(self.ship:getLayer())
	if not map then
		return 0
	end

	local width = map:getWidth() * map:getCellSize()
	local height = map:getHeight() * map:getCellSize()

	return math.max(width, height)
end

function ShipMovementCortex.Ship:steer(steerDirection, rudder)
	steerDirection = steerDirection or 0
	rudder = math.clamp(rudder or 1)

	local _, shipStats = self.ship:addBehavior(ShipStatsBehavior)
	local turnRadius = math.rad(shipStats.bonuses[ShipStatsBehavior.STAT_TURN])
	turnRadius = math.max(turnRadius, math.pi / 16) -- clamp the minimum to something sensible

	local shipMovement = self.ship:getBehavior(ShipMovementBehavior)
	local angle = turnRadius * steerDirection * rudder
	shipMovement.angularAcceleration = shipMovement.angularAcceleration + angle
end

function ShipMovementCortex.Ship:move(delta)
	local ocean
	do
		local instance = Utility.Peep.getInstance(self.ship)
		local position = self.ship:getBehavior(PositionBehavior)
		local layer = position and position.layer or instance:getBaseLayer()
		local oceanMapScript = instance:getMapScriptByLayer(layer)
		ocean = oceanMapScript and oceanMapScript:getBehavior(OceanBehavior)
	end

	local _, movement = self.ship:addBehavior(MovementBehavior)
	local _, shipMovement = self.ship:addBehavior(ShipMovementBehavior)
	local _, shipStats = self.ship:addBehavior(ShipStatsBehavior)

	if shipMovement.steerDirection ~= 0 and shipMovement.isMoving then
		self:steer(shipMovement.steerDirection, shipMovement.rudder)
		shipMovement.steerDirection = 0
	end

	local maxAcceleration = math.max(shipStats.bonuses[ShipStatsBehavior.STAT_SPEED] / self.MAX_ACCELERATION_DENOMINATOR, 1)
	local maxSpeed = math.max(shipStats.bonuses[ShipStatsBehavior.STAT_SPEED] / self.MAX_SPEED_DENOMINATOR, 1)
	movement.isStopping = not shipMovement.isMoving
	movement.maxAcceleration = maxAcceleration
	movement.maxSpeed = maxSpeed
	movement.accelerationDecay = shipMovement.baseAccelerationDecay
	movement.velocityDecay = shipMovement.baseVelocityDecay

	if movement.acceleration:getLength() > 0 then
		local velocityDirection = movement.velocity:getNormal()
		local accelerationDirection = movement.acceleration:getNormal()

		local dot = math.min(math.max(velocityDirection:dot(accelerationDirection), 0), 1)
		local angle = math.acos(dot)

		shipMovement.angularAcceleration = shipMovement.angularAcceleration + angle
	end

	local rotationStep = Quaternion.fromAxisAngle(Vector.UNIT_Y, shipMovement.angularAcceleration * delta)
	shipMovement.rotation = (shipMovement.rotation * rotationStep):getNormal()
	shipMovement.angularAcceleration = 0

	local steerDirectionNormal = shipMovement.steerDirectionNormal
	local currentDirectionNormal = Quaternion.transformVector(shipMovement.rotation, steerDirectionNormal)

	local rotation = Quaternion.lookAt(currentDirectionNormal, Vector.ZERO)
	if ocean then
		local delta = love.timer.getTime() * ocean.weatherRockMultiplier
		local mu = math.sin(delta)
		local angle = mu * ocean.weatherRockRange

		rotation = rotation * Quaternion.fromAxisAngle(shipMovement.rockDirectionNormal, angle)
	end
	Utility.Peep.setRotation(self.ship, (rotation * Quaternion.Y_90):getNormal())

	if shipMovement.isMoving then
		local acceleration = currentDirectionNormal * movement.maxAcceleration
		movement.acceleration = movement.acceleration + acceleration
	end
end

function ShipMovementCortex.Ship:projectRay(ray)
	local selfTransform = Utility.Peep.getTransform(self.ship)

	-- Make the ray planar (XZ).
	ray = Ray(ray.origin * Vector.PLANE_XZ, (ray.direction * Vector.PLANE_XZ):getNormal())

	for i = 1, #self.shape do
		local selfCircle = self.shape[i]
		local selfCircleX, _, selfCircleY = selfTransform:transformPoint(selfCircle.x, 0, selfCircle.y)
		local selfCircleRadius = selfCircle.radius
		local selfCirclePosition = Vector(selfCircleX, 0, selfCircleY)

		-- https://www.bluebill.net/circle_ray_intersection.html#example
		local U = selfCirclePosition - ray.origin
		local U1 = U:dot(ray.direction) * ray.direction
		local U2 = U - U1
		local d = U2:getLength()
		if d < selfCircleRadius then
			local m = math.sqrt(selfCircleRadius ^ 2 - d ^ 2)
			local P1 = ray.origin + U1 + m * ray.direction
			local P2 = ray.origin + U1 - m * ray.direction

			return P2, P1
		end
	end

	return nil
end

function ShipMovementCortex.Ship:avoid(otherShip, bowPosition)
	if otherShip == self then
		return
	end

	local selfPosition = Utility.Peep.getPosition(self.ship)
	local distance = (selfPosition - bowPosition):getLength()
	if distance < self:getRadius() then
		local direction = -Sailing.getDirection(self.ship, Utility.Peep.getPosition(otherShip.ship))
		otherShip:steer(direction)
	end
end

function ShipMovementCortex.Ship:isColliding(other)
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

function ShipMovementCortex.Ship:handleShipCollision(other)
	local _, selfPositionBehavior = self.ship:addBehavior(PositionBehavior)
	local _, otherPositionBehavior = other.ship:addBehavior(PositionBehavior)

	local didCollide = false
	while self:isColliding(other) do
		local selfPosition = selfPositionBehavior.position * Vector.PLANE_XZ
		local otherPosition = otherPositionBehavior.position * Vector.PLANE_XZ

		local difference = selfPosition - otherPosition
		local normal = difference:getNormal()

		local selfPush = (normal * self.PUSH_STEP)
		local otherPush = (-normal * self.PUSH_STEP)

		selfPositionBehavior.position = selfPositionBehavior.position + selfPush
		otherPositionBehavior.position = otherPositionBehavior.position + otherPush

		didCollide = true
	end

	if didCollide then
		self.ship:poke('rock')
		other.ship:poke('rock')
	end
end

function ShipMovementCortex.Ship:update(delta)
	self:steer(delta)
	self:move(delta)
end

function ShipMovementCortex:new()
	Cortex.new(self)

	self:require(ShipMovementBehavior)
	self:require(ShipStatsBehavior)
	self:require(MovementBehavior)

	self.ships = {}
	self.pendingShips = {}
end

function ShipMovementCortex:addPeep(peep)
	Cortex.addPeep(self, peep)

	self.ships[peep] = ShipMovementCortex.Ship(peep)
	self.pendingShips[peep] = true
end

function ShipMovementCortex:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.ships[peep] = nil
	self.pendingShips[peep] = nil
end

function ShipMovementCortex:projectRay(ray, key)
	local results = {}
	for peep in self:iterate() do
		if not self.pendingShips[peep] and peep:getLayerName() == key then
			local ship = self.ships[peep]

			local closePoint, farPoint = ship:projectRay(ray)
			if closePoint and farPoint then
				table.insert(results, {
					peep = peep,
					closePoint = closePoint,
					farPoint = farPoint
				})
			end
		end
	end

	return results
end

function ShipMovementCortex:avoid(otherShipPeep)
	if self.pendingShips[otherShipPeep] then
		return
	end

	local otherShip = self.ships[otherShipPeep]
	for peep in self:iterate() do
		if not self.pendingShips[peep] and peep:getLayerName() == otherShipPeep:getLayerName() then
			local ship = self.ships[peep]

			local bowPosition
			do
				local bow = Sailing.getShipBow(otherShipPeep)
				local position = Utility.Peep.getPosition(otherShipPeep)
				bowPosition = position + bow
			end

			if bowPosition then
				ship:avoid(otherShip, bowPosition)
			end
		end
	end
end

function ShipMovementCortex:update(delta)
	for peep in pairs(self.pendingShips) do
		if peep:getIsReady() then
			local ship = self.ships[peep]
			ship:prepare()

			self.pendingShips[peep] = nil
		end
	end

	for peep in self:iterate() do
		if not self.pendingShips[peep] then
			local ship = self.ships[peep]
			ship:update(delta)
		end
	end

	for currentPeep in self:iterate() do
		for otherPeep in self:iterate() do
			if currentPeep ~= otherPeep and currentPeep:getLayerName() == otherPeep:getLayerName() then
				local currentShip = self.ships[currentPeep]
				local otherShip = self.ships[otherPeep]

				currentShip:handleShipCollision(otherShip)
			end
		end
	end
end

return ShipMovementCortex
