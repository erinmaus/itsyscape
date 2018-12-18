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
Face.DIRECTION = B.Reference()

function Face:update(mashina, state, executor)
	local direction = state[self.DIRECTION]

	local movement = mashina:getBehavior(MovementBehavior)
	if movement then
		movement.facing = direction or movement.facing
		movement.targetFacing = direction or movement.facing

		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return Face
