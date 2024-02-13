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

	self.steerDirection = 0
	self.steerDirectionNormal = Vector(-1, 0, 0)
	self.rotation = Quaternion.IDENTITY
	self.isMoving = false
end

return ShipMovementBehavior
