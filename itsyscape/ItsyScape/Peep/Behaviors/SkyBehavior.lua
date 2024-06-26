--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/SkyBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

local SkyBehavior = Behavior("Sky")

function SkyBehavior:new()
	Behavior.Type.new(self)

	self.sunNormal = Vector()
	self.sunDistance = 60
	self.windDirection = Vector(1, 0, 0):getNormal()
	self.windSpeed = 2

	self.cloudiness = 0.5
	self.cloudPropType = "Cloud_Default"

	-- Clouds spawn around the mid point to the end point of the troposhere
	self.troposphereEnd = 30

	-- No clue what goes here?
	self.stratosphereEnd = 50

	-- Between the stratosphere and here is where comets, space debris spawn.
	-- After the mesosphere ends, space starts.
	self.mesosphereEnd = 60
end

return SkyBehavior
