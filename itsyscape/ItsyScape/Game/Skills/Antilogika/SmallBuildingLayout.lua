--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/SmallBuildingLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local FloorLayout = require "ItsyScape.Game.Skills.Antilogika.FloorLayout"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"

local SmallBuildingLayout = Class(FloorLayout)
SmallBuildingLayout.MAX_ENTRANCE_DOOR_ITERATIONS = 10

SmallBuildingLayout.DEFAULT_ROOMS_PROPS = {
	"ErrorRoom"
}

SmallBuildingLayout.DEFAULT_PROPS= {
	seedRoom = SmallBuildingLayout.DEFAULT_ROOMS
}

function SmallBuildingLayout:apply(buildingPlanner)
	local rng = buildingPlanner:getRNG()
	local graph = buildingPlanner:getGraph()

	local defaultProps = SmallBuildingLayout.DEFAULT_PROPS
	local buildingConfig = buildingPlanner:getCurrentBuildingConfig()
	local props = buildingConfig.props or defaultProps

	graph:split(buildingPlanner)

	local seedRoomProps = props.seedRoom or SmallBuildingLayout.DEFAULT_ROOMS_PROPS
	local seedRoom = seedRoomProps[rng:random(1, #seedRoomProps)]
	seedRoom = seedRoom or SmallBuildingLayout.DEFAULT_ROOMS_PROPS[1]

	if not graph:hasChildren() then
		local room = buildingPlanner:newRoom(seedRoom)
		graph:resolve(buildingPlanner, room)
	else
		for _, child in graph:iterate() do
			local room = buildingPlanner:newRoom(seedRoom)
			child:resolve(buildingPlanner, room)

			for i = 1, #BuildingAnchor.PLANE_XZ do
				buildingPlanner:enqueue(room, child, BuildingAnchor.PLANE_XZ[i])
			end

			break
		end
	end

	local iterations = 0
	while true do
		local doorAnchor = rng:random(#BuildingAnchor.PLANE_XZ)
		doorAnchor = BuildingAnchor.PLANE_XZ[doorAnchor]

		local offset = BuildingAnchor.OFFSET[doorAnchor]

		local i, j
		if offset.i < 0 then
			i = 1
			j = rng:random(1, graph:getDepth())
		elseif offset.i > 0 then
			i = graph:getRight()
			j = rng:random(1, graph:getDepth())
		elseif offset.j < 0 then
			i = rng:random(1, graph:getWidth())
			j = 1
		elseif offset.j > 0 then
			i = rng:random(1, graph:getWidth())
			j = graph:getBottom()
		end

		local layoutTile = buildingPlanner:getFloorLayout():getTile(i, j)
		if layoutTile and layoutTile:getRoomID() then
			buildingPlanner:addDoor(i, j, 1, 1, BuildingAnchor.REFLEX[doorAnchor])
			break
		end

		iterations = iterations + 1
		if iterations > SmallBuildingLayout.MAX_ENTRANCE_DOOR_ITERATIONS then
			Log.warn("Couldn't place entrance door in small building.")
			break
		end
	end
end

return SmallBuildingLayout
