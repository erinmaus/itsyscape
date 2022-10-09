--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/FloorLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"

local FloorLayout = Class()

FloorLayout.TILE_TYPE_UNDECIDED = 0
FloorLayout.TILE_TYPE_WALL      = 1
FloorLayout.TILE_TYPE_HALLWAY   = 2
FloorLayout.TILE_TYPE_ROOM      = 3
FloorLayout.TILE_TYPE_OUTSIDE   = 4
FloorLayout.TILE_TYPE_NOTHING   = 5

FloorLayout.Tile = Class()

function FloorLayout.Tile:new(floorLayout, i, j, tileType)
	self.floorLayout = floorLayout
	self.i = i
	self.j = j
	self.type = tileType or FloorLayout.TILE_TYPE_UNDECIDED
	self.roomIndex = false
	self.isDoor = false
end

function FloorLayout.Tile:getFloorLayout()
	return self.floorLayout
end

function FloorLayout.Tile:getI()
	return self.i
end

function FloorLayout.Tile:getJ()
	return self.j
end

function FloorLayout.Tile:setTileType(type)
	self.type = type or FloorLayout.TILE_TYPE_UNDECIDED
end

function FloorLayout.Tile:getTileType()
	return self.type
end

function FloorLayout.Tile:setRoomID(roomID)
	self.roomID = roomID
end

function FloorLayout.Tile:getRoomID()
	return self.roomID
end

function FloorLayout.Tile:setRoomIndex(value)
	self.roomIndex = value or false
end

function FloorLayout.Tile:getRoomIndex()
	return self.roomIndex
end

function FloorLayout.Tile:setIsDoor(value)
	self.isDoor = value or false
end

function FloorLayout.Tile:getIsDoor()
	return self.isDoor
end

function FloorLayout:new(width, depth)
	self.width = width
	self.depth = depth

	self.tiles = {}
	for i = 1, width do
		for j = 1, depth do
			local index = self:getTileIndex(i, j)
			self.tiles[index] = FloorLayout.Tile(self, i, j)
		end
	end
end

function FloorLayout:setRoom(i, j, width, depth, roomID, roomIndex)
	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			local tile = self:getTile(currentI, currentJ)
			if tile then
				tile:setTileType(FloorLayout.TILE_TYPE_ROOM)
				tile:setRoomID(roomID)
				tile:setRoomIndex(roomIndex)
			end
		end
	end
end

function FloorLayout:getWidth()
	return self.width
end

function FloorLayout:getDepth()
	return self.depth
end

function FloorLayout:getTileIndex(i, j)
	return (j - 1) * self.width + (i - 1) + 1
end

function FloorLayout:getTile(i, j)
	if i < 1 or i > self:getWidth() or j < 1 or j > self:getDepth() then
		return nil
	end

	return self.tiles[self:getTileIndex(i, j)]
end

function FloorLayout:getAvailableRectangles(tileType)
	local rectangles = {}
	local currentRectangle
	local lastTile
	for j = 1, self:getDepth() do
		for i = 1, self:getWidth() do
			local index = self:getTileIndex(i, j)
			local tile = self.tiles[index]

			local isMatch = tile:getTileType() == (tileType or FloorLayout.TILE_TYPE_ROOM)
			local isRoomMatch
			if not tileType or tileType == FloorLayout.TILE_TYPE_ROOM then
				isRoomMatch = not currentRectangle or (currentRectangle.roomID == tile:getRoomID() and currentRectangle.roomIndex == tile:getRoomIndex())
			else
				isRoomMatch = true
			end

			if isMatch then
				if currentRectangle and isRoomMatch then
					currentRectangle.right = currentRectangle.right + 1
					currentRectangle.width = currentRectangle.width + 1
				else
					if currentRectangle then
						table.insert(rectangles, currentRectangle)
					end

					currentRectangle = {
						left = i,
						right = i + 1,
						top = j,
						bottom = j + 1,
						width = 1,
						depth = 1,
						roomID = tile:getRoomID(),
						roomIndex = tile:getRoomIndex()
					}
				end
			else
				if currentRectangle then
					table.insert(rectangles, currentRectangle)
					currentRectangle = nil
				end
			end
		end

		if currentRectangle then
			table.insert(rectangles, currentRectangle)
			currentRectangle = nil
		end
	end

	for i = 1, #rectangles do
		for j = 1, #rectangles do
			local a = rectangles[i]
			local b = rectangles[j]

			if b.bottom == a.top and
			   a.left == b.left and a.right == b.right and
			   a.depth > 0 and b.depth > 0 and
			   a.roomID == b.roomID and
			   a.roomIndex == b.roomIndex
			then
				a.depth = a.depth - 1

				b.depth = b.depth + 1
				b.bottom = b.bottom + 1
				break
			end
		end
	end

	local result = {}
	for i = 1, #rectangles do
		local a = rectangles[i]
		if a.depth > 0 then
			table.insert(result, a)
		end
	end

	return result
end

function FloorLayout:apply(buildingPlanner)
	-- Nothing.
end

return FloorLayout
