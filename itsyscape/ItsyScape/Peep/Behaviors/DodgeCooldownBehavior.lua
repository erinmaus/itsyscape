--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/DodgeCooldownBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

local DodgeCooldownBehavior = Behavior("DodgeCooldown")

-- Constructs a DodgeCooldownBehavior.
--
-- * cooldown: time (in seconds) before the next dodge
-- * ticks: tick count when the peep dodged.
function DodgeCooldownBehavior:new()
	Behavior.Type.new(self)

	self.cooldown = 0
	self.ticks = 0
end

return DodgeCooldownBehavior
