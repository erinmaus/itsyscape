--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/Move.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Peep = require "ItsyScape.Peep.Peep"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"
local TargetTileBehavior = require "ItsyScape.Peep.Behaviors.TargetTileBehavior"

local Move = B.Node("Move")
Move.PEEP = B.Reference()
Move.VELOCITY = B.Reference()
Move.ACCELERATION = B.Reference()

function Move:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina
	if not peep then
		return B.Status.Failure
	end

	local movement = peep:getBehavior(MovementBehavior)
	if not movement then
		return B.Status.Failure
	end

	local velocity = state[self.VELOCITY]
	local acceleration = state[self.ACCELERATION]

	if velocity then
		movement.velocity = velocity
	end

	if acceleration then
		movement.acceleration = acceleration
	end

	peep:removeBehavior(TargetTileBehavior)

	if (velocity and velocity:getLength() > 0) or (acceleration and acceleration:getLength() > 0) then
		movement.isStopping = false
	else
		movement.isStopping = true
	end

	return B.Status.Success
end

return Move
