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
local Resource = require "ItsyScape.Graphics.Resource"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local Map = require "ItsyScape.World.Map"
local MultiTileSet = require "ItsyScape.World.MultiTileSet"

LargeTileSet = Class()

LargeTileSet.ATLAS_SIZE = 1024
LargeTileSet.TILE_SIZE  = 128
LargeTileSet.SCALED_TILE_SIZE = _MOBILE and 32 or 128
LargeTileSet.CACHED_MAP_SIZE = 128
LargeTileSet.MOBILE_CACHED_MAP_SIZE = 96

LargeTileSet.CACHED_MAP = Map(LargeTileSet.CACHED_MAP_SIZE, LargeTileSet.CACHED_MAP_SIZE)

function LargeTileSet:new(tileSet)
	if not Class.isCompatibleType(tileSet, MultiTileSet) then
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
	self.outlineCanvas = false

	self.ready = false

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

		local singleTileSet = self.tileSet:getTileSetByIndex(index)
		for i = 1, singleTileSet:getNumTiles() do
			local name = singleTileSet:getTileProperty(i, "name")
			if tileSet[name] then
				self:registerTile(tileSetID, name, tileSet[name])
			end
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
		tileSetTile = actualTileSet:getTile(actualTileSet:getTileIndex(name))
	end

	if tileSetTile then
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
	local layers = (w * h) * self.numLargeTiles + d

	local atlasSize = math.floor(self.SCALED_TILE_SIZE / self.TILE_SIZE * self.ATLAS_SIZE)

	if layers ~= self.layers then
		self.layers = layers
		self.diffuseCanvas = love.graphics.newCanvas(atlasSize, atlasSize, self.layers, { type = "array", format = "rgb5a1" })
		self.specularCanvas = love.graphics.newCanvas(atlasSize, atlasSize, self.layers, { type = "array", format = "rgb5a1" })
		self.outlineCanvas = love.graphics.newCanvas(atlasSize, atlasSize, self.layers, { type = "array", format = "rgba8" })

		self.diffuseTexture = LayerTextureResource(self.diffuseCanvas)
		self.diffuseTexture:getHandle():setPerPassTexture(RendererPass.PASS_OUTLINE, self.outlineCanvas)
		self.specularTexture = LayerTextureResource(self.specularCanvas)
	end

	self.numLargeTilesWidth = w
	self.numLargeTilesHeight = h
	self.numLayersPerLargeTile = w * h

	self.ready = false
end

function LargeTileSet:getLargeTilesCount()
	return self.numLargeTiles
end

function LargeTileSet:getLargeTile(index)
	local tile = self.largeTiles[index]
	if tile then
		return tile.name, tile.tileSetID
	end

	return nil, nil
end

function LargeTileSet:getLargeTileSize()
	return self.numLargeTilesWidth, self.numLargeTilesHeight
end

function LargeTileSet:getDiffuseTexture()
	return self.diffuseTexture
end

function LargeTileSet:getSpecularTexture()
	return self.specularTexture
end

function LargeTileSet:getIsCacheEnabled()
	return not Class.isCompatibleType(_APP, require "ItsyScape.BuildLargeTileSetsApplication")
end

function LargeTileSet:release()
	self.diffuseCanvas:release()
	self.specularCanvas:release()
	self.outlineCanvas:release()
end

function LargeTileSet:_buildBaseLayers()
	local diffuseCanvas = self.diffuseCanvas
	local specularCanvas = self.specularCanvas
	local outlineCanvas = self.outlineCanvas
	local scaleMultiplier = self.SCALED_TILE_SIZE / self.TILE_SIZE

	local texture = self.tileSet:getMultiTexture()
	texture = texture and texture:getResource()

	love.graphics.push("all")
	for i = 1, texture:getLayerCount() do
		love.graphics.setCanvas(diffuseCanvas, i)
		love.graphics.origin()
		love.graphics.scale(scaleMultiplier, scaleMultiplier)
		love.graphics.drawLayer(texture, i)
	end
	love.graphics.pop()

	love.graphics.push("all")
	for i = 1, texture:getLayerCount() do
		love.graphics.setCanvas(outlineCanvas, i)
		love.graphics.clear(0, 0, 0, 0)
	end
	love.graphics.pop()
end

function LargeTileSet:getIsReady()
	return self.ready
end

function LargeTileSet:emitAll(map)
	local scaleMultiplier = self.SCALED_TILE_SIZE / self.TILE_SIZE
	local numTilesPerAxis = self.ATLAS_SIZE / self.TILE_SIZE

	for largeTileIndex, largeTileInfo in ipairs(self.largeTiles) do
		local baseDirectory = string.format("Resources/Game/TileSets/%s/Cache", largeTileInfo.tileSetID)

		if self:getIsCacheEnabled() and love.filesystem.getInfo(baseDirectory) then
			map = self.CACHED_MAP
			self:resize(self.CACHED_MAP)
			self:_buildBaseLayers()

			local diffuseCanvas = self.diffuseCanvas
			local specularCanvas = self.specularCanvas
			local outlineCanvas = self.outlineCanvas

			local images = {}
			for offsetAtlasI = 1, self.numLargeTilesWidth do
				for offsetAtlasJ = 1, self.numLargeTilesHeight do
					local absoluteI = (offsetAtlasI - 1) * numTilesPerAxis + 1
					local absoluteJ = (offsetAtlasJ - 1) * numTilesPerAxis + 1

					if absoluteI <= map:getWidth() and absoluteJ <= map:getHeight() then
						local layer = self:getTextureCoordinates(largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ)

						if layer and layer <= diffuseCanvas:getLayerCount() then
							table.insert(images, "image")
							table.insert(images, string.format("%s/%s_%03dx%03d.png", baseDirectory, largeTileInfo.name, offsetAtlasI, offsetAtlasJ))
							table.insert(images, "image")
							table.insert(images, string.format("%s/%s_%03dx%03d@Specular.png", baseDirectory, largeTileInfo.name, offsetAtlasI, offsetAtlasJ))
							table.insert(images, "image")
							table.insert(images, string.format("%s/%s_%03dx%03d@Outline.png", baseDirectory, largeTileInfo.name, offsetAtlasI, offsetAtlasJ))
						end
					end
				end
			end

			local images = Resource.many(images)
			local index = 1

			for offsetAtlasI = 1, self.numLargeTilesWidth do
				for offsetAtlasJ = 1, self.numLargeTilesHeight do
					local absoluteI = (offsetAtlasI - 1) * numTilesPerAxis + 1
					local absoluteJ = (offsetAtlasJ - 1) * numTilesPerAxis + 1

					if absoluteI <= map:getWidth() and absoluteJ <= map:getHeight() then
						local layer = self:getTextureCoordinates(largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ)
						if layer and layer <= diffuseCanvas:getLayerCount() then
							love.graphics.push("all")
							love.graphics.setBlendMode("replace", "premultiplied")

							love.graphics.origin()
							love.graphics.scale(scaleMultiplier, scaleMultiplier)

							local diffuseImageData, specularImageData, outlineImageData = unpack(images, index, index + 3)

							local diffuseImage = love.graphics.newImage(diffuseImageData)
							local specularImage = love.graphics.newImage(specularImageData)
							local outlineImage = love.graphics.newImage(outlineImageData)

							love.graphics.setCanvas(diffuseCanvas, layer)
							love.graphics.draw(diffuseImage)

							love.graphics.setCanvas(specularCanvas, layer)
							love.graphics.draw(specularImage)

							love.graphics.setCanvas(outlineCanvas, layer)
							love.graphics.draw(outlineImage)

							love.graphics.pop()

							diffuseImageData:release()
							diffuseImage:release()
							specularImageData:release()
							specularImage:release()
							outlineImageData:release()
							outlineImage:release()

							index = index + 3
						end
					end
				end
			end

			self.ready = true
		elseif not (_ITSYREALM_PROD or _ITSYREALM_DEMO) then
			self:resize(map)
			self:_buildBaseLayers()

			local diffuseCanvas = self.diffuseCanvas
			local specularCanvas = self.specularCanvas
			local outlineCanvas = self.outlineCanvas

			self:_emit("cache", map, largeTileInfo.tileSetID, largeTileInfo.name, 1, 1, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

			for offsetAtlasI = 1, self.numLargeTilesWidth do
				for offsetAtlasJ = 1, self.numLargeTilesHeight do
					local absoluteI = (offsetAtlasI - 1) * numTilesPerAxis + 1
					local absoluteJ = (offsetAtlasJ - 1) * numTilesPerAxis + 1

					if absoluteI <= map:getWidth() and absoluteJ <= map:getHeight() then
						local layer = self:getTextureCoordinates(largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ)

						if layer and layer <= diffuseCanvas:getLayerCount() then
							love.graphics.push("all")
							love.graphics.setBlendMode("alpha", "alphamultiply")

							love.graphics.origin()
							love.graphics.scale(scaleMultiplier, scaleMultiplier)
							love.graphics.translate(
								-((offsetAtlasI - 1) * self.ATLAS_SIZE),
								-((offsetAtlasJ - 1) * self.ATLAS_SIZE))

							love.graphics.setCanvas(diffuseCanvas, layer)
							love.graphics.clear(0, 0, 0, 1)
							self:_emit("diffuse", map, largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

							love.graphics.setCanvas(specularCanvas, layer)
							love.graphics.clear(0, 0, 0, 0)
							self:_emit("specular", map, largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

							love.graphics.setCanvas(outlineCanvas, layer)
							love.graphics.clear(1, 1, 1, 0)
							self:_emit("outline", map, largeTileInfo.tileSetID, largeTileInfo.name, absoluteI, absoluteJ, numTilesPerAxis, numTilesPerAxis, self.TILE_SIZE)

							love.graphics.pop()
						end

						if coroutine.running() then
							coroutine.yield()
						end
					end
				end
			end

			self.ready = true
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
	local relativeI = (i - 1) / numTilesPerAxis
	local relativeJ = (j - 1) / numTilesPerAxis
	local floorI = math.floor(relativeI)
	local floorJ = math.floor(relativeJ)

	if floorI < 0 or floorI > self.numLargeTilesWidth or
	   floorJ < 0 or floorJ > self.numLargeTilesHeight
	then
		return nil, nil, nil, nil, nil
	end

	local fractionalI = relativeI - floorI
	local fractionalJ = relativeJ - floorJ
	local atlasIndex = floorI * self.numLargeTilesWidth + floorJ

	local layer = #self.tileSets + 1 + (largeTileIndex - 1) * self.numLayersPerLargeTile + atlasIndex
	local offsetS = fractionalI
	local offsetT = fractionalJ
	local offsetW = 1.0 / numTilesPerAxis
	local offsetH = 1.0 / numTilesPerAxis

	local left = offsetS + offsetW
	local right = offsetS
	local top = offsetT + offsetH
	local bottom = offsetT

	return layer, left, right, top, bottom
end

return LargeTileSet
