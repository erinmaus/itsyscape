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

function WFCConstraint:new(cellDefinition, roomID)
	self.cellDefinition = cellDefinition or false
	self.roomID = roomID or false
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

function WFCConstraint:setIsUndecided(value)
	self.isUndecided = value or false
end

function WFCConstraint:getIsUndecided()
	return self.isUndecided
end

function WFCConstraint:_makeGrid(width, height)
	local grid = {}
	for j = 1, height do
		grid[j] = {}
		for i = 1, width do
			grid[j][i] = { checked = false, tileType = 0, roomID = "" }
		end
	end

	return grid
end

function WFCConstraint:_paintGrid(grid, constraint, i, j)
	for currentJ = 1, 4 do
		for currentI = 1, 4 do
			grid[currentJ + j - 1][currentI + i - 1].tileType = constraint.cellDefinition[currentJ][currentI]
			grid[currentJ + j - 1][currentI + i - 1].roomID = constraint.roomID
		end
	end
end

function WFCConstraint:_isWallValid(grid, i, j)
	local corners = 0

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
		end
	end

	return corners <= 1
end

function WFCConstraint:_areRoomsDifferent(grid, i, j)
	for index = 1, #ADJACENT_OFFSETS do
		local offset = ADJACENT_OFFSETS[index]
		local leftI, leftJ = i + offset.i, j + offset.j
		local rightI, rightJ = i - offset.i, j - offset.j

		local isLeftRoom = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].tileType == FloorLayout.TILE_TYPE_ROOM
		local isLeftWall = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].tileType == FloorLayout.TILE_TYPE_WALL
		local leftRoomID = grid[leftJ] ~= nil and grid[leftJ][leftI] ~= nil and grid[leftJ][leftI].roomID
		local isRightRoom = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].tileType == FloorLayout.TILE_TYPE_ROOM
		local isRightWall = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].tileType == FloorLayout.TILE_TYPE_WALL
		local rightRoomID = grid[rightJ] ~= nil and grid[rightJ][rightI] ~= nil and grid[rightJ][rightI].roomID

		if isLeftRoom and isRightRoom and leftRoomID == rightRoomID then
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
				local isValid = self:_isWallValid(grid, i, j) and self:_areRoomsDifferent(grid, i, j)
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
				   grid[j + 1][i].roomID ~= grid[j][i].roomID
				then
					return false
				end

				if grid[j][i + 1].tileType == FloorLayout.TILE_TYPE_ROOM and
				   grid[j][i + 1].roomID ~= grid[j][i].roomID
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
				if grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_HALLWAY or
				   grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_WALL or
				   grid[j + 1][i].tileType ~= FloorLayout.TILE_TYPE_UNDECIDED
				then
					return false
				end

				if grid[j][i + 1].tileType ~= FloorLayout.TILE_TYPE_HALLWAY or
				   grid[j][i + 1].tileType ~= FloorLayout.TILE_TYPE_WALL or
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
	return self:_verifyRooms(grid) and self:_verifyWalls(grid) and self:_verifyHallways(grid)
end

return WFCConstraint
