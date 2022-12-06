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
MapMesh.EDGE_THRESHOLD = 0

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
	if self.isMultiTexture then
		tileSet = self.tileSet:getTileSetByID(tileSetID)
	else
		tileSet = self.tileSet
	end

	return (tileSet and tileSet:getTileProperty(tileIndex, property, defaultValue)) or defaultValue
end

function MapMesh:_getTileLayer(tileSetID)
	if self.isMultiTexture then
		return (self.tileSet:getTileSetLayerByID(tileSetID) or 1) - 1
	else
		return 0
	end
end

function MapMesh:_subTileElevationDifferent(a, b)
	local E = 0.01
	return math.abs(a - b) > E
end

function MapMesh:_shouldMask(currentTile, currentI, currentJ, otherTile, otherI, otherJ)
	local currentTileIsland = self.islandProcessor:getIslandForTile(currentI, currentJ)
	local currentTileIslandParentID = currentTileIsland and currentTileIsland.parent and currentTileIsland.parent.id
	local otherTileIsland = self.islandProcessor:getIslandForTile(otherI, otherJ)
	local otherTileIslandParentID = otherTileIsland and otherTileIsland.parent and otherTileIsland.parent.id

	if (currentTileIslandParentID or 0) < (otherTileIslandParentID or 0) then
		return false, "curID < othrID"
	end

	if currentTile.tileSetID == otherTile.tileSetID and currentTile.flat == otherTile.flat then
		return false, "same tileset/flat"
	end

	if currentI ~= otherI and currentJ ~= otherJ then
		if currentI < otherI and currentJ < otherJ then
			if self:_subTileElevationDifferent(currentTile.bottomRight, otherTile.topLeft) then
				return false, "currentI < otherI and currentJ < otherJ"
			end
		elseif currentI < otherI and currentJ > otherJ then
			if self:_subTileElevationDifferent(currentTile.topRight, otherTile.bottomLeft) then
				return false, "currentI < otherI and currentJ > otherJ"
			end
		elseif currentI > otherI and currentJ > otherJ then
			if self:_subTileElevationDifferent(currentTile.topLeft, otherTile.bottomRight) then
				return false, "currentI > otherI and currentJ > otherJ"
			end
		elseif currentI > otherI and currentJ < otherJ then
			if self:_subTileElevationDifferent(currentTile.topRight, otherTile.bottomLeft) then
				return false, "currentI > otherI and currentJ < otherJ"
			end
		end
	else
		if currentI < otherI then
			if self:_subTileElevationDifferent(currentTile.topRight, otherTile.topLeft) and
			   self:_subTileElevationDifferent(currentTile.bottomRight, otherTile.bottomLeft)
			then
				return false, "currentI < otherI"
			end
		elseif currentI > otherI then
			if self:_subTileElevationDifferent(currentTile.topLeft, otherTile.topRight) and
			   self:_subTileElevationDifferent(currentTile.bottomLeft, otherTile.bottomRight)
			then
				return false, "currentI > otherI"
			end
		end

		if currentJ < otherJ then
			if self:_subTileElevationDifferent(currentTile.bottomLeft, otherTile.topLeft) and
			   self:_subTileElevationDifferent(currentTile.bottomRight, otherTile.topRight)
			then
				return false, "currentJ < otherJ"
			end
		elseif currentJ > otherJ then
			if self:_subTileElevationDifferent(currentTile.topLeft, otherTile.bottomLeft) and
			   self:_subTileElevationDifferent(currentTile.topRight, otherTile.bottomRight)
			then
				return false, "currentJ > otherJ"
			end
		end
	end

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
				self:_addFlat(i, j, tile, k)
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

MapMesh.MASK_OFFSETS_ADJACENT = {
	{ -1,  0, MapMeshMask.TYPE_VERTICAL_LEFT     },
	{  1,  0, MapMeshMask.TYPE_VERTICAL_RIGHT    },
	{  0, -1, MapMeshMask.TYPE_HORIZONTAL_TOP    },
	{  0,  1, MapMeshMask.TYPE_HORIZONTAL_BOTTOM }
}

MapMesh.MASK_OFFSETS_DIAGONAL = {
	{ -1, -1, MapMeshMask.TYPE_CORNER_TL },
	{  1, -1, MapMeshMask.TYPE_CORNER_TR },
	{ -1,  1, MapMeshMask.TYPE_CORNER_BL },
	{  1,  1, MapMeshMask.TYPE_CORNER_BR }
}

MapMesh.MASK_OFFSET_CORNER_SKIP = {
	[MapMeshMask.TYPE_CORNER_TL] = { MapMeshMask.TYPE_VERTICAL_LEFT, MapMeshMask.TYPE_HORIZONTAL_TOP },
	[MapMeshMask.TYPE_CORNER_TR] = { MapMeshMask.TYPE_VERTICAL_RIGHT, MapMeshMask.TYPE_HORIZONTAL_TOP },
	[MapMeshMask.TYPE_CORNER_BL] = { MapMeshMask.TYPE_VERTICAL_LEFT, MapMeshMask.TYPE_HORIZONTAL_BOTTOM },
	[MapMeshMask.TYPE_CORNER_BR] = { MapMeshMask.TYPE_VERTICAL_RIGHT, MapMeshMask.TYPE_HORIZONTAL_BOTTOM }
}

function MapMesh:_maskTile(masks, islandTile, offsetI, offsetJ, mask)
	if offsetI ~= 0 and offsetJ ~= 0 then
		local otherOffsetTile1 = self.map:getTile(offsetI + islandTile.i, islandTile.j)
		local otherOffsetTile2 = self.map:getTile(islandTile.i, offsetJ + islandTile.j)

		local shouldMask1 = otherOffsetTile1.tileSetID == islandTile.tile.tileSetID and otherOffsetTile1.flat == islandTile.tile.flat
		local shouldMask2 = otherOffsetTile2.tileSetID == islandTile.tile.tileSetID and otherOffsetTile2.flat == islandTile.tile.flat

		if not (shouldMask1 and shouldMask2) then
			return
		end
	end

	offsetI = offsetI + islandTile.i
	offsetJ = offsetJ + islandTile.j

	local offsetTile = self.map:getTile(offsetI, offsetJ)
	local maskedTiles = self.maskedTiles[islandTile.tile] or {}
	wasOffsetTileMasked = maskedTiles[offsetTile]

	local shouldMask, reason = self:_shouldMask(islandTile.tile, islandTile.i, islandTile.j, offsetTile, offsetI, offsetJ)

	if shouldMask then
		masks[mask] = true
		self:_addFlat(islandTile.i, islandTile.j, islandTile.tile, 'flat', mask, offsetTile)
	end

	maskedTiles[offsetTile] = true
	self.maskedTiles[islandTile.tile] = maskedTiles
end

function MapMesh:_maskIsland(left, right, top, bottom, island)
	local islandTiles = self.islandProcessor:getTilesInIsland(island)

	local children = self.islandProcessor:getChildrenIslands(island)
	for i = 1, #children do
		self:_maskIsland(left, right, top, bottom, children[i])
	end

	self.masks = {}
	for i = 1, #islandTiles do
		local islandTile = islandTiles[i]
		local masks = self.masks[islandTile.index] or {}

		if islandTile.i >= left and islandTile.i <= right and
		   islandTile.j >= top and islandTile.j <= bottom
		then
			for j = 1, #MapMesh.MASK_OFFSETS_ADJACENT do
				local offsetI, offsetJ, mask = unpack(MapMesh.MASK_OFFSETS_ADJACENT[j])
				self:_maskTile(masks, islandTile, offsetI, offsetJ, mask)
			end

			for j = 1, #MapMesh.MASK_OFFSETS_DIAGONAL do
				local offsetI, offsetJ, mask = unpack(MapMesh.MASK_OFFSETS_DIAGONAL[j])
				local skip1, skip2 = unpack(MapMesh.MASK_OFFSET_CORNER_SKIP[mask])
				if not masks[skip1] and not masks[skip2] then
					self:_maskTile(masks, islandTile, offsetI, offsetJ, mask)
				end
			end
		end

		self.masks[islandTile.index] = masks
	end
end

function MapMesh:_mask(left, right, top, bottom)
	local rootIsland = self.islandProcessor:getRootIsland()
	local rootIslandChildren = self.islandProcessor:getChildrenIslands(rootIsland)

	self.maskedTiles = {}
	for i = 1, #rootIslandChildren do
		self:_maskIsland(left, right, top, bottom, rootIslandChildren[i])
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
			t = 0
		else
			t = 1
		end
	elseif index == 'edge' then
		t = localPosition.y / 4
		if side < 0 then
			s = 0
		elseif side > 0 then
			s = 1
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
	if difference1 > MapMesh.EDGE_THRESHOLD and difference2 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(-1, tileRef1, -1),
			Vector(1, tileRef2, -1),
			Vector(1, neighborRef2, -1),
			Vector(-1, neighborRef1, -1),
			Vector(-1, tileRef1, -1),
			Vector(1, neighborRef2, -1)
		}
	elseif difference1 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(-1, tileRef1, -1),
			Vector(1, tileRef2, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference2 > MapMesh.EDGE_THRESHOLD then
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
	if difference1 > MapMesh.EDGE_THRESHOLD and difference2 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(1, tileRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(1, neighborRef2, 1),
			Vector(1, neighborRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(-1, neighborRef1, 1)
		}
	elseif difference1 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(1, tileRef2, 1),
			Vector(-1, tileRef1, 1),
			Vector(-1, neighborRef1, 1)
		}
	elseif difference2 > MapMesh.EDGE_THRESHOLD then
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
	if difference1 > MapMesh.EDGE_THRESHOLD and difference2 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(-1, tileRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef2, 1),
			Vector(-1, neighborRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference1 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(-1, tileRef2, 1),
			Vector(-1, tileRef1, -1),
			Vector(-1, neighborRef1, -1)
		}
	elseif difference2 > MapMesh.EDGE_THRESHOLD then
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
	if difference1 > MapMesh.EDGE_THRESHOLD and difference2 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(1, tileRef1, -1),
			Vector(1, tileRef2, 1),
			Vector(1, neighborRef2, 1),
			Vector(1, neighborRef1, -1),
			Vector(1, tileRef1, -1),
			Vector(1, neighborRef2, 1)
		}
	elseif difference1 > MapMesh.EDGE_THRESHOLD then
		t = {
			Vector(1, tileRef1, -1),
			Vector(1, tileRef2, 1),
			Vector(1, neighborRef1, -1)
		}
	elseif difference2 > MapMesh.EDGE_THRESHOLD then
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
