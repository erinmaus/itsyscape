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
local RoomConfig = require "ItsyScape.Game.Skills.Antilogika.RoomConfig"

local BuildingConstructor = Class(Constructor)

BuildingConstructor.NIL_BUILDING = "None"
BuildingConstructor.MAX_PLACEMENT_ITERATIONS = 5

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

	local buildingPlanner = BuildingPlanner(BuildingConfig, RoomConfig)
	buildingPlanner:build(building.resource)

	local layout = buildingPlanner:getFloorLayout()
	i = i - math.ceil(layout:getWidth() / 2)
	j = j - math.ceil(layout:getDepth() / 2)

	local iteration = 0
	while i < 1 or i + math.ceil(layout:getWidth()) >= map:getWidth() or
	      j < 1 or j + math.ceil(layout:getDepth()) >= map:getHeight()
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

				local otherLayoutTile = layout:getTile(offsetI + offset.i, offsetJ + offset.j)
				if otherLayoutTile and not layoutTile:getIsDoor() and not otherLayoutTile:getIsDoor() then
					if otherLayoutTile:getRoomIndex() ~= layoutTile:getRoomIndex() then
						if anchor == BuildingAnchor.LEFT then
							mapTile:setFlag("wall-left")
						elseif anchor == BuildingAnchor.RIGHT then
							mapTile:setFlag("wall-right")
						elseif anchor == BuildingAnchor.BACK then
							mapTile:setFlag("wall-top")
						elseif anchor == BuildingAnchor.FRONT then
							mapTile:setFlag("wall-bottom")
						end
					end
				end
			end

			if layoutTile:getRoomID() then
				local roomConfig = buildingPlanner:getRoomConfig(layoutTile:getRoomID())
				local flatName = (roomConfig and roomConfig.flat) or "wood"
				mapTile.flat = tileSet:getTileIndex(flatName) or mapTile.flat
				mapTile:setFlag("building")
			end

			mapTile.topLeft = y
			mapTile.topRight = y
			mapTile.bottomLeft = y
			mapTile.bottomRight = y

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
