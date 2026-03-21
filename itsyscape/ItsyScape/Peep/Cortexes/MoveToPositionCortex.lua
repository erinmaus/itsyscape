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
local Callback = require "ItsyScape.Common.Callback"
local MathCommon = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local Cortex = require "ItsyScape.Peep.Cortex"
local CombatTargetBehavior = require "ItsyScape.Peep.Behaviors.CombatTargetBehavior"
local DynamicBehavior = require "ItsyScape.Peep.Behaviors.DynamicBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetPositionBehavior = require "ItsyScape.Peep.Behaviors.TargetPositionBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local Tile = require "ItsyScape.World.Tile"

local MoveToPosition = Class(Cortex)
MoveToPosition.DISTANCE_PADDING = -0.25

function MoveToPosition:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(TargetPositionBehavior)

	self.speed = {}
	self.previousTileCenter = {}

	self._filter = Callback.bind(self.filter, self)
end

function MoveToPosition:filter(item, other)
	if Class.isCompatibleType(other, Tile) then
		if other:hasStaticFlag("impassable") then
			return "slide"
		end
	elseif Class.isCompatibleType(other, Peep) then
		local static = other:getBehavior(StaticBehavior)
		if static and static.type == StaticBehavior.IMPASSABLE then
			return "slide"
		end
	end

	return false
end

function MoveToPosition:addPeep(peep)
	Cortex.addPeep(self, peep)

	self.speed[peep] = self.speed[peep] or 0
end

function MoveToPosition:removePeep(peep)
	Cortex.removePeep(self, peep)

	self.speed[peep] = nil
end

function MoveToPosition:accumulateVelocity(peep, value)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = effect:applyToVelocity(value)
	end

	return value
end

function MoveToPosition:step(peep)
	local movement = peep:getBehavior(MovementBehavior)
	local targetPositionBehavior = peep:getBehavior(TargetPositionBehavior)
	if not (targetPositionBehavior and movement) then
		return
	end

	if not targetPositionBehavior.pathNode:getIsPending() then
		if targetPositionBehavior.nextPathNode then
			targetPositionBehavior.nextPathNode:activate(peep)
		else
			peep:removeBehavior(TargetPositionBehavior)
			movement.isStopping = true
		end
	end
end

function MoveToPosition:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior)
		local targetPositionBehavior = peep:getBehavior(TargetPositionBehavior)
		local movement = peep:getBehavior(MovementBehavior)
		local dynamic = peep:getBehavior(DynamicBehavior)
		local radius = dynamic and (dynamic.radius + dynamic.margin) or (DynamicBehavior.DEFAULT_RADIUS + DynamicBehavior.DEFAULT_MARGIN)
		if movement.maxSpeed == 0 or movement.maxAcceleration == 0 or
		   movement.velocityMultiplier == 0 or movement.accelerationMultiplier == 0
		then
			peep:removeBehavior(TargetPositionBehavior)
		elseif targetPositionBehavior and movement and position and targetPositionBehavior.pathNode then
			local speed = math.min(self.speed[peep] + movement.maxSpeed * delta, movement.maxSpeed)
			local layer = Utility.Peep.getLayer(peep)
			local map = game:getDirector():getMap(layer)
			local world = game:getDirector():getCortex(MovementCortex):getWorld(layer)
			if map then
				local currentDelta = delta
				while currentDelta > 0 do
					local currentPosition = position.position * Vector.PLANE_XZ
					local targetPosition = targetPositionBehavior.pathNode.position * Vector.PLANE_XZ

					local direction = currentPosition:direction(targetPosition)
					local velocity = self:accumulateVelocity(peep, direction * speed)
					velocity = velocity * Vector.PLANE_XZ

					if not (peep:hasBehavior(RotationBehavior) or peep:hasBehavior(CombatTargetBehavior)) then
						if direction.x < 0 then
							movement.facing = MovementBehavior.FACING_LEFT
						elseif direction.x > 0 then
							movement.facing = MovementBehavior.FACING_RIGHT
						end
					end

					local distance = currentPosition:distance(targetPosition)

					if distance < 0.01 then
						self:step(peep)
						break
					end

					local velocityMagnitude = velocity:getLength()
					if velocityMagnitude < 0.01 then
						break
					end

					local estimatedPartialDelta = distance / velocityMagnitude
					local partialDelta = math.min(currentDelta, estimatedPartialDelta)

					local partialVelocitySlice = partialDelta * velocity
					local goal = currentPosition + partialVelocitySlice
					local currentX, currentZ = currentPosition.x, currentPosition.z
					if world and world:has(peep) then
						local currentGoalX, currentGoalZ = goal.x, goal.z
						goal.x, goal.z = world:move(peep, goal.x, goal.z, self._filter)

						if currentX == goal.x and currentZ == goal.z then
							targetPositionBehavior.pathNode:onStuck(peep)
							break
						elseif not (currentGoalX == goal.x and currentGoalZ == goal.z) and
						   goal.x == currentPosition.x and goal.z == currentPosition.z and
						   goal:distance(targetPosition) <= radius
						then
							self:step(peep)
							break
						end

						distance = ((targetPosition - goal) * Vector.PLANE_XZ):getLength()
					end

					local finalPosition = goal + Vector(0, map:getInterpolatedHeight(targetPosition.x, targetPosition.z) + movement.float)
					position.position = finalPosition

					currentDelta = currentDelta - partialDelta
				end

				self.speed[peep] = speed
			end
		end
	end
end

return MoveToPosition
