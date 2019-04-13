--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Compute.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Compute = B.Node("Compute")
Compute.INPUT = B.Reference()
Compute.OUTPUT = B.Reference()
Compute.FUNC = B.Reference()

function Compute:update(mashina, state, executor)
	local f = state[self.FUNC]
	if type(f) == 'table' or type(f) == 'function' then
		state[self.OUTPUT] = f(state[self.INPUT])
	end

	return B.Status.Success
end

return Compute
