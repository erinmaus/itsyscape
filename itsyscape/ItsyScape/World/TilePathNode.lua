--------------------------------------------------------------------------------
-- ItsyScape/World/TilePathNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local PathNode = require "ItsyScape.World.PathNode"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local TilePathNode = Class(PathNode)

function TilePathNode:activate(peep)
	local _, c = peep:addBehavior(TargetTileBehavior)
	c.pathNode = self
	c.nextPathNode = self:getNextNode()
end

return TilePathNode
