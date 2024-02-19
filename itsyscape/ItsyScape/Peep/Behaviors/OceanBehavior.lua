--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/OceanBehavior.lua
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
local OceanBehavior = Behavior("Ocean")

function OceanBehavior:new()
	Behavior.Type.new(self)

	-- Physical properties.
	self.weatherBobScale = 1
	self.weatherRockRange = 0
	self.weatherRockMultiplier = math.pi / 4
	self.depth = 1.5

	-- Visual properties.
	self.offset = 0
	self.positionTimeScale = 4
	self.textureTimeScale = Vector(math.pi / 4, 1 / 2, 0)
end

return OceanBehavior
