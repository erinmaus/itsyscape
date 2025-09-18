--------------------------------------------------------------------------------
-- ItsyScape/BuildLargeTileSetsApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local buffer = require "string.buffer"
local Class = require "ItsyScape.Common.Class"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local ResourceManager = require "ItsyScape.Graphics.ResourceManager"
local LargeTileSet = require "ItsyScape.World.LargeTileSet"
local Map = require "ItsyScape.World.Map"

local BuildLargeTileSetsApplication = Class(EditorApplication)

function BuildLargeTileSetsApplication:new()
	ResourceManager.DESKTOP_FRAME_DURATION = 5
	ResourceManager.MAX_TIME_FOR_SYNC_RESOURCE = 5
	_LOG_WRITE_ALL = true

	_ITSYREALM_PROD = false
	_ITSYREALM_DEMO = false

	EditorApplication.new(self)

	self.maps = self:getMaps()
	self.mapIndex = 0

	self.largeTileSets = self:getLargeTileSets()
	self.tileSetIndex = 0
end

function BuildLargeTileSetsApplication:getMaps()
	local maps = love.filesystem.getDirectoryItems("Resources/Game/Maps")

	local result = {}
	for _, map in ipairs(maps) do
		local baseFilename = string.format("Resources/Game/Maps/%s", map)
		local children = love.filesystem.getDirectoryItems(baseFilename)

		local metaFilename = string.format("%s/meta", baseFilename)
		local meta = setfenv(loadstring("return " .. (love.filesystem.read(metaFilename) or "")), {})() or {}

		for _, child in ipairs(children) do
			local index = child:match("^(%d+)%.lmap$")
			if index then
				local localMeta = meta[tonumber(index)]
				if localMeta and not (localMeta.disableGroundDecorations or localMeta.disableCaching) then
					localMeta.disableCaching = true

					local mapFilename = string.format("%s/%s", baseFilename, child)
					table.insert(result, { map = map, filename = mapFilename, meta = localMeta, layer = index })
					Log.info("Going to build map mesh & ground decorations '%s'.", mapFilename)
				end
			end
		end
	end

	return result
end

function BuildLargeTileSetsApplication:saveMap(layer, map, filename, meta)
	local gameView = self:getGameView()
	local mapMeshSceneNode = gameView:getMapMeshSceneNodes(layer)
	local vertices, min, max = mapMeshSceneNode:toVertices()

	local mapMesh = {
		data = vertices,
		min = { min:get() },
		max = { max:get() },
	}

	local baseFilename = string.format("Resources/Game/Maps/%s", map)
	love.filesystem.createDirectory(baseFilename)

	local outputFilename = string.format("%s.mapmesh", filename)
	love.filesystem.write(outputFilename, buffer.encode(mapMesh))
	Log.info("Saved map mesh '%s' to encoded buffer '%s'.", filename, outputFilename)

	local groundDecorationsDirectory = string.format("%s/GroundDecorationsCache", baseFilename, map)
	love.filesystem.createDirectory(groundDecorationsDirectory)

	for name, groundDecoration in pairs(gameView:getDecorations()) do
		local outputFilename = string.format("%s/%s.ldeco.cache", groundDecorationsDirectory, name)
		love.filesystem.write(outputFilename, buffer.encode(groundDecoration:serialize()))
		Log.info("Saved ground decoration '%s' to '%s'.", name, outputFilename)
	end	
end

function BuildLargeTileSetsApplication:buildMap(layer, map, filename, meta)
	Log.info("Building map '%s'.", filename)

	local game = self:getGame()
	local stage = game:getStage()

	stage:onUnloadMap(layer)
	game:getDirector():setMap(layer, Map())
	stage:onLoadMap(filename, layer, meta.tileSetID, meta.maskID, meta)
	stage:onMapModified(filename, layer)
end

function BuildLargeTileSetsApplication:getLargeTileSets()
	local tileSets = love.filesystem.getDirectoryItems("Resources/Game/TileSets")

	local result = {}
	for _, tileSet in ipairs(tileSets) do
		local largeLayout = string.format("Resources/Game/TileSets/%s/LargeLayout.lua", tileSet)
		if love.filesystem.getInfo(largeLayout) then
			table.insert(result, tileSet)
		end
	end

	return result
end

function BuildLargeTileSetsApplication:saveLargeTile(tileSetID, imageData, i, j, tileName, suffix)
	local directoryName = string.format("Resources/Game/TileSets/%s/Cache", tileSetID)
	love.filesystem.createDirectory(directoryName)
	
	local filename = string.format("%s/%s_%03dx%03d%s.png", directoryName, tileName, i, j, suffix)
	Log.info("Saving '%s'...", filename)
	imageData:encode("png", filename)

	imageData:release()
end

function BuildLargeTileSetsApplication:saveLargeTileSet(tileSetID, largeTileSet)
	local diffuse = largeTileSet:getDiffuseTexture():getResource()
	local outline = largeTileSet:getDiffuseTexture():getHandle():getPerPassTexture(RendererPass.PASS_OUTLINE)
	local specular = largeTileSet:getSpecularTexture():getResource()

	local w, h = largeTileSet:getLargeTileSize()
	local tilesCount = largeTileSet:getLargeTilesCount()

	for layer = 1, tilesCount do
		local name = largeTileSet:getLargeTile(layer)

		for i = 1, w do
			for j = 1, h do
				local atlasIndex = (i - 1) * w + (j - 1)
				local tileIndex = w * h * (layer - 1)
				local index = 2 + tileIndex + atlasIndex

				self:saveLargeTile(tileSetID, diffuse:newImageData(index), i, j, name, "")
				self:saveLargeTile(tileSetID, outline:newImageData(index), i, j, name, "@Outline")
				self:saveLargeTile(tileSetID, specular:newImageData(index), i, j, name, "@Specular")
			end
		end
	end
end

function BuildLargeTileSetsApplication:buildLargeTileSet(layer, tileSetID)
	local game = self:getGame()
	local stage = game:getStage()

	local map = stage:newMap(LargeTileSet.CACHED_MAP_SIZE, LargeTileSet.CACHED_MAP_SIZE, tileSetID, nil, layer, { disableGroundDecorations = true })
	stage:updateMap(layer, map)
end

function BuildLargeTileSetsApplication:saveLayer(layer)
	local game = self:getGame()
	local stage = game:getStage()

	local gameView = self:getGameView()
	local _, tileSetID, largeTileSet = gameView:getMapTileSet(layer)
	if largeTileSet then
		self:saveLargeTileSet(tileSetID, largeTileSet)
	end

	stage:unloadMap(layer)
end

function BuildLargeTileSetsApplication:update(delta)
	EditorApplication.update(self, delta)

	local resources = self:getGameView():getResourceManager()
	local _, n = resources:getIsPending()
	if n == 0 and not self:getGameView():getIsHeavyResourcePending() then
		if self.mapIndex <= #self.maps then
			if self.mapIndex > 0 then
				self:saveMap(self.maps[self.mapIndex].layer, self.maps[self.mapIndex].map, self.maps[self.mapIndex].filename, self.maps[self.mapIndex].meta)
			end

			self.mapIndex = self.mapIndex + 1
			if self.mapIndex <= #self.maps then
				self:buildMap(self.maps[self.mapIndex].layer, self.maps[self.mapIndex].map, self.maps[self.mapIndex].filename, self.maps[self.mapIndex].meta)
			end
		elseif self.tileSetIndex <= #self.largeTileSets then
			local previousLayer = self.tileSetIndex + 1000
			self:saveLayer(previousLayer)

			self.tileSetIndex = self.tileSetIndex + 1
			local currentLayer = self.tileSetIndex + 1000

			if self.tileSetIndex <= #self.largeTileSets then
				self:buildLargeTileSet(currentLayer, self.largeTileSets[self.tileSetIndex])
			end
		else
			love.event.quit()
		end
	end
end

return BuildLargeTileSetsApplication
