--------------------------------------------------------------------------------
-- ItsyScape/Peep/Behaviors/TargetTileBehavior.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Behavior = require "ItsyScape.Peep.Behavior"

-- Specifies a path that the Peep is moving along.
local TargetTileBehavior = Behavior("Path")

-- Constructs a TargetTileBehavior.
--
-- A path behavior has:
--  * pathNode: The target tile. Should be a TilePathNode.
--  * nextPathNode: The next path node, or nil if there is none.
--  * index: Index of path.
function TargetTileBehavior:new(node, nextNode)
	Behavior.Type.new(self)
	self.pathNode = node or false
	self.nextPathNode = nextNode or false
end

return TargetTileBehavior
