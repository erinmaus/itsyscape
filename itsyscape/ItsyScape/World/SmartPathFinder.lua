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
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
local PathFinder = require "ItsyScape.World.PathFinder"
local TilePathNode = require "ItsyScape.World.TilePathNode"
local PokePropPathNode = require "ItsyScape.World.PokePropPathNode"

local SmartPathFinder = Class(PathFinder)

function SmartPathFinder:new(map, peep, t)
	t = t or {}

	PathFinder.new(self, PathFinder.AStar(self))

	self.map = map
	self.peep = peep
	self.game = peep:getDirector():getGameInstance()

	if t.canUseObjects ~= false and peep:getBehavior(HumanoidBehavior) then
		self.canUseObjects = peep:getBehavior(HumanoidBehavior)
	end

	self.maxDistanceFromGoal = t.maxDistanceFromGoal or math.huge
end

function SmartPathFinder:getMap()
	return self.map
end

local D1 = 1
local D2 = math.sqrt(2)
function SmartPathFinder:makeEdge(i, j, parent, goal)
	-- This heuristic combines Manhattan distance and diagonal distance.
	-- We weight more heavily towards going straight unless the diagonal is much
	-- more optimal than doing straight. This prevents an annoying zig-zag when
	-- on cases where the diagonal and straight have the same weight.
	--
	-- Diagonal distance ise used from node to goal, Manhattan is used from node
	-- to parent.
	--
	-- In essence, we take diagonal distance and sum it with Manhattan distance.
	-- This gives more organic looking pathfinding. If you don't believe me,
	-- switch to just diagonal distance and see for yourself.
	--
	-- D2 being sqrt(2) works better than D2 being 2 as well. If D2 is 2,
	-- diagonals are too rare. Again, it looks worse.
	local di = math.abs(i - goal.i)
	local dj = math.abs(j - goal.j)
	local ds = math.abs(i - parent.i)
	local dt = math.abs(j - parent.j)
	local d = (D1 * (di + dj) + (D2 - 2 * D1) * math.min(di, dj)) + (ds + dt)
	--        [                      DD                         ]   [  MD   ]
	-- where DD = diagonal distance and MD = Manhattan distance

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

	if not self.canUseObjects then
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
					   a:canPerform(self.peep:getState(), flags, link) and
					   (not link:isCompatibleType(require "Resources.Game.Peeps.Props.BasicDoor") or
					   link:canOpen())
					then
						return true, a, link
					end
				end
			end

			local s, a, l
			do
				s, a, l = viable(Utility.Peep.getResource(link))
				if s then
					return s, a, l
				end
			end
			do
				local r = Utility.Peep.getMapObject(link)
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

	do
		local di = math.abs(i - goal.i)
		local dj = math.abs(j - goal.j)
		if di + dj > self.maxDistanceFromGoal then
			return {}
		end
	end

	local neighbors = {}
	local isLeftPassable, isRightPassable
	local isTopPassable, isBottomPassable
	if i > 1 then
		local left = self.map:getTile(i - 1, j)
		if (left.topRight <= tile.topLeft or
		    left.bottomRight <= tile.bottomLeft) and
		   not left:hasFlag('impassable') and
		   (not left:hasFlag('door') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i - 1, j, edge, goal))
			isLeftPassable = true
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(left)
				if success and left:hasFlag('door') then
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
		   (not right:hasFlag('door') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i + 1, j, edge, goal))
			isRightPassable = true
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(right)
				if success and right:hasFlag('door') then
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
		   (not top:hasFlag('door') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i, j - 1, edge, goal))
			isTopPassable = true
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(top)
				if success and top:hasFlag('door') then
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
		   (not bottom:hasFlag('door') or (edge.action and edge.action:is("open")))
		then
			table.insert(neighbors, self:makeEdge(i, j + 1, edge, goal))
			isBottomPassable = true
		elseif not edge.action then
			do
				local success, action, door = self:getDoor(bottom)
				if success and bottom:hasFlag('door') then
					table.insert(neighbors, self:makeActionEdge(i, j + 1, edge, goal, door, action))
				end
			end
		end
	end

	if isTopPassable and isLeftPassable and isRightPassable and isTopPassable then
		if i > 1 and j > 1 then
			local topLeft = self.map:getTile(i - 1, j - 1)
			if topLeft.bottomRight <= tile.topLeft and
			   not topLeft:hasFlag('impassable') and
			   not topLeft:hasFlag('door')
			then
				table.insert(neighbors, self:makeEdge(i - 1, j - 1, edge, goal))
			end
		end

		if i > 1 and j < self.map:getHeight() and isRightPassable and isBottomPassable and isRightPassable then
			local bottomLeft = self.map:getTile(i - 1, j + 1)
			if bottomLeft.topRight <= tile.bottomLeft and
			   not bottomLeft:hasFlag('impassable') and
			   not bottomLeft:hasFlag('door')
			then
				table.insert(neighbors, self:makeEdge(i - 1, j + 1, edge, goal))
			end
		end

		if i < self.map:getWidth() and j > 1 then
			local topRight = self.map:getTile(i + 1, j - 1)
			if topRight.bottomLeft <= tile.topRight and
			   not topRight:hasFlag('impassable') and
			   not topRight:hasFlag('door')
			then
				table.insert(neighbors, self:makeEdge(i + 1, j - 1, edge, goal))
			end
		end

		if i < self.map:getWidth() and j < self.map:getHeight() and isRightPassable and isBottomPassable and isRightPassable then
			local bottomRight = self.map:getTile(i + 1, j + 1)
			if bottomRight.topLeft <= tile.bottomRight and
			   not bottomRight:hasFlag('impassable') and
			   not bottomRight:hasFlag('door')
			then
				table.insert(neighbors, self:makeEdge(i + 1, j + 1, edge, goal))
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
