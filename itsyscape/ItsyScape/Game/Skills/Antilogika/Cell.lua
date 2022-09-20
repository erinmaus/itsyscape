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

	local initialZone

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local x = self.i + (i - 1) / (map:getWidth())
			local z = self.j + (j - 1) / (map:getHeight())

			local tile = map:getTile(i, j)
			for s = 1, 2 do
				for t = 1, 2 do
					local xOffset = (s - 1) / map:getWidth()
					local zOffset = (t - 1) / map:getHeight()

					local subTileX = x + xOffset
					local subTileZ = z + zOffset

					local zone = dimensionBuilder:getZone(subTileX, subTileZ)
					local sample = zone:sample(subTileX, subTileZ)

					initialZone = initialZone or zone
					if initialZone ~= zone then
						tile.red = 0.2
						tile.green = 0.2
						tile.blue = 0.2
					end

					tile[tile:getCornerName(s, t)] = sample
					tile.edge = 2
					tile.tileSetID = zone:getTileSetID()
				end
			end
		end
	end

	self.rng:setState(rngState)
end

return Cell
