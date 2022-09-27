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

function BuildingPlanner.Graph:new(roomID, roomConfig)
	self.id = roomID
	self.roomConfig = roomConfig
	self.anchors = {}
	self.children = {}
	self.i = 0
	self.j = 0
	self.width = 0
	self.depth = 0

	self:expand()
end

function BuildingPlanner.Graph:getRoomID()
	return self.id
end

function BuildingPlanner.Graph:getRoomConfig()
	return self.roomConfig
end

function BuildingPlanner.Graph:getParent()
	return self.parent
end

function BuildingPlanner.Graph:getFromAnchor()
	return self.from or BuildingAnchor.NONE
end

function BuildingPlanner.Graph:iterateChildren()
	return ipairs(self.children)
end

function BuildingPlanner.Graph:getDirectionFromParent()
	return self.from
end

function BuildingPlanner.Graph:setPosition(i, j)
	self.i = i
	self.j = j
	self.bounds = nil
end

function BuildingPlanner.Graph:getPosition()
	return self.i, self.j
end

function BuildingPlanner.Graph:setSize(width, depth)
	self.width = width
	self.depth = depth
	self.bounds = nil
end

function BuildingPlanner.Graph:getSize()
	return self.width, self.depth
end

function BuildingPlanner.Graph:getBounds()
	if not self.bounds then
		self.bounds = {
			left = self.i,
			right = self.i + self.width,
			top = self.j,
			bottom = self.j + self.depth
		}
	end

	return self.bounds
end

function BuildingPlanner.Graph:attach(parent, from)
	self.parent = parent
	self.from = from
	table.insert(parent.children, self)
end

function BuildingPlanner.Graph:expand()
	for anchors, rooms in pairs((self.roomConfig and self.roomConfig.anchors) or {}) do
		local a = (type(anchors) == 'number' and { anchors }) or anchors

		for i = 1, #a do
			local anchor = a[i]

			self.anchors[anchor] = {}
			for j = 1, #rooms do
				table.insert(self.anchors[anchor], rooms[j])
			end
		end
	end
end

function BuildingPlanner.Graph:resolve(buildingPlanner)
	local anchors = {}
	do
		local unshuffledAnchors = {}
		for anchor, rooms in pairs(self.anchors) do
			table.insert(unshuffledAnchors, anchor)
		end

		table.sort(unshuffledAnchors, function(a, b)
			return a < b
		end)

		while #unshuffledAnchors > 0 do
			local anchor = table.remove(unshuffledAnchors, buildingPlanner:getRNG():random(1, #unshuffledAnchors))
			table.insert(anchors, anchor)
		end
	end

	local didPlace = false
	for i = 1, #anchors do
		local rooms = {}
		do
			local r = self.anchors[anchors[i]]
			for i = 1, #r do
				table.insert(rooms, r[i])
			end
		end

		local roomConfig, roomID
		if rooms and BuildingAnchor.REFLEX[self.from] ~= anchors[i] then
			repeat
				local roomIndex = buildingPlanner:getRNG():random(1, #rooms)
				local pendingRoomID = rooms[roomIndex]
				local pendingRoomConfig = buildingPlanner:getRoomConfig(pendingRoomID) or BuildingPlanner.DEFAULT_ROOM

				-- if state.rooms[roomID] then
				-- 	if state.rooms[roomID].count >= ((roomConfig.rooms and roomConfig.rooms.max) or math.huge) then
				-- 		table.remove(rooms, roomIndex)
				-- 	else
				-- 		state.rooms[roomID].count = state.rooms[roomID].count + 1
				-- 		room = roomConfig
				-- 	end
				-- else
				-- 	state.rooms[roomID] = {
				-- 		count = 1
				-- 	}
				-- 	room = roomConfig
				-- end

				if #rooms == 0 then
					break
				end

				roomConfig = pendingRoomConfig
				roomID = pendingRoomID
			until roomConfig
		end

		if roomConfig then
			local childGraph = BuildingPlanner.Graph(roomID, roomConfig)

			local wasPlaced = buildingPlanner:tryPlace(childGraph, self, anchors[i])
			if wasPlaced then
				childGraph:attach(self, anchors[i])

				buildingPlanner:addRoom(childGraph)
				buildingPlanner:enqueue(childGraph)

				didPlace = true
			end
		end
	end

	if didPlace then
		buildingPlanner:enqueue(self)
	end
end

BuildingPlanner.DEFAULT_ROOM = {
	id = "Default",
	width = { min = 4, max = 8 },
	depth = { min = 4, max = 8 },
	anchors = {}
}

function BuildingPlanner:new(buildingConfig, roomConfig, rng)
	self.buildingConfig = buildingConfig
	self.roomConfig = roomConfig
	self.rng = rng or love.math.newRandomGenerator()
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

function BuildingPlanner:getRNG()
	return self.rng
end

function BuildingPlanner:getCurrentBuildingConfig()
	return self.currentBuildingConfig
end

function BuildingPlanner:getRoot()
	return self.graph
end

function BuildingPlanner:setRoot(graph)
	self.graph = graph
end

function BuildingPlanner:getRooms()
	return self.rooms or {}
end

function BuildingPlanner:getBounds()
	return self.bounds
end

function BuildingPlanner:build(buildingID)
	local buildingConfig = self:getBuildingConfig(buildingID)
	if not buildingConfig then
		return nil
	end

	self.currentBuildingConfig = buildingConfig

	self.graph = nil
	self.rooms = {}
	self.queue = {}

	local LayoutType = require(self.currentBuildingConfig.layout)
	self.layout = LayoutType(48, 48)
	self.layout:apply(self)

	while #self.queue > 0 do
		local g = table.remove(self.queue, 1)
		g:resolve(self)
	end

	self.bounds = {}
	for i = 1, #self.rooms do
		local bounds = self.rooms[i]:getBounds()

		self.bounds.left = math.min(bounds.left, self.bounds.left or math.huge)
		self.bounds.right = math.max(bounds.right, self.bounds.right or -math.huge)
		self.bounds.top = math.min(bounds.top, self.bounds.top or math.huge)
		self.bounds.bottom = math.max(bounds.bottom, self.bounds.bottom or -math.huge)
	end
end

function BuildingPlanner:enqueue(graph)
	table.insert(self.queue, graph)
end

function BuildingPlanner:addRoom(graph)
	table.insert(self.rooms, graph)
end

function BuildingPlanner:tryPlace(graph, parent, from)
	local offset = BuildingAnchor.OFFSET[from]
	local parentBounds = parent:getBounds()

	local searchBounds = {}
	if offset.i < 0 then
		searchBounds.left = parentBounds.left + offset.i
		searchBounds.right = searchBounds.left + 1
	elseif offset.i > 0 then
		searchBounds.left = parentBounds.right
		searchBounds.right = searchBounds.left + offset.i
	else
		searchBounds.left = parentBounds.left
		searchBounds.right = parentBounds.right
	end

	if offset.j < 0 then
		searchBounds.top = parentBounds.top + offset.j
		searchBounds.bottom = searchBounds.top + 1
	elseif offset.j > 0 then
		searchBounds.top = parentBounds.bottom
		searchBounds.bottom = searchBounds.top + offset.j
	else
		searchBounds.top = parentBounds.top
		searchBounds.bottom = parentBounds.bottom
	end

	local rectangles = self.layout:getAvailableRectangles()
	for i = 1, #rectangles do
		local rectangle = rectangles[i]
		if self:overlaps(rectangle, searchBounds) then
			if self:trySplit(rectangle, graph, parent, from) then
				return true
			end
		end
	end

	return false
end

function BuildingPlanner:trySplit(rectangle, graph, parent, from)
	local offset = BuildingAnchor.OFFSET[from]
	local parentBounds = parent:getBounds()

	local widthConstraint, depthConstraint
	do
		local roomConfig = graph:getRoomConfig()
		widthConstraint = roomConfig.width or BuildingPlanner.DEFAULT_ROOM.width
		depthConstraint = roomConfig.depth or BuildingPlanner.DEFAULT_ROOM.depth
	end

	local maxWidth, minWidth, maxDepth, minDepth
	do
		maxWidth = widthConstraint.max or BuildingPlanner.DEFAULT_ROOM.width.max
		minWidth = widthConstraint.min or BuildingPlanner.DEFAULT_ROOM.width.min
		maxDepth = depthConstraint.max or BuildingPlanner.DEFAULT_ROOM.depth.max
		minDepth = depthConstraint.min or BuildingPlanner.DEFAULT_ROOM.depth.min
	end

	local searchBounds = {}
	if offset.i < 0 then
		searchBounds.left = parentBounds.left - maxWidth
		searchBounds.right = searchBounds.left + maxWidth
	elseif offset.i > 0 then
		searchBounds.left = parentBounds.right
		searchBounds.right = searchBounds.left + maxWidth
	else
		searchBounds.left = parentBounds.left-- - math.floor(maxWidth / 2)
		searchBounds.right = parentBounds.right-- + math.floor(maxWidth / 2)
	end

	if offset.j < 0 then
		searchBounds.top = parentBounds.top - maxDepth
		searchBounds.bottom = searchBounds.top + maxDepth
	elseif offset.j > 0 then
		searchBounds.top = parentBounds.bottom
		searchBounds.bottom = searchBounds.top + maxDepth
	else
		searchBounds.top = parentBounds.top-- - math.floor(maxDepth / 2)
		searchBounds.bottom = parentBounds.bottom-- + math.floor(maxDepth / 2)
	end

	local intersection = self:intersects(rectangle, searchBounds)

	if (intersection.right - intersection.left) >= minWidth and
	   (intersection.bottom - intersection.top) >= minDepth
	then
		local i = self.rng:random(intersection.left, intersection.right - minWidth)
		local j = self.rng:random(intersection.top, intersection.bottom - minDepth)
		local width = self.rng:random(minWidth, maxWidth)
		local depth = self.rng:random(minDepth, maxDepth)

		if offset.i < 0 then
			i = searchBounds.right - width
		elseif offset.i > 0 then
			i = searchBounds.left
		end

		if offset.j < 0 then
			j = searchBounds.bottom - depth
		elseif offset.j > 0 then
			j = searchBounds.top
		end

		if self.layout:isUnassigned(i, j, width, depth) then
			self.layout:assign(i, j, width, depth, graph)
			graph:setPosition(i, j)
			graph:setSize(width, depth)
			return true
		end
	end

	return false
end

function BuildingPlanner:place(graph, i, j, width, depth)
	self.layout:assign(i, j, width, depth, graph)
	graph:setPosition(i, j)
	graph:setSize(width, depth)
end

function BuildingPlanner:overlaps(a, b)
	local overlapI = a.left < b.right and a.right > b.left
	local overlapJ = a.top < b.bottom and a.bottom > b.top
	return overlapI and overlapJ
end

function BuildingPlanner:intersects(a, b)
	local left = math.max(a.left, b.left)
	local right = math.min(a.right, b.right)
	local top = math.max(a.top, b.top)
	local bottom = math.min(a.bottom, b.bottom)

	return {
		left = left,
		right = right,
		top = top,
		bottom = bottom
	}
end

function BuildingPlanner:buildBounds(graph)
	graph.left = graph.i
	graph.right = graph.i + graph.width
	graph.top = graph.j
	graph.bottom = graph.j + graph.depth
end

return BuildingPlanner
