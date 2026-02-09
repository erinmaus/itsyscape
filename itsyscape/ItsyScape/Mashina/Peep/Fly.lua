--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Player/Fly.lua
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

local Fly = B.Node("Fly")
Fly.PEEP = B.Reference()

function Fly:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local flying = peep:getBehavior(FlyingBehavior)
	if not flying or flying.isFlying then
		return B.Status.Failure
	end

	flying.isFlying = true
	return B.Status.Success
end

return Fly
