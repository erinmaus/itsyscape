--------------------------------------------------------------------------------
-- ItsyScape/Peep/Cortexes/ActorPositionUpdateCortex.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Cortex = require "ItsyScape.Peep.Cortex"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local ActorPositionUpdateCortex = Class(Cortex)

function ActorPositionUpdateCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(PositionBehavior)

	self.positions = setmetatable({}, { __mode = 'k' })
	self.layers = setmetatable({}, { __mode = 'k' })
end

function ActorPositionUpdateCortex:update(delta)
	local game = self:getDirector():getGameInstance()
	local finished = {}

	for peep in self:iterate() do
		local position = peep:getBehavior(PositionBehavior)
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		if actor then
			if position.position ~= self.positions[actor] or position.layer ~= self.layers[actor] then
				actor:move(position.position, position.layer)
				self.positions[actor] = Vector(position.position:get())
				self.layers[actor] = position.layer
			end
		end
	end
end

return ActorPositionUpdateCortex
