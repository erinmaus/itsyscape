--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/WhirlpoolBehavior.lua
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

local WhirlpoolBehavior = Behavior("Whirlpool")

function WhirlpoolBehavior:new()
	Behavior.Type.new(self)

	-- Center of whirlpool in absolute world coordinates.
	self.center = Vector(0)

	-- Radius of whirlpool in absolute world coordinates.
	self.radius = 10

	-- Radius of whirlpool hole (death zone) in absolute world coordinates.
	self.holeRadius = 1

	-- Number of whirlpool rings.
	self.rings = 10

	-- Rotation of whirlpool.
	self.rotationSpeed = 1

	-- Speed of stuff getting sucked into hole in absolute world units per second.
	self.holeSpeed = 1
end

return WhirlpoolBehavior
