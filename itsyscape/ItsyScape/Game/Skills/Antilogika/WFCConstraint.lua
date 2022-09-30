--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/WFCConstraint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"
local FloorLayout = require "ItsyScape.Game.Skills.Antilogika.FloorLayout"

local WFCConstraint = Class()

local DIAGONAL_OFFSETS = {
	{ i = -1, j = -1 },
	{ i =  1, j = -1 },
	{ i = -1, j =  1 },
	{ i =  1, j =  1 }
}

local ADJACENT_OFFSETS = {
	{ i = -1, j =  0 },
	{ i =  1, j =  0 },
	{ i =  0, j = -1 },
	{ i =  0, j =  1 }
}

function WFCConstraint:new(cellDefinition, roomID, roomIndex)
	self.cellDefinition = cellDefinition or false
	self.roomID = roomID or false
	self.roomIndex = roomIndex
	self.isUndecided = false
end

function WFCConstraint:setCellDefinition(value)
	self.cellDefinition = value or false
end

function WFCConstraint:getCellDefinition()
	return self.cellDefinition
end

function WFCConstraint:setRoomID(value)
	self.roomID = value or false
end

function WFCConstraint:getRoomID()
	return self.roomID
end

function WFCConstraint:setRoomIndex(value)
	self.roomIndex = value or false
end

function WFCConstraint:getRoomIndex()
	return self.roomIndex
end

function WFCConstraint:setIsUndecided(value)
	self.isUndecided = value or false
end

function WFCConstraint:getIsUndecided()
	return self.isUndecided
end

function WFCConstraint:setFloorLayout(floorLayout)
	self.floorLayout = floorLayout
end

function WFCConstraint:getFloorLayout()
	return self.floorLayout
end

function WFCConstraint:setPosition(s, t)
	self.s = s
	self.t = t
end

function WFCConstraint:getPosition(s, t)
	return self.s, self.t
end

function WFCConstraint:_makeGrid(width, height)
	local grid = {}
	for j = 1, height do
		grid[j] = {}
		for i = 1, width do
			grid[j][i] = { checked = false, tileType = 0, roomID = "", roomIndex = 0 }
		end
	end

	return grid
end

function WFCConstraint:_paintGrid(grid, constraint, i, j)
	for currentJ = 1, 4 do
		for currentI = 1, 4 do
			local g = grid[currentJ + j - 1][currentI + i - 1]
			g.tileType = constraint.cellDefinition[currentJ][currentI]
			g.roomID = constraint.roomID
			g.roomIndex = constraint.roomIndex
			g.s = constraint.s
			g.t = constraint.t
			g.i = currentI
			g.j = currentJ
		end
	end
end

function WFCConstraint:print(grid)
	local patterns = {}

	for j = 1, #grid do
		local p = ""
		for i = 1, #grid[j] do
			if grid[j][i].tileType == FloorLayout.TILE_TYPE_ROOM then
				p = p .. "."
			elseif grid[j][i].tileType == FloorLayout.TILE_TYPE_HALLWAY then
				p = p .. "-"
			elseif grid[j][i].tileType == FloorLayout.TILE_TYPE_WALL then
				p = p .. "#"
			else
				p = p .. "?"
			end
		end

		patterns[j] = p
	end

	print(table.concat(patterns, "\n"))
end

function WFCConstraint:_isWallValid(grid, i, j)
	local corners, empty = 0, 0

	for index = 1, #DIAGONAL_OFFSETS do
		local offset = DIAGONAL_OFFSETS[index]

		local verticalI, verticalJ = i, j + offset.j
		local horizontalI, horizontalJ = i + offset.i, j
		local diagonalI, diagonalJ = i + offset.i, j + offset.j
		local isVerticalWall = grid[verticalJ] ~= nil and grid[verticalJ][verticalI] ~= nil and grid[verticalJ][verticalI].tileType == FloorLayout.TILE_TYPE_WALL
		local isHorizontalWall = grid[horizontalJ] ~= nil and grid[horizontalJ][horizontalI] ~= nil and grid[horizontalJ][horizontalI].tileType == FloorLayout.TILE_TYPE_WALL
		local isDiagonalWall = grid[diagonalJ] ~= nil and grid[diagonalJ][diagonalI] ~= nil and grid[diagonalJ][diagonalI].tileType == FloorLayout.TILE_TYPE_WALL

		if isDiagonalWall then
			if isVerticalWall and isHorizontalWall then
				corners = corners + 1
			elseif not isVerticalWall and not isHorizontalWall then
				return false
			end
		else
			if not isDiagonalWall and not isVerticalWall and not isHorizontalWall then
				empty = empty + 1
			end
		end
	end

	-- This requires looking to surrounding tiles outside the constraints' area
	-- if corners == 0 and empty == #DIAGONAL_OFFSETS then
	-- 	local g = grid[j][i]

	-- 	local adjacentOffsets = 0
	-- 	if self.floorLayout and g.s and g.t then
	-- 		for index = 1, #ADJACENT_OFFSETS do
	-- 			local offset = ADJACENT_OFFSETS[index]
	-- 			local tile = self.floorLayout:getTile(
	-- 				(g.s - 1) * self.floorLayout:getCellSize() + g.i + offset.i,
	-- 				(g.t - 1) * self.floorLayout:getCellSize() + g.j + offset.j)
	-- 			if tile and tile:getTileType() == FloorLayout.TILE_TYPE_WALL then
	-- 				adjacentOffsets = adjacentOffsets + 1
	-- 			end
	-- 		end
	-- 	end

	-- 	return adjacentOffsets == 2
	-- end

	return corners <= 1 and empty < (#DIAGONAL_OFFSETS)
end

function WFCConstraint:_areRoomsDifferent(grid, i, j)
	for index = 1, #ADJACENT_OFFSETS do
		local offset = ADJACENT_OFFSETS[index]
		local leftI, leftJ = i + offset.i, j + offset.j
		local rightI, rightJ = i - offset.i, j - offset.j

		local isLeftRoom = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].tileType == FloorLayout.TILE_TYPE_ROOM
		local isLeftWall = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].tileType == FloorLayout.TILE_TYPE_WALL
		local leftRoomID = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].roomID
		local leftRoomIndex = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].roomIndex
		local isRightRoom = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].tileType == FloorLayout.TILE_TYPE_ROOM
		local isRightWall = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].tileType == FloorLayout.TILE_TYPE_WALL
		local rightRoomID = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].roomID
		local rightRoomIndex = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].roomIndex

		if isLeftRoom and isRightRoom and leftRoomID == rightRoomID and leftRoomIndex == rightRoomIndex then
			return false
		elseif (isLeftRoom and isRightWall) or (isLeftWall and isRightRoom) then
			return false
		end
	end

	return true
end

function WFCConstraint:_getGrid(otherConstraint, otherConstraintAnchor)
	local offset = BuildingAnchor.OFFSET[otherConstraintAnchor]

	local grid
	if offset.i ~= 0 then
		grid = self:_makeGrid(8, 4)

		if offset.i < 0 then
			self:_paintGrid(grid, otherConstraint, 1, 1)
			self:_paintGrid(grid, self, 5, 1)
		elseif offset.i > 0 then
			self:_paintGrid(grid, self, 1, 1)
			self:_paintGrid(grid, otherConstraint, 5, 1)
		end
	else
		grid = self:_makeGrid(4, 8)

		if offset.j < 0 then
			self:_paintGrid(grid, otherConstraint, 1, 1)
			self:_paintGrid(grid, self, 1, 5)
		elseif offset.j > 0 then
			self:_paintGrid(grid, self, 1, 1)
			self:_paintGrid(grid, otherConstraint, 1, 5)
		end
	end

	return grid
end

function WFCConstraint:_verifyWalls(grid)
	for j = 1, #grid do
		for i = 1, #grid[j] do
			if grid[j][i].tileType == FloorLayout.TILE_TYPE_WALL then
				local isWallValid = self:_isWallValid(grid, i, j)
				local areRoomsDifferent = self:_areRoomsDifferent(grid, i, j)
				local isValid = isWallValid and areRoomsDifferent
				if not isValid then
					return false
				end
			end
		end
	end

	return true
end

function WFCConstraint:_verifyRooms(grid)
	for j = 1, #grid - 1 do
		for i = 1, #grid[j] - 1 do
			if grid[j][i].tileType == FloorLayout.TILE_TYPE_ROOM then
				if grid[j + 1][i].tileType == FloorLayout.TILE_TYPE_ROOM and
				   (grid[j + 1][i].roomID ~= grid[j][i].roomID or
				   grid[j + 1][i].roomIndex ~= grid[j][i].roomIndex)
				then
					return false
				end

				if grid[j][i + 1].tileType == FloorLayout.TILE_TYPE_ROOM and
				   (grid[j][i + 1].roomID ~= grid[j][i].roomID or
				   grid[j][i + 1].roomIndex ~= grid[j][i].roomIndex)
				then
					return false
				end

				if grid[j + 1][i].tileType == FloorLayout.TILE_TYPE_OUTSIDE then
					return false
				end

				if grid[j][i + 1].tileType == FloorLayout.TILE_TYPE_OUTSIDE then
					return false
				end
			elseif grid[j][i].tileType == FloorLayout.TILE_TYPE_OUTSIDE then
				if grid[j + 1][i].tileType == FloorLayout.TILE_TYPE_ROOM then
					return false
				end

				if grid[j][i + 1].tileType == FloorLayout.TILE_TYPE_ROOM then
					return false
				end
			end
		end
	end

	return true
end

function WFCConstraint:_verifyHallways(grid)
	for j = 1, #grid - 1 do
		for i = 1, #grid[j] - 1 do
			if grid[j][i].tileType == FloorLayout.TILE_TYPE_HALLWAY then
				if grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_HALLWAY and
				   grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_WALL and
				   grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_UNDECIDED
				then
					return false
				end

				if grid[j][i + 1].tileType ~= FloorLayout.TILE_TYPE_HALLWAY and
				   grid[j][i + 1].tileType ~= FloorLayout.TILE_TYPE_WALL and
				   grid[j][i + 1].tileType ~= FloorLayout.TILE_TYPE_UNDECIDED
				then
					return false
				end
			end
		end
	end

	return true
end

function WFCConstraint:isCompatible(otherConstraint, otherConstraintAnchor)
	if (self:getIsUndecided() or otherConstraint:getIsUndecided()) then
		return true
	end

	local grid = self:_getGrid(otherConstraint, otherConstraintAnchor)

	local rooms = self:_verifyRooms(grid)
	local walls = self:_verifyWalls(grid)
	local hallways = self:_verifyHallways(grid)
	
	return rooms and walls and hallways
end

return WFCConstraint
