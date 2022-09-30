--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/BuildingPlanner.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"

local BuildingPlanner = Class()

BuildingPlanner.Graph = Class()

function BuildingPlanner.Graph:new(parent, i, j, width, depth)
	self.parent = parent
	self.i = i
	self.j = j
	self.width = width
	self.depth = depth

	self.children = {}
end

function BuildingPlanner.Graph:getParent()
	return self.parent
end

function BuildingPlanner.Graph:getI()
	return self.i
end

function BuildingPlanner.Graph:getJ()
	return self.j
end

function BuildingPlanner.Graph:getWidth()
	return self.width
end

function BuildingPlanner.Graph:getDepth()
	return self.depth
end

function BuildingPlanner.Graph:split(buildingPlanner)
	if #self.children > 0 then
		return false
	end

	local bsp = { graph = self }
	self:_splitBSP(buildingPlanner, bsp, 1)
end

function BuildingPlanner.Graph:prettifySplit(n)
	if n == 0 then
		return 0
	end

	local first, second = 0, 1
	local third = first + second

	while third < n do
		first, second = second, third
		third = first + second
	end

	if math.abs(third - n) >= math.abs(second - n) then
		return second
	else
		return third
	end
end

function BuildingPlanner.Graph:_splitBSP(buildingPlanner, bsp, currentIteration)
	local buildingConfig = buildingPlanner:getCurrentBuildingConfig()

	if currentIteration > (buildingConfig.split and buildingConfig.split.iterations or 1) then
		return false
	end

	local minSplit = buildingConfig.split and buildingConfig.split.min or 0.35
	local maxSplit = buildingConfig.split and buildingConfig.split.max or 0.65
	local minWidth = buildingConfig.split and buildingConfig.split.minWidth or 4
	local minDepth = buildingConfig.split and buildingConfig.split.minDepth or 4

	local ratio = (math.random() * (maxSplit - minSplit)) + minSplit

	local definition1, definition2
	if bsp.graph.width > bsp.graph.depth then
		local split = math.floor(ratio * bsp.graph.width)
		split = self:prettifySplit(split)

		if split < minWidth or bsp.graph.width - split < minDepth then
			return false
		end

		definition1 = {
			i = bsp.graph.i,
			j = bsp.graph.j,
			width = split,
			depth = bsp.graph.depth
		}

		definition2 = {
			i = bsp.graph.i + split,
			j = bsp.graph.j,
			width = bsp.graph.width - split,
			depth = bsp.graph.depth
		}
	else
		local split = math.floor(ratio * bsp.graph.depth)
		split = self:prettifySplit(split)

		if split < minDepth or bsp.graph.depth - split < minDepth then
			return false
		end

		definition1 = {
			i = bsp.graph.i,
			j = bsp.graph.j,
			width = bsp.graph.width,
			depth = split
		}

		definition2 = {
			i = bsp.graph.i,
			j = bsp.graph.j + split,
			width = bsp.graph.width,
			depth = bsp.graph.depth - split
		}
	end

	local a = BuildingPlanner.Graph(self, definition1.i, definition1.j, definition1.width, definition1.depth)
	local b = BuildingPlanner.Graph(self, definition2.i, definition2.j, definition2.width, definition2.depth)

	bsp.a = { graph = a }
	bsp.b = { graph = b }

	if not self:_splitBSP(buildingPlanner, bsp.a, currentIteration + 1) then
		table.insert(self.children, a)
	end

	if not self:_splitBSP(buildingPlanner, bsp.b, currentIteration + 1) then
		table.insert(self.children, b)
	end

	return true
end

function BuildingPlanner.Graph:cut(i, j, width, depth)
	if i < self.i or j < self.j or i + width > self.i + self.width or j + depth > self.j + self.depth then
		return false
	end

	for index = 1, #self.children do
		local child = self.children[index]

		local overlapI = child.i < i + width and child.i + child.width > i
		local overlapJ = child.j < j + depth and child.j + child.depth > j

		if overlapI and overlapJ then
			return false
		end
	end

	local graph = BuildingPlanner.Graph(self, i, j, width, depth)
	table.insert(self.children, graph)

	return graph
end

function BuildingPlanner.Graph:resolve(buildingPlanner, room)
	self.room = room

	buildingPlanner:getFloorLayout():setRoom(
		self.i, self.j,
		self.width, self.depth,
		room:getRoomID(), room:getRoomIndex())
end

function BuildingPlanner.Graph:getRoom()
	return self.room
end

BuildingPlanner.Room = Class()

function BuildingPlanner.Room:new(roomID, roomIndex)
	self.roomID = roomID
	self.roomIndex = roomIndex
end

function BuildingPlanner.Room:getRoomID()
	return self.roomID
end

function BuildingPlanner.Room:getRoomIndex()
	return self.roomIndex
end

function BuildingPlanner.Graph:iterate()
	return ipairs(self.children)
end

function BuildingPlanner:new(buildingConfig, roomConfig, rng)
	self.buildingConfig = buildingConfig
	self.roomConfig = roomConfig
	self.rng = rng or love.math.newRandomGenerator()
end

function BuildingPlanner:getRNG()
	return self.rng
end

function BuildingPlanner:getBuildingConfig(buildingID)
	for i = 1, #self.buildingConfig do
		if self.buildingConfig[i].id == buildingID then
			return self.buildingConfig[i]
		end
	end

	return nil
end

function BuildingPlanner:getRoomConfig(roomID)
	for i = 1, #self.roomConfig do
		if self.roomConfig[i].id == roomID then
			return self.roomConfig[i]
		end
	end

	return nil
end

function BuildingPlanner:getGraph()
	return self.graph
end

function BuildingPlanner:getFloorLayout()
	return self.layout
end

function BuildingPlanner:getCurrentBuildingConfig()
	return self.currentBuildingConfig
end

function BuildingPlanner:build(buildingID)
	local buildingConfig = self:getBuildingConfig(buildingID)
	if not buildingConfig then
		return false
	end

	self.currentBuildingConfig = buildingConfig

	self.graph = BuildingPlanner.Graph(nil, 1, 1, 64, 64)

	self.currentRoomIndex = 1
	self.rooms = {}

	local LayoutType = require(self.currentBuildingConfig.layout)
	self.layout = LayoutType(32, 32, 4)
	self.layout:apply(self)
end

function BuildingPlanner:randomRange(min, max)
	return self.rng:random() * (max - min) + min
end

function BuildingPlanner:newRoom(roomID)
	local roomIndex = self.currentRoomIndex
	self.currentRoomIndex = self.currentRoomIndex + 1

	local room = BuildingPlanner.Room(roomID, roomIndex)
	table.insert(self.rooms, room)

	return room
end

return BuildingPlanner
