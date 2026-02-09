--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/IsFlying.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local FlyingBehavior = require "ItsyScape.Peep.Behaviors.FlyingBehavior"

local IsFlying = B.Node("IsFlying")
IsFlying.PEEP = B.Reference()

function IsFlying:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local flying = peep:getBehavior(FlyingBehavior)
	if not flying then
		return B.Status.Failure
	end

	if not flying.isFlying then
		return B.Status.Failure
	end

	return B.Status.Success
end

return IsFlying
