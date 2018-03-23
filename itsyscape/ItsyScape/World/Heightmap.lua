--------------------------------------------------------------------------------
-- ItsyScape/World/Heightmap.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

-- Heightmap type.
--
-- Stores height data. Allows methods for retrieving elevation data.
local Heightmap = Class()

-- Default scale values.
Heightmap.DEFAULT_SCALEXZ = 1.0
Heightmap.DEFAULT_SCALEY = 0.25

-- Constructs a new heightmap from the image at 'filename'.
--
-- 'scaleXZ' and 'scaleY' override 'DEFAULT_SCALEXZ' and 'DEFAULT_SCALEY' if
-- provided.
function Heightmap:new(filename, scaleXZ, scaleY)
	scaleXZ = scaleXZ or Heightmap.DEFAULT_SCALEXZ
	scaleY = scaleY or Heightmap.DEFAULT_SCALEY\

	local imageData = love.image.newImageData(filename)
	do
		self.width = imageData:getWidth()
		self.height = imageData:getHeight()
		self.size = scaleXZ
		self.maxElevation = scaleY

		self.heights = {}
		for j = 1, self.height do
			for i = 1, self.width do
				local r = imageData:getPixel(i - 1, j - 1)
				self.heights[j * self.width + i] = r * scaleY
			end
		end

		imageData:release()
	end
end

-- Creates a debug mesh ready to render with the provided color.
--
-- The color components are expected to be in the range of 0 through 255.
--
-- Returns the debug mesh.
function Heightmap:createDebugMesh(red, green, blue)
	red = red or 255
	green = green or 255
	blue = blue or 255

	local meshFormat = {
		{ "VertexPosition", 'float', 3 },
		{ "VertexColor", 'float', 4 }
	}

	local meshData = {}
	local function addVertex(x, y, z)
		local color = y / self.maxElevation / 2 + 0.5
		local vertex = {
			x, y, z,
			color * red / 255, color * green / 255, color * blue / 255, 1.0
		}

		table.insert(meshData, vertex)
	end

	for j = 0, self.height, 1 do
		for i = 0, self.width, 1 do
			local left = i * self.size
			local right = left + self.size
			local top = j * self.size
			local bottom = top + self.size

			addVertex(left, self:getGridHeight(i, j), top)
			addVertex(right, self:getGridHeight(i + 1, j), top)
			addVertex(right, self:getGridHeight(i + 1, j + 1), bottom)

			addVertex(left, self:getGridHeight(i, j), top)
			addVertex(right, self:getGridHeight(i + 1, j + 1), bottom)
			addVertex(left, self:getGridHeight(i, j + 1), bottom)
		end
	end

	local result = love.graphics.newMesh(meshFormat, meshData, 'triangles', 'static')
	result:setAttributeEnabled("VertexPosition", true)
	result:setAttributeEnabled("VertexColor", true)

	return result
end

-- Returns the height of the point exactly on the grid at (i, j).
--
-- If i or j are outside the bounds of the heightmap, they are clamped to the
-- nearest extent (1 or [size, width]).
--
-- Essentially, this returns heights[i][j].
function Heightmap:getHeight(i, j)
	i = math.floor(i)
	j = math.floor(j)

	if i < 1 then
		i = 1
	elseif i > self.width then
		i = self.width
	end

	if j < 1 then
		j = 1
	elseif j > self.height then
		j = self.height
	end

	return self.heights[j * self.width + i]
end

-- Returns the height (y) of the point at (x, z) on the heightmap.
--
-- The point is scaled down by self.size and the heights of the neighboring
-- tiles are interpolated to produce the height at that exact point.
--
-- Returns the height.
function Heightmap:getHeightAt(x, z)
	-- https://gamedev.stackexchange.com/a/24574
	local i = math.floor(x / self.size)
	local j = math.floor(z / self.size)

	local tz0 = self:getGridHeight(i, j)
	local tz1 = self:getGridHeight(i + 1, j)
	local tz2 = self:getGridHeight(i, j + 1)
	local tz3 = self:getGridHeight(i + 1, j + 1)

	local fractionalX = (x / self.size) - i
	local fractionalZ = (z / self.size) - j
	if fractionalX + fractionalZ < 1 then
		return tz0 + (tz1 - tz0) * fractionalX + (tz2 - tz0) * fractionalZ
	else
		return tz3 + (tz1 - tz3) * (1 - fractionalZ) + (tz2 - tz3) * (1 - fractionalX)
	end

	assert(false)
	return 0.0
end

return Heightmap
