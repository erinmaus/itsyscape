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
local QueueWalkCommand = require "ItsyScape.Peep.QueueWalkCommand"
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

	if not self.walkID then
		local i, j, k = Utility.Peep.getTile(peep)
		local callback, id = Utility.Peep.queueWalk(mashina, i, j, k, state[self.DISTANCE], {
			asCloseAsPossible = state[self.AS_CLOSE_AS_POSSIBLE]
		})

		callback:register(function(status, cancelled)
			if cancelled then
				self.walkID = nil
			else
				if status then
					Log.info("Success walking to (%d, %d; %d) for '%s'.", i, j, k, mashina:getName())
				else
					Log.info("Failure walking to (%d, %d; %d) for '%s'.", i, j, k, mashina:getName())
				end

				self.walkStatus = status
			end
		end)
	end

	local status = self.walkStatus
	if status ~= nil then
		self.walkStatus = nil

		if status then
			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

return WalkToPeep
