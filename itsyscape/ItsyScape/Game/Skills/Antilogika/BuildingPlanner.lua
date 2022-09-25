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

	return graph
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
				anchors = {}
			}

			table.insert(queue, graph.anchors[anchors[i]])
		else
			graph.anchors[anchors[i]] = nil
		end
	end
end

return BuildingPlanner
