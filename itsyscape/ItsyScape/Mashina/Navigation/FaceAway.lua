--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/FaceAway.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local MovementBehavior = require "ItsyScape.Peep.Behaviors.MovementBehavior"

local FaceAway = B.Node("FaceAway")
FaceAway.SOURCE = B.Reference()
FaceAway.TARGET = B.Reference()
FaceAway.DIRECTION = B.Reference()

function FaceAway:update(mashina, state, executor)
	local source = state[self.SOURCE] or mashina

	local direction = state[self.DIRECTION]
	local target = state[self.TARGET]

	if not target then
		local movement = mashina:getBehavior(MovementBehavior)
		if movement then
			movement.facing = -(direction or movement.facing)
			movement.targetFacing = -(direction or movement.facing)

			return B.Status.Success
		end

		return B.Status.Failure
	end

	if source:getLayerName() == target:getLayerName() then
		Utility.Peep.faceAway(source, target)
		return B.Status.Success
	end

	return B.Status.Failure
end

return FaceAway
