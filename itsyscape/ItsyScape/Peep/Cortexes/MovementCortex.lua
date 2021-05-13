--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MovementCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local MovementCortex = Class(Cortex)

-- The epsilon to determine whether an object is on the ground.
MovementCortex.GROUND_EPSILON = 0.1

-- If any of the components of the acceleration or velocity vectors fall within
-- +/- CLAMP_EPSILON, then the component is clamped to zero.
MovementCortex.CLAMP_EPSILON = 0.05

-- Baseline for tick.
--
-- The MovementCortex was built under the assumption of 10 ticks/second. If this
-- number changes in the future, the acceleration and velocity need to be smudged
-- to feel the same. The 'multiplier' calculation in update keeps the movement
-- roughly consistent no matter the ticks/second.
MovementCortex.BASE_LINE_TICKS = 10

function MovementCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
end

-- Clamps vector following rules of MovementCortex.CLAMP_EPSILON.
local function clampVector(v)
	if math.abs(v.x) < MovementCortex.CLAMP_EPSILON then
		v.x = 0
	end

	if math.abs(v.y) < MovementCortex.CLAMP_EPSILON then
		v.y = 0
	end

	if math.abs(v.z) < MovementCortex.CLAMP_EPSILON then
		v.z = 0
	end
end

function MovementCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local gravity = game:getStage():getGravity()
	local map = game:getStage():getMap()

	local multiplier = 1 + (game:getTicks() - 10) / 200

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local position = peep:getBehavior(PositionBehavior)
		local size = peep:getBehavior(SizeBehavior)
		local map = self:getDirector():getMap(position.layer or 1)
		if map then
			movement:clampMovement()

			movement.acceleration = movement.acceleration + movement.acceleration * delta + gravity
			clampVector(movement.acceleration)

			local wasMoving
			do
				local xzVelocity = movement.velocity * Vector(1, 0, 1)
				if xzVelocity:getLengthSquared() > 0 then
					wasMoving = true
				end
			end

			local acceleration = movement.acceleration * delta * movement.accelerationMultiplier + movement.additionalAcceleration
			movement.velocity = movement.velocity + acceleration * multiplier
			clampVector(movement.velocity)

			do
				local xzVelocity = movement.velocity * Vector(1, 0, 1)
				if xzVelocity:getLengthSquared() == 0 and movement.isOnGround then
					movement.isStopping = false
					if wasMoving and movement.targetFacing then
						movement.facing = movement.targetFacing
						movement.targetFacing = false
					end
				end
			end

			local oldPosition = position.position
			local oldTile, oldI, oldJ = map:getTileAt(oldPosition.x, oldPosition.z)

			local velocity = (movement.velocity + movement.additionalVelocity) * delta * movement.velocityMultiplier
			position.position = position.position + velocity * multiplier

			local newTile, newI, newJ = map:getTileAt(position.position.x, position.position.z)

			movement.acceleration = movement.acceleration * 1 / (1 + movement.decay * 8 * delta)
			movement.velocity = movement.velocity * 1 / (1 + movement.decay * 8 * delta)

			if newTile:hasFlag('impassable') or
			   newTile:hasFlag('door') or
			   not map:canMove(oldI, oldJ, newI - oldI, newJ - oldJ) or
			   map:isOutOfBounds(position.position.x, position.position.z)
			then
				local difference = (oldPosition - position.position):getNormal()
				local reflectionX, reflectionZ = map:snapToTile(
					position.position.x, position.position.z,
					oldPosition.x, oldPosition.z)
				local snappedX = reflectionX + position.position.x
				local snappedZ = reflectionZ + position.position.z
				local snappedTile = map:getTileAt(snappedX, snappedZ)

				if not snappedTile:getIsPassable() or map:isOutOfBounds(snappedX, snappedZ) then
					position.position = Vector(oldPosition:get())
				else
					position.position = Vector(snappedX, position.position.y, snappedZ)
				end

				Log.info("Peep '%s' entered an impassable region.", peep:getName())
			end

			local y = map:getInterpolatedHeight(
				position.position.x,
				position.position.z)
			if position.position.y < y then
				if movement.bounce > 0 then
					movement.acceleration.y = -movement.acceleration.y * movement.bounce
					movement.velocity.y = -movement.velocity.y * movement.bounce
					position.position.y = y

					if movement.velocity.y < movement.bounceThreshold then
						movement.acceleration.y = 0
						movement.velocity.y = 0
						movement.isOnGround = true
					else
						movement.isOnGround = false
					end
				elseif not movement.isOnGround then
					movement.isOnGround = true
				end
			elseif position.position.y > y + MovementCortex.GROUND_EPSILON
			       and movement.isOnGround
			then
				movement.isOnGround = false
			end

			if movement.isOnGround then
				position.position.y = y
				movement.acceleration.y = 0
				movement.velocity.y = 0

				if movement.isStopping then
					movement.acceleration = movement.acceleration * movement.decay ^ movement.stoppingForce
					movement.velocity = movement.velocity * movement.decay ^ movement.stoppingForce
				end
			else
				position.position.y = math.max(position.position.y, y)
			end

			local stepY = position.position.y - oldPosition.y 
			if stepY > movement.maxStepHeight then
				position.position = oldPosition
			end

			if movement.velocity.x < -0.5 then
				movement.facing = MovementBehavior.FACING_LEFT
			elseif movement.velocity.x > 0.5 then
				movement.facing = MovementBehavior.FACING_RIGHT
			end
		end
	end
end

return MovementCortex
