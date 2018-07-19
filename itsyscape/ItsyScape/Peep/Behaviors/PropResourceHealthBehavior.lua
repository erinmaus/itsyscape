--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/PropResourceHealthBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local PropResourceHealthBehavior = Behavior("PropResourceHealth")

-- Constructs an PropResourceHealthBehavior.
--
-- * currentProgress: Current progress of the action. Defaults to 0.
-- * maxProgress: Maximum progress of the action. Defaults to 1.
--
-- When currentProgress > maxProgress, the resource is depleted.
function PropResourceHealthBehavior:new()
	Behavior.Type.new(self)

	self.currentProgress = 0
	self.maxProgress = 1
end

return PropResourceHealthBehavior
