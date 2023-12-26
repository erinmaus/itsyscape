--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Set.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Set = B.Node("Set")
Set.VALUE = B.Reference()
Set.RESULT = B.Reference()

function Set:update(mashina, state, executor)
	local a = state[self.VALUE]

	if type(a) == 'function' then
		a = a(mashina, state, executor)
	end

	state[self.RESULT] = a

	return B.Status.Success
end

return Set
