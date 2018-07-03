--------------------------------------------------------------------------------
-- ItsyScape/World/HillMapMotion.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local MapMotion = require "ItsyScape.World.MapMotion"

HillMapMotion = Class(MapMotion)

function HillMapMotion:endPerform(e)
	self.direction = 0
end

-- Raises the corner of a tile. Default action.
function HillMapMotion:perform(e, distance)
	local tile, i, j = self:getTile()

	local min = math.min(
		tile.topLeft, tile.topRight,
		tile.bottomLeft, tile.bottomRight)

	local func, direction
	if distance < 0 then
		func = math.min
		direction = 0
	else
		func = math.max
		direction = 1
	end

	if self.direction ~= direction then
		if direction > 0 and
		   love.keyboard.isDown('lctrl') or
		   love.keyboard.isDown('rctrl')
		then
			self.start = 0
		else
			self.start = math.min(
				tile.topLeft, tile.topRight,
				tile.bottomLeft, tile.bottomRight)
		end

		self.direction = direction
	end

	min = min + distance
	tile.topLeft = func(min, tile.topLeft)
	tile.topRight = func(min, tile.topRight)
	tile.bottomLeft = func(min, tile.bottomLeft)
	tile.bottomRight = func(min, tile.bottomRight)

	if min == tile.topRight and min == tile.topRight and
	   min == tile.bottomLeft and min == tile.bottomRight or true
	then
		local stop
		if distance < 0 then
			stop = math.abs(min - self.start)
		else
			stop = min - self.start + 1
		end

		local length = min * 2 + 1
		local left = i - stop
		local top = j - stop

		for k = 0, stop do
			if distance > 0 then
				elevation = k
			else
				elevation = -k + 1
			end

			for currentStep = 1, 2 do
				local currentLength = (stop - k + 1) * 2 - currentStep
				local width = currentLength * 2
				local currentLeft = i * 2 - currentLength
				local currentTop = j * 2 - currentLength
				local stepElevation
				if distance < 0 then
					stepElevation = elevation - currentStep + 1 + (self.start - 1)
				else
					stepElevation = elevation + currentStep - 1 + (self.start - 1)
				end

				self:rectangle(
					currentLeft, currentTop,
					width, width,
					func, stepElevation)
			end
		end
	end
end

function HillMapMotion:raiseCorner(x, y, func, elevation)
	local map = self:getMap()
	local i = math.floor((x - 1) / 2) + 1
	local j = math.floor((y - 1) / 2) + 1
	local s = (x - (i - 1) * 2)
	local t = (y - (j - 1) * 2)

	if i >= 1 and i <= map:getWidth() and
	   j >= 1 and j <= map:getHeight()
	then
		local tile = map:getTile(i, j)
		local e = tile:getCorner(s, t)
		tile:setCorner(s, t, func(elevation, e))
	end
end

function HillMapMotion:rectangle(x, y, width, height, func, elevation)
	for i = 1, width do
		local s = i + x - 1
		local t1 = y
		local t2 = y + height - 1

		self:raiseCorner(s, t1, func, elevation)
		self:raiseCorner(s, t2, func, elevation)
	end

	for j = 1, height do
		local t = j + y - 1
		local s1 = x
		local s2 = x + width - 1

		self:raiseCorner(s1, t, func, elevation)
		self:raiseCorner(s2, t, func, elevation)
	end
end

return HillMapMotion
