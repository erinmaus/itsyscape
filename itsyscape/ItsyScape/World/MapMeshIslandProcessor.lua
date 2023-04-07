--------------------------------------------------------------------------------
-- ItsyScape/World/MapMeshIslandProcessor.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MapMeshMask = require "ItsyScape.World.MapMeshMask"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

local MapMeshIslandProcessor = Class()
MapMeshIslandProcessor.DIRECTIONS = {
	{ -1,  0 },
	{  1,  0 },
	{  0, -1 },
	{  0,  1 }
}

function MapMeshIslandProcessor:new(map, tileSet, i, j)
	self.map = map
	self.tileSet = tileSet
	self.isMultiTexture = Class.isCompatibleType(tileSet, MultiTileSet)
	self.currentIslandID = 1

	self:_process(i or 1, j or 1)
end

function MapMeshIslandProcessor:_getTileIndex(i, j)
	return ((j - 1) * self.map:getWidth() + (i - 1)) + 1
end

function MapMeshIslandProcessor:_buildVisitRecord(i, j)
	return {
		index = self:_getTileIndex(i, j),
		i = i,
		j = j,
		tile = self.map:getTile(i, j)
	}
end

function MapMeshIslandProcessor:_process(i, j)
	self.visited = {}

	self.rootIsland = self:_processIsland(i, j)

	if #self.visited ~= self.map:getWidth() * self.map:getWidth() then
		local difference = self.map:getWidth() * self.map:getWidth() - #self.visited
		Log.warn("Missed %d tile(s) while processing islands.", difference)
	end
end

function MapMeshIslandProcessor:_canMove(i, j)
	if i < 1 or i > self.map:getWidth() then
		return false
	end

	if j < 1 or j > self.map:getHeight() then
		return false
	end

	return true
end

function MapMeshIslandProcessor:_visited(i, j)
	local island = self.visited[self:_getTileIndex(i, j)]
	return island ~= nil
end

function MapMeshIslandProcessor:_sameFlat(i, j, currentTile)
	local nextTile = self.map:getTile(i, j)
	if nextTile.tileSetID ~= currentTile.tileSetID or nextTile.flat ~= currentTile.flat then
		return false
	end

	return true
end

function MapMeshIslandProcessor:_processIsland(i, j, parentIsland)
	if self:_visited(i, j) then
		return
	end

	local queue = {
		self:_buildVisitRecord(i, j)
	}

	local islands = {}
	local island = {
		parent = parentIsland,
		tileSetID = queue[1].tile.tileSetID,
		flat = queue[1].tile.flat,
		children = {},
		tiles = {},
		tilesByIndex = {},
		id = self.currentIslandID
	}

	self.currentIslandID = self.currentIslandID + 1

	if parentIsland then
		table.insert(parentIsland.children, island)
	end

	while #queue > 0 do
		local record = table.remove(queue, #queue)
		self.visited[record.index] = { island = island, record = record }

		for i = 1, #MapMeshIslandProcessor.DIRECTIONS do
			local offsetI, offsetJ = unpack(MapMeshIslandProcessor.DIRECTIONS[i])
			offsetI = record.i + offsetI
			offsetJ = record.j + offsetJ

			if self:_canMove(offsetI, offsetJ) then
				local isSameFlat = self:_sameFlat(offsetI, offsetJ, record.tile)
				local visited = self:_visited(offsetI, offsetJ)

				if not visited then
					if isSameFlat then
						table.insert(queue, self:_buildVisitRecord(offsetI, offsetJ))
					else
						table.insert(islands, self:_buildVisitRecord(offsetI, offsetJ))
					end
				end
			end
		end

		table.insert(island.tiles, record)
		island.tilesByIndex[record.index] = record
	end

	for i = 1, #islands do
		local record = islands[i]
		self:_processIsland(record.i, record.j, island)
	end

	return island
end

function MapMeshIslandProcessor:getRootIsland()
	return self.rootIsland
end

function MapMeshIslandProcessor:getIslandTileSetIDAndFlat(island)
	return island.tileSetID, island.flat
end

function MapMeshIslandProcessor:getIslandForTile(i, j)
	local index = self:_getTileIndex(i, j)
	return self.visited[index] and self.visited[index].island
end

function MapMeshIslandProcessor:getTilesInIsland(island)
	return island.tiles
end

function MapMeshIslandProcessor:getTileInIsland(i, j)
	return island.tiles[self:_getTileIndex(i, j)]
end

function MapMeshIslandProcessor:getChildrenIslands(island)
	return island.children
end

return MapMeshIslandProcessor
