--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/GetNearestOffset.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"
local ShipMovementBehavior = require "ItsyScape.Peep.Behaviors.ShipMovementBehavior"

local GetNearestOffset = B.Node("GetNearestOffset")
GetNearestOffset.TARGET = B.Reference()
GetNearestOffset.RESULT = B.Reference()

function GetNearestOffset:update(mashina, state, executor)
	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warnOnce("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local target = state[self.TARGET] or ship
	local shipMovement = target:getBehavior(ShipMovementBehavior)
	local direction = shipMovement and shipMovement.steerDirection

	if direction then
		state[self.RESULT] = direction
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return GetNearestOffset
