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
	local k
	do
		local position = mashina:getBehavior(PositionBehavior)
		if position then
			k = position.layer or 1
		else
			k = 1
		end
	end

	local s = Utility.Peep.walk(
		mashina,
		state[self.I] or 0,
		state[self.J] or 0,
		state[self.K] or k)
	if s then
		return B.Status.Success
	else
		return B.Status.Failure
	end
end

return WalkToTile
