--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/CastleFloorLayout.lua
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
local BuildingPlanner = require "ItsyScape.Game.Skills.Antilogika.BuildingPlanner"

local CastleFloorLayout = Class(FloorLayout)

function CastleFloorLayout:apply(buildingPlanner)
	self:fill(1, 1, self:getWidth(), self:getDepth(), true)

	local entrance = BuildingPlanner.Graph("CastleEntrance", buildingPlanner:getRoomConfig("CastleEntrance"))
	buildingPlanner:place(
		entrance,
		math.floor(self:getWidth() / 2) - 1,
		self:getDepth() - 8 + 1,
		2,
		8)

	local courtyard = BuildingPlanner.Graph("Courtyard", buildingPlanner:getRoomConfig("Courtyard"))
	buildingPlanner:place(
		courtyard,
		math.floor(self:getWidth() / 2) - 6,
		self:getDepth() - 20 + 1,
		12,
		12)
	courtyard:attach(entrance, BuildingAnchor.BACK)

	buildingPlanner:addRoom(entrance)
	buildingPlanner:addRoom(courtyard)

	buildingPlanner:setRoot(entrance)

	buildingPlanner:enqueue(courtyard)
end

return CastleFloorLayout
