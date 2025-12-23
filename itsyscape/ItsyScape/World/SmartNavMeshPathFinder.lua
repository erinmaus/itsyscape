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
local MathCommon = require "ItsyScape.Common.Math.Common"
local Ray = require "ItsyScape.Common.Math.Ray"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Peep = require "ItsyScape.Peep.Peep"
local DoorBehavior = require "ItsyScape.Peep.Behaviors.DynamicBehavior"
local DynamicBehavior = require "ItsyScape.Peep.Behaviors.DynamicBehavior"
local MovementCortex = require "ItsyScape.Peep.Cortexes.MovementCortex"
local StaticBehavior = require "ItsyScape.Peep.Behaviors.StaticBehavior"
local Path = require "ItsyScape.World.Path"
local PositionPathNode = require "ItsyScape.World.PositionPathNode"
local Tile = require "ItsyScape.World.Tile"

local SmartNavMeshPathFinder = Class()

SmartNavMeshPathFinder.DEFAULT_PEEP_MARGIN = 0.25

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

	self.ignored = {}
	self.pathfinder = slick.navigation.path.new({
		neighbor = function(_, _, e)
			local a = Vector(e.a.point.x, e.a.point.y)
			local b = Vector(e.b.point.x, e.b.point.y)
			local x, y = a:lerp(b, 0.5):get()

			if self.world and self.world:has(self.proxy) then
				local collisions = self.world:test(self.proxy, x, y, self._filter)
				for _, collision in ipairs(collisions) do
					if not self.ignored[collision.other] then
						return false
					end
				end
			end

			local userdata = meshBuilder:getEdgeUserdata(e.a.index, e.b.index)
			if not userdata then
				return true
			end

			for tile in userdata:iterate() do
				if tile:hasFlag("impassable") then
					return false
				elseif tile:hasFlag("door") then
					for link in tile:iterateLinks() do
						local door = link:getBehavior(DoorBehavior)
						if not (door and door.isOpen) then
							return false
						end
					end
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

	local dynamic = self.peep:getBehavior(DynamicBehavior)
	local radius = dynamic and dynamic.radius or MovementCortex.DEFAULT_PEEP_RADIUS
	local margin = dynamic and dynamic.margin or self.DEFAULT_PEEP_MARGIN

	if self.world then
		self.world:add(self.proxy, slick.newTransform(), slick.newCircleShape(0, 0, radius + margin))

		table.clear(self.ignored)
		local startCollisions = self.world:test(self.proxy, start.x, start.z, self._filter)
		for _, collision in ipairs(startCollisions) do
			self.ignored[collision.other] = true
		end

		local goalCollisions = self.world:test(self.proxy, goal.x, goal.z, self._filter)
		for _, collision in ipairs(goalCollisions) do
			self.ignored[collision.other] = true
		end
	end

	local _, path = self.pathfinder:nearest(self.mesh, start.x, start.z, goal.x, goal.z)

	local positions = {}

	local index = 1
	while path and index <= #path do
		local current = Vector(path[index].point.x, 0, path[index].point.y)
		if current ~= positions[#positions] then
			table.insert(positions, current)
		end

		local didJump = false
		if self.world and self.world:has(self.peep) then
			for nextIndex = #path, index + 1, -1 do
				local next = path[nextIndex].point
				local collisions = self.world:project(self.peep, current.x, current.z, next.x, next.y, self._filter)
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

	local resultPath = Path()
	local previous
	for i = 1, #positions do
		local k = (i - 1) * 2 + 1
		local current = positions[i]
		local next = positions[i + 1]

		local materialized = false
		if self.world and self.world:has(self.proxy) then
			local collisions = self.world:project(self.proxy, (previous or current).x, (previous or current).z, current.x, current.z, self._filter)
			local collision = collisions[#collisions]
			if collision then
				local a1 = previous or current
				local b1 = previous and current or next or current
				local forward1 = a1:direction(b1)

				local c = Vector(collision.otherShape.center.x, 0, collision.otherShape.center.y)
				local side1 = MathCommon.side(a1, b1, c)
				local left1 = Vector(forward1.z, 0, -forward1.x)
				local bump1 = Vector(collision.touch.x, 0, collision.touch.y) + left1 * -side1 * (radius + margin)

				local a2 = c
				local b2 = current
				local forward2 = a2:direction(b2)
				local side2 = MathCommon.side(a2, b2, c)
				local left2 = Vector(forward2.z, 0, -forward2.x)
				local bump2 = current + forward2 * (radius + margin)

				resultPath:makeNode(PositionPathNode, self.map, self.layer, bump1)
				resultPath:makeNode(PositionPathNode, self.map, self.layer, bump2)

				materialized = true
				previous = bump2
			end
		end

		if not materialized or i == #positions then
			resultPath:makeNode(PositionPathNode, self.map, self.layer, current)
			previous = current
		end
	end

	if self.world then
		self.world:remove(self.proxy)
	end

	return path and resultPath or nil
end

return SmartNavMeshPathFinder
