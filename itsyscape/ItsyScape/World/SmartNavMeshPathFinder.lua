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
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local Path = require "ItsyScape.World.Path"
local PositionPathNode = require "ItsyScape.World.PositionPathNode"
local Tile = require "ItsyScape.World.Tile"

local SmartNavMeshPathFinder = Class()
function SmartNavMeshPathFinder:new(peep, t)
	t = t or {}

	if t.yield then
		self.yield = true
	end

	self.layer = Utility.Peep.getLayer(peep)
	self.map = peep:getDirector():getMap(self.layer)
	self.peep = peep

	local movement = peep:getDirector():getCortex(MovementCortex)
	local mesh, meshBuilder = movement:getNavigationMesh(self.layer)
	self.mesh = mesh

	self.pathfinder = slick.navigation.path.new({
		neighbor = function(_, _, e)
			local a = Vector(e.a.point.x, e.a.point.y)
			local b = Vector(e.b.point.x, e.b.point.y)
			local x, y = a:lerp(b, 0.5):get()

			local world = movement:getWorld(self.layer)
			if world and world:has(self.peep) then
				local collisions = world:test(self.peep, x, y)
				for _, collision in ipairs(collisions) do
					local isImpassableTile = Class.isCompatibleType(collision.other, Tile)
					                         and not collision.other:getIsPassable()
					local isImpassablePeep = Class.isCompatibleType(collision.other, Peep) and
					                         collision.other:hasBehavior(StaticBehavior) and
					                         collision.other:getBehavior(StaticBehavior).type == StaticBehavior.IMPASSABLE

					if Class.isCompatibleType(collision.other, Peep) then
						if isImpassablePeep then print("colliding with peep", collision.other:getName()) end
					end

					if isImpassablePeep or isImpassableTile then
						return false
					end
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

	local _, path = self.pathfinder:nearest(self.mesh, start.x, start.z, goal.x, goal.z)

	local result = Path()
	for _, vertex in ipairs(path) do
		result:makeNode(PositionPathNode, self.map, self.layer, Vector(vertex.point.x, 0, vertex.point.y))
	end

	return result
end

return SmartNavMeshPathFinder
