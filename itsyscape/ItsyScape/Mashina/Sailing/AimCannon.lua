--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/FireCannon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Class = require "ItsyScape.Common.Class"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"

local FireCannon = B.Node("AimCannon")
FireCannon.PEEP = B.Reference()
FireCannon.TARGET = B.Reference()
FireCannon.CANNON = B.Reference()
FireCannon.STEADY = B.Reference()

function FireCannon:update(mashina, state, executor)
	local director = mashina:getDirector()
	local game = director:getGameInstance()

	local peep = state[self.PEEP] or mashina
	local target = state[self.TARGET]
	local cannon = state[self.CANNON]

	if not (target and cannon) then
		return B.Status.Failure
	end

	if not self.cannonPath or self.cannonPath:getTargetPeep() ~= peep or self.cannonPath:getTargetCannon() ~= cannon then
		if self.cannonPath then
			Utility.Peep.poof(self.cannonPath)
		end

		self.cannonPath = Utility.spawnPropAtPosition(peep, "CannonPath", 0, 0, 0):getPeep()
		self.cannonPath:poke("aim", peep, state[self.CANNON])
	end

	cannon:poke("tilt", self.currentX, self.currentY)

	local properties = Sailing.Cannon.getCannonballPathProperties(peep, cannon)
	local cannonballPath, cannonPathDuration = Sailing.Cannon.buildCannonballPath(cannon, properties)

	local targetPosition = Utility.Peep.getAbsolutePosition(target)
	local isHit = false
	local lastGoodIndex = 1
	do
		local targetSize = Utility.Peep.getSize(target)
		local targetHalfSize = targetSize / 2
		local min = targetPosition + Vector(-targetHalfSize.x, 0, -targetHalfSize.z)
		local max = targetPosition + Vector(targetHalfSize.x, targetSize.y, targetHalfSize.z)

		for i = 1, #cannonballPath - 1 do
			local nodeCurrent = cannonballPath[i].position
			local nodeNext = cannonballPath[i + 1].position

			local ray = Ray(nodeCurrent, nodeCurrent:direction(nodeNext))
			local s, _, t = ray:hitBounds(min, max, nil, 0.5)
			if s and t <= nodeNext:distance(nodeCurrent) then
				isHit = true
				break
			end
		end

		for i = #cannonballPath, 1, -1 do
			local node = cannonballPath[i]
			if node.position.y >= targetPosition.y then
				lastGoodIndex = i
				break
			end
		end
	end

	if isHit then
		Log.info("Target '%s' is in range for '%s' to shoot with '%s'!", target:getName(), peep:getName(), cannon:getName())
		return B.Status.Success
	end

	if #cannonballPath == 0 then
		return B.Status.Failure
	end

	local cannonPosition = Utility.Peep.getAbsolutePosition(cannon)
	local cannonRotation, cannonForward
	do
		cannonRotation = cannon:getCannonDirection()
		cannonForward = cannonRotation:transformVector(Vector.UNIT_Z):getNormal()
	end

	local yDirection = cannonPosition:direction(targetPosition):getNormal()
	local isInFront = yDirection:dot(cannonForward) > 0

	if not isInFront then
		return B.Status.Failure
	end

	local cannonTargetDistance = Vector.distance(cannonPosition, targetPosition)
	local hitTargetDistance = Vector.distance(cannonballPath[lastGoodIndex].position, cannonPosition)
	local xError = hitTargetDistance - cannonTargetDistance

	if cannonTargetDistance > hitTargetDistance then
		if self.currentX >= 1 then
			Log.info("Target '%s' is too far for gunner '%s' with '%s' cannon; cannon can never reach.", target:getName(), peep:getName(), cannon:getName())
			return B.Status.Failure
		end
	end

	local yDirection, yError = Sailing.getDirectionFromPoints(
		cannonPosition,
		cannonPosition + cannonForward,
		targetPosition)

	if yDirection ~= 0 then
		if yDirection < 0 and self.currentY <= 0 then
			Log.info("Target '%s' is too far left for gunner '%s' with '%s' cannon; cannon can never reach.", target:getName(), peep:getName(), cannon:getName())
			return B.Status.Failure
		elseif yDirection > 0 and self.currentY >= 1 then
			Log.info("Target '%s' is too far right for gunner '%s' with '%s' cannon; cannon can never reach.", target:getName(), peep:getName(), cannon:getName())
			return B.Status.Failure
		end
	end

	local deltaY = yError / 16
	local deltaX = xError / 16

	local targetX, targetY

	self.currentX = math.clamp(self.currentX + deltaX * game:getDelta())
	self.currentY = math.clamp(self.currentY - deltaY * game:getDelta())

	if state[self.STEADY] then
		return B.Status.Success
	else
		return B.Status.Working
	end
end	

function FireCannon:activated(mashina, state)
	local cannon = state[self.CANNON]
	if cannon then
		self.currentX, self.currentY = cannon:getCurrentX(), cannon:getCurrentY()
	else
		self.currentX = 0.5
		self.currentY = 0.5
	end
end

function FireCannon:deactivated()
	if self.cannonPath then
		Utility.Peep.poof(self.cannonPath)
		self.cannonPath = nil
	end
end

function FireCannon:removed()
	if self.cannonPath then
		Utility.Peep.poof(self.cannonPath)
		self.cannonPath = nil
	end
end

return FireCannon
