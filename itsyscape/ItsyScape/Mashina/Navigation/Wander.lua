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
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local ExecutePathcommand = require "ItsyScape.World.ExecutePathCommand"
local Path = require "ItsyScape.World.Path"
local PositionPathNode = require "ItsyScape.World.PositionPathNode"

local Wander = B.Node("Wander")
Wander.MIN_RADIAL_DISTANCE = B.Reference()
Wander.RADIAL_DISTANCE = B.Reference()
Wander.WANDER_I = B.Reference()
Wander.WANDER_J = B.Reference()

function Wander:update(mashina, state, executor)
	local k = Utility.Peep.getLayer(mashina)

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

	if not tile then
		return B.Status.Failure
	end

	local radialDistance = state[self.RADIAL_DISTANCE] or 5
	local minRadialDistance = state[self.MIN_RADIAL_DISTANCE] or 0

	local map = Utility.Peep.getMap(mashina)
	local targetI, targetJ = Utility.Map.getRandomTile(map, i, j, radialDistance, true, nil, nil, minRadialDistance)

	local start = map:getTileCenter(i, j)
	start.y = 0
	local stop = map:getTileCenter(targetI, targetJ)
	stop.y = 0

	local distance = start:distance(stop)
	local direction = start:direction(stop)

	local movement = mashina:getDirector():getCortex(MovementCortex)
	local world = movement:getWorld(k)

	local path = Path()

	map:lineOfSightPassable(i, j, targetI, targetJ, false, function(_, previousI, previousJ, differenceI, differenceJ)
		if world and world:has(mashina) then
			local previousCenter = map:getTileCenter(previousI, previousJ)
			local currentCenter = map:getTileCenter(previousI + differenceI, previousJ + differenceJ)

			local collisions = world:project(mashina, previousCenter.x, previousCenter.z, currentCenter.x, currentCenter.z, function(a, b)
				return movement:filter(a, b)
			end)

			if #collisions > 0 then
				local y = map:getInterpolatedHeight(collisions[1].touch.x, collisions[1].touch.y)
				path:makeNode(PositionPathNode, map, k, Vector(collisions[1].touch.x, y, collisions[1].touch.y))

				return false
			end
		end

		if map:canMove(previousI, previousJ, differenceI, differenceJ) then
			path:makeNode(PositionPathNode, map, k, map:getTileCenter(previousI + differenceI, previousJ + differenceJ))
			return true
		end

		return false
	end)

	if path:getNumNodes() == 0 then
		return B.Status.Failure
	end

	local command = ExecutePathcommand(path)
	if not mashina:getCommandQueue():interrupt(command) then
		return B.Status.Failure
	end

	return B.Status.Success
end

return Wander
