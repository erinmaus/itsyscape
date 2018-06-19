--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/CombatStatusBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores combat status information, such as current hitpoints.
local CombatStatusBehavior = Behavior("CombatStatus")

-- Constructs an CombatStatusBehavior.
--
-- * currentHitpoints: Current hitpoints. Defaults to 1.
-- * maximumHitpoints: Maximum hitpoints. Defaults to 1.
-- * currentPrayer: Current prayer. Defaults to 1.
-- * maximumPrayer: Current prayer. Defaults to 1.
function CombatStatusBehavior:new()
	Behavior.Type.new(self)
	
	self.currentHitpoints = 1
	self.maximumHitpoints = 1
	self.currentPrayer = 1
	self.maximumPrayer = 1
end

return CombatStatusBehavior
