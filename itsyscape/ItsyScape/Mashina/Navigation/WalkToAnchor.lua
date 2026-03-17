--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/WalkToAnchor.lua
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
WalkToPeep.ANCHOR = B.Reference()
WalkToPeep.DISTANCE = B.Reference()
WalkToPeep.AS_CLOSE_AS_POSSIBLE = B.Reference()

function WalkToPeep:update(mashina, state, executor)
	local anchor = state[self.ANCHOR]
	if not anchor then
		return B.Status.Failure
	end

	if not self.walkID then
		if not Utility.Map.hasAnchor(mashina:getDirector():getGameInstance(), Utility.Peep.getMapResource(mashina), anchor) then
			Log.info("Anchor '%s' doesn't exist; peep '%s' cannot walk to it.", anchor, mashina:getName())
			return B.Status.Failure
		end

		local x, _, z = Utility.Map.getAnchorPosition(
			mashina:getDirector():getGameInstance(),
			Utility.Peep.getMapResource(mashina),
			anchor)
		local map = Utility.Peep.getMap(mashina)

		local _, i, j = map:getTileAt(x,z)
		local k = Utility.Peep.getLayer(mashina)

		local callback, id = Utility.Peep.queueWalk(mashina, i, j, k, state[self.DISTANCE], {
			asCloseAsPossible = state[self.AS_CLOSE_AS_POSSIBLE]
		})

		self.walkID = id
		self.walkStatus = nil
		callback:register(function(status)
			self.walkStatus = status
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

function WalkToPeep:deactivated()
	if self.walkID then
		Utility.Peep.cancelWalk(self.walkID)
		self.walkID = nil
	end
end

return WalkToPeep
