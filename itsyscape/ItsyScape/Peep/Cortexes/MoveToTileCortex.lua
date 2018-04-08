--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/MoveToTileCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local MoveToTileCortex = Class(Cortex)

function MoveToTileCortex:new()
	Cortex.new(self)

	self:require(MovementBehavior)
	self:require(PositionBehavior)
	self:require(TargetTileBehavior)
end

function MoveToTileCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local map = game:getStage():getMap()
	local finished = {}

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior).position
		local targetTile = peep:getBehavior(TargetTileBehavior)
		local movement = peep:getBehavior(MovementBehavior)
		movement.isStopping = false

		local currentTile, currentTileI, currentTileJ = map:getTileAt(position.x, position.z)
		local nextTile, nextTileI, nextTileJ = map:getTile(targetTile.pathNode.i, targetTile.pathNode.j)

		local targetPosition = map:getTileCenter(nextTileI, nextTileJ)
		local positionDifference = targetPosition - position
		positionDifference.y = 0

		local distance = positionDifference:getLength()
		local direction = positionDifference:getNormal()

		if distance > 0.5 then
			-- If we're too far from the tile, steer towards it.
			movement.acceleration = movement.acceleration + positionDifference / delta
			movement.velocity = movement.velocity
		else
			peep:removeBehavior(TargetTileBehavior)

			-- Otherwise, activate next node (if possible).
			if targetTile.nextPathNode then
				targetTile.nextPathNode:activate(peep)
			else
				movement.isStopping = true
			end
		end
	end
end

return MoveToTileCortex
