--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/HasQueuedPower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"

local HasQueuedPower = B.Node("HasQueuedPower")
HasQueuedPower.TARGET = B.Reference()

function HasQueuedPower:update(mashina, state, executor)
	local peep = state[self.TARGET] or mashina

	if not peep:hasBehavior(PendingPowerBehavior) then
		return B.Status.Failure
	end

	return B.Status.Success
end

return HasQueuedPower
