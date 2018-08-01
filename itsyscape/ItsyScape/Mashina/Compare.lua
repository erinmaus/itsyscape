--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Compare.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Compare = B.Node("Compare")
Compare.LEFT = B.Reference()
Compare.RIGHT = B.Reference()
Compare.CONDITION = B.Reference()

function Compare:update(mashina, state, executor)
	local a = state[self.LEFT]
	local b = state[self.RIGHT]
	local c = state[self.CONDITION] or function() return false end
	
	if c(a, b) then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return Compare
