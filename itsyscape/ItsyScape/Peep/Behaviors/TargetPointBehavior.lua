--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TargetPointBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Behavior = require "ItsyScape.Peep.Behavior"

local TargetPointBehavior = Behavior("TargetPointBehavior")

function TargetPointBehavior:new(node, nextNode)
	Behavior.Type.new(self)
	self.pathNode = node or false
	self.nextPathNode = nextNode or false
end

return TargetPointBehavior
