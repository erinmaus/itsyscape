--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/StaticBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the size of a Peep.
local StaticBehavior = Behavior("Static")
StaticBehavior.BLOCKING = "blocking"
StaticBehavior.PASSABLE = "passable"
StaticBehavior.IMPASSABLE = "impassable"

-- Constructs a StaticBehavior with the provided dimensions.
--
-- Values default to 1.
function StaticBehavior:new(width, height, depth)
	Behavior.Type.new(self)

	self.type = StaticBehavior.IMPASSABLE
end

return StaticBehavior
