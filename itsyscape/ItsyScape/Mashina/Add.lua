--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Add.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Add = B.Node("Add")
Add.LEFT = B.Reference()
Add.RIGHT = B.Reference()
Add.RESULT = B.Reference()

function Add:update(mashina, state, executor)
	local a = state[self.LEFT] or 0
	local b = state[self.RIGHT] or 0
	state[self.RESULT] = a + b

	return B.Status.Success
end

return Add
