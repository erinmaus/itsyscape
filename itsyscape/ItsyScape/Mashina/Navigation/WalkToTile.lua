--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/WalkToTile.lua
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

local WalkToTile = B.Node("WalkToTile")
WalkToTile.I = B.Reference()
WalkToTile.J = B.Reference()
WalkToTile.K = B.Reference()

function WalkToTile:update(mashina, state, executor)
	local k = Utility.Peep.getLayer(mashina)

	local s
	if not self.walk then
		self.walk = coroutine.wrap(Utility.Peep.walk)
		s = self.walk(
			mashina,
			state[self.I] or 0,
			state[self.J] or 0,
			state[self.K] or k)
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

function WalkToTile:deactivated()
	self.walk = nil
end

return WalkToTile
