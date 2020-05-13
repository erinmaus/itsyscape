--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/OffsetBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the offset of a Peep.
local OffsetBehavior = Behavior("Offset")

-- Constructs a OffsetBehavior with the provided offset.
--
-- Values default to 0.
function OffsetBehavior:new(x, y, z)
	Behavior.Type.new(self)
	self.origin = Vector(x, y, z)
end

return OffsetBehavior
