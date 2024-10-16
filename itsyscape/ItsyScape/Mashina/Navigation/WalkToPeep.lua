--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/WalkToPeep.lua
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
local PositionBehavior = require "ItsyScape.Peep.Behaviors.PositionBehavior"

local WalkToPeep = B.Node("WalkToPeep")
WalkToPeep.PEEP = B.Reference()
WalkToPeep.DISTANCE = B.Reference()
WalkToPeep.AS_CLOSE_AS_POSSIBLE = B.Reference()

function WalkToPeep:update(mashina, state, executor)
	local peep = state[self.PEEP]
	if not peep then
		return B.Status.Failure
	end

	local s
	if not self.walk then
		local i, j, k = Utility.Peep.getTile(peep)
		self.walk = coroutine.wrap(Utility.Peep.walk)
		s = self.walk(mashina, i, j, k, state[self.DISTANCE], {
			asCloseAsPossible = state[self.AS_CLOSE_AS_POSSIBLE],
			yield = true
		})
	else
		s = self.walk()
	end

	if s ~= nil then
		self.walk = nil

		if s then
			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

function WalkToPeep:deactivated()
	self.walk = nil
end

return WalkToPeep
