--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Zone.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local TileSet = require "ItsyScape.World.TileSet"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

local Zone = Class()
Zone.DEFAULT_CURVE = {
	0.0, 0.0,
	0.5, 0.5,
	1.0, 1.0
}

function Zone:new(t)
	t = t or {}

	self.curve = love.math.newBezierCurve(unpack(t.curve or Zone.DEFAULT_CURVE))
	self.amplitude = t.amplitude or 1
	self.tileSetID = t.tileSetID or "Draft"
	self.bedrockHeight = t.bedrockHeight or 4

	local tileSetFilename = string.format(
		"Resources/Game/TileSets/%s/Layout.lua",
		self.tileSetID)
	self.tileSet = TileSet.loadFromFile(tileSetFilename, false)

	self.tiles = {}
	for i = 1, #(t.tiles or {}) do
		local tileInfo = t.tiles[i]
		table.insert(self.tiles, {
			tile = tileInfo.tile,
			sample = tileInfo.sample or 1
		})
	end

	table.sort(self.tiles, function(a, b)
		return a.sample < b.sample
	end)

	if #self.tiles == 0 then
		table.insert(self.tiles, {
			tile = "grass",
			sample = 1
		})
	end
end

function Zone:getCurve()
	return self.curve
end

function Zone:getAmplitude()
	return self.amplitude
end

function Zone:getTileSetID()
	return self.tileSetID
end

function Zone:getBedrockHeight()
	return self.bedrockHeight
end

function Zone:sample(x, y, z, w)
	local noise = NoiseBuilder.TERRAIN:sample4D(x or 0, y or 0, z or 0, w or 0)
	local clampedNoise = math.min(math.max((noise + 1) / 2, 0), 1)

	return math.abs(self.curve:evaluate(clampedNoise)) * self.amplitude + self.bedrockHeight
end

function Zone:sampleTileFlat(x, y, z, w)
	local noise = NoiseBuilder.TILE:sample4D(x or 0, y or 0, z or 0, w or 0)

	local previousTile = self.tiles[1]
	for i = 2, #self.tiles do
		local tile = self.tiles[i]
		if tile.sample > noise then
			break
		end

		previousTile = tile
	end

	return self.tileSet:getTileIndex(previousTile.tile)
end

return Zone