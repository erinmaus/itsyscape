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

local Land = B.Node("Land")
Land.PEEP = B.Reference()

function Land:update(mashina, state, executor)
	local peep = state[self.PEEP] or mashina

	local flying = peep:getBehavior(FlyingBehavior)
	if not (flying and flying.isFlying) then
		return B.Status.Failure
	end

	flying.isFlying = false
	return B.Status.Success
end

return Land
