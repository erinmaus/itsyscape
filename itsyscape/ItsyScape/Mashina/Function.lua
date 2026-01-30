--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Function.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Function = B.Node("Function")
Function.FUNC = B.Reference()

function Function:update(mashina, state, executor)
	local func = state[self.FUNC]
	if not func then
		return B.Status.Failure
	end

	local status = func(mashina, state, executor)
	if status == nil or status == true then
		return B.Status.Success
	elseif status == false then
		return B.Status.Failure
	end

	return status
end

return Function
