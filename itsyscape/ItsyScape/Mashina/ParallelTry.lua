--------------------------------------------------------------------------------
-- ItsyScape/Mashina/ParallelTry.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local ParallelTry = B.Node("ParallelTry")

function ParallelTry:update(mashina, state, executor)
	local working = false

	local index = 1
	local children = { self.tree:children(self.node) }
	for i = 1, #children do
		if i >= index then
			local r = executor:update(children[i])
			if r == B.Status.Working then
				working = true
			elseif r == B.Status.Success then
				executor:drop()
				return B.Status.Success
			else
				index = index + 1
			end
		else
			executor:visit(children[i])
		end
	end

	if working then
		return B.Status.Working
	else
		return B.Status.Failure
	end
end

return ParallelTry
