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
	PathNode.activate(self, peep)

	if peep:hasBehavior(TargetTileBehavior) then
		local target = peep:getBehavior(TargetTileBehavior)
		target.pathNode:interrupt(peep)

		peep:removeBehavior(TargetTileBehavior)
	end

	local _, c = peep:addBehavior(TargetTileBehavior)
	c.pathNode = self
	c.nextPathNode = self:getNextNode()
end

function TilePathNode:interrupt(peep)
	PathNode.interrupt(self, peep)

	peep:removeBehavior(TargetTileBehavior)
end

return TilePathNode
