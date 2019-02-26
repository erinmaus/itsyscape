--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PowerCoolDownBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Vector = require "ItsyScape.Common.Math.Vector"
local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies equipment bonuses directly.
local PowerCoolDownBehavior = Behavior("PowerCoolDownBehavior")

-- Constructs a PowerCoolDownBehavior.
--
-- 'powers' is a map of (power.id.value, time), where time is the time
-- the ability was used.
function PowerCoolDownBehavior:new()
	Behavior.Type.new(self)

	self.powers = {}
end

return PowerCoolDownBehavior
