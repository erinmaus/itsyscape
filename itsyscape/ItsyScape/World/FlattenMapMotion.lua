--------------------------------------------------------------------------------
-- ItsyScape/World/FlattenMapMotion.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MapMotion = require "ItsyScape.World.MapMotion"

FlattenMapMotion = Class(MapMotion)

function FlattenMapMotion:new(size, ...)
	MapMotion.new(self, ...)

	self.size = size - 1
end

function FlattenMapMotion:iterate(func)
	local map = self:getMap()
	local _, i, j = self:getTile()

	for y = -self.size, self.size do
		for x = -self.size, self.size do
			local s = x + i
			local t = y + j

			if s >= 1 and s <= map:getWidth() and
			   t >= 1 and t <= map:getHeight()
			then
				local tile = map:getTile(s, t)
				func(tile, s, t)
			end
		end
	end
end

function FlattenMapMotion:perform(e, distance)
	local min = math.huge
	self:iterate(function(tile)
		min = math.min(
			min,
			tile.topLeft, tile.topRight,
			tile.bottomLeft, tile.bottomRight)
	end)

	local func
	if distance < 0 then
		func = math.min
	else
		func = math.max
	end

	min = min + distance

	self:iterate(function(tile, i, j)
		tile.topLeft = func(min, tile.topLeft)
		tile.topRight = func(min, tile.topRight)
		tile.bottomLeft = func(min, tile.bottomLeft)
		tile.bottomRight = func(min, tile.bottomRight)
	end)
end

return FlattenMapMotion
