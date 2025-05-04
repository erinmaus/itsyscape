--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TeamBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

-- Stores a reference to an actor.
local TeamBehavior = Behavior("Team")

-- Constructs a TeamBehavior.
function TeamBehavior:new()
	Behavior.Type.new(self)

	self.teams = {}
	self.override = {}
end

return TeamBehavior
