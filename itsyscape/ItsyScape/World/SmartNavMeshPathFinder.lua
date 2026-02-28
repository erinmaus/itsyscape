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
local HumanoidBehavior = require "ItsyScape.Peep.Behaviors.HumanoidBehavior"
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

	self.maxSearchDistance = t.maxSearchDistance
	self.maxGoalDistance = t.maxGoalDistance

	self.layer = Utility.Peep.getLayer(peep)
	self.map = peep:getDirector():getMap(self.layer)
	self.peep = peep
	self.isPeepHuman = peep:hasBehavior(HumanoidBehavior)

	self.maxVisits = t.maxVisits or math.huge
	self.currentVisits = 0

	local position = Utility.Peep.getPosition(self.peep)
	self.xzPeepPosition = Vector(position.x, 0, position.z)

	self.proxy = {}

	local movement = peep:getDirector():getCortex(MovementCortex)
	local mesh, meshBuilder = movement:getNavigationMesh(self.layer)
	self.mesh = mesh

	self.world = movement:getWorld(self.layer)
	self._filter = Function(MovementCortex.filter, movement)

	self.visitedEdges = t.debug and {}
	self.visitedTriangles = t.debug and {}
	self.print = t.debug and print or function(...) end

	self.ignored = {}
	self.pathfinder = slick.navigation.path.new({
		visit = function(current, _, edge)
			if self.visitedEdges and self.visitedTriangles then
				self.visitedEdges[edge] = true
				self.visitedTriangles[current] = true
			end

			self.currentVisits = self.currentVisits + 1
			if self.currentVisits > self.maxVisits then
				return false
			end

			return true
		end,

		yield = function()
			if self.yield then
				coroutine.yield()
			end

			return true
		end,

		neighbor = function(from, to, e)
			local a = Vector(e.a.point.x, 0, e.a.point.y)
			local b = Vector(e.b.point.x, 0, e.b.point.y)
			local c = a:lerp(b, 0.5)

			if self.maxSearchDistance and c:distance(self.xzPeepPosition) > self.maxSearchDistance then
				return false
			end

			if self.world and self.world:has(self.peep) then
				local collisions = self.world:test(self.peep, c.x, c.z, self._filter)
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

function SmartNavMeshPathFinder:getDebugStats()
	return {
		edges = self.visitedEdges,
		triangles = self.visitedTriangles,
		visits = self.currentVisits
	}
end

function SmartNavMeshPathFinder:find(start, goal)
	if not self.mesh then
		return nil
	end

	if self.yield then
		coroutine.yield()
	end

	local dynamic = self.peep:getBehavior(DynamicBehavior)
	local radius = dynamic and dynamic.radius or MovementCortex.DEFAULT_PEEP_RADIUS
	local margin = dynamic and dynamic.margin or self.DEFAULT_PEEP_MARGIN
	local padding = (radius + margin)

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

	if self.world and self.world:has(self.peep) then
		local collisions = self.world:project(
			self.peep,
			start.x, start.z,
			goal.x, goal.z,
			self._filter)

		if #collisions == 0 then
			local resultPath = Path()
			resultPath:makeNode(PositionPathNode, self.map, self.layer, Vector(start.x, 0, start.z))
			resultPath:makeNode(PositionPathNode, self.map, self.layer, Vector(goal.x, 0, goal.z))
			return resultPath
		end
	end

	local _, path = self.pathfinder:nearest(self.mesh, start.x, start.z, goal.x, goal.z)
	if self.maxGoalDistance and path then
		local distance = Vector(path[#path].point.x, 0, path[#path].point.y):distance(Vector(goal.x, 0, goal.z))
		distance = distance - (radius + margin)
		if distance > self.maxGoalDistance then
			return nil
		end
	end

	local positions = {}
	for i, p in ipairs(path) do
		local currentPosition = Vector(p.point.x, 0, p.point.y)
		local previousPosition = positions[#positions]
		if currentPosition ~= previousPosition then
			table.insert(positions, currentPosition)
		end
	end

	local previous, source = positions[1], positions[1]
	local result = { previous }
	for i = 2, #positions do
		local current = positions[i]
		local next = positions[i + 1] or current
		local side = MathCommon.side(source, next, current)
		self.print("index", i)
		self.print("-", "source", source.x, source.z)
		self.print("-", "previous", previous.x, previous.z)
		self.print("-", "current", current.x, current.z)
		self.print("-", "next", next.x, next.z)
		self.print("-", "distance", previous:distance(current))

		if self.world and self.world:has(self.peep) then
			local previousDirection = previous:direction(current)
			self.print("-", "previousDirection", previousDirection.x, previousDirection.z)

			for i = 1, 16 do
				self.print("iteration", i)
				local direction = previous:direction(current)
				local collisions = self.world:project(self.peep, previous.x, previous.z, current.x, current.z, self._filter)
				local collision = collisions[1]

				if not collision then
					self.print("!", "no collision")
					table.insert(result, current)
					break
				end

				self.print("-", "normal", collision.normal.x, collision.normal.y)
				self.print("-", "touch", collision.touch.x, collision.touch.y)

				local touch = Vector(collision.touch.x, 0, collision.touch.y)
				local normal = -Vector(collision.normal.x, 0, collision.normal.y)

				local bumps
				if side >= 0 then
					side = 1
					self.print("clockwise")
					bumps = {
						normal,
						MathCommon.rightXZ(normal),
						-normal,
						MathCommon.rightXZ(-normal)
					}
				else
					self.print("counter-clockwise")
					bumps = {
						MathCommon.rightXZ(-normal),
						-normal,
						MathCommon.rightXZ(normal),
						normal
					}
				end

				local startIndex
				local bestDistance = math.huge
				for j, bumpNormal in ipairs(bumps) do
					local bump = touch + side * bumpNormal * padding
					bumps[j] = bump

					local distance = bump:distance(previous)
					if distance < bestDistance then
						startIndex = j
						bestDistance = distance
					end
				end

				local materialized = false
				local nextDirection
				for j = 1, #bumps do
					local index = math.wrap(j + startIndex, 1, #bumps)
					local bump = bumps[index]
					local isFarEnough = i == 1 or bump:distance(previous) > radius
					local direction1 = previous:direction(bump)
					local dot = previousDirection:dot(direction1)
					local isAhead = dot >= 0
					local canCheckCollision = isFarEnough and isAhead
					self.print("-", "previousDirection", previousDirection.x, previousDirection.z)
					self.print("-", "direction1", direction1.x, direction1.z)
					self.print("-", "dot", dot)
					self.print("-", "trying bump...", bump.x, bump.z)
					self.print("-", "isAhead", isAhead, "isFarEnough", isFarEnough, "canCheckCollision", canCheckCollision)

					local numProjectionCollisions = canCheckCollision and #self.world:project(self.peep, previous.x, previous.z, bump.x, bump.z, self._filter)
					self.print("-", "numProjectionCollisions", numProjectionCollisions)

					if numProjectionCollisions and numProjectionCollisions == 0 then
						self.print("!!!", bump.x, bump.z)
						table.insert(result, bump)
						materialized = true
						nextDirection = previous:direction(bump)
						previous = bump

						local numTargetCollisions = #self.world:project(self.peep, bump.x, bump.z, current.x, current.z, self._filter)
						if numTargetCollisions == 0 then
							break
						end
					elseif materialized then
						break
					end
				end

				if not materialized then
					self.print("!", "couldn't materialize")
					if i == 1 then
						table.insert(result, current)
						previous = current
					end

					break
				end

				previousDirection = nextDirection or previousDirection
			end
		else
			table.insert(result, current)
			previous = current
		end

		source = current

		if self.yield then
			coroutine.yield()
		end
	end
	table.insert(result, positions[#positions])

	local resultPath = Path()
	for _, current in ipairs(result) do
		resultPath:makeNode(PositionPathNode, self.map, self.layer, current)
	end

	if self.world then
		self.world:remove(self.proxy)
	end

	return path and resultPath or nil
end

return SmartNavMeshPathFinder
