--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/StaticBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"
local Tile = require "ItsyScape.World.Tile"

-- Specifies the collision properties of a Peep, specifically a prop.
local StaticBehavior = Behavior("Static")
StaticBehavior.BLOCKING = "blocking"
StaticBehavior.PASSABLE = "passable"
StaticBehavior.IMPASSABLE = "impassable"
StaticBehavior.DOOR = "door"

StaticBehavior.SHAPE_RECTANGLE = "rectangle"
StaticBehavior.SHAPE_CIRCLE = "circle"

-- Constructs a StaticBehavior.
function StaticBehavior:new()
	Behavior.Type.new(self)

	self.tile = Tile()
	self.mode = "spawn"
	self.static = true
	self.type = StaticBehavior.IMPASSABLE
	self.shape = StaticBehavior.SHAPE_RECTANGLE
end

return StaticBehavior
