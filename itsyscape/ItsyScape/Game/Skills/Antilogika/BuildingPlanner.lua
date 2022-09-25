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

	while #queue > 0 do
		local g = table.remove(queue, 1)
		self:expand(g, state, queue)
	end

	table.insert(queue, graph)
	while #queue > 0 do
		local g = table.remove(queue, 1)
		self:place(g, state, queue)
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
			local anchor = table.remove(unshuffledAnchors, math.random(1, #unshuffledAnchors))
			table.insert(anchors, anchor)
		end
	end

	for i = 1, #anchors do
		local rooms = graph.anchors[anchors[i]]

		local room
		if rooms and BuildingAnchor.REFLEX[graph.from] ~= anchors[i] then
			repeat
				local roomIndex = math.random(1, #rooms)
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

			graph.anchors[anchors[i]] = {
				from = anchors[i],
				id = room.id,
				parent = graph,
				anchors = {}
			}

			table.insert(queue, graph.anchors[anchors[i]])
		else
			graph.anchors[anchors[i]] = nil
		end
	end
end

function BuildingPlanner:place(graph, state, queue)
	local roomConfig = self:getRoomConfig(graph.id) or BuildingPlanner.DEFAULT_ROOM

	graph.width = math.random(
		(roomConfig.width or BuildingPlanner.DEFAULT_ROOM.width).min or BuildingPlanner.DEFAULT_ROOM.width.min,
		(roomConfig.width or BuildingPlanner.DEFAULT_ROOM.width).max or BuildingPlanner.DEFAULT_ROOM.width.max)
	graph.depth = math.random(
		(roomConfig.depth or BuildingPlanner.DEFAULT_ROOM.depth).min or BuildingPlanner.DEFAULT_ROOM.depth.min,
		(roomConfig.depth or BuildingPlanner.DEFAULT_ROOM.depth).max or BuildingPlanner.DEFAULT_ROOM.depth.max)

	if graph.from then
		local offset = BuildingAnchor.OFFSET[graph.from]

		graph.i = graph.parent.i + math.floor(graph.parent.width / 2) * offset.i + math.floor(graph.width / 2) * offset.i + offset.i
		graph.j = graph.parent.j + math.floor(graph.parent.depth / 2) * offset.j + math.floor(graph.depth / 2) * offset.j + offset.j
	else
		graph.i = 0
		graph.j = 0
	end

	graph.left = graph.i - math.floor(graph.width / 2)
	graph.right = graph.i + math.floor(graph.width / 2)
	graph.top = graph.j - math.floor(graph.depth / 2)
	graph.bottom = graph.j + math.floor(graph.depth / 2)

	state.left = math.min(graph.left, state.left or math.huge)
	state.right = math.max(graph.right, state.right or -math.huge)
	state.top = math.min(graph.top, state.top or math.huge)
	state.bottom = math.max(graph.bottom, graph.bottom or -math.huge)

	table.insert(state.rooms, graph)

	for _, g in pairs(graph.anchors) do
		table.insert(queue, g)
	end
end

return BuildingPlanner
