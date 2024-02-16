--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ShipMovementBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies movement properties.
local ShipMovementBehavior = Behavior("ShipMovement")

function ShipMovementBehavior:new()
	Behavior.Type.new(self)

	self.isMoving = false

	-- The current direction of the rudder
	-- 0 is straight
	-- 1 is right (starboard)
	-- -1 is left (port)
	self.steerDirection = 0

	-- The direction normal of the ship at rest
	-- This should point towards the bow (front) from the stern (back)
	self.steerDirectionNormal = Vector(-1, 0, 0)

	-- The direction normal the ship rocks along.
	self.rockDirectionNormal = Vector(0, 0, 1)

	-- The current angular acceleration.
	-- This is reset to 0 after being applied to ship.
	self.angularAcceleration = 0

	-- The current rotation of the ship along the steer direction normal.
	self.rotation = Quaternion.IDENTITY

	-- Decay (copied to MovementBehavior)
	self.baseAccelerationDecay = 0
	self.baseVelocityDecay = 0.2

	-- Dimensions of ship (beam is "width" of ship)
	self.length = 0
	self.beam = 0
end

return ShipMovementBehavior
