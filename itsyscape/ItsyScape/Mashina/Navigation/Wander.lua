--------------------------------------------------------------------------------
-- ItsyScape/Mashina/Navigation/Wander.lua
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

local Wander = B.Node("Wander")
Wander.MIN_RADIAL_DISTANCE = B.Reference()
Wander.RADIAL_DISTANCE = B.Reference()
Wander.WANDER_I = B.Reference()
Wander.WANDER_J = B.Reference()

function Wander:update(mashina, state, executor)
	local k
	do
		local position = mashina:getBehavior(PositionBehavior)
		if position then
			k = position.layer or 1
		else
			k = 1
		end
	end

	local wanderI, wanderJ
	do
		if state[self.WANDER_I] ~= nil then
			wanderI = state[self.WANDER_I]
		else
			wanderI = true
		end

		if state[self.WANDER_J] ~= nil then
			wanderJ = state[self.WANDER_J]
		else
			wanderJ = true
		end
	end

	local tile, i, j
	do
		local mapObject = Utility.Peep.getMapObject(mashina)
		if mapObject then
			local gameDB = mashina:getDirector():getGameDB()
			local record = gameDB:getRecord("MapObjectLocation", { Resource = mapObject })
			if record then
				local map = mashina:getDirector():getGameInstance():getStage():getMap(k)
				if not map then
					return B.Status.Failure
				end

				local x = record:get("PositionX") or 0
				local y = record:get("PositionY") or 0
				local z = record:get("PositionZ") or 0
				tile, i, j = map:getTileAt(x, z)
			end
		end
	end

	if not i or not j then
		i, j, k, tile = Utility.Peep.getTile(mashina)
	end

	if tile:hasFlag('impassable') then
		return B.Status.Working
	end

	local radialDistance = state[self.RADIAL_DISTANCE] or 5

	local s, t
	do
		local min = state[self.MIN_RADIAL_DISTANCE] or 0
		local max = radialDistance - min
		if wanderI then
			s = math.random(-max, max) + min
		else
			s = 0
		end

		if wanderJ  then
			t = math.random(-max, max) + min
		else
			t = 0
		end
	end

	local targetI = i + s
	local targetJ = j + t

	local command, path = Utility.Peep.getWalk(
		mashina,
		targetI,
		targetJ,
		k,
		0,
		{ asCloseAsPossible = true, maxDistanceFromGoal = radialDistance })
	if command then
		if mashina:getCommandQueue():interrupt(command) then
			return B.Status.Success
		else
			return B.Status.Failure
		end
	else
		return B.Status.Working
	end
end

return Wander
