--------------------------------------------------------------------------------
-- ItsyScape/Mashina/GreaterThanEqual.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local GreaterThanEqual = B.Node("GreaterThanEqual")
GreaterThanEqual.LEFT = B.Reference()
GreaterThanEqual.RIGHT = B.Reference()
GreaterThanEqual.RESULT = B.Reference()

function GreaterThanEqual:update(mashina, state, executor)
	local a = state[self.LEFT] or 0
	local b = state[self.RIGHT] or 0

	if a >= b then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return GreaterThanEqual
