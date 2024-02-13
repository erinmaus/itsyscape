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
local Vector = require "ItsyScape.Common.Math.Vector"
local Peep = require "ItsyScape.Peep.Peep"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"

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
	local relativeOffset = state[self.OFFSET]
	local direction = state[self.DIRECTION]
	local flank = state[self.FLANK]

	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warnOnce("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local _, movement = ship:addBehavior(ShipMovementBehavior)
	if direction then
		movement.isMoving = true
		movement.steerDirection = direction

		return B.Status.Success
	end

	local position = Sailing.getShipTarget(ship, target)
	if not position then
		return B.Status.Failure
	end

	local offset = relativeOffset and (movement.rotation * Quaternion.Y_90):transformVector(relativeOffset) or Vector.ZERO
	local targetPosition = position + offset
	local currentPosition = Utility.Peep.getPosition(ship)
	local distanceFromTarget = (currentPosition - targetPosition):getLengthSquared()

	local isFlanking
	do
		if flank then
			if Class.isCompatibleType(target, Peep) and target:hasBehavior(ShipMovementBehavior) then
				local selfNormal = Sailing.getShipDirectionNormal(ship)
				local otherNormal = Sailing.getShipDirectionNormal(target)

				local angle = math.deg(math.acos(selfNormal:dot(otherNormal)))
				if angle < 20 or angle > 160 then
					isFlanking = true
				else
					isFlanking = false
				end
			end
		else
			isFlanking = true
		end
	end

	if isFlanking and distanceFromTarget < distance * distance then
		movement.isMoving = false
		movement.steerDirection = 0

		return B.Status.Success
	else
		movement.isMoving = true
		movement.steerDirection = -Sailing.getDirection(ship, targetPosition, 1)

		return B.Status.Working
	end
end

return Sail
