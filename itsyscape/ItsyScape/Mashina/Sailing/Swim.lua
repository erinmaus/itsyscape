--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/Swim.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"

local Swim = B.Node("Swim")
Swim.TARGET = B.Reference()
Swim.OFFSET = B.Reference()
Swim.DISTANCE = B.Reference()
Swim.FACE3D = B.Reference()
Swim.FACE2D = B.Reference()

function Swim:update(mashina, state, executor)
	local distance = state[self.DISTANCE] or 0
	local target = state[self.TARGET]
	local offset = state[self.OFFSET]
	local face3D = state[self.FACE3D]
	local face2D = state[self.FACE2D]

	local movement = mashina:getBehavior(MovementBehavior)
	if not movement then
		return B.Status.Failure
	end

	local otherPosition, otherOffset = Sailing.getShipTarget(mashina, target, offset)
	if not otherPosition then
		return B.Status.Failure
	end

	local targetPosition
	if Class.isCompatibleType(otherOffset, Ray) then
		targetPosition = otherPosition + otherOffset.origin
	elseif Class.isCompatibleType(otherOffset, Vector) then
		targetPosition = otherPosition + otherOffset
	else
		targetPosition = otherPosition
	end	
	targetPosition = targetPosition * Vector.PLANE_XZ

	local currentPosition = Utility.Peep.getPosition(mashina) * Vector.PLANE_XZ
	local distanceFromTarget = (targetPosition - currentPosition):getLength()
	local direction = (targetPosition - currentPosition):getNormal()

	local isClose = false
	if Class.isCompatibleType(otherOffset, Ray) then
		local ray = Ray(targetPosition, otherOffset.direction)
		local _, A = ray:closest(currentPosition)
		local isWithinTargetDistance = (A - targetPosition):getLength() < distance

		local size = Utility.Peep.getSize(mashina)
		local isWithinWidth = (A - currentPosition):getLength() < size.x / 2
		isClose = isWithinTargetDistance and isWithinWidth
	end

	if Class.isCompatibleType(target, Peep) then
		local shipMovement = target:getBehavior(ShipMovementBehavior)

		if shipMovement and face3D and mashina:hasBehavior(RotationBehavior) then
			local rotation = shipMovement.rotation
			if face2D then
				local inverseRotation = -rotation
				local inverseTransformedDirection = inverseRotation:transformVector(direction)
				if inverseTransformedDirection.x < 0 then
					-- Rotation 180 to face left.
					-- Do nothing otherwise. Objects using 2D facing default to facing +X.
					rotation = rotation * Quaternion.Y_180
				end
			end

			Utility.Peep.setRotation(mashina, rotation)
		end

		if shipMovement then
			-- Try and avoid the ship.

			local radius = math.max(shipMovement.length, shipMovement.beam) / 2

			local projectedPosition = currentPosition + movement.velocity * Vector.PLANE_XZ
			local projectedDifference = projectedPosition - otherPosition
			local projectedDistanceFromShip = projectedDifference:getLength()

			if projectedDistanceFromShip <= radius then
				local modifiedOtherPosition = otherPosition + projectedDifference:getNormal() * radius
				direction = (modifiedOtherPosition - currentPosition):getNormal()
			end
		end
	end

	if isClose or distanceFromTarget < distance then
		movement.isStopping = true
		movement.acceleration = Vector(0)

		return B.Status.Success
	else
		movement.isStopping = false
		movement.acceleration = movement.acceleration + direction * movement.maxAcceleration

		return B.Status.Working
	end
end

return Swim
