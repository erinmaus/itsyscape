--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PowerRechargeBehavior.lua
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
local PowerRechargeBehavior = Behavior("PowerRecharge")

-- Constructs a PowerRechargeBehavior.
--
-- 'powers' is a map of (power.id.value, zeal). 'zeal' goes down; if it's zero,
-- the power is recharged.
function PowerRechargeBehavior:new()
	Behavior.Type.new(self)

	self.powers = {}
end

return PowerRechargeBehavior
