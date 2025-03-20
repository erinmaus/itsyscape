--------------------------------------------------------------------------------
-- ItsyScape/BuildLargeTileSetsApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local EditorApplication = require "ItsyScape.Editor.EditorApplication"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local LargeTileSet = require "ItsyScape.World.LargeTileSet"

local BuildLargeTileSetsApplication = Class(EditorApplication)

function BuildLargeTileSetsApplication:new()
	EditorApplication.new(self)

	self.largeTileSets = self:getLargeTileSets()
	self.index = 0
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
	local directoryName = string.format("Resources/Game/Tilesets/%s/Cache", tileSetID)
	love.filesystem.createDirectory(directoryName)

	local filename = string.format("%s/%s_%03dx%03d%s.png", directoryName, tileName, i, j, suffix)
	imageData:encode("png", filename)

	imageData:release()
end

function BuildLargeTileSetsApplication:saveLargeTileSet(tileSetID, largeTileSet)
	local diffuse = largeTileSet:getDiffuseTexture():getResource()
	local outline = largeTileSet:getDiffuseTexture():getHandle():getPerPassTexture(RendererPass.PASS_OUTLINE)
	local specular = largeTileSet:getDiffuseTexture():getResource()

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

	local map = stage:newMap(LargeTileSet.CACHED_MAP_SIZE, LargeTileSet.CACHED_MAP_SIZE, tileSetID, nil, layer)
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
	if not resources:getIsPending() then
		local previousLayer = self.index + 100
		self:saveLayer(previousLayer)

		self.index = self.index + 1
		local currentLayer = self.index + 100

		if self.index <= #self.largeTileSets then
			self:buildLargeTileSet(currentLayer, self.largeTileSets[self.index])
		else
			love.event.quit()
		end
	end
end

return BuildLargeTileSetsApplication
