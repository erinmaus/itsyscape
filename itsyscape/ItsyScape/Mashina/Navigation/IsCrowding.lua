--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/IsCrowding.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local B = require "B"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"

local IsCrowding = B.Node("IsCrowding")
IsCrowding.PEEP = B.Reference()
IsCrowding.DISTANCE = B.Reference()

function IsCrowding:update(mashina, state, executor)
	local peep = state[self.PEEP]
	if not peep then
		return B.Status.Failure
	end

	local peepI, peepJ, peepK = Utility.Peep.getTile(peep)
	local selfI, selfJ, selfK = Utility.Peep.getTile(mashina)

	if peepI == selfI and peepJ == selfJ and peepK == selfK then
		return B.Status.Success
	end

	local distance = state[self.DISTANCE] or 1.5

	local peepPosition = Utility.Peep.getAbsolutePosition(peep)
	local selfPosition = Utility.Peep.getAbsolutePosition(mashina)

	local selfDistanceFromPeep = peepPosition:distance(selfPosition)
	if selfDistanceFromPeep <= distance then
		return B.Status.Success
	end

	return B.Status.Failure
end

return IsCrowding
