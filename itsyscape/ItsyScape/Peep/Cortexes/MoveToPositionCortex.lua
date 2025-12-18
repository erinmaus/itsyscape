--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MoveToPosition.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetPositionBehavior = require "ItsyScape.Peep.Behaviors.TargetPositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local MoveToPosition = Class(Cortex)
MoveToPosition.DISTANCE_THRESHOLD = 0

function MoveToPosition:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(TargetPositionBehavior)

	self.speed = {}
	self.previousTileCenter = {}
end

function MoveToPosition:addPeep(peep)
	Cortex.addPeep(self, peep)

	self.speed[peep] = self.speed[peep] or peep:getBehavior(MovementBehavior).maxSpeed / 2

	local map = Utility.Peep.getMap(peep)
	if map then
		self.previousTileCenter[peep] = self.previousTileCenter[peep] or map:getTileCenter(Utility.Peep.getTile(peep))
	end
end

function MoveToPosition:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.speed[peep] = nil
	self.previousTileCenter[peep] = nil
end

function MoveToPosition:accumulateVelocity(peep, value)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = effect:applyToVelocity(value)
	end

	return value
end

function MoveToPosition:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior)
		local targetPositionBehavior = peep:getBehavior(TargetPositionBehavior)
		local movement = peep:getBehavior(MovementBehavior)
		if movement.maxSpeed == 0 or movement.maxAcceleration == 0 or
		   movement.velocityMultiplier == 0 or movement.accelerationMultiplier == 0
		then
			peep:removeBehavior(TargetPositionBehavior)
		elseif targetPositionBehavior and movement and position and targetPositionBehavior.pathNode then
			local speed = math.min(self.speed[peep] + movement.maxSpeed * delta, movement.maxSpeed)
			local map = game:getDirector():getMap(peep:getBehavior(PositionBehavior).layer or 1)
			if map then
				local currentDelta = delta
				while currentDelta > 0 do
					local currentPosition = position.position
					local targetPosition = targetPositionBehavior.pathNode.position
					targetPosition = targetPosition + Vector(0, map:getInterpolatedHeight(targetPosition.x, targetPosition.z), 0)
					targetPosition = targetPosition + Vector.UNIT_Y * movement.float
					local direction = currentPosition:direction(targetPosition)
					local offset = direction * speed

					if not peep:hasBehavior(RotationBehavior) then
						if direction.x < 0 then
							movement.facing = MovementBehavior.FACING_LEFT
						elseif direction.x > 0 then
							movement.facing = MovementBehavior.FACING_RIGHT
						end
					end

					local velocity = offset
					velocity = self:accumulateVelocity(peep, velocity)

					local velocitySlice = velocity * currentDelta
					local velocitySliceLength = velocitySlice:getLength()

					local didOvershoot = false
					local distance = ((targetPosition - currentPosition) * Vector.PLANE_XZ):getLength()
					if distance < velocitySliceLength and distance > MoveToPosition.DISTANCE_THRESHOLD then
						currentDelta = currentDelta - (delta * (distance / velocitySliceLength))
						velocitySlice = direction * distance
						didOvershoot = true
					else
						currentDelta = 0
						didOvershoot = false
					end

					position.position = position.position + velocitySlice

					if (didOvershoot or distance == 0) and not targetPositionBehavior.pathNode:getIsPending() then
						peep:removeBehavior(TargetPositionBehavior)

						if targetPositionBehavior.nextPathNode then
							targetPositionBehavior.nextPathNode:activate(peep)
						else
							movement.isStopping = true
						end
					end
				end

				self.speed[peep] = speed
			end
		end
	end
end

return MoveToPosition
