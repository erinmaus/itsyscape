--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/Wait.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Probe = require "ItsyScape.Peep.Probe"
local Utility = require "ItsyScape.Game.Utility"

local Wait = B.Node("Wait")
Wait.QUEUE = B.Reference()

function Wait:update(mashina, state, executor)
	local q = state[self.QUEUE]
	if mashina:getCommandQueue(q):getIsPending() then
		return B.Status.Working
	end

	return B.Status.Success
end

return Wait
