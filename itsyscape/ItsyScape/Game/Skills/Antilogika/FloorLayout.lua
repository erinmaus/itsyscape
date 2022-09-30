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

function FloorLayout.Tile:new(floorLayout, i, j)
	self.floorLayout = floorLayout
	self.i = i
	self.j = j
	self.type = FloorLayout.TILE_TYPE_UNDECIDED
	self.roomIndex = false
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

function FloorLayout:new(width, depth, cellSize)
	self.width = width
	self.depth = depth
	self.cellSize = cellSize

	assert(self.width % self.cellSize == 0)
	assert(self.depth % self.cellSize == 0)

	self.tiles = {}
	for i = 1, width do
		for j = 1, depth do
			local index = self:getTileIndex(i, j)
			self.tiles[index] = FloorLayout.Tile(self, i, j)
		end
	end
end

function FloorLayout:makeConstraint(s, t, constraint)
	local cellDefinition = {}
	for j = 1, self.cellSize do
		cellDefinition[j] = {}
	end

	local i, j = (s - 1) * self.cellSize + 1, (t - 1) * self.cellSize + 1

	for offsetI = 1, self.cellSize do
		for offsetJ = 1, self.cellSize do
			local tile = self:getTile(i + offsetI - 1, j + offsetJ - 1)
			if tile then
				if tile:getTileType() == FloorLayout.TILE_TYPE_ROOM then
					constraint:setRoomID(tile:getRoomID())
					constraint:setRoomIndex(tile:getRoomIndex())
				end

				cellDefinition[offsetJ][offsetI] = tile:getTileType()
			end
		end
	end

	constraint:setCellDefinition(cellDefinition)
	constraint:setIsUndecided(self:isUndecided(s, t))
	constraint:setPosition(s, t)
	constraint:setFloorLayout(self)
end

function FloorLayout:getRoom(s, t)
	local i, j = (s - 1) * self.cellSize + 1, (t - 1) * self.cellSize + 1

	for offsetI = 1, self.cellSize do
		for offsetJ = 1, self.cellSize do
			local tile = self:getTile(i + offsetI - 1, j + offsetJ - 1)
			if tile and tile:getTileType() == FloorLayout.TILE_TYPE_ROOM then
				return tile:getRoomID(), tile:getRoomIndex()
			end
		end
	end

	return nil
end

function FloorLayout:setRoom(s, t, roomID, roomIndex)
	local i, j = (s - 1) * self.cellSize + 1, (t - 1) * self.cellSize + 1

	for offsetI = 1, self.cellSize do
		for offsetJ = 1, self.cellSize do
			local tile = self:getTile(i + offsetI - 1, j + offsetJ - 1)
			if tile then
				tile:setTileType(FloorLayout.TILE_TYPE_ROOM)
				tile:setRoomID(roomID)
				tile:setRoomIndex(roomIndex)
			end
		end
	end
end

function FloorLayout:setNothing(s, t)
	local i, j = (s - 1) * self.cellSize + 1, (t - 1) * self.cellSize + 1

	for offsetI = 1, self.cellSize do
		for offsetJ = 1, self.cellSize do
			local tile = self:getTile(i + offsetI - 1, j + offsetJ - 1)
			if tile then
				tile:setTileType(FloorLayout.TILE_TYPE_NOTHING)
			end
		end
	end
end

function FloorLayout:isUndecided(s, t)
	local i, j = (s - 1) * self.cellSize + 1, (t - 1) * self.cellSize + 1

	for offsetI = 1, self.cellSize do
		for offsetJ = 1, self.cellSize do
			local tile = self:getTile(i + offsetI - 1, j + offsetJ - 1)
			if not tile or tile:getTileType() ~= FloorLayout.TILE_TYPE_UNDECIDED then
				return false
			end
		end
	end

	return true
end

function FloorLayout:getWidth()
	return self.width
end

function FloorLayout:getDepth()
	return self.depth
end

function FloorLayout:getCellSize()
	return self.cellSize
end

function FloorLayout:getTileIndex(i, j)
	return (j - 1) * self.width + (i - 1) + 1
end

function FloorLayout:getTile(i, j)
	return self.tiles[self:getTileIndex(i, j)]
end

function FloorLayout:getAvailableRectangles()
	local rectangles = {}
	local currentRectangle
	local lastTile
	for j = 1, self:getDepth() do
		for i = 1, self:getWidth() do
			local index = self:getTileIndex(i, j)
			local tile = self.tiles[index]

			if tile:getTileType() == FloorLayout.TILE_TYPE_ROOM and (not currentRectangle or currentRectangle.roomID == tile:getRoomID()) then
				if currentRectangle then
					currentRectangle.right = currentRectangle.right + 1
					currentRectangle.width = currentRectangle.width + 1
				else
					currentRectangle = {
						left = i,
						right = i + 1,
						top = j,
						bottom = j + 1,
						width = 1,
						depth = 1,
						roomID = tile:getRoomID()
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
			   a.roomID == b.roomID
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
