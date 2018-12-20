--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/PathRandom.lua
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

local PathRandom = B.Node("PathRandom")
PathRandom.TILES = B.Reference()
PathRandom.SELECTED_TILE = B.Reference()

function PathRandom:update(mashina, state, executor)
	local k
	do
		local position = mashina:getBehavior(PositionBehavior)
		if position then
			k = position.layer or 1
		else
			k = 1
		end
	end

	local tile
	do
		local tiles = state[self.TILES] or {}
		if #tiles == 0 then
			return B.Status.Failure
		else
			tile = tiles[math.random(#tiles) + 1]
		end
	end

	local command, path = Utility.Peep.getWalk(
		mashina,
		tile.i or tile[1],
		tile.j or tile[2],
		k,
		0,
		{ asCloseAsPossible = true })

	if command then
		if mashina:getCommandQueue():interrupt(command) then
			state[self.SELECTED_TILE] = tile
			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

return PathRandom
