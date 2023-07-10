--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Step.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Step = B.Node("Step")
Step.INDEX = B.Local()
Step.DEBUG = B.Reference()

function Step:update(mashina, state, executor)
	local index = state[self.INDEX] or 1
	local children = { self.tree:children(self.node) }
	for i = 1, #children do
		if i >= index then
			local r = executor:update(children[i])
			if r == B.Status.Working then
				return B.Status.Working
			elseif r == B.Status.Failure then
				state[self.INDEX] = nil
				executor:drop()
				return B.Status.Failure
			else
				index = index + 1
				state[self.INDEX] = index
			end
		else
			executor:visit(children[i])
		end
	end

	state[self.INDEX] = nil
	executor:drop()
	return B.Status.Success
end

function Step:deactivated(mashina, state)
	state[self.INDEX] = nil
end

function Step:activated(mashina, state)
	state[self.INDEX] = 1
end

return Step
