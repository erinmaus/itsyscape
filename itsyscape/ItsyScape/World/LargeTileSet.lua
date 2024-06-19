--------------------------------------------------------------------------------
-- ItsyScape/World/LargeTileSet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

LargeTileSet = Class()

LargeTileSet.ATLAS_SIZE = 1024
LargeTileSet.TILE_SIZE  = 128

function LargeTileSet:new(tileSet)
	if not Class.isCompatibleType(tileSet, MultiTileSet) then
		print(">>> id", tileSet:getID())
		tileSet = MultiTileSet({ tileSet:getID() }, true)
	end

	self.tileSet = tileSet
	self.tileFunctions = {}

	self.tileSets = {}
	for _, tileSetID in tileSet:iterateTileSetIDs() do
		self:_loadLargeTileSetDescription(tileSetID)
	end

	self.layers = 0
	self.diffuseCanvas = false
	self.specularCanvas = false

	self.numLargeTiles = 0
	self.numLayersPerLargeTile = 0
	self.largeTiles = {}
	self:_registerLargeTileSetDescriptions()
end

function LargeTileSet:_loadLargeTileSetDescription(tileSetID)
	local tileSetFilename = string.format("Resources/Game/TileSets/%s/LargeLayout.lua", tileSetID)
	local chunk, e = love.filesystem.load(tileSetFilename)
	if not chunk then
		Log.error("Could not load tile set '%s' when creating tileset: %s", tileSetFilename, e)
		table.insert(self.tileSets, {})
	else
		local success, result = pcall(chunk)
		if success then
			table.insert(self.tileSets, result or {})
		else
			Log.error("Could not load tile set '%s' when creating tileset: %s", tileSetFilename, result)
			table.insert(self.tileSets, {})
		end
	end
end

function LargeTileSet:_registerLargeTileSetDescriptions()
	for index, tileSet in ipairs(self.tileSets) do
		local tileSetID = self.tileSet:getTileSetID(index)

		for name, tile in pairs(tileSet) do
			self:registerTile(tileSetID, name, tile)
		end
	end
end

function LargeTileSet:registerTile(tileSetID, name, func, ...)
	local tileFunctionsByTileSetID = self.tileFunctions[tileSetID] or {}
	local callback = tileFunctionsByTileSetID[name]

	if not callback then
		callback = Callback()

		self.numLargeTiles = self.numLargeTiles + 1
		self.largeTiles[self.numLargeTiles] = { tileSetID = tileSetID, name = name }
	end

	callback:register(func, ...)

	tileFunctionsByTileSetID[name] = callback
	self.tileFunctions[tileSetID] = tileFunctionsByTileSetID
end

function LargeTileSet:_emit(type, map, tileSetID, name, i, j, w, h, tileSize)
	local tileSetTile, actualTileSet
	do
		actualTileSet = self.tileSet:getTileSetByID(tileSetID)
		tileSetTile = actualTileSet:getTile(name)
	end

	if tileSetTile and mapTile.tileSetID then
		local callback = self.tileFunctions[tileSetID] and self.tileFunctions[tileSetID][name]
		if callback then
			callback(type, actualTileSet, map, i, j, w, h, tileSetTile, tileSize)
		end
	end
end

function LargeTileSet:resize(map)
	local w = math.max(math.ceil(map:getWidth() / (self.ATLAS_SIZE / self.TILE_SIZE)), 1)
	local h = math.max(math.ceil(map:getHeight() / (self.ATLAS_SIZE / self.TILE_SIZE)), 1)
	local t = self.numLargeTiles
	local d = self.tileSet:getNumTileSets()
	local layers = (w + h) * self.numLargeTiles + d

	if layers ~= self.layers then
		self.layers = layers
		self.diffuseCanvas = love.graphics.newCanvas(self.ATLAS_SIZE, self.ATLAS_SIZE, self.layers, { type = "array" })
		self.specularCanvas = love.graphics.newCanvas(self.ATLAS_SIZE, self.ATLAS_SIZE, self.layers, { type = "array" })

		self.diffuseTexture = LayerTextureResource(self.diffuseCanvas)
		self.specularTexture = LayerTextureResource(self.specularCanvas)
	end

	self.numLargeTilesWidth = w
	self.numLargeTilesHeight = h
	self.numLayersPerLargeTile = w + h
end

function LargeTileSet:getDiffuseTexture()
	return self.diffuseTexture
end

function LargeTileSet:getSpecularTexture()
	return self.specularTexture
end

function LargeTileSet:emitAll(map)
	self:resize(map)

	local texture = self.tileSet:getMultiTexture()
	texture = texture and texture:getResource()

	local diffuseCanvas = self.diffuseCanvas
	local specularCanvas = self.specularCanvas

	love.graphics.push("all")
	for i = 1, texture:getLayerCount() do
		love.graphics.setCanvas(diffuseCanvas, i)
		love.graphics.origin()
		love.graphics.drawLayer(texture, i)
	end
	love.graphics.pop()

	if coroutine.running() then
		coroutine.yield()
	end

	local numTilesPerAxis = self.ATLAS_SIZE / self.TILE_SIZE
	for largeTileIndex, largeTileInfo in ipairs(self.largeTiles) do
		for offsetAtlasI = 1, self.numLargeTilesWidth do
			for offsetAtlasJ = 1, self.numLargeTilesHeight do
				local absoluteI = (offsetAtlasI - 1) * numTilesPerAxis + 1
				local absoluteJ = (offsetAtlasJ - 1) * numTilesPerAxis + 1

				if absoluteI <= map:getWidth() and absoluteJ <= map:getHeight() then
					local layer = self:getTextureCoordinates(largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ)

					if layer then
						love.graphics.push("all")

						love.graphics.origin()
						love.graphics.translate(
							-((offsetAtlasI - 1) * self.ATLAS_SIZE),
							-((offsetAtlasJ - 1) * self.ATLAS_SIZE))

						love.graphics.setCanvas(diffuseCanvas, layer)
						love.graphics.clear(0, 0, 0, 1)
						self:_emit("diffuse", map, largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

						love.graphics.setCanvas(specularCanvas, layer)
						love.graphics.clear(0, 0, 0, 0)
						self:_emit("specular", map, largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

						love.graphics.pop()
					end

					if coroutine.running() then
						coroutine.yield()
					end
				end
			end
		end
	end
end

function LargeTileSet:getTextureCoordinates(tileSetID, name, i, j)
	if not tileSetID or tileSetID == "" then
		tileSetID = self.tileSet:getTileSetID(1)
	end

	local largeTileIndex
	for index, info in ipairs(self.largeTiles) do
		if info.tileSetID == tileSetID and info.name == name then
			largeTileIndex = index
			break
		end
	end

	if not largeTileIndex then
		return nil, nil, nil, nil, nil
	end

	local numTilesPerAxis = self.ATLAS_SIZE / self.TILE_SIZE
	local relativeI = i / numTilesPerAxis
	local relativeJ = j / numTilesPerAxis
	local floorI = math.floor(relativeI)
	local floorJ = math.floor(relativeJ)

	if floorI <= 0 or floorI > self.numLargeTilesWidth or
	   floorJ <= 0 or floorJ > self.numLargeTilesHeight
	then
		return nil, nil, nil, nil, nil
	end

	local fractionalI = relativeI - floorI
	local fractionalJ = relativeJ - floorJ
	local atlasIndex = (floorI + 1) * self.numLargeTilesWidth + (floorJ + 1)

	local layer = #self.tileSets + (largeTileIndex - 1) * self.numLayersPerLargeTile + atlasIndex
	local offsetS = fractionalI
	local offsetT = fractionalJ
	local offsetW = 1.0 / numTilesPerAxis
	local offsetH = 1.0 / numTilesPerAxis

	local left = offsetS
	local right = offsetS + offsetW
	local top = offsetT
	local bottom = offsetT + offsetH

	return layer, left, right, top, bottom
end

return LargeTileSet
