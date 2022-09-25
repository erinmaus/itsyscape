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

	local graph = { id = buildingConfig.root, anchors = {} }
	local state = { buildingConfig = buildingConfig, rooms = {}, roomCount = 1 }
	local queue = {
		graph
	}

	self:place(graph, state)
	table.insert(state.rooms, graph)

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

		if room and state.roomCount < state.buildingConfig.rooms.max then
			if not room.isHallway then
				state.roomCount = state.roomCount + 1
			end

			local childGraph = {
				from = anchors[i],
				id = room.id,
				parent = graph,
				anchors = {},
				isHallway = room.isHallway
			}

			local wasPlaced = self:place(childGraph, state)
			if wasPlaced then
				graph.anchors[anchors[i]] = childGraph

				if not childGraph.isHallway then
					table.insert(state.rooms, childGraph)
				end

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

	graph.width = self.rng:random(
		(roomConfig.width or BuildingPlanner.DEFAULT_ROOM.width).min or BuildingPlanner.DEFAULT_ROOM.width.min,
		(roomConfig.width or BuildingPlanner.DEFAULT_ROOM.width).max or BuildingPlanner.DEFAULT_ROOM.width.max)
	graph.depth = self.rng:random(
		(roomConfig.depth or BuildingPlanner.DEFAULT_ROOM.depth).min or BuildingPlanner.DEFAULT_ROOM.depth.min,
		(roomConfig.depth or BuildingPlanner.DEFAULT_ROOM.depth).max or BuildingPlanner.DEFAULT_ROOM.depth.max)

	if graph.from then
		local parent = graph.parent
		while parent and parent.isHallway do
			parent = parent.parent
		end

		if parent then
			local offset = BuildingAnchor.OFFSET[graph.from]

			graph.i = parent.i + math.floor(parent.width / 2) * offset.i + math.floor(graph.width / 2) * offset.i + offset.i
			graph.j = parent.j + math.floor(parent.depth / 2) * offset.j + math.floor(graph.depth / 2) * offset.j + offset.j
		end
	else
		graph.i = 0
		graph.j = 0
	end

	graph.left = graph.i - math.floor(graph.width / 2)
	graph.right = graph.i + math.floor(graph.width / 2)
	graph.top = graph.j - math.floor(graph.depth / 2)
	graph.bottom = graph.j + math.floor(graph.depth / 2)

	return not self:overlaps(graph, state)
end

function BuildingPlanner:overlaps(graph, state)
	for i = 1, #state.rooms do
		local otherGraph = state.rooms[i]
		local overlapI = graph.left < otherGraph.right and graph.right > otherGraph.left
		local overlapJ = graph.top < otherGraph.bottom and graph.bottom > otherGraph.top

		if overlapI and overlapJ then
			print(graph.id, "OVERLAPS", otherGraph.id)
			return true
		end
	end

	return false
end

return BuildingPlanner
