--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/SetState.lua
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
local MashinaBehavior = require "ItsyScape.Peep.Behaviors.MashinaBehavior"

local SetState = B.Node("SetState")
SetState.STATE = B.Reference()

function SetState:update(mashina, state, executor)
	local mashina = mashina:getBehavior(MashinaBehavior)
	if mashina then
		mashina.currentState = state[self.STATE] or false

		return B.Status.Success
	end

	return B.Status.Failure
end

return SetState
