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

Noise.UniformSampler = Class()

function Noise.UniformSampler:new(noise)
	self.noise = noise
	self.samples = {}
	self.cache = {}
end

function Noise.UniformSampler:sample1D(x)
	return self:sample4D(x, 0, 0, 0)
end

function Noise.UniformSampler:sample2D(x, y)
	return self:sample4D(x, y, 0, 0)
end

function Noise.UniformSampler:sample3D(x, y, z)
	return self:sample4D(x, y, z, 0)
end

function Noise.UniformSampler:sample4D(x, y, z, w)
	local value = self.noise:sample4D(x, y, z, w)

	self.min = math.min(value, self.min or value)
	self.max = math.max(value, self.max or value)

	self:_add(x, y, z, w, value)

	return value
end

function Noise.UniformSampler:_add(x, y, z, w, value)
	local xCache = self.cache[x] or {}
	local yCache = xCache[y] or {}
	local zCache = yCache[z] or {}
	local wCache = zCache[w] or false

	if not wCache then
		zCache[w] = true
		yCache[z] = zCache
		xCache[y] = yCache
		self.cache[x] = xCache

		table.insert(self.samples, value)
		self.isDirty = true
	end
end

function Noise.UniformSampler:uniform(value)
	if true and self.min and self.max then
		return (value - self.min) / (self.max - self.min)
	end

	if self.isDirty then
		table.sort(self.samples)
		self.isDirty = false
	end

	if #self.samples > 1 then
		local low = 1
		local high = #self.samples
		local mid
		local index

		local iterations = 0

		while low <= high do
			iterations = iterations + 1
			mid = low + math.ceil((high - low) / 2)
			if self.samples[mid] == value then
				index = mid
				break
			elseif self.samples[mid] < value then
				low = mid + 1
			else
				high = mid - 1
			end
		end

		if not index then
			index = mid -- Close enough.
		end

		return (index - 1) / (#self.samples - 1)
	end

	return 1
end

function Noise.UniformSampler:range(value, a, b)
	local max = b or a
	local min = not b and 1 or a

	local result = self:uniform(value)
	return result * (max - min) + min
end

function Noise.UniformSampler:index(value, a, b)
	return math.floor(self:range(value, a, b))
end

function Noise:new(t)
	t = t or {}
	self.offset = (t.offset or Vector(0)):keep()
	self.scale = t.scale or 1
	self.octaves = t.octaves or 1
	self.attenuation = t.attenuation or 0
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
