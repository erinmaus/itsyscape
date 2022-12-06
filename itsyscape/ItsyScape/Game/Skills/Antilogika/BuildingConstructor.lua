--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/BuildingConstructor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"
local BuildingConfig = require "ItsyScape.Game.Skills.Antilogika.BuildingConfig"
local BuildingPlanner = require "ItsyScape.Game.Skills.Antilogika.BuildingPlanner"
local Constructor = require "ItsyScape.Game.Skills.Antilogika.Constructor"
local FloorLayout = require "ItsyScape.Game.Skills.Antilogika.FloorLayout"
local RoomConfig = require "ItsyScape.Game.Skills.Antilogika.RoomConfig"

local BuildingConstructor = Class(Constructor)

BuildingConstructor.NIL_BUILDING = "None"
BuildingConstructor.MAX_PLACEMENT_ITERATIONS = 5
BuildingConstructor.SUB_TILE_OFFSETS = {
	{ -1, -1, "bottomRight", nil },
	{  0, -1, "bottomLeft", "bottomLeft" },
	{  1, -1, "bottomLeft", nil },
	{ -1,  0, "topRight", "bottomRight" },
	{  1,  0, "topLeft", "bottomLeft" },
	{ -1,  1, "topRight", nil },
	{  0,  1, "topLeft", "topRight" },
	{  1,  1, "topLeft", nil }
}

BuildingConstructor.DEFAULT_CONFIG = {
	min = 1,
	max = 2,
	buildings = {
		{
			resource = BuildingConstructor.NIL_BUILDING,
			weight = 1000
		}
	}
}

function BuildingConstructor:isRoughlyFlat(map, i, j, width, height)
	local y = map:getTileCenter(i + width / 2, j + height / 2).y

	for currentI = i, i + width - 1 do
		for currentJ = j, j + height - 1 do
			local center = map:getTileCenter(currentI, currentJ)
			if math.abs(center.y - y) > 1 then
				return false
			end

			if not map:getTile(currentI, currentJ):getIsPassable() then
				return false
			end
		end
	end

	return true
end

function BuildingConstructor:placeBuilding(map, mapScript, i, j, buildings)
	local building = self:choose(buildings)
	building = {
		resource = "Azathoth_Cabin"
	}

	if not building then
		return
	elseif building.resource == BuildingConstructor.NIL_BUILDING then
		return
	end

	local buildingPlanner = BuildingPlanner(BuildingConfig, RoomConfig, self:getRNG())
	buildingPlanner:build(building.resource)

	local layout = buildingPlanner:getFloorLayout()
	i = i - math.ceil(layout:getWidth() / 2)
	j = j - math.ceil(layout:getDepth() / 2)

	local iteration = 0
	while i < 1 or i + math.ceil(layout:getWidth()) >= map:getWidth() or
	      j < 1 or j + math.ceil(layout:getDepth()) >= map:getHeight() or
	      not self:isRoughlyFlat(map, i, j, layout:getWidth(), layout:getDepth())
	do
		i = self:getRNG():random(1, map:getWidth())
		j = self:getRNG():random(1, map:getHeight())

		i = i - math.ceil(layout:getWidth() / 2)
		j = j - math.ceil(layout:getDepth() / 2)

		iteration = iteration + 1
		if iteration >= BuildingConstructor.MAX_PLACEMENT_ITERATIONS then
			return
		end
	end

	local y = map:getTileCenter(i, j).y
	local emptyRoomLayoutTile = FloorLayout.Tile(layout, 0, 0)
	emptyRoomLayoutTile:setRoomIndex(0)

	local tileSets = {}
	for offsetI = 1, layout:getWidth() do
		for offsetJ = 1, layout:getDepth() do
			local currentI = (offsetI - 1) + i
			local currentJ = (offsetJ - 1) + j

			local layoutTile = layout:getTile(offsetI, offsetJ)
			local mapTile = map:getTile(currentI, currentJ)
			local tileSet = tileSets[mapTile.tileSetID] or MultiTileSet({ mapTile.tileSetID }, false):getTileSetByIndex(1)

			for k = 1, #BuildingAnchor.PLANE_XZ do
				local anchor = BuildingAnchor.PLANE_XZ[k]
				local offset = BuildingAnchor.OFFSET[anchor]

				local otherLayoutTile = layout:getTile(offsetI + offset.i, offsetJ + offset.j) or emptyRoomLayoutTile
				local otherMapTile = map:getTile(currentI + offset.i, currentJ + offset.j)
				if otherLayoutTile and not layoutTile:getIsDoor() and not otherLayoutTile:getIsDoor() then
					if otherLayoutTile:getRoomIndex() ~= layoutTile:getRoomIndex() then
						if anchor == BuildingAnchor.LEFT then
							mapTile:setFlag("wall-left")
							if otherMapTile ~= mapTile and otherLayoutTile == emptyRoomLayoutTile then
								otherMapTile:setFlag("wall-right")
							end
						elseif anchor == BuildingAnchor.RIGHT then
							mapTile:setFlag("wall-right")
							if otherMapTile ~= mapTile and otherLayoutTile == emptyRoomLayoutTile then
								otherMapTile:setFlag("wall-left")
							end
						elseif anchor == BuildingAnchor.BACK then
							mapTile:setFlag("wall-top")
							if otherMapTile ~= mapTile and otherLayoutTile == emptyRoomLayoutTile then
								otherMapTile:setFlag("wall-bottom")
							end
						elseif anchor == BuildingAnchor.FRONT then
							mapTile:setFlag("wall-bottom")
							if otherMapTile ~= mapTile and otherLayoutTile == emptyRoomLayoutTile then
								otherMapTile:setFlag("wall-top")
							end
						end
					end
				end
			end

			if layoutTile:getRoomID() then
				local roomConfig = buildingPlanner:getRoomConfig(layoutTile:getRoomID())
				local flatName = (roomConfig and roomConfig.flat) or "wood"
				mapTile.flat = tileSet:getTileIndex(flatName) or mapTile.flat
				mapTile:setFlag("building")

				mapTile.topLeft = y
				mapTile.topRight = y
				mapTile.bottomLeft = y
				mapTile.bottomRight = y

				for k = 1, #BuildingConstructor.SUB_TILE_OFFSETS do
					local offsetI, offsetJ, subTile1, subTile2 = unpack(BuildingConstructor.SUB_TILE_OFFSETS[k])
					offsetI = offsetI + currentI
					offsetJ = offsetJ + currentJ

					if subTile1 and offsetI >= 1 and offsetI <= map:getWidth() and offsetJ >= 1 and offsetJ <= map:getHeight() then
						map:getTile(offsetI, offsetJ)[subTile1] = y
					end

					if subTile2 and offsetI >= 1 and offsetI <= map:getWidth() and offsetJ >= 1 and offsetJ <= map:getHeight() then
						map:getTile(offsetI, offsetJ)[subTile2] = y
					end
				end

				local topLeftTile = map:getTile(currentI - 1, currentJ - 1)
				topLeftTile.bottomRight = y
			end

			tileSets[mapTile.tileSetID] = tileSet
		end
	end

	local building = Utility.spawnPropAtPosition(
		mapScript,
		"CSGBuilding",
		(i - 1) * map:getCellSize(),
		y,
		(j - 1) * map:getCellSize(),
		0)
	local peep = building:getPeep()
	peep:setPropState(buildingPlanner:getState())
end

function BuildingConstructor:place(map, mapScript)
	local rng = self:getRNG()
	local config = self:getConfig()
	local numBuildings = rng:random(
		config.min or BuildingConstructor.DEFAULT_CONFIG.min,
		config.max or BuildingConstructor.DEFAULT_CONFIG.max)

	for i = 1, 1 do
		local i = rng:random(1, map:getWidth())
		local j = rng:random(1, map:getHeight())

		self:placeBuilding(map, mapScript, i, j, config.buildings or BuildingConstructor.DEFAULT_CONFIG.buildings)
	end
end

return BuildingConstructor
