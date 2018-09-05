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
Wander.RADIAL_DISTANCE = B.Reference()
Wander.MAX_PATH_LENGTH = B.Reference()

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

	local i, j
	if mashina.getMapObject then
		local mapObject = mashina:getMapObject()
		local gameDB = mashina:getDirector():getGameDB()
		local record = gameDB:getRecord("MapObjectLocation", { Resource = mapObject })
		if record then

			local map = mashina:getDirector():getGameInstance():getStage():getMap(k)
			local x = record:get("PositionX") or 0
			local y = record:get("PositionY") or 0
			local z = record:get("PositionZ") or 0
			local tile
			tile, i, j = map:getTileAt(x, z)
		end
	end

	if not i or not j then
		i, j = Utility.Peep.getTile(mashina)
	end

	local radialDistance = state[self.RADIAL_DISTANCE] or 5
	local maxPathLength = state[self.PATH_DISTANCE] or 10

	local s = math.random(-radialDistance, radialDistance)
	local t = math.random(-radialDistance, radialDistance)

	local targetI = i + s
	local targetJ = j + t

	local command, path = Utility.Peep.getWalk(
		mashina,
		targetI,
		targetJ,
		k)
	if command and path:getNumNodes() <= maxPathLength then
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
