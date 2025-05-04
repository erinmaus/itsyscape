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
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Cortex = require "ItsyScape.Peep.Cortex"
local ActorReferenceBehavior = require "ItsyScape.Peep.Behaviors.ActorReferenceBehavior"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local RotationBehavior = require "ItsyScape.Peep.Behaviors.RotationBehavior"

local ActorDirectionUpdateCortex = Class(Cortex)

function ActorDirectionUpdateCortex:new()
	Cortex.new(self)

	self:require(ActorReferenceBehavior)
	self:require(MovementBehavior)

	self.directions = setmetatable({}, { __mode = 'k' })
	self.rotations = setmetatable({}, { __mode = 'k' })
end

function ActorDirectionUpdateCortex:update(delta)
	local game = self:getDirector():getGameInstance()

	for peep in self:iterate() do
		local movement = peep:getBehavior(MovementBehavior)
		local direction = movement.velocity
		local facing = movement.facing
		local actor = peep:getBehavior(ActorReferenceBehavior).actor

		if actor then
			local xzDirection = direction * Vector(1, 0, 1)
			if xzDirection:getLength() == 0 then
				direction = Vector.UNIT_X * facing
			end

			local rotation = peep:getBehavior(RotationBehavior)

			if direction ~= self.directions[actor] or (rotation and rotation.rotation ~= self.rotations[actor]) then
				actor:setDirection(direction)
				self.directions[actor] = direction
				self.rotations[actor] = rotation and Quaternion(rotation.rotation:get())
			end
		end
	end
end

return ActorDirectionUpdateCortex
