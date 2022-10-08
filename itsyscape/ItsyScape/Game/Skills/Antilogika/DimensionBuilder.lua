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
local ContentConfig = require "ItsyScape.Game.Skills.Antilogika.ContentConfig"
local DimensionConfig = require "ItsyScape.Game.Skills.Antilogika.DimensionConfig"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"
local Zone = require "ItsyScape.Game.Skills.Antilogika.Zone"
local ZoneMap = require "ItsyScape.Game.Skills.Antilogika.ZoneMap"

local DimensionBuilder = Class()

function DimensionBuilder:new(seed, scale, dimensionConfig, playerConfig)
	self.scale = scale
	self.size = scale * 2 + 1
	self.width = self.size
	self.height = self.size

	self.seed = seed
	self.rng = love.math.newRandomGenerator(seed:toSeed())

	self.dimensionConfig = dimensionConfig or DimensionConfig[1]
	self.playerConfig = playerConfig

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

function DimensionBuilder:getScale()
	return self.scale
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

function DimensionBuilder:buildContentConfig(configIDs)
	-- This also ensures we collapse repeat config IDs into a single occurrence
	-- This makes this method easier to use by just concatenating a list of zone content IDs
	-- into a single list.
	local configIDsByID = {}
	for i = 1, #configIDs do
		configIDsByID[configIDs[i]] = true
	end

	local newConfig = {}
	for i = 1, #ContentConfig do
		local rootConfig = ContentConfig[i]
		if configIDsByID[rootConfig.id] then
			for category, content in pairs(rootConfig.content) do
				local newSubConfig = newConfig[category] or { config = { props = {}, peeps = {} } }

				newSubConfig.constructor = newSubConfig.constructor or content.constructor
				if newSubConfig.constructor ~= content.constructor then
					Log.warn(
						"Content config for '%s' (sub-config '%s') has mismatch constructor ('%s' vs '%s'); might be a problem.",
						rootConfig.id, category, newSubConfig.constructor, content.constructor)
				end

				newSubConfig.config.min = math.min(newSubConfig.config.min or content.config.min or 0, content.config.min or newSubConfig.config.min or 0)
				newSubConfig.config.max = math.max(newSubConfig.config.max or content.config.max or 0, content.config.max or newSubConfig.config.min or 0)

				for j = 1, #content.config.props do
					local propConfig = content.config.props[j]

					local newPropConfig
					for k = 1, #newSubConfig.config.props do
						if newSubConfig.config.props[k].prop == propConfig.prop then
							newPropConfig = newSubConfig.config.props[k]
							break
						end
					end

					if not newPropConfig then
						newPropConfig = { prop = propConfig.prop }

						table.insert(newSubConfig.config.props, newPropConfig)
					end

					newPropConfig.tier = math.min(propConfig.tier, newPropConfig.tier or propConfig.tier)
					newPropConfig.weight = (newPropConfig.weight or 0) + propConfig.weight
				end

				local index = 1
				while index < #newSubConfig.config.props do
					if newSubConfig.config.props[index].weight <= 0 then
						table.remove(newSubConfig.config.props, index)
					else
						index = index + 1
					end
				end

				newConfig[category] = newSubConfig
			end
		end
	end

	return newConfig
end

return DimensionBuilder
