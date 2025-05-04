--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/Face.lua
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

local Face = B.Node("Face")
Face.SOURCE = B.Reference()
Face.TARGET = B.Reference()
Face.DIRECTION = B.Reference()

function Face:update(mashina, state, executor)
	local source = state[self.SOURCE] or mashina

	local direction = state[self.DIRECTION]
	local target = state[self.TARGET]

	if not target then
		local movement = mashina:getBehavior(MovementBehavior)
		if movement then
			movement.facing = direction or movement.facing
			movement.targetFacing = direction or movement.facing

			return B.Status.Success
		end

		return B.Status.Failure
	end

	if source:getLayerName() == target:getLayerName() then
		Utility.Peep.face(source, target)
		return B.Status.Success
	end

	return B.Status.Failure
end

return Face
