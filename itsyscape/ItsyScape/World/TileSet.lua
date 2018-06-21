--------------------------------------------------------------------------------
-- ItsyScape/World/TileSet.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

-- Base tile set class.
--
-- Stores properties for tiles.
local TileSet = Class()

-- Loads a TileSet from 'filename'.
--
-- Optionally loads the texture if loadTexture is true.
--
-- Returns the TileSet and the TextureResource.
function TileSet.loadFromFile(filename, loadTexture)
	local t
	do
		local data = "return " .. (love.filesystem.read(filename) or "")
		local chunk = assert(loadstring(data))
		t = setfenv(chunk, {})() or {}
		t.flags = t.flags or {}
	end

	local invertY = false
	if t.flags['invert-y'] then
		invertY = true
	end

	local texture
	if loadTexture and t.texture then
		texture = TextureResource()
		texture:loadFromFile(t.texture)
	end

	local result = TileSet()
	for i = 1, #t do
		local tile = t[i]

		if tile.x and tile.y and tile.width and tile.height and texture then
			if invertY and texture then
				tile.y = texture:getHeight() - (tile.y + tile.height)
			end

			result:setTileProperty(i, 'textureLeft', tile.x / texture:getWidth())
			result:setTileProperty(i, 'textureRight', (tile.x + tile.width) / texture:getWidth())
			result:setTileProperty(i, 'textureTop', tile.y / texture:getHeight())
			result:setTileProperty(i, 'textureBottom', (tile.y + tile.height) / texture:getHeight())
		end

		-- We don't want these keys to propagate below.
		tile.x = nil
		tile.y = nil
		tile.width = nil
		tile.height = nil

		for key, value in pairs(tile) do
			result:setTileProperty(i, key, value)
		end
	end

	return result, texture
end

-- Constructs the tile set.
function TileSet:new()
	self.tiles = {}
end

-- Gets the tile at 'index'.
function TileSet:getTile(index)
	return self.tiles[index]
end

-- Returns true if the tile set has the tile at index, false otherwise.
function TileSet:hasTile(index)
	return self.tiles[index] ~= nil
end

-- Sets a tile property for the tile at the index.
--
-- If no tile exists at the index, one is created.
function TileSet:setTileProperty(index, key, value)
	local tile = self.tiles[index] or {}
	tile[key] = value

	self.tiles[index] = tile
end

-- Gets a tile property for the tile at the index.
--
-- Returns property if set, or 'defaultValue' if unset.
function TileSet:getTileProperty(index, key, defaultValue)
	local tile = self.tiles[index]
	if tile then
		return tile[key] or defaultValue
	else
		return defaultValue
	end
end

-- Returns an iterator over the tiles.
function TileSet:iterateTiles()
	return pairs(self.tiles)
end

return TileSet
