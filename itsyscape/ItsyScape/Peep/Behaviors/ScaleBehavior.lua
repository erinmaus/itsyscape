--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ScaleBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the scale of a Peep.
local ScaleBehavior = Behavior("Scale")

-- Constructs a ScaleBehavior with the provided scale.
--
-- Values default to 1.
function ScaleBehavior:new(x, y, z)
	Behavior.Type.new(self)
	self.scale = Vector(x or 1, y or x or 1, z or x or 1)
end

return ScaleBehavior
