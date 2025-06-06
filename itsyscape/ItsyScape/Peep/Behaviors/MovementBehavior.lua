--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/MovementBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies movement properties.
local MovementBehavior = Behavior("Movement")

-- Direction enumeration. Assumes face right by default.
MovementBehavior.FACING_LEFT  = -1
MovementBehavior.FACING_NONE  = 0
MovementBehavior.FACING_RIGHT =  1

-- Constructs a MovementBehavior with some poor defaults.
--
-- * facing is an enumeration (FACING_*) that corresponds to whether the Peep
--   is facing left or right. Defaults to FACING_RIGHT.
-- * targetFacing is an enumeration (FACEING_*) that corresponds to the direction
--   the peep will face after it stops.
-- * acceleration is a Vector. Self-explanatory.
-- * velocity is a Vector. Self-explanatory.
-- * maxSpeed is the maximum magnitude of velocity.
-- * maxAcceleration is the maximum magnitude of acceleration.
-- * velocityMultiplier is how much to multiply velocity by
-- * accelerationMultiplier is how much to multiply acceleration by
-- * bounce is how much the object bounces. A value of zero means no bounce,
--   while a value of 1 means the velocity and acceleration are reflected
--   without any change to the magnitude.
-- * decay is how quickly the acceleration and velocity move towards zero.
--   A value of 0.05, for example, means at 20 ticks per second (TPS), the object
--   will have 1% of its initial acceleration and velocity (assuming they were
--   not modified since) after 90 frames. It's similar to the compound interest
--   formula: future = current * (1 - decay) ^ frames. The default value is 1;
--   i.e., no decay.
-- * isOnGround indicates if the Peep is on the ground. To be on the ground
--   means the Y component of acceleration and velocity are zero and the Peep is
--   within a very, very small range of the ground elevation at its position.
-- * isStopping will apply decay ^ stoppingForce to acceleration and velocity
--   if on ground.
-- * stoppingForce is the exponent of decay when stopping.
-- * maxStepHeight: maximum step height. If this is exceeded after a step,
--                  the old position is returned. Default value is 1.
-- * clampToZero: clamps acceleration and velocity to zero as they near zero individually (true)
--                or as a whole (false)
--
-- Defaults are 0 (or equivalent) unless otherwise specified.
function MovementBehavior:new()
	Behavior.Type.new(self)

	self.facing = MovementBehavior.FACING_RIGHT
	self.targetFacing = false
	self.acceleration = Vector(0, 0, 0)
	self.velocity = Vector(0, 0, 0)
	self.push = Vector(0, 0, 0)
	self.additionalAcceleration = Vector(0, 0, 0)
	self.additionalVelocity = Vector(0, 0, 0)
	self.maxSpeed = 0
	self.maxAcceleration = 0
	self.velocityMultiplier = 1
	self.accelerationMultiplier = 1
	self.bounce = 0
	self.bounceThreshold = 0
	self.velocityDecay = 0
	self.accelerationDecay = 0
	self.pushDecay = 0.1
	self.isOnGround = false
	self.isStopping = false
	self.stoppingForce = 2
	self.maxStepHeight = 1
	self.clampToZero = true
	self.float = 0
	self.noClip = false
	self.ghost = false
end

function MovementBehavior:clampMovement()
	local speed = self.velocity:getLength()
	local acceleration = self.acceleration:getLength()

	if speed > self.maxSpeed then
		self.velocity = self.velocity:getNormal() * self.maxSpeed
	end

	if acceleration > self.maxAcceleration then
		self.acceleration = self.acceleration:getNormal() * self.maxAcceleration
	end
end

return MovementBehavior
