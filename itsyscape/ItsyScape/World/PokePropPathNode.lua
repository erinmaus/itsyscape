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

local PokePropPathNode = Class(PathNode)
PokePropPathNode.CHANNEL = {}

function PokePropPathNode:new(action, prop, ...)
	PathNode.new(self, ...)
	self.action = action
	self.prop = prop
end

function PokePropPathNode:activate(peep)
	PathNode.activate(self, peep)

	self.action:perform(peep:getState(), peep, self.prop, PokePropPathNode.CHANNEL)
	peep:getCommandQueue(PokePropPathNode.CHANNEL):push(CallbackCommand(self.finish, self, peep))
end

function PokePropPathNode:finish(peep)
	PathNode.finish(self, peep)

	local n = self:getNextNode()
	if n then
		n:activate(peep)
	end
end

return PokePropPathNode
