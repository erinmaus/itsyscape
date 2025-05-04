--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Sailing/FireCannons.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Class = require "ItsyScape.Common.Class"
local Sailing = require "ItsyScape.Game.Skills.Sailing"
local ShipCaptainBehavior = require "ItsyScape.Peep.Behaviors.ShipCaptainBehavior"

local FireCannons = B.Node("FireCannons")
FireCannons.TARGET = B.Reference()
FireCannons.DIRECTION = B.Reference()
FireCannons.ALWAYS = B.Reference()
FireCannons.HITS = B.Reference()

function FireCannons:update(mashina, state, executor)
	local director = mashina:getDirector()

	local target = state[self.TARGET]
	local direction = state[self.DIRECTION]
	local always = state[self.ALWAYS] or false

	local ship = mashina:getBehavior(ShipCaptainBehavior)
	ship = ship and ship.peep
	if not ship then
		Log.warnOnce("Peep '%s' is not currently a captain of a ship!", mashina:getName())
		return B.Status.Failure
	end

	local position = Sailing.getShipTarget(ship, target)
	if not position and not direction then
		return B.Status.Failure
	end

	local normal = Sailing.getShipForward(target)

	local cannonProbe = Sailing.probeShipCannons(ship, position, normal, direction, always)
	local count = Sailing.fireShipCannons(ship, cannonProbe)

	state[self.HITS] = count

	if count == 0 then
		return B.Status.Failure
	else
		return B.Status.Success
	end
end

return FireCannons
