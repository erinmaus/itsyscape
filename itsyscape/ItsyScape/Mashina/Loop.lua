--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Loop.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local Loop = B.Node("Loop")
Loop.RESULT = B.Reference()
Loop.ITEMS = B.Reference()
Loop.INDEX = B.Local()

function Loop:update(mashina, state, executor)
	local index = state[self.INDEX] or 1

	local items = state[self.ITEMS]
	if not items then
		return B.Status.Failure
	end

	local children = { self.tree:children(self.node) }
	while index <= #items do
		local result = items[index]
		state[self.RESULT] = result

		for i = 1, #children do
			local r = executor:update(children[i])
			if r == B.Status.Working then
				return B.Status.Working
			elseif r == B.Status.Failure then
				state[self.INDEX] = nil
				executor:drop()
				return B.Status.Failure
			end
		end

		index = index + 1
		state[self.INDEX] = index
	end

	state[self.INDEX] = nil
	return B.Status.Success
end

function Loop:deactivated(mashina, state)
	state[self.INDEX] = nil
end

function Loop:activated(mashina, state)
	state[self.INDEX] = 1
end

return Loop
