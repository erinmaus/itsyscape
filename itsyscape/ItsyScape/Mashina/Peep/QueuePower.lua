--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/QueuePower.lua
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

local QueuePower = B.Node("QueuePower")
QueuePower.POWER = B.Reference()
QueuePower.CLEAR_COOL_DOWN = B.Reference()
QueuePower.REQUIRE_NO_COOLDOWN = B.Reference()

function QueuePower:update(mashina, state, executor)
	local gameDB = mashina:getDirector():getGameDB()
	local powerResource = gameDB:getResource(state[self.POWER], "Power")

	if not powerResource then
		Log.warn("Unknown power: %s.", tostring(state[self.POWER]))
		return B.Status.Failure
	end

	local coolDown = mashina:getBehavior(PowerCoolDownBehavior)
	if coolDown then
		local clearCoolDown = state[self.CLEAR_COOL_DOWN] or false
		local requireNoCooldown = state[self.REQUIRE_NO_COOLDOWN] or false
		if clearCoolDown then
			coolDown.powers[powerResource.id.value] = nil
		elseif requireNoCooldown then
			if coolDown.powers[powerResource.id.value] then
				return B.Status.Failure
			end
		end
	end

	local power
	do
		local PowerType = Utility.Peep.getPowerType(powerResource, gameDB)
		if not PowerType then
			Log.warn("Couldn't find underlying type for power: %s", tostring(state[self.POWER]))
			return B.Status.Failure
		end

		power = PowerType(mashina:getDirector():getGameInstance(), powerResource)

		local _, b = mashina:addBehavior(PendingPowerBehavior)
		b.power = power
	end

	return B.Status.Success
end

return QueuePower
