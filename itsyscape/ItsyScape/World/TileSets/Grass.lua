--------------------------------------------------------------------------------
-- ItsyScape/World/TileSets/Grass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Noise = require "ItsyScape.Graphics.Noise"
local Block = require "ItsyScape.World.TileSets.Block"

local Grass = Class(Block)

Grass.GLOBAL_OFFSET = Vector(174 / 257)

Grass.SATURATION = 4
Grass.CLUMP_NOISE = Noise {
	scale = 32,
	octaves = 2,
	attenuation = 0
}

Grass.MIN_OFFSET = -16
Grass.MAX_OFFSET = 16
Grass.OFFSET_NOISE = Noise {
	scale = 8,
	octaves = 2,
	attenuation = -2
}

Grass.MIN_SCALE = 0.5
Grass.MAX_SCALE = 1.0
Grass.SCALE_NOISE = Noise {
	scale = 3,
	octaves = 2,
	attenuation = 0.5
}

Grass.MIN_ROTATION = -math.pi
Grass.MAX_ROTATION = math.pi
Grass.ROTATION_NOISE = Noise {
	scale = 3,
	octaves = 3,
	attenuation = 0
}

Grass.DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Grass%d.png"
Grass.SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Grass%d@Specular.png"
Grass.OUTLINE_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Grass%d@Outline.png"
Grass.DIRT_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Dirt%d.png"

Grass.NUM_SAMPLES = 3
Grass.SAMPLE_NOISE = Noise {
	scale = 123,
	octaves = 1,
	attenuation = 0
}

Grass.DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("5c4b40")
Grass.SPECULAR_BACKGROUND_COLOR = Color(0)

Grass.COLORS = {
	Color.fromHexString("558855"),
	Color.fromHexString("4c7a4c"),
	Color.fromHexString("5d805e"),
	Color.fromHexString("4f7252"),
	Color.fromHexString("49784d"),
	Color.fromHexString("3e6d3a"),
}

Grass.NUM_DIRT_SAMPLES = 3
Color.DIRT_COLORS = {
	Color.fromHexString("876f6d"),

}

Grass.COLOR_NOISE = Noise {
	offset = Vector(0.5, 0, 0.5),
	scale = 123,
	octaves = 1,
	attenuation = 0
}

function Grass:bind()
	self._DIFFUSE_SAMPLES = {}
	self._SPECULAR_SAMPLES = {}
	self._OUTLINE_SAMPLES = {}
	for i = 1, self.NUM_SAMPLES do
		local diffuseFilename = string.format(self.DIFFUSE_SAMPLE_FILENAME, i)
		local specularFilename = #self.SPECULAR_SAMPLE_FILENAME >= 1 and string.format(self.SPECULAR_SAMPLE_FILENAME, i)
		local outlineFilename = #self.OUTLINE_SAMPLE_FILENAME >= 1 and string.format(self.OUTLINE_SAMPLE_FILENAME, i)
		self._DIFFUSE_SAMPLES[i] = love.graphics.newImage(diffuseFilename)
		self._SPECULAR_SAMPLES[i] = specularFilename and love.graphics.newImage(specularFilename)
		self._OUTLINE_SAMPLES[i] = outlineFilename and love.graphics.newImage(outlineFilename)
	end

	self._colors = Noise.UniformSampler(self.COLOR_NOISE)
	self._samples = Noise.UniformSampler(self.SAMPLE_NOISE)
	self._scales = Noise.UniformSampler(self.SCALE_NOISE)
	self._rotations = Noise.UniformSampler(self.ROTATION_NOISE)
	self._offsets = Noise.UniformSampler(self.OFFSET_NOISE)
	self._cache = {}
end

function Grass._sort(a, b)
	return a.z < b.z
end

function Grass:_getCacheIndex(i, j, w, h, x, y)
	return (j - 1) * w + (i - 1) + 1, (y - 1) * self.SATURATION + (x - 1) + 1
end

function Grass:_addCache(i, j, w, h, x, y, g)
	local index1, index2 = self:_getCacheIndex(i, j, w, h, x, y)

	local c = self._cache[index1] or {}
	assert(not c[index2])

	c[index2] = g
	self._cache[index1] = c
end

function Grass:_getCache(i, j, w, h, x, y)
	local index1, index2  = self:_getCacheIndex(i, j, w, h, x, y)
	return self._cache[index1] and self._cache[index1][index2]
end

function Grass:cache(map, i, j, w, h, tileSize)
	for currentI = 1, map:getWidth() do
		for currentJ = 1, map:getHeight() do
			local rng = love.math.newRandomGenerator(currentI, currentJ)

			for x = 1, self.SATURATION do
				for y = 1, self.SATURATION do
					local tileX = (x - 1) / (self.SATURATION - 1)
					local tileY = (y - 1) / (self.SATURATION - 1)
					local deltaX = (currentI - 1) / w
					local deltaY = (currentJ - 1) / h
					local noiseX = deltaX + tileX / map:getWidth()
					local noiseY = deltaY + tileY / map:getHeight()

					local offsetX = self._offsets:sample3D(noiseX, noiseY, 1)
					local offsetY = self._offsets:sample3D(noiseX, noiseY, 2)
					local z = rng:random()

					local scale = self._scales:sample2D(noiseX, noiseY)
					local rotation = self._rotations:sample2D(noiseX, noiseY)
					local color = self._colors:sample2D(noiseX, noiseY)
					local sample = self._samples:sample2D(noiseX, noiseY)


					local g = {
						i = currentI * self.SATURATION + x,
						j = currentJ * self.SATURATION + y,
						x = (currentI + tileX) * tileSize,
						y = (currentJ + tileY) * tileSize,
						offsetX = offsetX,
						offsetY = offsetY,
						z = z,
						scale = scale,
						rotation = rotation,
						color = color,
						sample = sample
					}

					self:_addCache(currentI, currentJ, map:getWidth(), map:getHeight(), x, y, g)
				end
			end
		end
	end
end

function Grass:emit(drawType, tileSet, map, i, j, w, h, tileSetTile, tileSize)
	if drawType == "cache" then
		self:cache(map, i, j, w, h, tileSize)
		return
	end

	local grass = {}
	-- Go an extra tile to cover edges shared with other atlas pieces on top/bottom/left/right
	for offsetI = -1, w + 2 do
		for offsetJ = -1, h + 2 do
			for x = 1, self.SATURATION do
				for y = 1, self.SATURATION do
					local currentI = offsetI + i
					local currentJ = offsetJ + j

					if currentI >= 1 and currentJ >= 1 and currentI <= map:getWidth() and currentJ <= map:getHeight() then
						local g = self:_getCache(currentI, currentJ, map:getWidth(), map:getHeight(), x, y)
						assert(g)
						table.insert(grass, g)
					end
				end
			end
		end
	end

	table.sort(grass, Grass._sort)

	if drawType == "diffuse" then
		love.graphics.clear(self.DIFFUSE_BACKGROUND_COLOR:get())
	elseif drawType == "specular" then
		love.graphics.clear(self.SPECULAR_BACKGROUND_COLOR:get())
	end

	for _, g in ipairs(grass) do
		local scale = self._scales:range(g.scale, self.MIN_SCALE, self.MAX_SCALE)
		local rotation = self._rotations:range(g.rotation, self.MIN_ROTATION, self.MAX_ROTATION)
		local x = g.x + self._offsets:range(g.offsetX, self.MIN_OFFSET, self.MAX_OFFSET)
		local y = g.y + self._offsets:range(g.offsetY, self.MIN_OFFSET, self.MAX_OFFSET)

		if drawType == "diffuse" then
			local diffuseSample = self._DIFFUSE_SAMPLES[self._samples:index(g.sample, #self._DIFFUSE_SAMPLES)]
			local color = self.COLORS[self._colors:index(g.color, #self.COLORS)]
			if diffuseSample then
				love.graphics.setColor(color:get())
				love.graphics.draw(diffuseSample, x, y, rotation, scale, scale, diffuseSample:getWidth() / 2, diffuseSample:getHeight() / 2)
			end
		elseif drawType == "specular" then
			local specularSample = self._SPECULAR_SAMPLES[self._samples:index(g.sample, #self._SPECULAR_SAMPLES)]
			if specularSample then
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(specularSample, x, y, rotation, scale, scale, specularSample:getWidth() / 2, specularSample:getHeight() / 2)
			end
		elseif drawType == "outline" then
			local outlineSample = self._OUTLINE_SAMPLES[self._samples:index(g.sample, #self._OUTLINE_SAMPLES)]
			if outlineSample then
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.draw(outlineSample, x, y, rotation, scale, scale, outlineSample:getWidth() / 2, outlineSample:getHeight() / 2)
			end
		end
	end
end

return Grass