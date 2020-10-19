--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/FlyingBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores combat status information, such as current hitpoints.
local FlyingBehavior = Behavior("Flying")

-- Constructs an FlyingBehavior.
--
-- * range: Number of spaces this peep decreases weapon range.
--          Defaults to 1. Higher numbers = longer range weapons
--          required to fight.
-- * elevation: Difference between the base of the peep and the ground.
--              Higher values 
function FlyingBehavior:new()
	Behavior.Type.new(self)
	
	self.range = 1
	self.elevation = 1
end

return FlyingBehavior
