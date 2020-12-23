--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Random.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Random = B.Node("Random")
Random.MIN = B.Reference()
Random.MAX = B.Reference()
Random.RESULT = B.Reference()

function Random:update(mashina, state, executor)
	local min = state[self.MIN]
	local max = state[self.MAX]

	if min == nil and max == nil then
		state[self.RESULT] = math.random()
	else
		state[self.RESULT] = math.random(min, max)
	end

	return B.Status.Success
end

return Random
