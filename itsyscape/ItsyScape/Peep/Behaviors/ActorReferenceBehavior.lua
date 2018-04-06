--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/ActorReferenceBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local ActorReferenceBehavior = Behavior("ActorReference")

-- Constructs an ActorReferenceBehavior.
--
-- * actor: Reference to actor. Should be falsey if there is no reference.
--   Defaults to false.
function ActorReferenceBehavior:new()
	Behavior.Type.new(self)
	self.actor = false
end

return ActorReferenceBehavior
