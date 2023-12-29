--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Yield.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local Utility = require "ItsyScape.Game.Utility"

local Yield = B.Node("Yield")
Yield.PENDING = B.Local()

function Yield:update(mashina, state, executor)
	if state[self.PENDING] then
		state[self.PENDING] = false

		return B.Status.Working
	end

	state[self.PENDING] = true
	return B.Status.Success
end

function Yield:activated(mashina, state, executor)
	state[self.PENDING] = true
end

function Yield:deactivated(mashina, state, executor)
	state[self.PENDING] = false
end

return Yield
