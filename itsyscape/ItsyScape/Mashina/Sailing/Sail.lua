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

function Sail:update(mashina, state, executor)
	local director = mashina:getDirector()

	local distance = state[self.DISTANCE] or 0
	local target = state[self.TARGET]
	local offset = state[self.OFFSET] or Vector.ZERO
	local direction = state[self.DIRECTION]

	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warnOnce("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local _, shipMovement = ship:addBehavior(ShipMovementBehavior)
	if direction then
		shipMovement.isMoving = true
		shipMovement.steerDirection = direction

		return B.Status.Success
	end

	local _, movement = ship:addBehavior(MovementBehavior)

	local otherPosition, offset = Sailing.getShipTarget(ship, target, offset)
	if not otherPosition then
		return B.Status.Failure
	end

	local targetPosition = otherPosition + offset
	local currentPosition = Utility.Peep.getPosition(ship)
	local distanceFromTarget = (currentPosition - targetPosition):getLength()
	local projectedDistanceFromTarget = distanceFromTarget - movement.velocity:getLength()

	local rudder = 1
	if projectedDistanceFromTarget < distance then
		local distanceDelta = 1 - (projectedDistanceFromTarget / distance)

		local shipStats = ship:getBehavior(ShipStatsBehavior)
		local turnRadius = shipStats and shipStats.bonuses[ShipStatsBehavior.STAT_TURN] or math.deg(math.pi / 16)
		rudder = distanceDelta ^ (distanceDelta / 2)
	end

	local isFlanking = true
	if Class.isCompatibleType(target, Peep) and target:hasBehavior(ShipMovementBehavior) then
		local flank = state[self.FLANK]
		if flank then
			local selfNormal = Sailing.getShipDirectionNormal(ship)
			local otherNormal = Sailing.getShipDirectionNormal(target)
			local dot = math.abs(selfNormal:dot(otherNormal))

			local angle = math.acos(dot)
			isFlanking = angle < math.pi / 8

			-- print(">>> angle", math.floor(math.deg(angle)), math.deg(math.pi / 8))
			print(">>> is flanking", isFlanking, "is close", distanceFromTarget < distance)
			-- print(">>> rudder", rudder)
			-- print(">>> cur distance", distanceFromTarget, "tar distance", distance)
		end
	end

	if isFlanking and distanceFromTarget < distance then
		if mashina:getName():match("Raven") then print("SUCCESS!") end
		shipMovement.isMoving = false
		shipMovement.steerDirection = 0

		return B.Status.Success
	else
		shipMovement.isMoving = true

		local direction = Sailing.getDirection(ship, targetPosition, 1)
		shipMovement.steerDirection = -direction
		shipMovement.rudder = rudder

		return B.Status.Working
	end
end

return Sail
