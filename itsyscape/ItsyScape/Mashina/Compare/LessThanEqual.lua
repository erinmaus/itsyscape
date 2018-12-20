--------------------------------------------------------------------------------
-- ItsyScape/Mashina/LessThanEqual.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local LessThanEqual = B.Node("LessThanEqual")
LessThanEqual.LEFT = B.Reference()
LessThanEqual.RIGHT = B.Reference()
LessThanEqual.RESULT = B.Reference()

function LessThanEqual:update(mashina, state, executor)
	local a = state[self.LEFT] or 0
	local b = state[self.RIGHT] or 0

	if a <= b then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return LessThanEqual
