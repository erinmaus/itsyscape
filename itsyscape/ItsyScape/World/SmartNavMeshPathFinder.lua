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

			if not self.isPeepHuman and self.world and self.world:has(self.peep) then
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

	if self.world and self.world:has(self.peep) then
		local collisions = self.world:project(
			self.peep,
			start.x, start.z,
			goal.x, goal.z,
			self._filter)

		if #collisions == 0 then
			local elevationStart = self.map:getInterpolatedHeight(start.x, start.z)
			local elevationGoal = self.map:getInterpolatedHeight(goal.x, goal.z)

			local resultPath = Path()
			resultPath:makeNode(PositionPathNode, self.map, self.layer, Vector(start.x, elevationStart, start.z))
			resultPath:makeNode(PositionPathNode, self.map, self.layer, Vector(goal.x, elevationGoal, goal.z))
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
	for _, p in ipairs(path) do
		local position = Vector(p.point.x, 0, p.point.y)
		if position ~= positions[#positions] then
			table.insert(positions, position)
		end
	end

	local previous = positions[1]
	local result = { previous }
	for i = 2, #positions - 1 do
		print(">", "i", i)

		local current = positions[i]
		local next = positions[i + 1]

		local materialized = false

		if self.world and self.world:has(self.peep) then
			local collisions = self.world:project(self.peep, previous.x, previous.z, current.x, current.z, self._filter)

			local collision = collisions[1]
			if collision then
				print("-", "touch", collision.touch.x, collision.touch.y)
				print("-", "normal", collision.normal.x, collision.normal.y)
				print("-", "current", current.x, current.z)
				print("-", "previous", previous.x, previous.z)
				print("-", "next", next.x, next.z)

				local touch = Vector(collision.touch.x, 0, collision.touch.y)
				local normal = Vector(collision.normal.x, 0, collision.normal.y)
				local side = MathCommon.side(previous, current, touch, 0.01)
				print("side 'touch' is on from previous -> current", side)
				local directionSign = math.sign(previous:direction(current):dot(normal))
				print("-", "directionSign", directionSign)
				local strafe = Vector(collision.normal.y, 0, -collision.normal.x)
				local strafeSign = math.sign(previous:direction(current):dot(strafe))
				print("-", "strafeSign", strafeSign)

				--local side = MathCommon.side(previous, next, current)
				local base = current
				local bump = current + normal * (radius + margin)
				local bumpCollisions = self.world:project(self.peep, previous.x, previous.z, bump.x, bump.z, self._filter)

				local needsExtraBump = false
				if #bumpCollisions > 0 then
					print("!!! NEEDS EXTRA BUMP")
					bump = current + -normal * (radius + margin)
					-- needsExtraBump = true
					strafeSign = -strafeSign
				end

				print("-", "bump", bump.x, bump.z)
				table.insert(result, bump)
				previous = bump

				local strafeBump = base + strafe * strafeSign * (radius + margin)
				print("-", "strafe bump", strafeBump.x, strafeBump.z)
				local strafeCollisions = self.world:project(self.peep, bump.x, bump.z, strafeBump.x, strafeBump.z, self._filter)
				if #strafeCollisions == 0 then
					table.insert(result, strafeBump)
					previous = strafeBump

					local cornerBump = strafeBump + -normal * (radius + margin)
					local cornerCollisions = self.world:project(self.peep, strafeBump.x, strafeBump.z, cornerBump.x, cornerBump.z, self._filter)
					print("cornerBump", cornerBump.x, cornerBump.z)
					if #cornerCollisions == 0 then
						print("-", "corner bump", cornerBump.x, cornerBump.z)
						table.insert(result, cornerBump)
						previous = cornerBump
					else
						print(">>>", "corner bump skipped")
					end
				else
					print(">>> strafe bump skipped")
				end

				if needsExtraBump then

				end
				-- 	print("GOTA EXTRA BUMP")
				-- 	local extraBump = current + strafe * strafeSign * (radius + margin)
				-- 	print(">>> extraBump", extraBump.x, extraBump.z)
				-- 	local extraBumpCollisions = self.world:project(self.peep, previous.x, previous.z, extraBump.x, extraBump.z, self._filter)
				-- 	if #extraBumpCollisions == 0 then
				-- 		table.insert(result, extraBump)

				-- 		local extraBumpCorner = current + -normal * (radius + margin)
				-- 			print(">>> extraBumpCorner", extraBumpCorner.x, extraBumpCorner.z)
				-- 		local extraBumpCornerCollisions = self.world:project(self.peep, extraBump.x, extraBump.z, extraBumpCorner.x, extraBumpCorner.z, self._filter)
				-- 		if #extraBumpCornerCollisions == 0 then
				-- 			table.insert(result, extraBumpCorner)
				-- 		else
				-- 			print(">>> extraBump CORNER skipped", extraBump.x, extraBump.z)
				-- 		end
				-- 	else
				-- 		print(">>> extraBump skipped", extraBump.x, extraBump.z)
				-- 	end

				-- 	previous = current
				-- end


				materialized = true

				if self.yield then
					coroutine.yield()
				end
			end
		end

		if not materialized or i == #positions then
			table.insert(result, current)
			previous = current
		end

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
