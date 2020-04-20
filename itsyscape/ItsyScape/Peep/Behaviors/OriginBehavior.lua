--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/OriginBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies the local origin of a Peep.
local OriginBehavior = Behavior("Origin")

-- Constructs a OriginBehavior with the provided origin.
--
-- Values default to 0.
function OriginBehavior:new(x, y, z)
	Behavior.Type.new(self)
	self.origin = Vector(x, y, z)
end

return OriginBehavior
