--------------------------------------------------------------------------------
-- ItsyScape/World/ExecutePathCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Command = require "ItsyScape.Peep.Command"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local ExecutePathCommand = Class(Command)

function ExecutePathCommand:new(path, distance, canceled)
	Command.new(self)

	for i = 1, path:getNumNodes() do
		local node = path:getNodeAtIndex(i)
		node.onInterrupt:register(ExecutePathCommand.cancel, self)
	end

	self.path = path
	self.canceled = false
	self.onCanceled = Callback()

	self.distance = distance or 0
end

function ExecutePathCommand:getPath()
	return self.path
end

function ExecutePathCommand:getIsFinished()
	return self.peep and not self.peep:hasBehavior(TargetTileBehavior)
end

function ExecutePathCommand:cancel()
	self.canceled = true
	self.onCanceled()
end

function ExecutePathCommand:step(peep)
	local position = peep:getBehavior(PositionBehavior)
	if position then
		local layer = position.layer
		position = position.position

		local map = peep:getDirector():getMap(layer or 1)
		if map then
			local target = self.path:getNodeAtIndex(-1)
			if target then
				local center = map:getTileCenter(target.i, target.j) * Vector.PLANE_XZ
				local distance = (center - (Utility.Peep.getPosition(peep) * Vector.PLANE_XZ)):getLength()

				if distance <= self.distance then
					self:onInterrupt(peep)

					return false
				end
			end
		end
	end

	return true
end

function ExecutePathCommand:onBegin(peep)
	if self:step(peep) then
		peep:poke('walk', {
			i = i,
			j = j,
			k = k
		})

		self.path:activate(peep)
	end

	self.peep = peep
end

function ExecutePathCommand:onInterrupt(peep)
	local targetTile = peep:getBehavior(TargetTileBehavior)
	if targetTile and targetTile.pathNode then
		targetTile.pathNode:interrupt(peep)
	elseif targetTile then
		peep:removeBehavior(TargetTileBehavior)
	end

	self:cancel()
end

function ExecutePathCommand:update(delta, peep)
	if not self:step(peep) or self:getIsFinished() then
		local movement = peep:getBehavior(MovementBehavior)
		if movement then
			movement.isStopping = true
		end
	end
end

return ExecutePathCommand
