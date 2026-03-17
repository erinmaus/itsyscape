--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/DynamicBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"
local Tile = require "ItsyScape.World.Tile"

-- Specifies the collision properties of a Peep, specifically an actor.
local DynamicBehavior = Behavior("Dynamic")
DynamicBehavior.PASSABLE = "passable"
DynamicBehavior.IMPASSABLE = "impassable"

DynamicBehavior.SHAPE_SQUARE = "square"
DynamicBehavior.SHAPE_CIRCLE = "circle"

DynamicBehavior.DEFAULT_RADIUS = 0.5
DynamicBehavior.DEFAULT_MARGIN = 0.5

-- Constructs a DynamicBehavior.
function DynamicBehavior:new()
	Behavior.Type.new(self)

	self.tile = Tile()
	self.radius = 0.5
	self.margin = 0.25
	self.type = DynamicBehavior.PASSABLE
	self.shape = DynamicBehavior.SHAPE_CIRCLE
end

return DynamicBehavior
