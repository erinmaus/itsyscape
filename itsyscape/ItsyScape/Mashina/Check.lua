--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Check.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Check = B.Node("Check")
Check.CONDITION = B.Reference()

function Check:update(mashina, state)
	local a = state[self.CONDITION]

	if a then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return Check
