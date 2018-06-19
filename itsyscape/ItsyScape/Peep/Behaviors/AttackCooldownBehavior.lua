--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/AttackCooldownBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local AttackCooldownBehavior = Behavior("AttackCooldown")

-- Constructs an AttackCooldownBehavior.
--
-- * cooldown: time (in seconds) before the next attack
-- * ticks: tick count when the attack was dealt.
function AttackCooldownBehavior:new()
	Behavior.Type.new(self)

	self.cooldown = 0
	self.ticks = 0
end

return AttackCooldownBehavior
