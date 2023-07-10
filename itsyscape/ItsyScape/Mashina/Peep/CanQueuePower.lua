--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/CanQueuePower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local PowerCoolDownBehavior = require "ItsyScape.Peep.Behaviors.PowerCoolDownBehavior"
local PendingPowerBehavior = require "ItsyScape.Peep.Behaviors.PendingPowerBehavior"

local CanQueuePower = B.Node("CanQueuePower")
CanQueuePower.POWER = B.Reference()

function CanQueuePower:update(mashina, state, executor)
	local gameDB = mashina:getDirector():getGameDB()
	local powerResource = gameDB:getResource(state[self.POWER], "Power")

	if not powerResource then
		Log.warn("Unknown power: %s.", tostring(state[self.POWER]))
		return B.Status.Failure
	end

	local coolDown = mashina:getBehavior(PowerCoolDownBehavior)
	if coolDown then
		if coolDown.powers[powerResource.id.value] then
			return B.Status.Failure
		end
	end

	return B.Status.Success
end

return CanQueuePower
