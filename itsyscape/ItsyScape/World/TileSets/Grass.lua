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

Grass.SATURATION = 4
Grass.CLUMP_NOISE = Noise {
	scale = 32,
	octaves = 2,
	attenuation = 0
}

Grass.MIN_OFFSET = 0.1
Grass.MAX_OFFSET = 0.3
Grass.OFFSET_NOISE = Noise {
	scale = 8,
	octaves = 2,
	attenuation = -2
}

Grass.MIN_SCALE = 0.75
Grass.MAX_SCALE = 1.00
Grass.SCALE_NOISE = Noise {
	scale = 4,
	octaves = 2,
	attenuation = 0.5
}

Grass.MIN_ROTATION = -math.pi
Grass.MAX_ROTATION = math.pi
Grass.SCALE_NOISE = Noise {
	scale = 10,
	octaves = 3,
	attenuation = 0
}

Grass.DIFFUSE_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Grass%d.png"
Grass.SPECULAR_SAMPLE_FILENAME = "Resources/Game/TileSets/Common/Grass%d@Specular.png"

Grass.NUM_SAMPLES = 3
Grass.SAMPLE_NOISE = Noise {
	scale = 64,
	octaves = 1,
	attenuation = 0
}

Grass.DIFFUSE_BACKGROUND_COLOR = Color.fromHexString("49784d")
Grass.SPECULAR_BACKGROUND_COLOR = Color(0)

Grass.COLORS = {
	Color.fromHexString("4c7a4c"),
	Color.fromHexString("558855"),
	Color.fromHexString("689868")
}
Grass.COLOR_NOISE = Noise {
	offset = Vector(0.5, 0, 0.5),
	scale = 64,
	octaves = 1,
	attenuation = 0
}

function Grass:bind()
	self._DIFFUSE_SAMPLES = {}
	self._SPECULAR_SAMPLES = {}
	for i = 1, self.NUM_SAMPLES do
		local diffuseFilename = string.format(self.DIFFUSE_SAMPLE_FILENAME, i)
		local specularFilename = #self.SPECULAR_SAMPLE_FILENAME >= 1 and string.format(self.SPECULAR_SAMPLE_FILENAME, i)
		self._DIFFUSE_SAMPLES[i] = love.graphics.newImage(diffuseFilename)
		self._SPECULAR_SAMPLES[i] = specularFilename and love.graphics.newImage(diffuseFilename)
	end
end

function Grass._sort(a, b)
	return a.z < b.z
end

function Grass:emit(drawType, tileSet, map, i, j, w, h, tileSetTile, tileSize)
	local grass = {}

	-- Go an extra tile to cover edges shared with other atlas pieces on top/bottom/left/right
	for offsetI = 0, w + 1 do
		for offsetJ = 0, h + 1 do
			local absoluteI = (offsetI - 1) + i
			local absoluteJ = (offsetJ - 1) + j

			for x = 1, self.SATURATION do
				for y = 1, self.SATURATION do
					local deltaX = (x - 1) / (self.SATURATION - 1)
					local deltaY = (y - 1) / (self.SATURATION - 1)
					local noiseX = i + deltaX
					local noiseY = j + deltaY

					local offsetX = self.OFFSET_NOISE:sample3D(noiseX, 0, noiseY)
					local offsetY = self.OFFSET_NOISE:sample3D(noiseX, 1, noiseY)
					local z = self.OFFSET_NOISE:sample3D(noiseX, 2, noiseY)

					local scaleDelta = self.SCALE_NOISE:sample2D(noiseX, noiseY)
					local scale = math.lerp(self.MIN_SCALE, self.MAX_SCALE, scaleDelta)

					local rotationDelta = self.SCALE_NOISE:sample2D(noiseX, noiseY)
					local rotation = math.lerp(self.MIN_ROTATION, self.MAX_ROTATION, rotationDelta)

					local colorIndex = math.floor(self.COLOR_NOISE:sample2D(noiseX, noiseY) * #self.COLORS)
					local color = self.COLORS[math.clamp(colorIndex, 1, #self.COLORS)]

					local sampleIndex = math.floor(self.SAMPLE_NOISE:sample2D(noiseX, noiseY) * #self._DIFFUSE_SAMPLES)
					local diffuseSample = self._DIFFUSE_SAMPLES[math.clamp(sampleIndex, 1, #self._DIFFUSE_SAMPLES)]
					local specularSample = self._SPECULAR_SAMPLES[math.clamp(sampleIndex, 1, #self._DIFFUSE_SAMPLES)]

					table.insert(grass, {
						x = offsetX + noiseX * tileSize,
						y = offsetY + noiseY * tileSize,
						z = z,
						scale = scale,
						rotation = rotation,
						color = color,
						diffuseSample = diffuseSample,
						specularSample = specularSample
					})
				end
			end
		end
	end

	table.sort(grass, self._sort)

	if drawType == "diffuse" then
		love.graphics.clear(self.DIFFUSE_BACKGROUND_COLOR:get())
	elseif drawType == "specular" then
		love.graphics.clear(self.SPECULAR_BACKGROUND_COLOR:get())
	end

	for _, g in ipairs(grass) do
		if drawType == "diffuse" then
			love.graphics.setColor(g.color:get())
			love.graphics.draw(g.diffuseSample, x, y, rotation, scale, scale, g.diffuseSample:getWidth() / 2, g.diffuseFilename:getHeight() / 2)
		elseif drawType == "specular" then
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(g.specularSample, x, y, rotation, scale, scale, g.diffuseSample:getWidth() / 2, g.diffuseFilename:getHeight() / 2)
		end
	end
end

return Grass
