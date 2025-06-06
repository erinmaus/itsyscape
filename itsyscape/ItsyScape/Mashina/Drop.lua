--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Drop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Drop = B.Node("Drop")

function Drop:update(mashina, state, executor)
	local child = self.tree:children(self.node)
	if child then
		local r = executor:update(child)
		if r == B.Status.Working then
			return B.Status.Working
		else
			executor:drop()
			return r
		end
	end

	return B.Status.Success
end

return Drop
