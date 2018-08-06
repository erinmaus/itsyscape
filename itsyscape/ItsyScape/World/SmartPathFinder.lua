--------------------------------------------------------------------------------
-- ItsyScape/World/SmartPathFinder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Prop = require "ItsyScape.Peep.Peeps.Prop"
local PathFinder = require "ItsyScape.World.PathFinder"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local PokePropPathNode = require "ItsyScape.World.PokePropPathNode"

local SmartPathFinder = Class(PathFinder)

function SmartPathFinder:new(map, peep)
	PathFinder.new(self, PathFinder.AStar(self))
	self.map = map
	self.peep = peep
	self.game = peep:getDirector():getGameInstance()
end

function SmartPathFinder:getSmart()
	return self.map
end

function SmartPathFinder:makeEdge(i, j, parent, goal)
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

function SmartPathFinder:makeActionEdge(i, j, parent, goal, prop, action)
	local edge = self:makeEdge(i, j, parent, goal)
	edge.prop = prop
	edge.action = action

	return edge
end

function SmartPathFinder:getDoor(tile)
	if not self.game then
		return false
	end

	for link in tile:iterateLinks() do
		if Class.isCompatibleType(link, Prop) then
			local function viable(resource)
				local flags = { ['item-inventory'] = true }
				local actions = Utility.getActions(self.game, resource, 'world')
				for i = 1, #actions do
					local a = actions[i].instance
					if a:is("Open") and
					   a:canPerform(self.peep:getState(), flags, link)
					then
						return true, a, link
					end
				end
			end

			local s, a, l
			do
				s, a, l = viable(link:getGameDBResource())
				if s then
					return s, a, l
				end
			end
			do
				local r = link:getMapObject()
				if r then
					s, a, l = viable(r)
					if s then
						return s, a, l
					end
				end
			end
		end
	end

	return false
end

function SmartPathFinder:getNeighbors(edge, goal)
	local i = edge.i
	local j = edge.j
	local tile = self.map:getTile(i, j)

	local neighbors = {}
	if i > 1 then
		local left = self.map:getTile(i - 1, j)
		if (left.topRight <= tile.topLeft or
		    left.bottomRight <= tile.bottomLeft) and
		   not left:hasFlag('impassable') and
		   (not left:hasFlag('wall-right') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i - 1, j, edge, goal))
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(left)
				if success and left:hasFlag('wall-right') then
					table.insert(neighbors, self:makeActionEdge(i - 1, j, edge, goal, door, action))
				end
			end
		end
	end

	if i < self.map:getWidth() then
		local right = self.map:getTile(i + 1, j)
		if (right.topLeft <= tile.topRight or
		    right.bottomLeft <= tile.bottomRight) and
		   not right:hasFlag('impassable') and
		   (not right:hasFlag('wall-left') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i + 1, j, edge, goal))
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(right)
				if success and right:hasFlag('wall-left') then
					table.insert(neighbors, self:makeActionEdge(i + 1, j, edge, goal, door, action))
				end
			end
		end
	end

	if j > 1 then
		local top = self.map:getTile(i, j - 1)
		if (top.bottomLeft <= tile.topLeft or
		    top.bottomRight <= tile.topLeft) and
		   not top:hasFlag('impassable') and
		   (not top:hasFlag('wall-bottom') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i, j - 1, edge, goal))
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(top)
				if success and top:hasFlag('wall-bottom') then
					table.insert(neighbors, self:makeActionEdge(i, j - 1, edge, goal, door, action))
				end
			end
		end
	end

	if j < self.map:getHeight() then
		local bottom = self.map:getTile(i, j + 1)
		if (bottom.topLeft <= tile.bottomLeft or
		    bottom.topRight <= tile.bottomRight) and
		   not bottom:hasFlag('impassable') and
		   (not bottom:hasFlag('wall-top') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i, j + 1, edge, goal))
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(bottom)
				if success and bottom:hasFlag('wall-top') then
					table.insert(neighbors, self:makeActionEdge(i, j + 1, edge, goal, door, action))
				end
			end
		end
	end

	return neighbors
end

function SmartPathFinder:getID(edge)
	return edge.j * self.map:getWidth() + edge.i
end

function SmartPathFinder:getCost(edge)
	return edge.cost or 1
end

function SmartPathFinder:getScore(edge)
	return edge.score or 0
end

function SmartPathFinder:getEdge(location)
	return {
		i = location.i,
		j = location.j,
		cost = 1,
		score = 0
	}
end

function SmartPathFinder:getLocation(edge)
	return edge
end

function SmartPathFinder:getDistance(a, b)
	local di = math.abs(a.i - b.i)
	local dj = math.abs(a.j - b.j)
	return di + dj
end

function SmartPathFinder:sameLocation(a, b)
	return a.i == b.i and a.j == b.j
end

function SmartPathFinder:materialize(edge)
	if edge.action then
		return PokePropPathNode(edge.action, edge.prop, edge.i, edge.j)
	else
		return TilePathNode(edge.i, edge.j)
	end
end

function SmartPathFinder:getParent(edge)
	return edge.parent
end

return SmartPathFinder
