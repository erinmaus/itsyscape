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
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local SizeBehavior = require "ItsyScape.Peep.Behaviors.SizeBehavior"

local MovementCortex = Class(Cortex)

-- The epsilon to determine whether an object is on the ground.
MovementCortex.GROUND_EPSILON = 0.05

-- If any of the components of the acceleration or velocity vectors fall within
-- +/- CLAMP_EPSILON, then the component is clamped to zero.
MovementCortex.CLAMP_EPSILON = 0.01

function MovementCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(SizeBehavior)
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

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local position = peep:getBehavior(PositionBehavior)
		
		movement.acceleration = movement.acceleration + gravity * delta
		clampVector(movement.acceleration)

		movement.velocity = movement.velocity + movement.acceleration * delta
		clampVector(movement.velocity)

		position.position = position.position + movement.velocity * delta

		movement.acceleration = movement.acceleration:lerp(
			Vector.ZERO,
			movement.decay * delta)
		movement.velocity = movement.velocity:lerp(
			Vector.ZERO,
			movement.decay * delta)

		local y = map:getInterpolatedHeight(
			position.position.x,
			position.position.z)
		if position.y < y then
			movement.acceleration.y = -movement.acceleration.y * movement.bounce
			movement.velocity.y = -movement.velocity.y * movement.bounce
			position.y = y
		elseif position.y - y < MovementCortex.GROUND_EPSILON and
		       movement.velocity.y == 0.0 and
		       movement.acceleration.y == 0.0
		then
			movement.isOnGround = true
		end
	end
end

return MovementCortex
