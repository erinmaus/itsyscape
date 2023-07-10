--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Peep/ActivatePrayer.lua
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

local ActivatePrayer = B.Node("ActivatePrayer")
ActivatePrayer.PRAYER = B.Reference()

function ActivatePrayer:update(mashina, state, executor)
	local game = mashina:getDirector():getGameInstance()
	local gameDB = mashina:getDirector():getGameDB()
	local prayer = gameDB:getResource(state[self.PRAYER], "Effect")

	if not prayer then
		Log.warn("Unknown prayer: %s.", tostring(state[self.PRAYER]))
		return B.Status.Failure
	end

	local action
	do
		local actions = Utility.getActions(game, prayer, 'prayer')
		for i = 1, #actions do
			if actions[i].instance:is("pray") then
				action = actions[i]
				break
			end
		end
	end

	if not action then
		Log.warn("Can't activate prayer '%s'; no 'Pray' action.", tostring(state[self.PRAYER]))
		return B.Status.Failure
	end

	local success = action.instance:perform(mashina:getState(), mashina)
	if success then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return ActivatePrayer
