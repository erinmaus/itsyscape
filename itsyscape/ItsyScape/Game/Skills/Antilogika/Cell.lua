--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Cell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local Cell = Class()

Cell.MutateMapResult = Class()

function Cell.MutateMapResult:new(t)
	t = t or {}

	self.tileSetIDs = {}

	for key in pairs(t.tileSetIDs) do
		table.insert(self.tileSetIDs, key)
	end
end

function Cell.MutateMapResult:getTileSetIDs()
	return self.tileSetIDs
end

function Cell:new(i, j, rng)
	self.i = i
	self.j = j
	self.rng = rng
end

function Cell:getPosition()
	return self.i, self.j
end

function Cell:mutateMap(map, dimensionBuilder)
	local rngState = self.rng:getState()

	local tileSetIDs = {}

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local x = self.i + (i - 1) / (map:getWidth())
			local z = self.j + (j - 1) / (map:getHeight())

			local zone = dimensionBuilder:getZone(x, z)

			local tile = map:getTile(i, j)
			local flat = zone:sampleTileFlat(x, z)
			tile.flat = flat
			tile.edge = 2

			for s = 1, 2 do
				for t = 1, 2 do
					local xOffset = (s - 1) / map:getWidth()
					local zOffset = (t - 1) / map:getHeight()

					local subTileX = x + xOffset
					local subTileZ = z + zOffset

					local subZone = dimensionBuilder:getZone(subTileX, subTileZ)
					local sample = subZone:sample(subTileX, subTileZ)

					tile[tile:getCornerName(s, t)] = sample
					tile.tileSetID = zone:getTileSetID()

					tileSetIDs[zone:getTileSetID()] = true
				end
			end
		end
	end

	self.rng:setState(rngState)

	return Cell.MutateMapResult {
		tileSetIDs = tileSetIDs
	}
end

return Cell
