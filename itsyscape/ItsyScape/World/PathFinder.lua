--------------------------------------------------------------------------------
-- ItsyScape/World/PathFinder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Path = require "ItsyScape.World.Path"

local PathFinder = Class()
function PathFinder:new(algorithm)
	assert(
		algorithm:isCompatibleType(PathFinder.Algorithm),
		"expected PathFinder.Algorithm")

	self.algorithm = algorithm
end

-- Returns a table of neighbor edges for edge.
--
-- goal is the destination tile.
function PathFinder:getNeighbors(edge, goal)
	return Class.ABSTRACT()
end

-- Returns a unique ID (in the sense of location) of the edge.
--
-- Two edges with the same location should have the same ID.
function PathFinder:getID(edge)
	return Class.ABSTRACT()
end

-- Gets the cost of this edge.
--
-- Cost is how much time it takes to move across the edge.
function PathFinder:getCost(edge)
	return Class.ABSTRACT()
end

-- Gets the score of this edge.
--
-- Score is how much time it takes to move from this edge to the goal.
function PathFinder:getScore(edge)
	return Class.ABSTRACT()
end

-- Gets a valid edge for location.
function PathFinder:getEdge(location)
	return Class.ABSTRACT()
end

-- Gets a valid location for an edge.
function PathFinder:getLocation(edge)
	return Class.ABSTRACT()
end

-- Calculates the distance between two locations.
function PathFinder:getDistance(a, b)
	return Class.ABSTRACT()
end

-- Returns true if edge a and b are the same location, false otherwise.
function PathFinder:sameLocation(a, b)
	return Class.ABSTRACT()
end

-- Materializes the edge into a PathNode.
function PathFinder:materialize(edge)
	return Class.ABSTRACT()
end

-- Gets the parent of the edge, or nil if there is no parent.
function PathFinder:getParent(edge)
	return Class.ABSTRACT()
end

-- Returns a path from start to stop, or nil if no such path exists.
function PathFinder:find(start, stop, ...)
	return self.algorithm:find(start, stop, ...)
end

PathFinder.Algorithm = Class()
function PathFinder.Algorithm:new(pathFinder)
	self.pathFinder = pathFinder
end

function PathFinder.Algorithm:getPathFinder()
	return self.pathFinder
end

-- Finds a path from start to stop.
--
-- If no path is found, returns nil. Otherwise, returns a Path object.
function PathFinder.Algorithm:find(start, stop)
	return Class.ABSTRACT()
end

PathFinder.Dijkstra = Class(PathFinder.Algorithm)
function PathFinder.Dijkstra:new(pathFinder)
	PathFinder.Algorithm.new(self, pathFinder)
end

function PathFinder.Dijkstra:materialize(edge)
	local path = Path()

	local parent = edge
	while parent ~= nil do
		local nextParent = self:getPrevious(parent)
		if nextParent ~= nil then
			path:prependNode(self:getPathFinder():materialize(parent))
		end

		parent = nextParent
	end

	return path
end

function PathFinder.Dijkstra:find(start, stop, nearest)
	start = self:getPathFinder():getEdge(start)
	stop = self:getPathFinder():getEdge(stop)

	self.set = { [self:getPathFinder():getID(start)] = start }
	self.distance = {}
	self.previous = {}

	if self:getPathFinder():sameLocation(start, stop) then
		local path = Path()
		path:prependNode(self:getPathFinder():materialize(start))
		return path
	end

	local pending = { self:getPathFinder():getNeighbors(start, stop) }
	repeat
		local p = pending[1]
		for i = 1, #p do
			if not self.set[self:getPathFinder():getID(p[i])] then
				table.insert(pending, self:getPathFinder():getNeighbors(p[i], stop))
				self.set[self:getPathFinder():getID(p[i])] = p[i]
			end
		end

		table.remove(pending, 1)
	until #pending == 0

	self:setDistance(start, 0)

	while next(self.set, nil) do
		local edge, distance = self:getLowestDistanceEdge()
		self.set[self:getPathFinder():getID(edge)] = nil

		local neighbors = self:getPathFinder():getNeighbors(edge, stop)
		for i = 1, #neighbors do
			local neighborDistance = distance + self:getPathFinder():getDistance(edge, neighbors[i])
			if neighborDistance < self:getDistance(neighbors[i]) then
				self:setDistance(neighbors[i], neighborDistance)
				self:setPrevious(neighbors[i], edge)
			end
		end
	end

	local goal = self:getPrevious(stop)
	if goal then
		return self:materialize(goal)
	end

	if nearest then
		local min = math.huge
		local minI = nearest
		local minEdge = nil
		for id, edge in pairs(self.distance) do
			local distanceI = self:getPathFinder():getDistance(stop, edge.edge)
			if distanceI < minI then
				if edge.distance < min then
					minI = distanceI
					min = edge.distance
					minEdge = edge.edge
				end
			end
		end

		if minEdge then
			return self:materialize(minEdge)
		end
	end

	return nil
end

function PathFinder.Dijkstra:getLowestDistanceEdge()
	local min = math.huge
	local minEdge = nil
	for id, edge in pairs(self.distance) do
		if edge.distance < min and self.set[id] then
			min = edge.distance
			minEdge = edge.edge
		end
	end

	return minEdge, min
end

function PathFinder.Dijkstra:getDistance(edge)
	local e = self.distance[self:getPathFinder():getID(edge)] 
	if not e then
		return math.huge
	end

	return e.distance
end

function PathFinder.Dijkstra:setDistance(edge, value)
	self.distance[self:getPathFinder():getID(edge)] = {
		edge = edge,
		distance = value
	}
end

function PathFinder.Dijkstra:getPrevious(edge)
	return self.previous[self:getPathFinder():getID(edge)] or nil
end

function PathFinder.Dijkstra:setPrevious(edge, value)
	self.previous[self:getPathFinder():getID(edge)] = value
end

PathFinder.AStar = Class(PathFinder.Algorithm)
function PathFinder.AStar:new(pathFinder)
	PathFinder.Algorithm.new(self, pathFinder)
end

function PathFinder.AStar:materialize(edge)
	local path = Path()

	local parent = edge
	while parent ~= nil do
		local nextParent = self:getPathFinder():getParent(parent)
		if nextParent ~= nil then
			path:prependNode(self:getPathFinder():materialize(parent))
		end

		parent = nextParent
	end

	return path
end

function PathFinder.AStar:find(start, stop, nearest)
	self.open = {}
	self.closed = {}

	if self:getPathFinder():sameLocation(start, stop) then
		local path = Path()
		path:prependNode(self:getPathFinder():materialize(start))
		return path
	end

	local startEdge = self:getPathFinder():getEdge(start)
	local nextEdge = nil
	if startEdge ~= nil then
		self.open[self.pathFinder:getID(startEdge)] = startEdge
		nextEdge = startEdge
	end

	while nextEdge ~= nil do
		local edge = self:processEdge(nextEdge, stop)
		if edge ~= nil then
			return self:materialize(edge)
		end

		nextEdge = self:getBestOpenEdge()
	end

	if nearest then
		local bestEdge = nil
		local bestDistanceI = math.huge
		local bestDistanceJ = math.huge
		for _, closed in pairs(self.closed) do
			local distanceI = self:getPathFinder():getDistance(stop, closed)
			local distanceJ = self:getPathFinder():getDistance(start, closed)

			local function choosePath()
				bestEdge = closed
				bestDistanceJ = distanceJ
				bestDistanceI = distanceI
			end
			if nearest == math.huge then
				if distanceI < bestDistanceI or
				   distanceI == bestDistanceI and distanceJ < bestDistanceJ
				then
					choosePath()
				end
			else
				if distanceI < nearest and distanceJ < bestDistanceJ then
					choosePath()
				end
			end
		end

		if bestEdge then
			return self:materialize(bestEdge)
		end
	end

	return nil
end

function PathFinder.AStar:getBestOpenEdge()
	local bestOpenEdge = nil
	local bestOpenEdgeScore = math.huge

	for _, edge in pairs(self.open) do
		if bestOpenEdge == nil then
			bestOpenEdge = edge
			bestOpenEdgeScore = self:getPathFinder():getScore(edge)
		else
			local cost = self:getPathFinder():getScore(edge)
			if cost < bestOpenEdgeScore then
				bestOpenEdge = edge
				bestOpenEdgeScore = cost
			end
		end
	end

	return bestOpenEdge
end

function PathFinder.AStar:processEdge(edge, goal)
	local edgeID = self:getPathFinder():getID(edge)
	self.open[edgeID] = nil
	self.closed[edgeID] = edge

	local neighbors = self:getPathFinder():getNeighbors(edge, goal)
	for _, neighbor in pairs(neighbors) do repeat
		local neighborID = self:getPathFinder():getID(neighbor)
		if self:getPathFinder():sameLocation(neighbor, goal) then
			return neighbor
		elseif self.closed[neighborID] ~= nil then
			break
		elseif self.open[neighborID] then
			local pendingEdge = self.open[neighborID]

			local nextScore = self:getPathFinder():getScore(neighbor)
			local currentScore = self:getPathFinder():getScore(pendingEdge)
			if nextScore < currentScore then
				self.open[neighborID] = neighbor
			end
		else
			self.open[neighborID] = neighbor
		end
	until true end

	return nil
end

return PathFinder
