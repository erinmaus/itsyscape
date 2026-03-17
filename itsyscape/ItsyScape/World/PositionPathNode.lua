--------------------------------------------------------------------------------
-- ItsyScape/World/PositionPathNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PathNode = require "ItsyScape.World.PathNode"
local TargetPositionBehavior = require "ItsyScape.Peep.Behaviors.TargetPositionBehavior"

local PositionPathNode = Class(PathNode)

function PositionPathNode:new(map, layer, position)
	local _, i, j = map:getTileAt(position.x, position.z)
	PathNode.new(self, i, j, layer)

	self.position = position
end

function PositionPathNode:activate(peep)
	PathNode.activate(self, peep)

	local previousPathNode
	if peep:hasBehavior(TargetPositionBehavior) then
		local target = peep:getBehavior(TargetPositionBehavior)
		previousPathNode = target.pathNode

		if target.pathNode then
			target.pathNode:interrupt(peep)
		end
	end

	local _, c = peep:addBehavior(TargetPositionBehavior)
	c.previousPathNode = previousPathNode or false
	c.pathNode = self
	c.nextPathNode = self:getNextNode()
end

function PositionPathNode:interrupt(peep)
	PathNode.interrupt(self, peep)

	peep:removeBehavior(TargetPositionBehavior)
end

return PositionPathNode
