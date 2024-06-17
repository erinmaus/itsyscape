--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Noise.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local Noise, Metatable = Class()

function Noise:new(t)
	t = t or {}
	self.offset = t.offset or Vector(0)
	self.scale = t.scale or 1
	self.octaves = t.octaves or 1
	self.attenuation = t.attenuation
end

function Metatable:__call(t)
	t = t or {}

	local r = {
		offset = t.offset or self.offset,
		scale = t.scale or self.scale,
		octaves = t.octaves or self.octaves,
		attenuation = t.attenuation or self.attenuation
	}

	return Noise(r)
end

function Noise:getOffset()
	return self.offset
end

function Noise:getScale()
	return self.scale
end

function Noise:getOctaves()
	return self.octaves
end

function Noise:getAttenuation()
	return self.attenuation
end

function Noise:sample1D(x)
	return self:sample3D(x, 0, 0)
end

function Noise:sample2D(x, y)
	return self:sample3D(x, y, 0)
end

function Noise:sample3D(x, y, z)
	return self:sample4D(x, y, z, 0)
end

function Noise:sample4D(x, y, z, w)
	local result = 0
	local frequency = 1
	local weight = 0
	local scale = self.scale

	for i = 1, self.octaves do
		local multiplier = frequency ^ self.attenuation
		local value = love.math.noise(
			(x + self.offset.x) * scale,
			(y + self.offset.y) * scale,
			(z + self.offset.z) * scale,
			w * scale)

		result = result + (value * multiplier)
		weight = weight + multiplier

		scale = scale / 2
		frequency = frequency / 2
	end

	return result / weight
end

function Noise:sampleTestImage(width, height, tiles, z, w)
	tiles = tiles or 1

	local data = love.image.newImageData(width, height)

	data:mapPixel(function(i, j)
		i = i + 1
		j = j + 1

		local value = self:sample4D(i / (width / tiles), z or 0, j / (height / tiles), w or 0)
		return value, value, value, 1
	end)

	return data
end

Noise.DEFAULT = Noise {
	scale = 32,
	octaves = 2,
	attenuation = 0
}

return Noise
