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
BuildingPlanner.DEFAULT_ROOM = {
	width = { min = 4, max = 8 },
	depth = { min = 4, max = 8 },
	anchors = {}
}

BuildingPlanner.SPLIT_I = 1
BuildingPlanner.SPLIT_J = 2
BuildingPlanner.SPLITS = {
	BuildingPlanner.SPLIT_I,
	BuildingPlanner.SPLIT_J
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

function BuildingPlanner:build(buildingID)
	local buildingConfig = self:getBuildingConfig(buildingID)
	if not buildingConfig then
		return nil
	end

	local state = { buildingConfig = buildingConfig, rooms = {} }
	self:measure(state)

	local graph = { id = buildingConfig.root, anchors = {} }
	self:place(graph, state)
	table.insert(state.rooms, graph)

	local queue = { graph }

	while #queue > 0 do
		local g = table.remove(queue, 1)
		self:expand(g, state, queue)
	end

	for i = 1, #state.rooms do
		local room = state.rooms[i]

		state.left = math.min(room.left, state.left or math.huge)
		state.right = math.max(room.right, state.right or -math.huge)
		state.top = math.min(room.top, state.top or math.huge)
		state.bottom = math.max(room.bottom, state.bottom or -math.huge)
	end

	return graph, state
end

function BuildingPlanner:expand(graph, state, queue)
	local roomConfig = self:getRoomConfig(graph.id)

	for anchors, rooms in pairs((roomConfig and roomConfig.anchors) or {}) do
		local a = (type(anchors) == 'number' and { anchors }) or anchors

		for i = 1, #a do
			local anchor = a[i]

			graph.anchors[anchor] = {}
			for j = 1, #rooms do
				table.insert(graph.anchors[anchor], rooms[j])
			end
		end
	end

	graph.config = roomConfig

	self:resolve(graph, state, queue)
end

function BuildingPlanner:resolve(graph, state, queue)
	local anchors = {}
	do
		local unshuffledAnchors = {}
		for anchor, rooms in pairs(graph.anchors) do
			table.insert(unshuffledAnchors, anchor)
		end

		table.sort(unshuffledAnchors, function(a, b)
			return a < b
		end)

		while #unshuffledAnchors > 0 do
			local anchor = table.remove(unshuffledAnchors, self.rng:random(1, #unshuffledAnchors))
			table.insert(anchors, anchor)
		end
	end

	for i = 1, #anchors do
		local rooms = graph.anchors[anchors[i]]

		local room
		if rooms and BuildingAnchor.REFLEX[graph.from] ~= anchors[i] then
			repeat
				local roomIndex = self.rng:random(1, #rooms)
				local roomID = rooms[roomIndex]
				local roomConfig = self:getRoomConfig(roomID) or {
					id = roomID
				}

				if state.rooms[roomID] then
					if state.rooms[roomID].count >= ((roomConfig.rooms and roomConfig.rooms.max) or math.huge) then
						table.remove(rooms, roomIndex)
					else
						state.rooms[roomID].count = state.rooms[roomID].count + 1
						room = roomConfig
					end
				else
					state.rooms[roomID] = {
						count = 1
					}
					room = roomConfig
				end

				if #rooms == 0 then
					break
				end
			until room
		end

		if room and #state.rooms < state.buildingConfig.rooms.max then
			local childGraph = {
				from = anchors[i],
				id = room.id,
				parent = graph,
				anchors = {}
			}

			local wasPlaced = self:place(childGraph, state, rooms.extrude)
			if wasPlaced then
				graph.anchors[anchors[i]] = childGraph
				table.insert(state.rooms, childGraph)
				table.insert(queue, childGraph)
			else
				graph.anchors[anchors[i]] = nil
			end
		else
			graph.anchors[anchors[i]] = nil
		end
	end
end


function BuildingPlanner:place(graph, state)
	local roomConfig = self:getRoomConfig(graph.id) or BuildingPlanner.DEFAULT_ROOM

	if graph.parent then
		local offset = BuildingAnchor.OFFSET[graph.from]

		local bounds = {}
		do
			if offset.i < 0 then
				bounds.i = graph.parent.left - 1
				bounds.width = 1
			elseif offset.i > 0 then
				bounds.i = graph.parent.right + 1
				bounds.width = 1
			else
				bounds.i = graph.parent.left
				bounds.width = graph.parent.width
			end

			if offset.j < 0 then
				bounds.j = graph.parent.top - 1
				bounds.depth = 1
			elseif offset.j > 0 then
				bounds.j = graph.parent.bottom + 1
				bounds.depth = 1
			else
				bounds.j = graph.parent.top
				bounds.depth = graph.parent.depth
			end
		end
		self:buildBounds(bounds)

		local leaf = self:findLeafs(state.space, bounds)[1]
		if not leaf then
			return false
		end

		graph.i = leaf.i
		graph.j = leaf.j
		graph.width = leaf.width
		graph.depth = leaf.depth
		graph.leaf = leaf
		self:buildBounds(graph)

		leaf.occupied = graph

		return true
	else
		local desiredI = state.space.width * state.buildingConfig.rootPosition.x
		local desiredJ = state.space.depth * state.buildingConfig.rootPosition.z

		local leaf = self:findLeafs(state.space, {
			left = desiredI - 1, right = desiredI + 1,
			top = desiredJ - 1, bottom = desiredJ + 1
		})[1]

		graph.i = leaf.i
		graph.j = leaf.j
		graph.width = leaf.width
		graph.depth = leaf.depth
		graph.leaf = leaf
		self:buildBounds(graph)

		leaf.occupied = graph

		return true
	end
end

function BuildingPlanner:overlaps(space, bounds)
	local overlapI = space.left < bounds.right and space.right > bounds.left
	local overlapJ = space.top < bounds.bottom and space.bottom > bounds.top
	return overlapI and overlapJ
end

function BuildingPlanner:findLeafs(space, bounds, result)
	result = result or {}

	if (not space.a or not space.b) and not space.occupied then
		table.insert(result, space)
	elseif space.a and space.b then
		if self:overlaps(space.a, bounds) then
			self:findLeafs(space.a, bounds, result)
		end

		if self:overlaps(space.b, bounds) then
			self:findLeafs(space.b, bounds, result)
		end
	end

	return result
end

function BuildingPlanner:measure(state)
	local width = self.rng:random(
		state.buildingConfig.width.min,
		state.buildingConfig.width.max)
	local depth = self.rng:random(
		state.buildingConfig.depth.min,
		state.buildingConfig.width.max)

	local space, leafs = self:extrude(0, 0, width, depth, state)
	state.space = space
	state.leafs = leafs
end

function BuildingPlanner:extrude(i, j, width, depth, state)
	local space = {
		i = i,
		j = j,
		width = width,
		depth = depth
	}

	local leafs = {}
	self:split(space, state, leafs, 1)

	return space, leafs
end

function BuildingPlanner:split(space, state, leafs, currentSplitDepth)
	self:buildBounds(space)

	if currentSplitDepth > state.buildingConfig.split.maxDepth then
		table.insert(leafs, space)
		return
	end

	local splitDirection
	if space.width > space.depth then
		splitDirection = BuildingPlanner.SPLIT_I
	else
		splitDirection = BuildingPlanner.SPLIT_J
	end

	local split = self.rng:random() * (state.buildingConfig.split.max - state.buildingConfig.split.min) + state.buildingConfig.split.min

	if splitDirection == BuildingPlanner.SPLIT_I then
		local width = math.floor(space.width * split)

		local left = {
			parent = space,
			i = space.i,
			j = space.j,
			width = width,
			depth = space.depth
		}

		local right = {
			parent = space,
			i = space.i + width,
			j = space.j,
			width = space.width - width,
			depth = space.depth
		}

		space.a = left
		space.b = right
	elseif splitDirection == BuildingPlanner.SPLIT_J then
		local depth = math.floor(space.depth * split)

		local top = {
			parent = space,
			i = space.i,
			j = space.j,
			width = space.width,
			depth = depth
		}

		local bottom = {
			parent = space,
			i = space.i,
			j = space.j + depth,
			width = space.width,
			depth = space.depth - depth
		}

		space.a = top
		space.b = bottom
	end

	self:split(space.a, state, leafs, currentSplitDepth + 1)
	self:split(space.b, state, leafs, currentSplitDepth + 1)
end

function BuildingPlanner:buildBounds(graph)
	graph.left = graph.i
	graph.right = graph.i + graph.width
	graph.top = graph.j
	graph.bottom = graph.j + graph.depth
end

return BuildingPlanner
