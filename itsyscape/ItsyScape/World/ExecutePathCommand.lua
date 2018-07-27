--------------------------------------------------------------------------------
-- ItsyScape/World/ExecutePathCommand.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Command = require "ItsyScape.Peep.Command"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local ExecutePathCommand = Class(Command)

function ExecutePathCommand:new(path, distance)
	Command.new(self)

	for i = 1, path:getNumNodes() do
		local node = path:getNodeAtIndex(i)
		node.onBegin:register(ExecutePathCommand.next, self)
	end

	self.path = path
	self.index = 1
	self.distance = distance or 0
end

function ExecutePathCommand:getIsFinished()
	return self.index > self.path:getNumNodes()
end

function ExecutePathCommand:next()
	self.index = self.index + 1
end

function ExecutePathCommand:step(peep)
	local game = peep:getDirector():getGameInstance()
	local position = peep:getBehavior(PositionBehavior)
	if position then
		position = position.position

		local map = game:getStage():getMap(position.layer or 1)
		if map then
			local tile, i, j = map:getTileAt(position.x, position.z)
			if tile then
				local target = self.path:getNodeAtIndex(-1)
				if target then
					local di = math.abs(i - target.i)
					local dj = math.abs(j - target.j)

					if di + dj <= self.distance then
						self:onInterrupt(peep)
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
	self:step(peep)
end

return ExecutePathCommand
