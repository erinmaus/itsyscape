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
local WFCBuildingPlanner = require "ItsyScape.Game.Skills.Antilogika.WFCBuildingPlanner"

local CastleFloorLayout = Class(FloorLayout)

function CastleFloorLayout:apply(buildingPlanner)
	for i = 1, self:getWidth() do
		self:getTile(i, 1):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, 2):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, 3):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, 4):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)

		self:getTile(i, self:getDepth()):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, self:getDepth() - 1):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, self:getDepth() - 2):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(i, self:getDepth() - 3):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
	end

	for j = 1, self:getDepth() do
		self:getTile(1, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(2, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(3, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(4, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)

		self:getTile(self:getWidth(), j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(self:getWidth() - 1, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(self:getWidth() - 2, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
		self:getTile(self:getWidth() - 3, j):setTileType(FloorLayout.TILE_TYPE_OUTSIDE)
	end

	local centerS = math.floor(self:getWidth() / self:getCellSize() / 2 + 0.5)
	local centerT = math.floor(self:getDepth() / self:getCellSize() / 2 + 0.5)
	self:setRoom(centerS, centerT, "Courtyard")
	print("center", centerS, centerT)
	buildingPlanner:enqueue(centerS - 1, centerT)
	buildingPlanner:enqueue(centerS + 1, centerT)
	buildingPlanner:enqueue(centerS, centerT - 1)
	buildingPlanner:enqueue(centerS, centerT + 1)

	--local cell = WFCBuildingPlanner.Cell(centerS, centerT)
	--cell:constrain(buildingPlanner)
	--cell:resolve(buildingPlanner, 1)
end

return CastleFloorLayout
