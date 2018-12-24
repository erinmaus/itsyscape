--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/PathFollow.lua
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

local PathFollow = B.Node("PathFollow")
PathFollow.TILES = B.Reference()
PathFollow.SELECTED_TILE = B.Reference()
PathFollow.CURRENT_INDEX = B.Local()

function PathFollow:update(mashina, state, executor)
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
		local index = state[self.CURRENT_INDEX] or 1
		if #tiles == 0 then
			return B.Status.Failure
		else
			tile = tiles[index]
		end

		index = index + 1
		if index > #tiles then
			index = 1
		end

		state[self.CURRENT_INDEX] = index

		if type(tile) == 'string' then
			Log.info("Chose anchor %s.", tile)

			local mapResource = Utility.Peep.getMap(mashina)
			local gameDB = mashina:getDirector():getGameDB()
			local anchor = gameDB:getRecord( "MapObjectLocation",{
				Name = tile,
				Map = mapResource
			})
			if anchor then
				local map = mashina:getDirector():getMap(k)
				if map then
					local _, i, j = map:getTileAt(anchor:get("PositionX"), anchor:get("PositionZ"))
					tile = { i = i, j = j, name = tile }
				end
			end
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
			if tile.name then
				state[self.SELECTED_TILE] = tile.name
			else
				state[self.SELECTED_TILE] = tile
			end

			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

return PathFollow
