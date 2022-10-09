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

SmallBuildingLayout.DEFAULT_ROOMS_PROPS = {
	"ErrorRoom"
}

SmallBuildingLayout.DEFAULT_PROPS= {
	seedRoom = SmallBuildingLayout.DEFAULT_ROOMS
}

function SmallBuildingLayout:apply(buildingPlanner)
	local graph = buildingPlanner:getGraph()

	local defaultProps = SmallBuildingLayout.DEFAULT_PROPS
	local buildingConfig = buildingPlanner:getCurrentBuildingConfig()
	local props = buildingConfig.props or defaultProps

	graph:split(buildingPlanner)

	local seedRoomProps = props.seedRoom or SmallBuildingLayout.DEFAULT_ROOMS_PROPS
	local seedRoom = seedRoomProps[buildingPlanner:getRNG():random(1, #seedRoomProps)]
	seedRoom = seedRoom or SmallBuildingLayout.DEFAULT_ROOMS_PROPS[1]

	for _, child in graph:iterate() do
		local room = buildingPlanner:newRoom(seedRoom)
		child:resolve(buildingPlanner, room)

		for i = 1, #BuildingAnchor.PLANE_XZ do
			buildingPlanner:enqueue(room, child, BuildingAnchor.PLANE_XZ[i])
		end

		break
	end
end

return SmallBuildingLayout
