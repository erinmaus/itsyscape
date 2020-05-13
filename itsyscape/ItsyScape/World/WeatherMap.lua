--------------------------------------------------------------------------------
-- ItsyScape/World/WeatherMao.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local ffi = require "ffi"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"

local WeatherMap = Class()

function WeatherMap:new(layer, i, j, cellSize, width, height)
	self.maps = {}

	self.layer = layer
	self.realI = i or 1
	self.realJ = j or 1
	self.realWidth = width or 1
	self.realHeight = height or 1
	self.i = 1
	self.j = 1
	self.width = (self.realWidth - self.realI)
	self.height = (self.realHeight - self.realJ)
	self.cellSize = cellSize or 2
	self.position = Vector(0, 0, 0)
	self.isDirty = true

	self.tiles = false
end

function WeatherMap:getCellSize()
	return self.cellSize
end

function WeatherMap:getPosition()
	return self.realI, self.realJ
end

function WeatherMap:getSize()
	return self.realWidth, self.realHeight
end

function WeatherMap:move(i, j)
	self.i = i or self.i
	self.j = j or self.j
	self.isDirty = true
end

function WeatherMap:resize(width, height)
	self.width = width or self.width
	self.height = height or self.height
	self.isDirty = true
end

function WeatherMap:getAbsolutePosition()
	return self.position
end

function WeatherMap:setAbsolutePosition(position)
	self.position = position or value
end

function WeatherMap:addMap(map)
	if not self.maps[map] then
		self.maps[map] = {
			translation = Vector(0),
			rotation = Quaternion(0),
			scale = Vector(1)
		}
	end

	-- This lets us know the map data was updated.
	if self.maps[map] then
		self.isDirty = true
	end
end

function WeatherMap:removeMap(map)
	if map and self.maps[map] then
		self.maps[map] = nil
		self.isDirty = true
	end
end

function WeatherMap:updateMap(map, translation, rotation, scale)
	translation = translation or Vector(0)
	rotation = rotation or Quaternion(0)
	scale = scale or Scale(1)

	local transform = self.maps[map]
	if transform then
		if transform.translation.x ~= translation.x or
		   transform.translation.y ~= translation.y or
		   transform.translation.z ~= translation.z or
		   transform.rotation.x    ~= rotation.x    or
		   transform.rotation.y    ~= rotation.y    or
		   transform.rotation.z    ~= rotation.z    or
		   transform.rotation.w    ~= rotation.w    or
		   transform.scale.x       ~= scale.x       or
		   transform.scale.y       ~= scale.y       or
		   transform.scale.z       ~= scale.z
		then
			transform.translation = translation
			transform.rotation = rotation
			translation.scale = scale
			self.isDirty = true
		end
	end
end

function WeatherMap:update()
	if self.isDirty then
		self.tiles = ffi.new("float[?]", self.width * self.height, -math.huge)

		local t = self.tiles
		local transform = love.math.newTransform()

		for map, mapTransform in pairs(self.maps) do
			do
				local r = mapTransform.rotation
				local s = mapTransform.scale
				local t = mapTransform.translation

				transform:reset()
				transform:translate(t.x, t.y, t.z)
				transform:applyQuaternion(r.x, r.y, r.z, r.w)
				transform:scale(s.x, s.y, s.z)
			end

			for j = 0, self.height - 1 do
				for i = 0, self.width - 1 do
					local center = map:getTileCenter(i + self.realI, j + self.realJ)
					center = Vector(transform:transformPoint(center:get()))

					local index = j * self.width + i

					local y = center.y
					if map:getTile(i, j):hasFlag("building") then
						y = math.huge
					end

					t[index] = y
				end
			end
		end

		self.isDirty = false
	end
end

function WeatherMap:getHeightAt(i, j)
	if self.isDirty then
		self:update()
	end

	i = i - self.realI
	j = j - self.realJ

	local max = self.width * self.height
	local index = j * self.width + i
	if index >= 0 and index < max then
		return self.tiles[index]
	end

	return math.huge
end

return WeatherMap
