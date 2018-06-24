--------------------------------------------------------------------------------
-- ItsyScape/World/MapMesh.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tile = require "ItsyScape.World.Tile"

-- Map mesh. Builds a mesh from a map.
MapMesh = Class()

-- Vertex format.
--
-- Similar to the default, except:
--
-- 1) Position is 3D.
-- 2) VertexTexture is relative to VertexTileBounds
-- 3) VertexTileBounds is { left, right, top, bottom }
--
-- Ergo, to properly wrap VertexTexture, you'd do something like this in the pixel shader:
--
-- s = mod(VertexTexture.s, (VertexTileBounds.y - VertexTileBounds.x)) + VertexTileBounds.x
-- t = mod(VertexTexture.t, (VertexTileBounds.w - VertexTileBounds.z)) + VertexTileBounds.z
MapMesh.FORMAT = {
    { "VertexPosition", 'float', 3 },
    { "VertexNormal", 'float', 3 },
    { "VertexTexture", 'float', 2 },
    { "VertexTileBounds", 'float', 4 },
    { "VertexColor", 'float', 4 }
}

-- Creates a mesh from 'map' using the provided tile set.
--
-- If 'left', 'right', 'top', and 'bottom' are provided, only a portion of the
-- map mesh is generated (those tiles that fall within the bounds).
function MapMesh:new(map, tileSet, left, right, top, bottom)
	self.vertices = {}
	self.map = map
	self.tileSet = tileSet

	left = math.max(left or 1, 1)
	right = math.max(right or map.width, map.width)
	top = math.max(top or 1, 1)
	bottom = math.max(bottom or map.height, map.height)

	self:_buildMesh(left, right, top, bottom)
end

-- Frees underlying resources.
--
-- Drawing is prohibited.
function MapMesh:release()
	self.mesh:release()
end

-- Draws the mesh with the provided texture.
function MapMesh:draw(texture, ...)
	self.mesh:setTexture(texture)
	love.graphics.draw(self.mesh, ...)
end

-- Releases all resources used by the mesh.
function MapMesh:release()
	self.mesh:release()
end

-- Builds a mesh within the provided bounds.
function MapMesh:_buildMesh(left, right, top, bottom)
	-- Build vertices.
	for j = top, bottom do
		for i = left, right do
			local tile = self.map:getTile(i, j)

			if i == 1 then
				self:_addLeftEdge(i, j, tile, nil)
			end
			if i == self.map.width then
				self:_addRightEdge(i, j, tile, nil)
			end

			self:_addLeftEdge(i, j, tile, self.map:getTile(i - 1, j))
			self:_addRightEdge(i, j, tile, self.map:getTile(i + 1, j))

			if j == 1 then
				self:_addTopEdge(i, j, tile, nil)
			end
			if j == self.map.height then
				self:_addBottomEdge(i, j, tile, nil)
			end

			self:_addTopEdge(i, j, tile, self.map:getTile(i, j - 1))
			self:_addBottomEdge(i, j, tile, self.map:getTile(i, j + 1))

			self:_addFlat(i, j, tile)
		end
	end

	-- Create mesh and enable all attributes.
	self.mesh = love.graphics.newMesh(MapMesh.FORMAT, self.vertices, 'triangles', 'static')
	for i = 1, #MapMesh.FORMAT do
		self.mesh:setAttributeEnabled(MapMesh.FORMAT[i][1], true)
	end
end

-- Adds a vertex directly.
--
-- * position is expected to be in the form { x, y, z }.
-- * normal is expected to be in the form { x, y, z }
-- * texture is expected to be in the form { s, t }
-- * tile is expected to be in the form { left, right, top, bottom }
-- * color is expected to be in the form { r, g, b, a }, where each component
--   is in the range of 0 .. 255 inclusive
--
-- color is modified as a function of height.
function MapMesh:_addVertex(position, normal, texture, tile, color)
	local vertex = {
		position.x, position.y, position.z,
		normal.x, normal.y, normal.z,
		texture.s, texture.t,
		tile.left, tile.right, tile.top, tile.bottom,
		color.r / 255, color.g / 255, color.b / 255, color.a / 255
	}

	table.insert(self.vertices, vertex)
	self.minY = math.min(self.minY or math.huge, position.y)
	self.maxY = math.max(self.maxY or -math.huge, position.y)
end

-- Builds a vertex from a local position.
--
-- * localPosition is the local offset of the tile relative to the center of the
--   tile at (i, j).
-- * side is a value, either less than zero or greater than zero, that indicates
--   which side the vertex falls on. For example, -1 on the X axis means left.
-- * index is the tile set index of the tile. This is either 'flat' or 'edge'.
-- * i, j are the tile indices on the x and y axis, respectively
-- * tile is the tile at (i, j) from the Map instance
function MapMesh:_buildVertex(localPosition, normal, side, index, i, j, tile)
	local tileCenterPosition = Vector(i - 0.5, 0, j - 0.5) * self.map.cellSize
	local worldPosition = localPosition * Vector(self.map.cellSize / 2, 1, self.map.cellSize / 2) + tileCenterPosition

	local s, t
	if index == 'flat' then
		if localPosition.x < 0 then
			s = 0
		else
			s = 1
		end

		if localPosition.z < 0 then
			t = 0.0
		else
			t = 1.0
		end
	elseif index == 'edge' then
		t = localPosition.y / 4
		if side < 0 then
			s = 0.0
		elseif side > 0 then
			s = 1.0
		else
			assert(false, "side no good :(")
		end
		--print(s, t)
	else
		s = 0
		t = 0
	end

	local left = self.tileSet:getTileProperty(tile[index], 'textureLeft', 0)
	local right = self.tileSet:getTileProperty(tile[index], 'textureRight', 1)
	local top = self.tileSet:getTileProperty(tile[index], 'textureTop', 0)
	local bottom = self.tileSet:getTileProperty(tile[index], 'textureBottom', 1)

	local red = self.tileSet:getTileProperty(tile[index], 'colorRed', 255)
	local green = self.tileSet:getTileProperty(tile[index], 'colorGreen', 255)
	local blue = self.tileSet:getTileProperty(tile[index], 'colorBlue', 255)
	local alpha = 255

	local texture = { s = s, t = t }
	local tileBounds = { left = left, right = right, top = top, bottom = bottom }
	local color = { r = red, g = green, b = blue, a = alpha }

	self:_addVertex(worldPosition, normal, texture, tileBounds, color)
end

-- Generates and returns a function to add an edge.
--
-- * func is expecte to be in the form:
--     function(tile, neighbor) return vertices, normal, d end
--   where tile is the current tile and neighbor is the relevant adjacent tile.
--     * vertices are the vertices (forming 0-3 triangles)
--     * normal is the normal of the edge
--     * d is a vector that that satsifies d . vertices[i] == side, where side
--       is either -1 or +1 (see _buildVertex).
local function addEdgeBuilder(func, side)
	return function(self, i, j, tile, neighbor)
		if tile == neighbor then
			return false
		end

		local vertices, normal, d = func(tile, neighbor or Tile.EMPTY)
		if vertices == nil then
			return false
		end

		for k = 1, #vertices do
			self:_buildVertex(vertices[k], normal, d:dot(vertices[k]), 'edge', i, j, tile)
		end
		--print()
		return true
	end
end

local function getTopVertices(tile, neighbor)
	local tileRef1 = tile.topLeft
	local tileRef2 = tile.topRight
	local neighborRef1 = neighbor.bottomLeft
	local neighborRef2 = neighbor.bottomRight
	local difference1 = tileRef1 - neighborRef1
	local difference2 = tileRef2 - neighborRef2

	local t
	if difference1 >= 1 and difference2 >= 1 then
		t = {
			Vector(-1, tileRef1, -1),
			Vector(1, tileRef2, -1),
			Vector(1, neighborRef2, -1),
			Vector(-1, neighborRef1, -1),
			Vector(-1, tileRef1, -1),
			Vector(1, neighborRef2, -1)
		}
	elseif difference1 >= 1 then
		t = {
			Vector(-1, tileRef1, -1),
			Vector(1, tileRef2, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference2 >= 1 then
		t = {
			Vector(-1, tileRef1, -1),
			Vector(1, tileRef2, -1),
			Vector(1, neighborRef2, -1)
		}
	end

	return t, Vector(0, 0, -1), Vector(1, 0, 0)
end

local function getBottomVertices(tile, neighbor)
	local tileRef1 = tile.bottomLeft
	local tileRef2 = tile.bottomRight
	local neighborRef1 = neighbor.topLeft
	local neighborRef2 = neighbor.topRight
	local difference1 = tileRef1 - neighborRef1
	local difference2 = tileRef2 - neighborRef2

	local t
	if difference1 >= 1 and difference2 >= 1 then
		t = {
			Vector(1, tileRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(1, neighborRef2, 1),
			Vector(1, neighborRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(-1, neighborRef1, 1)
		}
	elseif difference1 >= 1 then
		t = {
			Vector(1, tileRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(-1, neighborRef1, 1)
		}
	elseif difference2 >= 1 then
		t = {
			Vector(1, tileRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(1, neighborRef2, 1)
		}
	end

	return t, Vector(0, 0, 1), Vector(1, 0, 0)
end

local function getLeftVertices(tile, neighbor)
	local tileRef1 = tile.topLeft
	local tileRef2 = tile.bottomLeft
	local neighborRef1 = neighbor.topRight
	local neighborRef2 = neighbor.bottomRight
	local difference1 = tileRef1 - neighborRef1
	local difference2 = tileRef2 - neighborRef2

	local t
	if difference1 >= 1 and difference2 >= 1 then
		t = {
			Vector(-1, tileRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef2, 1),
			Vector(-1, neighborRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference1 >= 1 then
		t = {
			Vector(-1, tileRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference2 >= 1 then
		t = {
			Vector(-1, neighborRef2, 1),
			Vector(-1, tileRef2, 1),
			Vector(-1, tileRef1, -1)
		}
	end

	return t, Vector(-1, 0, 0), Vector(0, 0, 1)
end

local function getRightVertices(tile, neighbor)
	local tileRef1 = tile.topRight
	local tileRef2 = tile.bottomRight
	local neighborRef1 = neighbor.topLeft
	local neighborRef2 = neighbor.bottomLeft
	local difference1 = tileRef1 - neighborRef1
	local difference2 = tileRef2 - neighborRef2

	local t
	if difference1 >= 1 and difference2 >= 1 then
		t = {
			Vector(1, tileRef1, -1),
			Vector(1, tileRef2, 1),
			Vector(1, neighborRef2, 1),
			Vector(1, neighborRef1, -1),
			Vector(1, tileRef1, -1),
			Vector(1, neighborRef2, 1)
		}
	elseif difference1 >= 1 then
		t = {
			Vector(1, tileRef1, -1),
			Vector(1, tileRef2, 1),
			Vector(1, neighborRef1, -1)
		}
	elseif difference2 >= 1 then
		t = {
			Vector(1, tileRef2, 1),
			Vector(1, neighborRef2, 1),
			Vector(1, tileRef1, -1)
		}
	end

	return t, Vector(1, 0, 0), Vector(0, 0, 1)
end


MapMesh._addLeftEdge = addEdgeBuilder(getLeftVertices, -1)

MapMesh._addRightEdge = addEdgeBuilder(getRightVertices, 1)

MapMesh._addTopEdge = addEdgeBuilder(getTopVertices, -1)

MapMesh._addBottomEdge = addEdgeBuilder(getBottomVertices, 1)

-- Simply adds the flat (top).
function MapMesh:_addFlat(i, j, tile)
	local E = self.map.cellSize / 2
	local topLeft = Vector(-E, tile.topLeft, -E)
	local topRight = Vector(E, tile.topRight, -E)
	local bottomLeft = Vector(-E, tile.bottomLeft, E)
	local bottomRight = Vector(E, tile.bottomRight, E)

	local function calculateTriangleNormal(a, b, c)
		local s = a - b
		local t = c - a
		return s:cross(t):getNormal()
	end

	local crease = tile:getCrease()
	if crease == Tile.CREASE_FORWARD then
		-- Triangle 1
		local normal1 = calculateTriangleNormal(bottomLeft, topRight,  bottomRight)
		self:_buildVertex(Vector(1, tile.topRight, -1), normal1, 1, 'flat', i, j, tile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal1, -1, 'flat', i, j, tile)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal1, 1, 'flat', i, j, tile)

		-- Triangle 2
		local normal2 = calculateTriangleNormal(topLeft, topRight, bottomLeft)
		self:_buildVertex(Vector(1, tile.topRight, -1), normal2, 1, 'flat', i, j, tile)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal2, -1, 'flat', i, j, tile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal2, -1, 'flat', i, j, tile)
	else
		-- Triangle 1
		local normal1 = calculateTriangleNormal(topLeft, topRight, bottomRight)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal1, -1, 'flat', i, j, tile)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal1, 1, 'flat', i, j, tile)
		self:_buildVertex(Vector(1, tile.topRight, -1), normal1, 1, 'flat', i, j, tile)

		-- Triangle 2
		local normal2 = calculateTriangleNormal(topLeft, bottomRight, bottomLeft)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal2, 1, 'flat', i, j, tile)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal2, -1, 'flat', i, j, tile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal2, -1, 'flat', i, j, tile)
	end
end

return MapMesh
