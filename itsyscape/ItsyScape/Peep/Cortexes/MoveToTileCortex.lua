--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MoveToTileCortex.lua
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

local MoveToTileCortex = Class(Cortex)
MoveToTileCortex.SPEED_MULTIPLIER = 3

function MoveToTileCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(TargetTileBehavior)

	self.speed = {}
end

function MoveToTileCortex:addPeep(peep)
	Cortex.addPeep(self, peep)
	self.speed[peep] = 0
end

function MoveToTileCortex:removePeep(peep)
	Cortex.removePeep(self, peep)
	self.speed[peep] = nil
end

function MoveToTileCortex:accumulateVelocity(peep, value)
	for effect in peep:getEffects(require "ItsyScape.Peep.Effects.MovementEffect") do
		value = effect:applyToVelocity(value)
	end

	return value
end

function MoveToTileCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior)
		local targetTile = peep:getBehavior(TargetTileBehavior)
		local movement = peep:getBehavior(MovementBehavior)
		if movement.maxSpeed == 0 or movement.maxAcceleration == 0 or
		   movement.velocityMultiplier == 0 or movement.accelerationMultiplier == 0
		then
			peep:removeBehavior(TargetTileBehavior)
		elseif targetTile and movement and position then
			local speed = math.min(self.speed[peep] + movement.maxSpeed * delta, movement.maxSpeed)
			local map = game:getDirector():getMap(peep:getBehavior(PositionBehavior).layer or 1)
			if map then
				local currentTile, currentTileI, currentTileJ = map:getTileAt(position.position.x, position.position.z)
				local nextTile, nextTileI, nextTileJ = map:getTile(targetTile.pathNode.i, targetTile.pathNode.j)
				local currentPosition = position.position * Vector.PLANE_XZ
				local targetPosition = map:getTileCenter(nextTileI, nextTileJ) * Vector.PLANE_XZ
				local direction = (targetPosition - currentPosition):getNormal()
				local offset = direction * speed

				if direction.x < 0 then
					movement.facing = MovementBehavior.FACING_LEFT
				elseif direction.x > 0 then
					movement.facing = MovementBehavior.FACING_RIGHT
				end

				local velocity = offset * MoveToTileCortex.SPEED_MULTIPLIER
				velocity = self:accumulateVelocity(peep, velocity)

				position.position = position.position + velocity * delta 

				local distance = ((position.position * Vector.PLANE_XZ) - targetPosition):getLength()
				if distance < 0.5 then
					peep:removeBehavior(TargetTileBehavior)

					-- Otherwise, activate next node (if possible).
					if targetTile.nextPathNode then
						targetTile.nextPathNode:activate(peep)
					else
						movement.isStopping = true
					end
				end
			end
		end
	end
end

return MoveToTileCortex
