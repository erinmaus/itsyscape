--------------------------------------------------------------------------------
-- ItsyScape/Mashina/RandomSequence.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"

local RandomSequence = B.Node("RandomSequence")

function RandomSequence:update(mashina, state, executor)
	local children = { self.tree:children(self.node) }

	return executor:update(children[math.random(#children)])
end

return RandomSequence
