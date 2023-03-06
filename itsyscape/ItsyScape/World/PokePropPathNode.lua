--------------------------------------------------------------------------------
-- ItsyScape/World/PokePropPathNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PathNode = require "ItsyScape.World.PathNode"
local CallbackCommand = require "ItsyScape.Peep.CallbackCommand"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local PokePropPathNode = Class(PathNode)
PokePropPathNode.CHANNEL = {}

function PokePropPathNode:new(action, prop, ...)
	PathNode.new(self, ...)
	self.action = action
	self.prop = prop
	self.isPending = true
end

function PokePropPathNode:activate(peep)
	PathNode.activate(self, peep)

	local _, b = peep:addBehavior(TargetTileBehavior)
	b.pathNode = self
	b.nextPathNode = self:getNextNode()

	self.action:perform(peep:getState(), peep, self.prop, PokePropPathNode.CHANNEL)
	peep:getCommandQueue(PokePropPathNode.CHANNEL):push(CallbackCommand(self.finish, self, peep))
end

function PokePropPathNode:finish(peep)
	PathNode.finish(self, peep)

	self.isPending = false

	local n = self:getNextNode()
	local b = peep:getBehavior(TargetTileBehavior)
	if n and (not b or b.nextPathNode == n) then
		n:activate(peep)
	end
end

function PokePropPathNode:getIsPending()
	return self.isPending
end

return PokePropPathNode
