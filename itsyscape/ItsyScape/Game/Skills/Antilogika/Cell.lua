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
	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local x = self.i + (i - 1) / (map:getWidth())
			local z = self.j + (j - 1) / (map:getHeight())

			local zone = dimensionBuilder:getZone(x, y)

			local tile = map:getTile(i, j)
			for s = 1, 2 do
				for t = 1, 2 do
					local xOffset = (s - 1) / map:getWidth()
					local zOffset = (t - 1) / map:getHeight()

					local sample = zone:sample(x + xOffset, 0, z + zOffset)

					tile[tile:getCornerName(s, t)] = sample
				end
			end
		end
	end
end

return Cell
