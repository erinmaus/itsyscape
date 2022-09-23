--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/DimensionBuilder.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Cell = require "ItsyScape.Game.Skills.Antilogika.Cell"
local DimensionConfig = require "ItsyScape.Game.Skills.Antilogika.DimensionConfig"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"
local Zone = require "ItsyScape.Game.Skills.Antilogika.Zone"
local ZoneMap = require "ItsyScape.Game.Skills.Antilogika.ZoneMap"

local DimensionBuilder = Class()

function DimensionBuilder:new(seed, scale, dimensionConfig)
	self.size = scale * 2 + 1
	self.width = self.size
	self.height = self.size

	self.seed = seed
	self.rng = love.math.newRandomGenerator(seed:toSeed())

	self.dimensionConfig = dimensionConfig or DimensionConfig[1]

	self.zoneNoiseOffset = Vector(0, (self:_randomNoiseOffset()), 0)
	self.zoneNoise = NoiseBuilder.TERRAIN {
		scale = 1 / self.size * NoiseBuilder.TERRAIN:getScale(),
		offset = self.zoneNoiseOffset
	}

	self.param1Offset = Vector(0, (self:_randomNoiseOffset()), 0)
	self.param1Noise = NoiseBuilder.TERRAIN {
		scale = 1 / self.size * NoiseBuilder.TERRAIN:getScale(),
		offset = self.param1Offset
	}

	self.param2Offset = Vector(0, (self:_randomNoiseOffset()), 0)
	self.param2Noise = NoiseBuilder.TERRAIN {
		scale = 1 / self.size * NoiseBuilder.TERRAIN:getScale(),
		offset = self.param2Offset
	}

	self.zoneMap = ZoneMap()
	self.zoneByParamCache = {}

	self:_initializeCells()
end

function DimensionBuilder:_randomNoiseOffset()
	return ((self.rng:random() * 2) - 1) * self.size
end

function DimensionBuilder:_initializeCells()
	self.cells = {}

	for i = 1, self.width do
		for j = 1, self.height do
			local index = (j - 1) * self.width + (i - 1)

			local rng = love.math.newRandomGenerator(
				(2 ^ 32 - 1) * self.rng:random(),
				(2 ^ 32 - 1) * self.rng:random())

			self.cells[index] = Cell(i, j, rng)

			local noiseSample = self.zoneNoise:sample4D(i, 0, j, self.seed:getTime())
			if noiseSample >= self.dimensionConfig.zoneThreshold then
				local param1Sample = self.param1Noise:sample4D(i, self.param1Offset.y, j, self.seed:getTime())
				local param2Sample = self.param2Noise:sample4D(i, self.param2Offset.y, j, self.seed:getTime())
				self.zoneMap:assignZone(i, j, param1Sample, param2Sample)
			end
		end
	end

	local requiredZones = {
		{ i = 1, j = 1 },
		{ i = 1, j = self.height },
		{ i = self.width, j = 1 },
		{ i = self.width, j = self.height }
	}

	for index = 1, #requiredZones do
		local i, j = requiredZones[index].i, requiredZones[index].j

		if not self.zoneMap:hasZone(i, j) then
			local param1Sample = self.param1Noise:sample4D(i, self.param1Offset.y, j, self.seed:getTime())
			local param2Sample = self.param2Noise:sample4D(i, self.param2Offset.y, j, self.seed:getTime())
			self.zoneMap:assignZone(i, j, param1Sample, param2Sample)
		end
	end
end

function DimensionBuilder:getWidth()
	return self.width
end

function DimensionBuilder:getHeight()
	return self.height
end

function DimensionBuilder:getSeed()
	return self.seed
end

function DimensionBuilder:getCell(i, j)
	return self.cells[(j - 1) * self.width + (i - 1)]
end

function DimensionBuilder:getZone(x, z)
	local zoneProperties = self.zoneMap:getZone(x, z)
	if zoneProperties then
		return self:getZoneFromParams(zoneProperties:getParams())
	end

	return self:getZoneFromParams(0, 0)
end

function DimensionBuilder:getZoneFromParams(param1, param2)
	for i = 1, #self.zoneByParamCache do
		local c = self.zoneByParamCache[i]
		if c.param1 == param1 and c.param2 == param2 then
			return c.zone
		end
	end

	local zoneIndex = self.rng:random(1, #self.dimensionConfig.zones)
	local zone = Zone(self.dimensionConfig.zones[zoneIndex])

	table.insert(self.zoneByParamCache, {
		param1 = param1,
		param2 = param2,
		zone = zone
	})

	return zone
end

return DimensionBuilder
