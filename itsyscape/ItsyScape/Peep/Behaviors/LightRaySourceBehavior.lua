--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/LightRaySourceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the rotation of a Peep.
local LightRaySourceBehavior = Behavior("LightRaySource")

-- Constructs a LightRaySourceBehavior.
--
-- * rays: An array of Rays starting at (0, 0, 0) relative to the peep
--         that are being emitted as light sources.
function LightRaySourceBehavior:new(rot)
	Behavior.Type.new(self)

	self.rays = {}
	self.paths = {}
end

return LightRaySourceBehavior
