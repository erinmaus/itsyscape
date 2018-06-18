--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/CombatTargetBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local CombatTargetBehavior = Behavior("CombatTarget")

-- Constructs an CombatTargetBehavior.
--
-- * actor: Reference to actor. Should be falsey if there is no reference.
--   Defaults to false.
function CombatTargetBehavior:new()
	Behavior.Type.new(self)
	self.actor = false
end

return CombatTargetBehavior
