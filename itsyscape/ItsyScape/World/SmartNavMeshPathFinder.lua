--------------------------------------------------------------------------------
-- ItsyScape/World/SmartNavMeshPathFinder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local slick = require "slick"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local Path = require "ItsyScape.World.Path"
local PositionPathNode = require "ItsyScape.World.PositionPathNode"
local Tile = require "ItsyScape.World.Tile"

local SmartNavMeshPathFinder = Class()
SmartNavMeshPathFinder.ACTOR_RADIUS = 0.75

function SmartNavMeshPathFinder:new(peep, t)
	t = t or {}

	if t.yield then
		self.yield = true
	end

	self.layer = Utility.Peep.getLayer(peep)
	self.map = peep:getDirector():getMap(self.layer)
	self.peep = peep
	self.proxy = {}

	local movement = peep:getDirector():getCortex(MovementCortex)
	local mesh, meshBuilder = movement:getNavigationMesh(self.layer)
	self.mesh = mesh

	self.world = movement:getWorld(self.layer)
	self._filter = Function(MovementCortex.filter, movement)

	self.pathfinder = slick.navigation.path.new({
		neighbor = function(_, _, e)
			local a = Vector(e.a.point.x, e.a.point.y)
			local b = Vector(e.b.point.x, e.b.point.y)
			local x, y = a:lerp(b, 0.5):get()

			if self.world and self.world:has(self.proxy) then
				local collisions = self.world:test(self.proxy, x, y, self._filter)
				for _, collision in ipairs(collisions) do
					if Class.isCompatibleType(collision.other, Peep) then
						if isImpassablePeep then print("colliding with peep", collision.other:getName()) end
					end
				end

				if #collisions > 0 then
					return false
				end
			end

			local userdata = meshBuilder:getEdgeUserdata(e.a.index, e.b.index)
			if not userdata then
				return true
			end

			for tile in userdata:iterate() do
				if not tile:getIsPassable() then
					return false
				end
			end

			return true
		end,

		neighbors = function(mesh, triangle)
			if self.yield then
				coroutine.yield()
			end

			return mesh:getTriangleNeighbors(triangle.index)
		end
	})
end

function SmartNavMeshPathFinder:find(start, goal)
	if not self.mesh then
		return nil
	end

	if self.world then
		self.world:add(self.proxy, slick.newTransform(), slick.newCircleShape(0, 0, self.ACTOR_RADIUS))
	end

	local _, path = self.pathfinder:nearest(self.mesh, start.x, start.z, goal.x, goal.z)

	if self.world then
		self.world:remove(self.proxy)
	end

	if not path then
		return nil
	end

	local result = Path()

	local index = 1
	while index <= #path do
		local current = path[index].point
		result:makeNode(PositionPathNode, self.map, self.layer, Vector(current.x, 0, current.y))

		local didJump = false
		if self.world and self.world:has(self.peep) then
			for nextIndex = #path, index + 1, -1 do
				local next = path[nextIndex].point
				local collisions = self.world:project(self.peep, current.x, current.y, next.x, next.y, filter)
				if #collisions == 0 then
					index = nextIndex
					didJump = true
					break
				end
			end
		end

		if not didJump then
			index = index + 1
		end
	end

	return result
end

return SmartNavMeshPathFinder
