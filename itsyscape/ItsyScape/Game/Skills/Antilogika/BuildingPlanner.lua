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

BuildingPlanner.DEFAULT_ROOM_CONFIG = {
	width = { min = 5, max = 8 },
	depth = { min = 5, max = 8 },
	anchors = {}
}

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

function BuildingPlanner.Graph:getLeft()
	return self.i
end

function BuildingPlanner.Graph:getRight()
	return self.i + self.width
end

function BuildingPlanner.Graph:getTop()
	return self.j
end

function BuildingPlanner.Graph:getBottom()
	return self.j + self.depth
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

	local ratio = buildingPlanner:randomRange(minSplit, maxSplit)

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

function BuildingPlanner.Graph:getSideGraphs(i, j, width, depth, anchor, results)
	results = results or {}

	if #self.children == 0 then
		local offset = BuildingAnchor.OFFSET[anchor]

		local isHorizontalMatch = true
		if offset.i < 0 then
			if self.i + self.width ~= i then
				isHorizontalMatch = false
			end
		elseif offset.i > 0 then
			if self.i ~= i + width then
				isHorizontalMatch = false
			end
		else
			if not (self.i < i + width and self.i + self.width > i) then
				isHorizontalMatch = false
			end
		end

		local isVerticalMatch = true
		if offset.j < 0 then
			if self.j + self.depth ~= j then
				isVerticalMatch = false
			end
		elseif offset.j > 0 then
			if self.j ~= j + depth then
				isVerticalMatch = false
			end
		else
			if not (self.j < j + depth and self.j + self.depth > j) then
				isVerticalMatch = false
			end
		end

		if isHorizontalMatch and isVerticalMatch then
			table.insert(results, self)
		end
	end

	for index = 1, #self.children do
		self.children[index]:getSideGraphs(i, j, width, depth, anchor, results)
	end

	return results
end

function BuildingPlanner.Graph:resolve(buildingPlanner, room)
	self.room = room
	room:attach(self)

	buildingPlanner:getFloorLayout():setRoom(
		self.i, self.j,
		self.width, self.depth,
		room:getRoomID(), room:getRoomIndex())
end

function BuildingPlanner.Graph:getRoom()
	return self.room
end

function BuildingPlanner.Graph:iterate()
	return ipairs(self.children)
end

function BuildingPlanner.Graph:hasChildren()
	return #self.children > 0
end

BuildingPlanner.Room = Class()

function BuildingPlanner.Room:new(roomID, roomIndex, roomConfig)
	self.roomID = roomID
	self.roomIndex = roomIndex
	self.roomConfig = roomConfig

	self.graphs = {}

	self.left, self.top = math.huge, math.huge
	self.right, self.bottom = -math.huge, -math.huge
end

function BuildingPlanner.Room:connect(room, fromGraph, toGraph)
	self.parent = room
	self.fromGraph = fromGraph
	self.toGraph = toGraph

	self.door = {}

	local left, right, top, bottom, anchor
	if fromGraph:getRight() == toGraph:getLeft() or
	   fromGraph:getLeft() == toGraph:getRight()
	then
		anchor = (fromGraph:getRight() == toGraph:getLeft() and BuildingAnchor.RIGHT) or BuildingAnchor.LEFT

		left = (fromGraph:getRight() == toGraph:getLeft() and fromGraph:getRight()) or fromGraph:getLeft()
		right = left + 1

		local j1, j2, depth
		j1 = math.max(fromGraph:getTop(), toGraph:getTop())
		j2 = math.min(fromGraph:getBottom(), toGraph:getBottom())
		depth = j2 - j1

		top = j1 + math.floor((depth - (self.roomConfig.doorSize or 1)) / 2)
		bottom = top + (self.roomConfig.doorSize or 1)
	elseif fromGraph:getBottom() == toGraph:getTop() or
	       fromGraph:getTop() == toGraph:getBottom()
	then
		anchor = (fromGraph:getBottom() == toGraph:getTop() and BuildingAnchor.FRONT) or BuildingAnchor.BACK

		top = (fromGraph:getBottom() == toGraph:getTop() and fromGraph:getBottom()) or fromGraph:getTop()
		bottom = top + 1

		local i1, i2, width
		i1 = math.max(fromGraph:getLeft(), toGraph:getLeft())
		i2 = math.min(fromGraph:getRight(), toGraph:getRight())
		width = i2 - i1

		left = i1 + math.floor((width - (self.roomConfig.doorSize or 1)) / 2)
		right = left + (self.roomConfig.doorSize or 1)
	end

	if left and right and top and bottom and anchor then
		self.door = {
			left = left,
			right = right,
			top = top,
			bottom = bottom,

			i = left,
			j = top,
			width = right - left,
			depth = bottom - top,

			anchor = anchor
		}
	end

	return self.door
end

function BuildingPlanner.Room:getParent()
	return self.parent
end

function BuildingPlanner.Room:getFromGraphConnection()
	return self.fromGraph
end

function BuildingPlanner.Room:getToGraphConnection()
	return self.toGraph
end

function BuildingPlanner.Room:getDoor()
	return self.door
end

function BuildingPlanner.Room:getRoomID()
	return self.roomID
end

function BuildingPlanner.Room:getRoomIndex()
	return self.roomIndex
end

function BuildingPlanner.Room:getRoomConfig()
	return self.roomConfig
end

function BuildingPlanner.Room:attach(graph)
	table.insert(self.graphs, graph)

	self.left = math.min(self.left, graph:getI())
	self.right = math.max(self.right, graph:getI() + graph:getWidth())
	self.top = math.min(self.top, graph:getJ())
	self.bottom = math.max(self.right, graph:getJ() + graph:getDepth())
end

function BuildingPlanner.Room:getExpandedRoomAnchors(room)
	local anchors = {}
	for a, rooms in pairs(self.roomConfig.anchors or {}) do
		a = (type(a) == 'number' and { a }) or a

		for i = 1, #a do
			local anchor = a[i]

			anchors[anchor] = anchors[anchor] or { required = {} }
			for j = 1, #rooms do
				table.insert(anchors[anchor], rooms[j])

				if self.roomConfig.requiredRooms then
					for k = 1, #self.roomConfig.requiredRooms do
						if self.roomConfig.requiredRooms[k] == rooms[j] then
							table.insert(anchors[anchor].required, rooms[j])
						end
					end
				end
			end
		end
	end

	return anchors
end

function BuildingPlanner.Room:_isBigEnough()
	if #self.graphs == 0 then
		return false
	end

	local width = self.right - self.left
	local depth = self.bottom - self.top

	local area = width * depth

	local minWidth = (self.roomConfig.width and self.roomConfig.width.min) or BuildingPlanner.DEFAULT_ROOM_CONFIG.width.min
	local minDepth = (self.roomConfig.depth and self.roomConfig.depth.min) or BuildingPlanner.DEFAULT_ROOM_CONFIG.depth.min
	local minArea = minWidth * minDepth

	return area >= minArea, width >= minWidth, depth >= minDepth
end

function BuildingPlanner.Room:_resolveRooms(buildingPlanner, graph, anchor, rooms)
	while #rooms > 0 do
		local index = buildingPlanner:getRNG():random(1, #rooms)
		local roomID = table.remove(rooms, index)

		local roomConfig = buildingPlanner:getRoomConfig(roomID) or BuildingPlanner.DEFAULT_ROOM_CONFIG

		if not roomConfig.rooms or not roomConfig.rooms.max or buildingPlanner:countRooms(roomID) < roomConfig.rooms.max then
			local graphs = buildingPlanner:getGraph():getSideGraphs(graph:getI(), graph:getJ(), graph:getWidth(), graph:getDepth(), anchor)
			for i = 1, #graphs do
				if not graphs[i]:getRoom() then
					local room = buildingPlanner:newRoom(roomID)
					graphs[i]:resolve(buildingPlanner, room)

					local door = room:connect(self, graph, graphs[i])
					if door then
						for i = door.left, door.right - 1 do
							for j = door.top, door.bottom - 1 do
								local tile = buildingPlanner:getFloorLayout():getTile(i, j)
								if tile then
									tile:setIsDoor(true)
								end
							end
						end
					end

					for j = 1, #BuildingAnchor.PLANE_XZ do
						if BuildingAnchor.PLANE_XZ[j] ~= BuildingAnchor.REFLEX[anchor] then
							buildingPlanner:enqueue(room, graphs[i], BuildingAnchor.PLANE_XZ[j])
						end
					end

					break
				end
			end

			return true
		end
	end

	return false
end

function BuildingPlanner.Room:resolve(buildingPlanner, graph, anchor)
	local reflexAnchor = BuildingAnchor.REFLEX[anchor]

	local areaGood, widthGood, depthGood = self:_isBigEnough()
	if areaGood and widthGood and depthGood then
		local anchors = self:getExpandedRoomAnchors()

		for a, rooms in pairs(anchors) do
			if a ~= reflexAnchor then
				if not self:_resolveRooms(buildingPlanner, graph, a, rooms.required) then
					self:_resolveRooms(buildingPlanner, graph, a, rooms)
				end
			end
		end
	else
		local offset = BuildingAnchor.OFFSET[anchor]
		if widthGood and offset.i ~= 0 and
		   depthGood and offset.j ~= 0
		then
			for i = 1, #self.graphs do
				for j = 1, #BuildingAnchor.PLANE_XZ do
					buildingPlanner:enqueue(self, self.graphs[i], BuildingPlanner.PLANE_XZ[j])
				end
			end

			return
		end

		local graphs = buildingPlanner:getGraph():getSideGraphs(graph:getI(), graph:getJ(), graph:getWidth(), graph:getDepth(), anchor)

		for i = 1, #graphs do
			if not graphs[i]:getRoom() then
				graph:resolve(buildingPlanner, self)

				for j = 1, #BuildingAnchor.PLANE_XZ do
					local a = BuildingAnchor.PLANE_XZ[j]
					if a ~= reflexAnchor then
						buildingPlanner:enqueue(self, graphs[i], a)
					end
				end

				break
			end
		end
	end
end

function BuildingPlanner.Room:iterate()
	return ipairs(self.graphs)
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

	local width = self.rng:random(buildingConfig.width.min, buildingConfig.width.max)
	local depth = self.rng:random(buildingConfig.depth.min, buildingConfig.depth.max)

	self.graph = BuildingPlanner.Graph(nil, 1, 1, width, depth)

	self.currentRoomIndex = 1
	self.rooms = {}
	self.roomsByID = {}
	self.doors = {}

	self.queue = {}

	local LayoutType = require(self.currentBuildingConfig.layout)
	self.layout = LayoutType(width, depth)
	self.layout:apply(self)

	while #self.queue > 0 do
		local room, graph, anchor = unpack(table.remove(self.queue, 1))
		room:resolve(self, graph, anchor)
	end
end

function BuildingPlanner:getState()
	local state = { rooms = {} }

	local left, right = math.huge, -math.huge
	local top, bottom = math.huge, -math.huge

	for i = 1, #self.rooms do
		local room = self.rooms[i]

		local r = { graphs = {} }
		for _, graph in room:iterate() do
			local g = {
				i = graph:getI(),
				j = graph:getJ(),
				width = graph:getWidth(),
				depth = graph:getDepth(),

				left = graph:getLeft(),
				right = graph:getRight(),
				top = graph:getTop(),
				bottom = graph:getBottom()
			}

			if graph == room:getToGraphConnection() then
				local door = room:getDoor()
				g.door = {
					i = door.i,
					j = door.j,
					width = door.width,
					depth = door.depth,
					left = door.left,
					right = door.right,
					top = door.top,
					bottom = door.bottom
				}
			end

			table.insert(r.graphs, g)

			left = math.min(left, g.left)
			right = math.max(right, g.right)
			top = math.min(top, g.top)
			bottom = math.max(bottom, g.bottom)
		end

		table.insert(state.rooms, r)
	end

	state.root = {
		i = left,
		j = top,
		width = right - left,
		depth = bottom - top,

		left = left,
		right = right,
		top = top,
		bottom = bottom,

		doors = {}
	}

	for i = 1, #self.doors do
		local door = self.doors[i]
		table.insert(state.root.doors, {
			i = door.i,
			j = door.j,
			width = door.width,
			depth = door.depth,
			left = door.left,
			right = door.right,
			top = door.top,
			bottom = door.bottom
		})
	end

	return state
end

function BuildingPlanner:enqueue(room, graph, anchor)
	table.insert(self.queue, { room, graph, anchor })
end

function BuildingPlanner:randomRange(min, max)
	return self.rng:random() * (max - min) + min
end

function BuildingPlanner:newRoom(roomID)
	local roomIndex = self.currentRoomIndex
	self.currentRoomIndex = self.currentRoomIndex + 1

	local room = BuildingPlanner.Room(roomID, roomIndex, self:getRoomConfig(roomID) or BuildingPlanner.DEFAULT_ROOM_CONFIG)
	table.insert(self.rooms, room)

	local rooms = self.roomsByID[roomID] or {}
	table.insert(rooms, room)
	self.roomsByID[roomID] = rooms

	return room
end

function BuildingPlanner:countRooms(roomID)
	if self.roomsByID[roomID] then
		return #self.roomsByID[roomID]
	end

	return 0
end

function BuildingPlanner:iterate()
	return ipairs(self.rooms)
end

function BuildingPlanner:getRoomByIndex(roomIndex)
	return self.rooms[roomIndex]
end

function BuildingPlanner:addDoor(i, j, width, depth, anchor)
	table.insert(self.doors, {
		left = i,
		right = i + width,
		top = j,
		bottom = j + depth,

		i = i,
		j = j,
		width = width,
		depth = depth,

		anchor = anchor
	})

	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			self.layout:getTile(currentI, currentJ):setIsDoor(true)
			print("door", currentI, currentJ)
		end
	end
end

return BuildingPlanner
