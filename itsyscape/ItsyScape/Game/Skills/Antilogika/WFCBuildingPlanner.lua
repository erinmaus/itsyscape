--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/WFCBuildingPlanner.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"
local FloorLayout = require "ItsyScape.Game.Skills.Antilogika.FloorLayout"
local WFCCells = require "ItsyScape.Game.Skills.Antilogika.WFCCells"
local WFCConstraint = require "ItsyScape.Game.Skills.Antilogika.WFCConstraint"

local WFCBuildingPlanner = Class()
WFCBuildingPlanner.CELL_SIZE = 4

WFCBuildingPlanner.DEFAULT_ROOM = {
	id = "Default",
	width = { min = 4, max = 8 },
	depth = { min = 4, max = 8 },
	anchors = {}
}

WFCBuildingPlanner.Cell = Class()

function WFCBuildingPlanner.Cell:new(s, t)
	self.s = s
	self.t = t
	self.constraints = {}
end

function WFCBuildingPlanner.Cell:getS()
	return self.s
end

function WFCBuildingPlanner.Cell:getT()
	return self.t
end

function WFCBuildingPlanner.Cell:getEntropy()
	return #self.constraints
end

function WFCBuildingPlanner.Cell:constrainRooms(buildingPlanner)
	local adjacentRooms = {}

	local layout = buildingPlanner:getFloorLayout()
	for i = 1, #BuildingAnchor.PLANE_XZ do
		local anchor = BuildingAnchor.PLANE_XZ[i]
		local offset = BuildingAnchor.OFFSET[anchor]

		local roomID = layout:getRoom(self.s + offset.i, self.t + offset.j)
		if roomID then
			table.insert(adjacentRooms, { roomID = roomID, offset = offset })
		end
	end

	self.possibleRooms = {}
	for i = 1, #adjacentRooms do
		local roomID = adjacentRooms[i].roomID
		local offset = adjacentRooms[i].offset

		local anchors = buildingPlanner:getExpandedRoomAnchors(roomID)
		for anchor, rooms in pairs(anchors) do
			local otherOffset = BuildingAnchor.OFFSET[anchor]
			if otherOffset.i == -offset.i and otherOffset.j == -offset.j then
				for i = 1, #rooms do
					table.insert(self.possibleRooms, rooms[i])
				end
			end
		end

		table.insert(self.possibleRooms, roomID)
	end

	if #self.possibleRooms == 0 then
		local buildingConfig = buildingPlanner:getCurrentBuildingConfig()
		table.insert(self.possibleRooms, buildingConfig.root)
	end
end

function WFCBuildingPlanner.Cell:constrainConstraints(buildingPlanner)
	local layout = buildingPlanner:getFloorLayout()

	table.clear(self.constraints)
	for i = 1, #self.possibleRooms do
		local roomID = self.possibleRooms[i]

		for j = 1, #WFCCells do
			local cellDefinition = WFCCells[j]

			local constraint = WFCConstraint(cellDefinition, roomID)

			local isCompatible = true
			for k = 1, #BuildingAnchor.PLANE_XZ do
				local socketAnchor = BuildingAnchor.PLANE_XZ[k]
				local reflexAnchor = BuildingAnchor.REFLEX[socketAnchor]
				local offset = BuildingAnchor.OFFSET[reflexAnchor]

				local otherConstraint = WFCConstraint()
				layout:makeConstraint(self.s + offset.i, self.t + offset.j, otherConstraint)

				if not constraint:isCompatible(otherConstraint, reflexAnchor) then
					isCompatible = false
					break
				end
			end

			if isCompatible then
				table.insert(self.constraints, constraint)
			end
		end
	end
end

function WFCBuildingPlanner.Cell:constrain(buildingPlanner)
	self:constrainRooms(buildingPlanner)
	self:constrainConstraints(buildingPlanner)
end

function WFCBuildingPlanner.Cell:resolve(buildingPlanner, index)
	local layout = buildingPlanner:getFloorLayout()

	local constraint = self.constraints[index or buildingPlanner:getRNG():random(1, self:getEntropy())]
	if not constraint then
		return false
	end

	local cellDefinition = constraint:getCellDefinition()
	for j = 1, #cellDefinition do
		for i = 1, #cellDefinition[j] do
			local tileType = cellDefinition[j][i]

			local absoluteI = ((self.s - 1) * WFCBuildingPlanner.CELL_SIZE) + i
			local absoluteJ = ((self.t - 1) * WFCBuildingPlanner.CELL_SIZE) + j

			local tile = layout:getTile(absoluteI, absoluteJ)
			if tile then
				tile:setTileType(tileType)

				if tileType == FloorLayout.TILE_TYPE_ROOM then
					tile:setRoomID(constraint.roomID)
				end
			end
		end
	end

	for i = 1, #BuildingAnchor.PLANE_XZ do
		local anchor = BuildingAnchor.PLANE_XZ[i]
		local offset = BuildingAnchor.OFFSET[anchor]

		local s = self.s + offset.i
		local t = self.t + offset.j
		if layout:isUndecided(s, t) then
			buildingPlanner:enqueue(s, t)
		end
	end

	return true
end

function WFCBuildingPlanner:new(buildingConfig, roomConfig, rng)
	self.buildingConfig = buildingConfig
	self.roomConfig = roomConfig
	self.rng = rng or love.math.newRandomGenerator()
end

function WFCBuildingPlanner:getRNG()
	return self.rng
end

function WFCBuildingPlanner:getBuildingConfig(buildingID)
	for i = 1, #self.buildingConfig do
		if self.buildingConfig[i].id == buildingID then
			return self.buildingConfig[i]
		end
	end

	return nil
end

function WFCBuildingPlanner:getRoomConfig(roomID)
	for i = 1, #self.roomConfig do
		if self.roomConfig[i].id == roomID then
			return self.roomConfig[i]
		end
	end

	return nil
end

function WFCBuildingPlanner:getExpandedRoomAnchors(roomID)
	local roomConfig = self:getRoomConfig(roomID) or WFCBuildingPlanner.DEFAULT_ROOM

	local anchors = {}
	for a, rooms in pairs(roomConfig.anchors or {}) do
		a = (type(a) == 'number' and { a }) or a

		for i = 1, #a do
			local anchor = a[i]

			anchors[anchor] = {}
			for j = 1, #rooms do
				table.insert(anchors[anchor], rooms[j])
			end
		end
	end

	return anchors
end

function WFCBuildingPlanner:build(buildingID)
	local buildingConfig = self:getBuildingConfig(buildingID)
	if not buildingConfig then
		return false
	end

	self.currentBuildingConfig = buildingConfig

	self.queue = {}

	local LayoutType = require(self.currentBuildingConfig.layout)
	self.layout = LayoutType(32, 32, 4)
	self.layout:apply(self)

	while #self.queue > 0 do
		local cell = table.remove(self.queue, 1)

		cell:constrain(self)
		cell:resolve(self)
	end
end

function WFCBuildingPlanner:enqueue(s, t)
	local cell = WFCBuildingPlanner.Cell(s, t)
	table.insert(self.queue, cell)

	return cell
end

function WFCBuildingPlanner:getFloorLayout()
	return self.layout
end

function WFCBuildingPlanner:getCurrentBuildingConfig()
	return self.currentBuildingConfig
end

return WFCBuildingPlanner
