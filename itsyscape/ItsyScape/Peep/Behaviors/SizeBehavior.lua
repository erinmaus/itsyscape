--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/SizeBehavior.lua
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
local SizeBehavior = Behavior("Size")

-- Constructs a SizeBehavior with the provided dimensions.
--
-- Values default to 1.
function SizeBehavior:new(width, height, depth)
	self.size = Vector(width or 1, height or 1, depth or 1)
end

return SizeBehavior
