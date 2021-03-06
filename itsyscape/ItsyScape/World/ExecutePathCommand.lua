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
		node.onBegin:register(ExecutePathCommand.next, self)
		node.onInterrupt:register(ExecutePathCommand.cancel, self)
	end

	self.path = path
	self.index = 1
	self.canceled = false
	self.onCanceled = Callback()

	self.distance = distance or 0
end

function ExecutePathCommand:getPath()
	return self.path
end

function ExecutePathCommand:getIsFinished()
	return self.index > self.path:getNumNodes() or self.canceled
end

function ExecutePathCommand:next()
	self.index = self.index + 1
end

function ExecutePathCommand:cancel()
	self.canceled = true
	self.onCanceled()
end

function ExecutePathCommand:step(peep)
	local game = peep:getDirector():getGameInstance()
	local position = peep:getBehavior(PositionBehavior)
	if position then
		position = position.position

		local map = game:getDirector():getMap(position.layer or 1)
		if map then
			local tile, i, j = map:getTileAt(position.x, position.z)
			if tile then
				local target = self.path:getNodeAtIndex(-1)
				if target then
					local di = math.abs(i - target.i)
					local dj = math.abs(j - target.j)

					if di + dj <= self.distance or
					   di == dj and di == self.distance
					then
						local n = self.path:getNodeAtIndex(self.index)
						if n then
							n:interrupt(peep)
						end

						self.index = self.path:getNumNodes() + 1

						return false
					end
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
end

function ExecutePathCommand:onInterrupt(peep)
	local n = self.path:getNodeAtIndex(self.index)
	if n then
		n:interrupt(peep)
	end
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
