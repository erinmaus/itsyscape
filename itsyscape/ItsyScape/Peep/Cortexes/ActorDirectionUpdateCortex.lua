--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/ActorDirectionUpdateCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Cortex = require "ItsyScape.Peep.Cortex"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local ActorDirectionUpdateCortex = Class(Cortex)

function ActorDirectionUpdateCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(MovementBehavior)
end

function ActorDirectionUpdateCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local direction = peep:getBehavior(MovementBehavior).velocity
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		if actor then
			actor:setDirection(direction)
		end
	end
end

return ActorDirectionUpdateCortex
