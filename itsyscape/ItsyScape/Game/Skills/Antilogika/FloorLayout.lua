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

local FloorLayout = Class()

FloorLayout.Tile = Class()

function FloorLayout.Tile:new()
	self.isBuilding = false
	self.room = false
end

function FloorLayout.Tile:setRoomGraph(room)
	self.room = room or false
end

function FloorLayout.Tile:getRoomGraph()
	return self.room
end

function FloorLayout.Tile:setIsOutside(isOutside)
	self.isBuilding = not isOutside
end

function FloorLayout.Tile:getIsOutside()
	return not self.isBuilding
end

function FloorLayout.Tile:setIsInside(isInside)
	self.isBuilding = isInside
end

function FloorLayout.Tile:getIsInside()
	return self.isBuilding
end

function FloorLayout:new(width, depth)
	self.width = width
	self.depth = depth

	self.tiles = {}
	for i = 1, width do
		for j = 1, depth do
			local index = self:getTileIndex(i, j)
			self.tiles[index] = FloorLayout.Tile()
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
	return self.tiles[self:getTileIndex(i, j)]
end

function FloorLayout:fill(i, j, width, depth, isInside)
	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			local index = self:getTileIndex(currentI, currentJ)
			local tile = self.tiles[index]
			if tile then
				tile:setIsInside(isInside or false)
			end
		end
	end
end

function FloorLayout:assign(i, j, width, depth, room)
	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			local index = self:getTileIndex(currentI, currentJ)
			local tile = self.tiles[index]
			if tile then
				tile:setRoomGraph(room)
			end
		end
	end
end

function FloorLayout:isInside(i, j, width, depth)
	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			local index = self:getTileIndex(currentI, currentJ)
			local tile = self.tiles[index]

			if not tile or not tile:getIsInside() then
				return false
			end
		end
	end

	return true
end

function FloorLayout:isUnassigned(i, j, width, depth)
	for currentI = i, i + width - 1 do
		for currentJ = j, j + depth - 1 do
			local index = self:getTileIndex(currentI, currentJ)
			local tile = self.tiles[index]

			if not tile or tile:getRoomGraph() then
				return false
			end
		end
	end

	return true
end

function FloorLayout:getAvailableRectangles()
	local rectangles = {}
	local currentRectangle
	local lastTile
	for j = 1, self:getDepth() do
		for i = 1, self:getWidth() do
			local index = self:getTileIndex(i, j)
			local tile = self.tiles[index]

			if tile:getIsInside() and not tile:getRoomGraph() then
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
						depth = 1
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
			   a.depth > 0 and b.depth > 0
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
