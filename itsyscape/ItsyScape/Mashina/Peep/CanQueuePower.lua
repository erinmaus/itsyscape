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
local CombatStatusBehavior = require "ItsyScape.Peep.Behaviors.CombatStatusBehavior"

local CanQueuePower = B.Node("CanQueuePower")
CanQueuePower.PEEP = B.Reference()
CanQueuePower.POWER = B.Reference()

function CanQueuePower:update(mashina, state, executor)
	local gameDB = mashina:getDirector():getGameDB()
	local powerResource = gameDB:getResource(state[self.POWER], "Power")

	if not powerResource then
		Log.warn("Unknown power: %s.", tostring(state[self.POWER]))
		return B.Status.Failure
	end

	local PowerType = Utility.Peep.getPowerType(powerResource, gameDB)
	if not PowerType then
		return B.Status.Failure
	end

	local peep = state[self.PEEP] or mashina

	local status = peep:getBehavior(CombatStatusBehavior)
	if not status then
		return B.Status.Failure
	end

	local zeal = math.floor(status.currentZeal * 100)

	local power = PowerType(peep:getDirector():getGameInstance(), powerResource)
	local zealCost = math.floor(power:getCost(peep) * 100)

	if zealCost > zeal then
		return B.Status.Failure
	end

	return B.Status.Success
end

return CanQueuePower
