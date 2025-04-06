--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TeamsBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local TeamsBehavior = Behavior("Teams")

TeamsBehavior.ENEMY   = "enemy"
TeamsBehavior.NEUTRAL = "neutral"
TeamsBehavior.ALLY    = "ally"

-- Constructs a TeamsBehavior.
function TeamsBehavior:new()
	Behavior.Type.new(self)

	self.teams = {}
	self.characters = {}
end

return TeamsBehavior
