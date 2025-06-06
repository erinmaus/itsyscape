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
-- * maxChaseDistance: Maximum distance to chase the target.
--                     Defaults to 4.
function CombatStatusBehavior:new()
	Behavior.Type.new(self)
	
	self.dead = false
	self.currentHitpoints = 1
	self.maximumHitpoints = 1
	self.currentPrayer = 1
	self.maximumPrayer = 1
	self.maxChaseDistance = 8
	self.canEngage = true
	self.deathPoofTime = false

	self.currentZeal = 0
	self.maximumZeal = 1

	self.currentProwessFlux = 0
	self.currentCriticalFlux = 0
	self.currentTimeFlux = 0
	self.currentStrategyFlux = 0
	self.currentSynergyFlux = 0

	self.damage = {}
end

return CombatStatusBehavior
