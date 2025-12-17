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

local NavigationMeshBuilder = Class()

NavigationMeshBuilder.OFFSETS = {
	{ -1,  0 },
	{  1,  0 },
	{  0, -1 },
	{  0,  1 }
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

function NavigationMeshBuilder:new(map, polygons)
	self.map = map
	self.polygons = polygons

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
	e1[j] = userdata

	local e2 = self.edgeUserdata[j]
	if not e2 then
		e2 = {}
		self.edgeUserdata[j] = e2
	end
	e2[i] = userdata
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

function NavigationMeshBuilder:_buildMap()
	local scale = self.map:getCellSize()

	for j = 1, self.map:getHeight() do
		for i = 1, self.map:getWidth() do
			local tile = self.map:getTile(i, j)
			local userdata = NavigationMeshBuilder.Userdata(tile)

			local left = (i - 1) * scale
			local right = i * scale
			local top = (j - 1) * scale
			local bottom = j * scale

			local e = math.floor(#self.points / 2) + 1

			table.insert(self.points, left)
			table.insert(self.points, top)

			table.insert(self.points, right)
			table.insert(self.points, top)

			table.insert(self.points, right)
			table.insert(self.points, bottom)

			table.insert(self.points, left)
			table.insert(self.points, bottom)

			table.insert(self.edges, e)
			table.insert(self.edges, e + 1)
			self:_addEdgeUserdata(e, e + 1, userdata)

			table.insert(self.edges, e + 1)
			table.insert(self.edges, e + 2)
			self:_addEdgeUserdata(e + 1, e + 2, userdata)

			table.insert(self.edges, e + 2)
			table.insert(self.edges, e + 3)
			self:_addEdgeUserdata(e + 2, e + 3, userdata)

			table.insert(self.edges, e + 3)
			table.insert(self.edges, e)
			self:_addEdgeUserdata(e + 3, e, userdata)

			table.insert(self.vertexUserdata, userdata)
			table.insert(self.vertexUserdata, userdata)
			table.insert(self.vertexUserdata, userdata)
			table.insert(self.vertexUserdata, userdata)

			if tile:getIsPassable() then
				for k = 1, #NavigationMeshBuilder.OFFSETS do
					local offsetI, offsetJ = unpack(NavigationMeshBuilder.OFFSETS[k])

					if not self.map:canMove(i, j, offsetI, offsetJ, false, _isPassable) and self.map:getTile(i + offsetI, j + offsetJ):getIsPassable() then
						local tile = Tile()
						tile:setFlag("edge")
						tile:setFlag("impassable")

						local userdata = NavigationMeshBuilder.Userdata(tile)
						local e = math.floor(#self.points / 2) + 1

						if offsetI < 0 then
							table.insert(self.points, left)
							table.insert(self.points, top)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.points, left)
							table.insert(self.points, bottom)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.edges, e)
							table.insert(self.edges, e + 1)

							self:_addEdgeUserdata(e, e + 1, userdata)
						elseif offsetI > 0 then
							table.insert(self.points, right)
							table.insert(self.points, top)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.points, right)
							table.insert(self.points, bottom)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.edges, e)
							table.insert(self.edges, e + 1)

							self:_addEdgeUserdata(e, e + 1, userdata)
						end

						if offsetJ < 0 then
							table.insert(self.points, left)
							table.insert(self.points, top)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.points, right)
							table.insert(self.points, top)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.edges, e)
							table.insert(self.edges, e + 1)

							self:_addEdgeUserdata(e, e + 1, userdata)
						elseif offsetJ > 0 then
							table.insert(self.points, left)
							table.insert(self.points, bottom)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.points, right)
							table.insert(self.points, bottom)
							table.insert(self.vertexUserdata, userdata)

							table.insert(self.edges, e)
							table.insert(self.edges, e + 1)

							self:_addEdgeUserdata(e, e + 1, userdata)
						end
					end
				end
			end
		end
	end
end

function NavigationMeshBuilder:_buildPolygons()
	for _, polygon in ipairs(self.polygons) do
		local tile = Tile()
		tile:setFlag("polygon")
		tile:setFlag("impassable")

		for i = 1, #polygon do
			local j = math.wrapIndex(i, 1, #polygon)

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
	local triangulator = slick.geometry.triangulation.delaunay.new()

	self.points, self.edges, self.vertexUserdata = triangulator:clean(self.points, self.edges, self.vertexUserdata, self.cleanOptions)
	self.triangles = triangulator:triangulate(self.points, self.edges, self.triangulateOptions)
end

function NavigationMeshBuilder:_remapEdgeUserdata()
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
	self:_buildMap()
	self:_buildPolygons()
	self:_triangulate()
	self:_remapEdgeUserdata()
	self:_buildNavigationMeshBuilder()
end

function NavigationMeshBuilder:getNavigationMesh()
	return self.navigationMesh
end

return NavigationMeshBuilder
