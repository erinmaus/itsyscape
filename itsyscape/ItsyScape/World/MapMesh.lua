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
local MapMeshMask = require "ItsyScape.World.MapMeshMask"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"
local Tile = require "ItsyScape.World.Tile"

-- Map mesh. Builds a mesh from a map.
local MapMesh = Class()

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
    { "VertexColor", 'float', 4 },
    { "VertexTextureLayer", 'float', 2 }
}

-- Creates a mesh from 'map' using the provided tile set.
--
-- If 'left', 'right', 'top', and 'bottom' are provided, only a portion of the
-- map mesh is generated (those tiles that fall within the bounds).
function MapMesh:new(map, tileSet, left, right, top, bottom, mask, islandProcessor)
	self.vertices = {}
	self.map = map
	self.tileSet = tileSet
	self.isMultiTexture = Class.isCompatibleType(tileSet, MultiTileSet)
	self.mask = mask
	self.islandProcessor = islandProcessor
	self.min, self.max = Vector(math.huge), Vector(-math.huge)

	left = math.max(left or 1, 1)
	right = math.min(right or map.width, map.width)
	top = math.max(top or 1, 1)
	bottom = math.min(bottom or map.height, map.height)

	self:_buildMesh(left, right, top, bottom)
end

function MapMesh:getBounds()
	return self.min, self.max
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

function MapMesh:_getTileProperty(tileSetID, tileIndex, property, defaultValue)
	local tileSet
	if self.multiTexture then
		tileSet = self.tileSet:getTileSetByID(tileSetID)
	else
		tileSet = self.tileSet
	end

	return (tileSet and tileSet:getTileProperty(tileIndex, property, defaultValue)) or defaultValue
end

function MapMesh:_getTileLayer(tileSetID)
	if self.multiTexture then
		return (self.tileSet:getTileSetLayerByID(tileSetID) or 1) - 1
	else
		return 0
	end
end

function MapMesh:_shouldMask(currentTile, currentI, currentJ, otherTile, otherI, otherJ)
	if currentTile.tileSetID == otherTile.tileSetID and currentTile.flat == otherTile.flat then
		return false
	end

	-- local isCurrentSharp = self:_getTileProperty(currentTile.tileSetID, currentTile.flat, 'sharp', false)
	-- local isOtherSharp = self:_getTileProperty(otherTile.tileSetID, otherTile.flat, 'sharp', false)
	-- if isCurrentSharp or isOtherSharp then
	-- 	return false
	-- end

	-- local currentTileY = currentTile:getCorner(currentTileS, currentTileT)
	-- local otherTileY = otherTile:getCorner(otherTileS, otherTileT)
	-- if currentTileY ~= otherTileY then
	-- 	return false
	-- end

	return true
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

			self:_addFlat(i, j, tile, 'flat')
			for k = 1, #tile.decals do
				--self:_addFlat(i, j, tile, k)
			end
		end
	end

	if self.mask and self.islandProcessor then
		self:_mask(left, right, top, bottom)
	end

	-- Create mesh and enable all attributes.
	self.mesh = love.graphics.newMesh(MapMesh.FORMAT, self.vertices, 'triangles', 'static')
	for i = 1, #MapMesh.FORMAT do
		self.mesh:setAttributeEnabled(MapMesh.FORMAT[i][1], true)
	end
end

MapMesh.MASKS = {
	[
		"10" ..
		"00"
	] = { MapMeshMask.TYPE_HORIZONTAL_TOP, MapMeshMask.TYPE_VERTICAL_LEFT },
	[
		"01" ..
		"00"
	] = { MapMeshMask.TYPE_HORIZONTAL_TOP, MapMeshMask.TYPE_VERTICAL_RIGHT },
	[
		"00" ..
		"10"
	] = { MapMeshMask.TYPE_HORIZONTAL_BOTTOM, MapMeshMask.TYPE_VERTICAL_LEFT },
	[
		"00" ..
		"01"
	] = { MapMeshMask.TYPE_HORIZONTAL_BOTTOM, MapMeshMask.TYPE_VERTICAL_RIGHT },
	[
		"11" ..
		"00"
	] = { MapMeshMask.TYPE_HORIZONTAL_TOP },
	[
		"00" ..
		"11"
	] = { MapMeshMask.TYPE_HORIZONTAL_BOTTOM },
	[
		"10" ..
		"10"
	] = { MapMeshMask.TYPE_VERTICAL_LEFT },
	[
		"01" ..
		"01"
	] = { MapMeshMask.TYPE_VERTICAL_RIGHT },
	[
		"01" ..
		"11"
	] = { MapMeshMask.TYPE_CORNER_TL },
	[
		"10" ..
		"11"
	] = { MapMeshMask.TYPE_CORNER_TR },
	[
		"11" ..
		"01"
	] = { MapMeshMask.TYPE_CORNER_BL },
	[
		"11" ..
		"10"
	] = { MapMeshMask.TYPE_CORNER_BR }
}

MapMesh.MASK_OFFSETS = {
	{ -1, -1 },
	{  0, -1 },
	{  1, -1 },
	{ -1,  0 },
	{  0,  0 },
	{ -1,  1 },
	{  0,  1 },
	{  1,  1 }
}

function MapMesh:_buildMaskName(a, b, c, d)
	local x = (a and "1") or "0"
	local y = (b and "1") or "0"
	local z = (c and "1") or "0"
	local w = (d and "1") or "0"

	return x .. y .. z .. w
end

function MapMesh:_maskTile(i, j, reference, referenceI, referenceJ)
	local topLeft = self.map:getTile(i, j)
	local topLeftMask = self:_shouldMask(topLeft, i, j, reference, referenceI, referenceJ)

	local topRight = self.map:getTile(i + 1, j)
	local topRightMask = self:_shouldMask(topRight, i + 1, j, reference, referenceI, referenceJ)

	local bottomLeft = self.map:getTile(i, j + 1)
	local bottomLeftMask = self:_shouldMask(topRight, i, j + 1, reference, referenceI, referenceJ)

	local bottomRight = self.map:getTile(i + 1, j + 1)
	local bottomRightMask = self:_shouldMask(topRight, i + 1, j + 1, reference, referenceI, referenceJ)

	local maskName = self:_buildMaskName(topLeftMask, topRightMask, bottomLeftMask, bottomRightMask)
	return MapMesh.MASKS[maskName],
		(topLeftMask and topLeft) or
		(topRightMask and topRight) or
		(bottomLeftMask and bottomLeft) or
		(bottomRightMask and bottomRight)
end

function MapMesh:_maskIsland(left, right, top, bottom, island)
	local islandTiles = self.islandProcessor:getTilesInIsland(island)

	local masks = {}
	for i = 1, #islandTiles do
		local islandTile = islandTiles[i]

		if islandTile.i >= left and islandTile.i <= right and
		   islandTile.j >= top and islandTile.j <= bottom
		then
			for j = 1, #MapMesh.MASK_OFFSETS do
				local offsetI, offsetJ = unpack(MapMesh.MASK_OFFSETS[j])

				offsetI = offsetI + islandTile.i
				offsetJ = offsetJ + islandTile.j

				local result, resultTile = self:_maskTile(offsetI, offsetJ, islandTile.tile, islandTile.i, islandTile.j)
				if result then
					for k = 1, #result do
						if not masks[result[k]] then
							self:_addFlat(islandTile.i, islandTile.j, islandTile.tile, 'flat', result[k], resultTile)
							masks[result[k]] = true
						end
					end
				end
			end
		end

		table.clear(masks)
	end
end

function MapMesh:_mask(left, right, top, bottom)
	local islands = {}

	for j = top, bottom do
		for i = left, right do
			local island = self.islandProcessor:getIslandForTile(i, j)
			if not islands[island] then
				islands[island] = true
				self:_maskIsland(left, right, top, bottom, island)
			end
		end
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
function MapMesh:_addVertex(position, normal, texture, tile, color, layer, maskLayer)
	local vertex = {
		position.x, position.y, position.z,
		normal.x, normal.y, normal.z,
		texture.s, texture.t,
		tile.left, tile.right, tile.top, tile.bottom,
		color.r / 255, color.g / 255, color.b / 255, color.a / 255,
		layer, maskLayer
	}

	table.insert(self.vertices, vertex)
	self.minY = math.min(self.minY or math.huge, position.y)
	self.maxY = math.max(self.maxY or -math.huge, position.y)
	self.min = self.min:min(position)
	self.max = self.max:max(position)
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
function MapMesh:_buildVertex(localPosition, normal, side, index, i, j, tile, maskType, maskTile)
	tile = maskTile or tile
	maskType = maskType or MapMeshMask.TYPE_UNMASKED

	local tileCenterPosition = Vector(i - 0.5, 0, j - 0.5) * self.map.cellSize
	local worldPosition = localPosition * Vector(self.map.cellSize / 2, 1, self.map.cellSize / 2) + tileCenterPosition

	local s, t
	if index == 'flat' or type(index) == 'number' then
		if localPosition.x > 0 then
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
	else
		s = 0
		t = 0
	end

	local tileIndex
	if type(index) == 'number' then
		tileIndex = tile.decals[index]
	else
		tileIndex = tile[index]
	end

	local left = self:_getTileProperty(tile.tileSetID, tileIndex, 'textureLeft', 0)
	local right = self:_getTileProperty(tile.tileSetID, tileIndex, 'textureRight', 1)
	local top = self:_getTileProperty(tile.tileSetID, tileIndex, 'textureTop', 0)
	local bottom = self:_getTileProperty(tile.tileSetID, tileIndex, 'textureBottom', 1)

	local red = self:_getTileProperty(tile.tileSetID, tileIndex, 'colorRed', 255) * tile.red
	local green = self:_getTileProperty(tile.tileSetID, tileIndex, 'colorGreen', 255) * tile.green
	local blue = self:_getTileProperty(tile.tileSetID, tileIndex, 'colorBlue', 255) * tile.blue
	local alpha = 255

	local texture = { s = s, t = t }
	local tileBounds = { left = left, right = right, top = top, bottom = bottom }
	local color = { r = red, g = green, b = blue, a = alpha }
	local layer = self:_getTileLayer(tile.tileSetID)
	local maskLayer = maskType - 1

	self:_addVertex(worldPosition, normal, texture, tileBounds, color, layer, maskLayer)
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
function MapMesh:_addFlat(i, j, tile, index, maskType, maskTile)
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
		self:_buildVertex(Vector(1, tile.topRight, -1), normal1, 1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal1, -1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal1, 1, index, i, j, tile, maskType, maskTile)

		-- Triangle 2
		local normal2 = calculateTriangleNormal(topLeft, topRight, bottomLeft)
		self:_buildVertex(Vector(1, tile.topRight, -1), normal2, 1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal2, -1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal2, -1, index, i, j, tile, maskType, maskTile)
	else
		-- Triangle 1
		local normal1 = calculateTriangleNormal(topLeft, topRight, bottomRight)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal1, -1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal1, 1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(1, tile.topRight, -1), normal1, 1, index, i, j, tile, maskType, maskTile)

		-- Triangle 2
		local normal2 = calculateTriangleNormal(topLeft, bottomRight, bottomLeft)
		self:_buildVertex(Vector(1, tile.bottomRight, 1), normal2, 1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(-1, tile.topLeft, -1), normal2, -1, index, i, j, tile, maskType, maskTile)
		self:_buildVertex(Vector(-1, tile.bottomLeft, 1), normal2, -1, index, i, j, tile, maskType, maskTile)
	end
end

return MapMesh
