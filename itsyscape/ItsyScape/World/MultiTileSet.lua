--------------------------------------------------------------------------------
-- ItsyScape/World/MultiTileSet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local LayerTextureResource = require "ItsyScape.Graphics.LayerTextureResource"
local TileSet = require "ItsyScape.World.TileSet"

MultiTileSet = Class()

function MultiTileSet:new(tileSetIDs)
	self.tileSetIDs = {}
	self.tileSets = {}
	self.tileSetIDToLayer = {}

	local filenames = {}
	for i = 1 , #tileSetIDs do
		local tileSetID = tileSetIDs[i] or "GrassyPlain"

		table.insert(self.tileSetIDs, tileSetID)

		local tileSetFilename = string.format("Resources/Game/TileSets/%s/Layout.lua", tileSetID)
		local tileSet = TileSet.loadFromFile(tileSetFilename, true)

		if self.tileSets[tileSetID] then
			Log.warn("Duplicate tile set ID '%s' at index %d.", tileSetID, i)
		else
			self.tileSets[tileSetID] = tileSet
			self.tileSetIDToLayer[tileSetID] = i

			table.insert(filenames, tileSet:getTextureFilename())
		end
	end

	self.multiTexture = LayerTextureResource(love.graphics.newArrayImage(filenames))
end

function MultiTileSet:getNumTileSets()
	return #self.tileSetIDs
end

function MultiTileSet:getTileSetByIndex(index)
	return self.tileSets[self.tileSetIDs[index]]
end

function MultiTileSet:getTileSetByID(tileSetID)
	return self.tileSets[tileSetID] or self.tileSets[self.tileSetIDs[1]]
end

function MultiTileSet:getTileSetLayerByID(tileSetID)
	return self.tileSetIDToLayer[tileSetID]
end

function MultiTileSet:getMultiTexture()
	return self.multiTexture
end

return MultiTileSet
