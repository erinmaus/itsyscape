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
local ShipMovementCortex = require "ItsyScape.Peep.Cortexes.ShipMovementCortex"

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

	local nodes = Sailing.Navigation.buildNodes(mashina, target, offset)
	local path = Sailing.Navigation.navigate(nodes)

	if not path then
		return B.Status.Failure
	end

	local movement = mashina:getBehavior(MovementBehavior)
	if not movement then
		return B.Status.Failure
	end

	local targetPosition = path[1]
	if not targetPosition then
		local _, _, t = Sailing.getShipTarget(mashina, target, offset)
		targetPosition = t
	end

	local goalPosition = path[#path]
	local currentPosition = Utility.Peep.getPosition(mashina) * Vector.PLANE_XZ
	local distanceFromGoal = (goalPosition - currentPosition):getLength()
	local direction = currentPosition:direction(targetPosition)

	local isClose = false
	if Class.isCompatibleType(otherOffset, Ray) then
		local ray = Ray(goalPosition, otherOffset.direction)
		local _, A = ray:closest(currentPosition)
		local isWithinTargetDistance = (A - goalPosition):getLength() < distance

		local size = Utility.Peep.getSize(mashina)
		local isWithinWidth = (A - currentPosition):getLength() < size.x / 2
		isClose = isWithinTargetDistance and isWithinWidth
	end

	local direction = currentPosition:direction(targetPosition)

	if isClose or distanceFromGoal < distance then
		movement.isStopping = true

		Utility.Peep.lookAt(mashina, target)

		return B.Status.Success
	else
		movement.isStopping = false
		--movement.acceleration = movement.acceleration + direction * movement.maxAcceleration
		movement.velocity = direction * movement.maxSpeed
		Utility.Peep.lookAt(mashina, target)

		return B.Status.Working
	end
end

function Swim:deactivated(mashina, state)
	local prop = state[self.PROP]
	if prop then
		Utility.Peep.poof(prop:getPeep())
	end
end

return Swim
