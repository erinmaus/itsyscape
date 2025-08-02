--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/GatherableBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

local GatherableBehavior = Behavior("PropResourceHealth")
function GatherableBehavior:new()
	Behavior.Type.new(self)

	self.generation = 1
	self.instances = {}
end

return GatherableBehavior
