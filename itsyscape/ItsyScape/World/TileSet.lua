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

-- Base tile set class.
--
-- Stores properties for tiles.
TileSet = Class()

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
