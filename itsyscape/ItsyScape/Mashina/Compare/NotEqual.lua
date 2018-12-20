--------------------------------------------------------------------------------
-- ItsyScape/Mashina/NotEqual.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local NotEqual = B.Node("NotEqual")
NotEqual.LEFT = B.Reference()
NotEqual.RIGHT = B.Reference()
NotEqual.RESULT = B.Reference()

function NotEqual:update(mashina, state, executor)
	local a = state[self.LEFT] or 0
	local b = state[self.RIGHT] or 0

	if a ~= b then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return NotEqual
