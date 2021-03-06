--------------------------------------------------------------------------------
-- ItsyScape/World/MapPathFinder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local PathFinder = require "ItsyScape.World.PathFinder"
local TilePathNode = require "ItsyScape.World.TilePathNode"

local MapPathFinder = Class(PathFinder)

function MapPathFinder:new(map)
	PathFinder.new(self, PathFinder.AStar(self))
	self.map = map
end

function MapPathFinder:getMap()
	return self.map
end

function MapPathFinder:makeEdge(i, j, parent, goal)
	local di = i - goal.i
	local dj = j - goal.j
	local d = math.abs(di) + math.abs(dj)

	local edge = {
		i = i,
		j = j,
		parent = parent
	}

	edge.cost = 1 + parent.cost
	edge.score = edge.cost + d

	return edge
end

function MapPathFinder:getNeighbors(edge, goal)
	local i = edge.i
	local j = edge.j
	local tile = self.map:getTile(i, j)

	local neighbors = {}
	local isLeftPassable, isRightPassable
	local isTopPassable, isBottomPassable
	if i > 1 then
		local left = self.map:getTile(i - 1, j)
		if (left.topRight <= tile.topLeft or
		    left.bottomRight <= tile.bottomLeft) and
		   not left:hasFlag('impassable') and
		   not left:hasFlag('wall-right')
		then
			table.insert(neighbors, self:makeEdge(i - 1, j, edge, goal))
			isLeftPassable = true
		end
	end

	if i < self.map:getWidth() then
		local right = self.map:getTile(i + 1, j)
		if (right.topLeft <= tile.topRight or
		    right.bottomLeft <= tile.bottomRight) and
		   not right:hasFlag('impassable') and
		   not right:hasFlag('wall-left')
		then
			table.insert(neighbors, self:makeEdge(i + 1, j, edge, goal))
			isRightPassable = true
		end
	end

	if j > 1 then
		local top = self.map:getTile(i, j - 1)
		if (top.bottomLeft <= tile.topLeft or
		    top.bottomRight <= tile.topLeft) and
		   not top:hasFlag('impassable') and
		   not top:hasFlag('wall-bottom')
		then
			table.insert(neighbors, self:makeEdge(i, j - 1, edge, goal))
			isTopPassable = true
		end
	end

	if j < self.map:getHeight() then
		local bottom = self.map:getTile(i, j + 1)
		if (bottom.topLeft <= tile.bottomLeft or
		    bottom.topRight <= tile.bottomRight) and
		   not bottom:hasFlag('impassable') and
		   not bottom:hasFlag('wall-top')
		then
			table.insert(neighbors, self:makeEdge(i, j + 1, edge, goal))
			isBottomPassable = true
		end
	end

	if i > 1 and j > 1 and isTopPassable and isLeftPassable then
		local topLeft = self.map:getTile(i - 1, j - 1)
		if topLeft.bottomRight <= tile.topLeft and
		   not topLeft:hasFlag('impassable')
		then
			table.insert(neighbors, self:makeEdge(i - 1, j - 1, edge, goal))
		end
	end

	if i > 1 and j < self.map:getHeight() and isBottomPassable and isLeftPassable then
		local bottomLeft = self.map:getTile(i - 1, j + 1)
		if bottomLeft.topRight <= tile.bottomLeft and
		   not bottomLeft:hasFlag('impassable')
		then
			table.insert(neighbors, self:makeEdge(i - 1, j + 1, edge, goal))
		end
	end

	if i < self.map:getWidth() and j > 1 and isTopPassable and isRightPassable then
		local topRight = self.map:getTile(i + 1, j - 1)
		if topRight.bottomLeft <= tile.topRight and
		   not topRight:hasFlag('impassable')
		then
			table.insert(neighbors, self:makeEdge(i + 1, j - 1, edge, goal))
		end
	end

	if i < self.map:getWidth() and j < self.map:getHeight() and isBottomPassable and isRightPassable then
		local bottomRight = self.map:getTile(i + 1, j + 1)
		if bottomRight.topLeft <= tile.bottomRight and
		   not bottomRight:hasFlag('impassable')
		then
			table.insert(neighbors, self:makeEdge(i + 1, j + 1, edge, goal))
		end
	end

	return neighbors
end

function MapPathFinder:getID(edge)
	return edge.j * self.map:getWidth() + edge.i
end

function MapPathFinder:getCost(edge)
	return edge.cost or 1
end

function MapPathFinder:getScore(edge)
	return edge.score or 0
end

function MapPathFinder:getEdge(location)
	return {
		i = location.i,
		j = location.j,
		cost = 1,
		score = 0
	}
end

function MapPathFinder:getLocation(edge)
	return edge
end

function MapPathFinder:getDistance(a, b)
	local di = math.abs(a.i - b.i)
	local dj = math.abs(a.j - b.j)
	return di + dj
end

function MapPathFinder:sameLocation(a, b)
	return a.i == b.i and a.j == b.j
end

function MapPathFinder:materialize(edge)
	return TilePathNode(edge.i, edge.j)
end

function MapPathFinder:getParent(edge)
	return edge.parent
end

return MapPathFinder
