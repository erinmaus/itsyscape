--------------------------------------------------------------------------------
-- ItsyScape/Mashina/RandomTry.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local RandomTry = B.Node("RandomTry")
RandomTry.INDEX = B.Local()
RandomTry.CAN_REPEAT = B.Reference()

function RandomTry:update(mashina, state, executor)
	local children = { self.tree:children(self.node) }
	local index = state[self.INDEX] or love.math.random(#children)
	state[self.INDEX] = index

	local retry
	for i = 1, #children do
		if i == index then
			local r = executor:update(children[i])

			if r == B.Status.Working then
				return B.Status.Working
			elseif r == B.Status.Failure then
				executor:drop()
				retry = true
			else
				executor:drop()
				state[self.INDEX] = nil
				return B.Status.Success
			end

			if retry then
				break
			end
		else
			executor:visit(children[i])
		end
	end

	if retry and #children > 1 then
		if state[self.CAN_REPEAT] then
			index = love.math.random(#children)
		else
			local newIndex
			repeat
				newIndex = love.math.random(#children)
			until newIndex ~= index

			index = newIndex
		end

		state[self.INDEX] = index

		return B.Status.Working
	end

	return B.Status.Failure
end

return RandomTry
