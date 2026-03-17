--------------------------------------------------------------------------------
-- ItsyScape/World/NavigationMeshBuilder.lua
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
local Tile = require "ItsyScape.World.Tile"

local triangulator = slick.geometry.triangulation.delaunay.new()

local NavigationMeshBuilder = Class()

NavigationMeshBuilder.OFFSETS = {
	{ -1,  0, 2, 1, 2, 2 },
	{  1,  0, 1, 1, 1, 2 },
	{  0, -1, 1, 2, 2, 2 },
	{  0,  1, 1, 1, 2, 1 }
}

NavigationMeshBuilder.Userdata = Class()

function NavigationMeshBuilder.Userdata:new(...)
	self.tiles = {}

	for i = 1, select("#", ...) do
		local tile = select(i, ...)
		if tile then
			self.tiles[tile] = true
		end
	end
end

function NavigationMeshBuilder.Userdata:iterate()
	return pairs(self.tiles)
end

function NavigationMeshBuilder.Userdata.merge(...)
	local result = NavigationMeshBuilder.Userdata()

	for i = 1, select("#", ...) do
		local other = select(i, ...)
		if other then
			for tile in pairs(other.tiles) do
				result.tiles[tile] = true
			end
		end
	end

	return result
end

NavigationMeshBuilder.Polygons = Class()
function NavigationMeshBuilder.Polygons:new(tile, polygons)
	self.tile = tile
	self.polygons = polygons
end

function NavigationMeshBuilder.Polygons:getTile()
	return self.tile
end

function NavigationMeshBuilder.Polygons:iterate()
	return ipairs(self.polygons)
end

function NavigationMeshBuilder:new(map, polygons)
	self.map = map
	self.polygons = polygons

	self.vertices = {}
	self.vertexUserdata = {}
	self.vertexMap = {}
	self.edgeUserdata = {}

	self.points = {}
	self.edges = {}

	self.cleanOptions = {
		intersect = Function(self._intersect, self),
		dissolve = Function(self._dissolve, self),
		map = Function(self._map, self),
	}

	self.triangulateOptions = {
		interior = true,
		exterior = true,
		refine = true,
		polygonization = false
	}

	self:_build()
end

function NavigationMeshBuilder:_addEdgeUserdata(i, j, userdata)
	local e1 = self.edgeUserdata[i]
	if not e1 then
		e1 = {}
		self.edgeUserdata[i] = e1
	end
	e1[j] = NavigationMeshBuilder.Userdata.merge(userdata, e1[j])

	local e2 = self.edgeUserdata[j]
	if not e2 then
		e2 = {}
		self.edgeUserdata[j] = e2
	end
	e2[i] = NavigationMeshBuilder.Userdata.merge(userdata, e2[i])
end

function NavigationMeshBuilder:_removeEdgeUserdata(i, j)
	local e1 = self.edgeUserdata[i]
	if e1 then
		e1[j] = nil

		if not next(e1) then
			self.edgeUserdata[i] = nil
		end
	end

	local e2 = self.edgeUserdata[j]
	if e2 then
		e2[i] = nil

		if not next(e2) then
			self.edgeUserdata[j] = nil
		end
	end
end

function NavigationMeshBuilder:_isEdgePassable(i, j)
	local e = self.edgeUserdata[i]
	local userdata = e and e[j]

	if not userdata then
		return true, nil
	end

	for tile in userdata:iterate() do
		if not tile:getIsPassable() then
			return false, userdata
		end
	end

	return true, userdata
end

function NavigationMeshBuilder:getEdgeUserdata(i, j)
	local e = self.edgeUserdata[i]
	local userdata = e and e[j]

	return userdata
end

local function _isPassable(map, i, j, s, t)
	return not map:getTile(s, t):hasStaticFlag("impassable")
end

function NavigationMeshBuilder:_getVertexIndex(i, j, s, t)
	local height = self.map:getHeight() + 1
	local index = ((i - 1) + (s - 1)) * height + ((j - 1) + (t - 1)) + 1
	return index
end

function NavigationMeshBuilder:_getEdgeIndices(i, j, s, t)
	local index = self:_getVertexIndex(i, j, s, t)
	return (index - 1) * 2 + 1, (index - 1) * 2 + 2
end

function NavigationMeshBuilder:_getPointIndices(i, j, s, t)
	local index = self:_getVertexIndex(i, j, s, t)
	return (index - 1) * 2 + 1, (index - 1) * 2 + 2
end

function NavigationMeshBuilder:_addVertexUserdata(i, j, s, t, userdata)
	local index = self:_getVertexIndex(i, j, s, t)

	self.vertexUserdata[index] = NavigationMeshBuilder.Userdata.merge(self.vertexUserdata[index], userdata)
end

function NavigationMeshBuilder:_addVertex(i, j, s, t)
	local cellSize = self.map:getCellSize()

	local x = (i - 1) * cellSize + (s - 1) * cellSize
	local y = (j - 1) * cellSize + (t - 1) * cellSize

	local xIndex, yIndex = self:_getPointIndices(i, j, s, t)
	self.points[xIndex] = x
	self.points[yIndex] = y
end

function NavigationMeshBuilder:_resize()
	local numPoints = (self.map:getWidth() + 1) * (self.map:getHeight() + 1) * 2

	for i = 1, numPoints do
		self.points[i] = 0
	end
end

function NavigationMeshBuilder:_buildMap()
	local scale = self.map:getCellSize()

	local border = Tile()
	border:setFlag("border")
	border:setFlag("impassable")

	local borderUserdata = NavigationMeshBuilder.Userdata(border)

	for i = 1, self.map:getWidth() do
		for j = 1, self.map:getHeight() do
			local tile = self.map:getTile(i, j)
			local userdata = NavigationMeshBuilder.Userdata(tile)

			if tile:hasFlag("impassable") then
				self:_addVertexUserdata(i, j, 1, 1, userdata)
				self:_addVertex(i, j, 1, 1)
				self:_addVertexUserdata(i, j, 1, 2, userdata)
				self:_addVertex(i, j, 1, 2)
				self:_addVertexUserdata(i, j, 2, 1, userdata)
				self:_addVertex(i, j, 2, 1)
				self:_addVertexUserdata(i, j, 2, 2, userdata)
				self:_addVertex(i, j, 2, 2)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 1, 1),
					self:_getVertexIndex(i, j, 1, 2),
					userdata)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 1, 2),
					self:_getVertexIndex(i, j, 2, 2),
					userdata)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 2, 2),
					self:_getVertexIndex(i, j, 2, 1),
					userdata)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 2, 1),
					self:_getVertexIndex(i, j, 1, 1),
					userdata)
			end

			if i == 1 then
				self:_addVertex(i, j, 1, 1)
				self:_addVertex(i, j, 1, 2)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 1, 1),
					self:_getVertexIndex(i, j, 1, 2),
					borderUserdata)
			end

			if i == self.map:getWidth() then
				self:_addVertex(i, j, 2, 1)
				self:_addVertex(i, j, 2, 2)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 2, 1),
					self:_getVertexIndex(i, j, 2, 2),
					borderUserdata)
			end

			if j == 1 then
				self:_addVertex(i, j, 1, 1)
				self:_addVertex(i, j, 2, 1)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 1, 1),
					self:_getVertexIndex(i, j, 2, 1),
					borderUserdata)
			end

			if j == self.map:getHeight() then
				self:_addVertex(i, j, 1, 2)
				self:_addVertex(i, j, 2, 2)

				self:_addEdgeUserdata(
					self:_getVertexIndex(i, j, 1, 2),
					self:_getVertexIndex(i, j, 2, 2),
					borderUserdata)
			end

			if tile:getIsPassable() then
				for k = 1, #NavigationMeshBuilder.OFFSETS do
					local offsetI, offsetJ, s1, t1, s2, t2 = unpack(NavigationMeshBuilder.OFFSETS[k])

					if not self.map:canMove(i, j, offsetI, offsetJ, false, _isPassable) and self.map:getTile(i + offsetI, j + offsetJ):getIsPassable() then
						local tile = Tile()
						tile:setFlag("edge")
						tile:setFlag("impassable")

						local userdata = NavigationMeshBuilder.Userdata(tile)

						self:_addVertex(i + offsetI, j + offsetJ, s1, t1)
						self:_addVertex(i + offsetI, j + offsetJ, s2, t2)

						self:_addEdgeUserdata(
							self:_getVertexIndex(i + offsetI, j + offsetJ, s1, t1),
							self:_getVertexIndex(i + offsetI, j + offsetJ, s2, t2),
							userdata)
					end
				end
			end
		end
	end
end

function NavigationMeshBuilder:_buildMapEdges()
	for i, e in pairs(self.edgeUserdata) do
		for j in pairs(e) do
			if i > j then
				table.insert(self.edges, i)
				table.insert(self.edges, j)
			end
		end
	end
end

function NavigationMeshBuilder:_buildPolygons()
	for _, polygons in ipairs(self.polygons) do
		local tile = polygons:getTile()

		for _, polygon in polygons:iterate() do
			for i = 1, #polygon - 1 do
				local j = i + 1

				local x1, y1 = unpack(polygon[i])
				local x2, y2 = unpack(polygon[j])

				local e = math.floor(#self.points / 2) + 1

				table.insert(self.points, x1)
				table.insert(self.points, y1)

				table.insert(self.points, x2)
				table.insert(self.points, y2)

				table.insert(self.edges, e)
				table.insert(self.edges, e + 1)

				local userdata = NavigationMeshBuilder.Userdata(tile)
				table.insert(self.vertexUserdata, userdata)
				self:_addEdgeUserdata(e, e + 1, userdata)
			end
		end
	end
end

function NavigationMeshBuilder:_dissolve(dissolve)
	local i = dissolve.otherIndex
	local j = dissolve.index

	local dissolvedEdges = self.edgeUserdata[i]
	local currentEdges = self.edgeUserdata[j]

	if dissolvedEdges then
		for s, u1 in pairs(dissolvedEdges) do
			local u2 = currentEdges and currentEdges[s]
			self:_addEdgeUserdata(s, j, NavigationMeshBuilder.Userdata.merge(u1, u2))
		end
	end

	dissolve.userdata = NavigationMeshBuilder.Userdata.merge(dissolve.userdata, dissolve.otherUserdata)
end

function NavigationMeshBuilder:_intersect(intersection)
	local numPoints = math.floor(#self.points / 2)

	if intersection.resultIndex > numPoints then
		-- Edge/edge split. Created new point.
		local isLeftPassable, leftUserdata = self:_isEdgePassable(intersection.a1Index, intersection.b1Index)
		if not isLeftPassable then
			self:_addEdgeUserdata(intersection.a1Index, intersection.resultIndex, leftUserdata)
			self:_addEdgeUserdata(intersection.resultIndex, intersection.b1Index, leftUserdata)
		end

		local isRightPassable, rightUserdata = self:_isEdgePassable(intersection.a2Index, intersection.b2Index)
		if not isRightPassable then
			self:_addEdgeUserdata(intersection.a2Index, intersection.resultIndex, rightUserdata)
			self:_addEdgeUserdata(intersection.resultIndex, intersection.b2Index, rightUserdata)
		end
	else
		-- Edge/point split.
		local isPassable, userdata = self:_isEdgePassable(intersection.a1Index, intersection.b2Index)
		if not isPassable then
			self:_addEdgeUserdata(intersection.a1Index, intersection.b1Index, userdata)
			self:_addEdgeUserdata(intersection.a2Index, intersection.b2Index, userdata)
		end
	end

	intersection.resultUserdata = NavigationMeshBuilder.Userdata.merge(intersection.a1Userdata, intersection.b1Userdata, intersection.a2Userdata, intersection.b2Userdata)
end

function NavigationMeshBuilder:_map(map)
	self.vertexMap[map.oldIndex] = map.newIndex
end

function NavigationMeshBuilder:_triangulate()
	self.points, self.edges, self.vertexUserdata = triangulator:clean(self.points, self.edges, self.vertexUserdata, self.cleanOptions)
	self.triangles = triangulator:triangulate(self.points, self.edges, self.triangulateOptions)
end

function NavigationMeshBuilder:_remapEdgeUserdata()
	if not next(self.vertexMap) then
		return
	end

	local oldEdgeUserdata = self.edgeUserdata
	self.edgeUserdata = {}

	for i, e in pairs(oldEdgeUserdata) do
		for j, userdata in pairs(e) do
			local s = self.vertexMap[i]
			local t = self.vertexMap[j]

			if s and t then
				self:_addEdgeUserdata(s, t, userdata)
			end
		end
	end
end

function NavigationMeshBuilder:_buildNavigationMeshBuilder()
	self.navigationMesh = slick.navigation.mesh.new(self.points, self.vertexUserdata, self.edges, self.triangles)
end

function NavigationMeshBuilder:_build()
	self:_resize()
	self:_buildMap()
	self:_buildMapEdges()
	self:_buildPolygons()
	self:_triangulate()
	self:_remapEdgeUserdata()
	self:_buildNavigationMeshBuilder()
end

function NavigationMeshBuilder:getNavigationMesh()
	return self.navigationMesh
end

return NavigationMeshBuilder
