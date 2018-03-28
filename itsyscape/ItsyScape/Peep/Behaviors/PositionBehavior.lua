--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PositionBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the position of a Peep.
local PositionBehavior = Behavior("Position")

-- Constructs a PositionBehavior with the provided position.
--
-- Values default to 0.
function PositionBehavior:new(x, y, z)
	self.position = Vector(x, y, z)
end

return PositionBehavior
