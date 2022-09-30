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

local CastleFloorLayout = Class(FloorLayout)

CastleFloorLayout.DEFAULT_RELATIVE_COURTYARD_SIZE_PROPS = {
	min = 0.2,
	max = 0.4
}

CastleFloorLayout.DEFAULT_NUM_TOWERS_PROPS = {
	min = 1,
	max = 4
}

CastleFloorLayout.DEFAULT_RELATIVE_TOWER_SIZE_PROPS = {
	min = 0.1,
	max = 0.2
}

CastleFloorLayout.DEFAULT_TOWER_OFFSETS_PROPS = {
	0
}

CastleFloorLayout.DEFAULT_PROPS = {
	relativeCourtyardSize = CastleFloorLayout.DEFAULT_RELATIVE_COURTYARD_SIZE_PROPS,
	numTowers = CastleFloorLayout.DEFAULT_NUM_TOWERS_PROPS,
	relativeTowerSize = CastleFloorLayout.DEFAULT_RELATIVE_TOWER_SIZE_PROPS,
	towerOffsets = CastleFloorLayout.DEFAULT_TOWER_OFFSETS_PROPS
}

function CastleFloorLayout:apply(buildingPlanner)
	local graph = buildingPlanner:getGraph()

	local defaultProps = CastleFloorLayout.DEFAULT_PROPS
	local props = buildingPlanner:getCurrentBuildingConfig().props or defaultProps

	local relativeTowerSizeProps = props.relativeTowerSize or defaultProps.relativeTowerSize
	local towerSize = math.floor(
		buildingPlanner:randomRange(
			relativeTowerSizeProps.min or defaultProps.relativeTowerSize.min,
			relativeTowerSizeProps.max or defaultProps.relativeTowerSize.max) * math.min(self:getWidth(), self:getDepth()))

	local relativeCourtyardSizeProps = props.relativeCourtyardSize or defaultProps.relativeCourtyardSize
	local relativeCourtyardSize = buildingPlanner:randomRange(
		relativeCourtyardSizeProps.min or defaultProps.relativeCourtyardSize.min,
		relativeCourtyardSizeProps.max or defaultProps.relativeCourtyardSize.max)
	local courtyardWidth = math.floor(self:getWidth() - towerSize * 2)
	local courtyardDepth = math.floor(self:getDepth() - towerSize * 2)

	local courtyard = graph:cut(
		towerSize + 1,
		towerSize + 1,
		courtyardWidth,
		courtyardDepth)
	courtyard:resolve(buildingPlanner, buildingPlanner:newRoom("Courtyard"))

	local numTowersProps = props.numTowers or defaultProps.numTowers
	local numTowers = buildingPlanner:getRNG():random(
		numTowersProps.min or defaultProps.numTowers.min,
		numTowersProps.max or defaultProps.numTowers.max)

	local towerOffsetsProps = props.towerOffsets or defaultProps.towerOffsets
	local towerOffset = towerOffsetsProps[buildingPlanner:getRNG():random(1, #towerOffsetsProps)] or defaultProps.towerOffsets[1]

	for index = 1, numTowers do
		local angle = math.pi * 2 * ((index - 1) / numTowers) + towerOffset
		local x, z = math.cos(angle), math.sin(angle)

		local i, j
		if math.abs(x) < math.abs(z) then
			j = math.floor(((z + 1) * 0.5) * self:getDepth())
			if x <= 0 then
				i = 1
			else
				i = self:getWidth()
			end
		else
			i = math.floor(((x + 1) * 0.5) * self:getWidth())
			if z <= 0 then
				j = 1
			else
				j = self:getDepth()
			end
		end

		i = math.max(1, math.min(self:getWidth() - towerSize + 1, i))
		j = math.max(1, math.min(self:getDepth() - towerSize + 1, j))

		local tower = graph:cut(
			i,
			j,
			towerSize,
			towerSize)
		if tower then
			tower:resolve(buildingPlanner, buildingPlanner:newRoom("CastleTower"))
		end
	end

	local rectangles = self:getAvailableRectangles(FloorLayout.TILE_TYPE_UNDECIDED)
	for i = 1, #rectangles do
		local r = rectangles[i]
		local child = graph:cut(r.left, r.top, r.width, r.depth)
		if child then
			self:split(buildingPlanner, child)
		end
	end
end

function CastleFloorLayout:split(buildingPlanner, graph)
	graph:split(buildingPlanner)

	for _, child in graph:iterate() do
		if buildingPlanner:getRNG():random() < 1 then
			self:split(buildingPlanner, child)
		end
	end
end

return CastleFloorLayout
