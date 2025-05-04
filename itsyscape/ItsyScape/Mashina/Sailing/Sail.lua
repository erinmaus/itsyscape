--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/Sail.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"
local ShipStatsBehavior = require "ItsyScape.Peep.Behaviors.ShipStatsBehavior"

local Sail = B.Node("Sail")
Sail.DIRECTION = B.Reference()
Sail.TARGET = B.Reference()
Sail.OFFSET = B.Reference()
Sail.DISTANCE = B.Reference()
Sail.FLANK = B.Reference()
Sail.FLANK_THRESHOLD = B.Reference()

function Sail:update(mashina, state, executor)
	local distance = state[self.DISTANCE] or 0
	local target = state[self.TARGET]
	local offset = state[self.OFFSET]
	local direction = state[self.DIRECTION]
	local flankThreshold = state[self.FLANK_THRESHOLD] or math.pi / 8

	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warn("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local _, shipMovement = ship:addBehavior(ShipMovementBehavior)
	if direction then
		shipMovement.isMoving = true
		shipMovement.steerDirection = direction

		return B.Status.Success
	end

	local otherPosition, otherOffset = Sailing.getShipTarget(ship, target, offset)
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

	local currentPosition = Utility.Peep.getPosition(ship) * Vector.PLANE_XZ
	local distanceFromTarget = (currentPosition - targetPosition):getLength()

	local isClose = false
	if Class.isCompatibleType(otherOffset, Ray) then
		local ray = Ray(targetPosition, otherOffset.direction)
		local _, A = ray:closest(currentPosition)
		local isWithinTargetDistance = (A - targetPosition):getLength() < distance
		local isWithinBeamDistance = (A - currentPosition):getLength() < shipMovement.beam / 2
		isClose = isWithinTargetDistance and isWithinBeamDistance
	end

	local isFlanking = true
	if Class.isCompatibleType(target, Peep) and target:hasBehavior(ShipMovementBehavior) then
		local flank = state[self.FLANK]
		if flank then
			local selfNormal = Sailing.getShipForward(ship)
			local otherNormal = Sailing.getShipForward(target)
			local dot = math.abs(selfNormal:dot(otherNormal))

			local angle = math.acos(math.clamp(dot))
			isFlanking = angle < flankThreshold
		end
	end

	if isFlanking and (isClose or distanceFromTarget < distance) then
		shipMovement.isMoving = false
		shipMovement.steerDirection = 0

		return B.Status.Success
	else
		shipMovement.isMoving = true
		shipMovement.steerDirection = -Sailing.getDirection(ship, targetPosition)

		return B.Status.Working
	end
end

return Sail
