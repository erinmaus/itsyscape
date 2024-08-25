--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/NoiseBuilder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local NoiseBuilder, Metatable = Class()

function NoiseBuilder:new(t)
	t = t or {}
	self.persistence = t.persistence or 1
	self.offset = (t.offset or Vector(0)):keep()
	self.scale = t.scale or 1
	self.octaves = t.octaves or 1
	self.amplitude = 1
	self.lacunarity = t.lacunarity or 0
end

function Metatable:__call(t)
	t = t or {}

	local r = {
		persistence = t.persistence or self.persistence,
		offset = t.offset or self.offset,
		scale = t.scale or self.scale,
		octaves = t.octaves or self.octaves,
		amplitude = t.amplitude or self.amplitude,
		lacunarity = t.lacunarity or self.lacunarity
	}

	return NoiseBuilder(r)
end

function NoiseBuilder:getOffset()
	return self.offset
end

function NoiseBuilder:getPersistence()
	return self.persistence
end

function NoiseBuilder:getFrequency()
	return self.frequency
end

function NoiseBuilder:getScale()
	return self.scale
end

function NoiseBuilder:getOctaves()
	return self.octaves
end

function NoiseBuilder:getAmplitude()
	return self.amplitude
end

function NoiseBuilder:getLacunarity()
	return self.lacunarity
end

function NoiseBuilder:sample1D(x)
	return self:sample3D(x, 0, 0)
end

function NoiseBuilder:sample2D(x, y)
	return self:sample3D(x, y, 0)
end

function NoiseBuilder:sample3D(x, y, z)
	return self:sample4D(x, y, z, 0)
end

function NoiseBuilder:sample4D(x, y, z, w)
	local sum = 0
	local divisor = 1

	for i = 0, self.octaves do
		local octave = (2 + self.lacunarity) ^ i
		local position = octave * (self.scale * (Vector(x, y, z) + self.offset))
		local value = love.math.noise(position.x, position.y, position.z, w)
		local d = (1 / octave * self.persistence)
		value = value * d

		sum = sum + value
		divisor = divisor + d
	end

	return math.max(math.min((sum / divisor), 1), 0)
end

function NoiseBuilder:sampleTestImage(width, height, z, w)
	local data = love.image.newImageData(width, height)

	data:mapPixel(function(i, j)
		i = i + 1
		j = j + 1

		local value = self:sample4D(i / width, z or 0, j / height, w or 0)
		return value, value, value, 1
	end)

	return data
end

NoiseBuilder.DEFAULT = NoiseBuilder()

NoiseBuilder.TERRAIN = NoiseBuilder {
	persistence = 3,
	lacunarity  = -1,
	octaves     = 3,
	scale       = 4
}

NoiseBuilder.TILE = NoiseBuilder {
	persistence = 2,
	lacunarity  = -3,
	octaves     = 2,
	scale       = 2
}

return NoiseBuilder
