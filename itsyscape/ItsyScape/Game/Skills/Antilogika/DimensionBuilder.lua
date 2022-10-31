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
local BuildingAnchor = require "ItsyScape.Game.Skills.Antilogika.BuildingAnchor"
local Cell = require "ItsyScape.Game.Skills.Antilogika.Cell"
local CivilizationContentConfig = require "ItsyScape.Game.Skills.Antilogika.CivilizationContentConfig"
local ContentConfig = require "ItsyScape.Game.Skills.Antilogika.ContentConfig"
local DimensionConfig = require "ItsyScape.Game.Skills.Antilogika.DimensionConfig"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"
local Zone = require "ItsyScape.Game.Skills.Antilogika.Zone"
local ZoneMap = require "ItsyScape.Game.Skills.Antilogika.ZoneMap"

local DimensionBuilder = Class()
DimensionBuilder.CONNECT_ITERATIONS = 2

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

	self.livingScaleOffset = Vector(
		self:_randomNoiseOffset(),
		0,
		self:_randomNoiseOffset())
	self.livingNoise = NoiseBuilder.TERRAIN {
		offset = self.livingScaleOffset
	}

	self.populationScaleOffset = Vector(
		self:_randomNoiseOffset(),
		0,
		self:_randomNoiseOffset())
	self.populationNoise = NoiseBuilder.TERRAIN {
		offset = self.populationScaleOffset
	}

	self.zoneMap = ZoneMap()
	self.zoneByParamCache = {}

	self:_initializeCells()
end

function DimensionBuilder:getDimensionConfig()
	return self.dimensionConfig
end

function DimensionBuilder:_randomNoiseOffset()
	return ((self.rng:random() * 2) - 1)
end

function DimensionBuilder:_queueNeighbors(cellIndex, queue)
	local cell = self.cells[cellIndex]

	local i, j = cell:getPosition()

	local neighbors = {}
	if i > 1 then
		table.insert(neighbors, self:_getCellIndex(i - 1, j))
	end

	if i < self.width then
		table.insert(neighbors, self:_getCellIndex(i + 1, j))
	end

	if j > 1 then
		table.insert(neighbors, self:_getCellIndex(i, j - 1))
	end

	if j < self.height then
		table.insert(neighbors, self:_getCellIndex(i, j + 1))
	end

	while #neighbors > 0 do
		table.insert(queue, {
			a = cellIndex,
			b = table.remove(neighbors, self.rng:random(#neighbors))
		})
	end
end

function DimensionBuilder:_connectCell(parentIndex, childIndex)
	local parent = self.cells[parentIndex]
	local child = self.cells[childIndex]

	if not parent or not child then
		return
	end

	local parentI, parentJ = parent:getPosition()
	local childI, childJ = child:getPosition()

	if parentI < childI then
		parent:addNeighbor(BuildingAnchor.RIGHT, child)
		child:addNeighbor(BuildingAnchor.LEFT, parent)
	elseif parentI > childI then
		parent:addNeighbor(BuildingAnchor.LEFT, child)
		child:addNeighbor(BuildingAnchor.RIGHT, parent)
	elseif parentJ < childJ then
		parent:addNeighbor(BuildingAnchor.FRONT, child)
		child:addNeighbor(BuildingAnchor.BACK, parent)
	elseif parentJ > childJ then
		parent:addNeighbor(BuildingAnchor.BACK, child)
		child:addNeighbor(BuildingAnchor.FRONT, parent)
	end
end

function DimensionBuilder:_connectCells()
	local queue = { { a = 0, b = self:_getCellIndex(1, 1) } }
	local visited = {}
	while #queue > 0 do
		local q = table.remove(queue, 1)
		if not visited[q.b] then
			self:_connectCell(q.a, q.b)
			self:_queueNeighbors(q.b, queue)

			visited[q.b] = true
		end
	end
end

function DimensionBuilder:_initializeCells()
	self.cells = {}

	local minLivingScale, maxLivingScale = math.huge, -math.huge
	local minPopulationScale, maxPopulationScale = math.huge, -math.huge

	for i = 1, self.width do
		for j = 1, self.height do
			local index = self:_getCellIndex(i, j)

			local rng = love.math.newRandomGenerator(
				(2 ^ 32 - 1) * self.rng:random(),
				(2 ^ 32 - 1) * self.rng:random())

			local livingScale = self.livingNoise:sample4D(i / self.width, 0, j / self.height)
			local populationScale = self.populationNoise:sample4D(i / self.width, 0, j / self.height)

			minLivingScale = math.min(livingScale, minLivingScale)
			maxLivingScale = math.max(livingScale, maxLivingScale)
			minPopulationScale = math.min(livingScale, minPopulationScale)
			maxPopulationScale = math.max(livingScale, maxPopulationScale)

			local cell = Cell(i, j, rng)
			cell:setCivilizationParams(livingScale, populationScale)

			self.cells[index] = cell

			local noiseSample = self.zoneNoise:sample4D(i, 0, j, self.seed:getTime())
			if noiseSample >= self.dimensionConfig.zoneThreshold then
				local param1Sample = self.param1Noise:sample4D(i, self.param1Offset.y, j, self.seed:getTime())
				local param2Sample = self.param2Noise:sample4D(i, self.param2Offset.y, j, self.seed:getTime())
				self.zoneMap:assignZone(i, j, param1Sample, param2Sample)
			end
		end
	end

	for i = 1, self.width do
		for j = 1, self.height do
			local index = self:_getCellIndex(i, j)
			local cell = self.cells[index]

			local livingScale, populationScale = cell:getCivilizationParams()
			livingScale = ((livingScale - minLivingScale) / (maxLivingScale - minLivingScale)) * 2 - 1
			populationScale = ((populationScale - minPopulationScale) / (maxPopulationScale - minPopulationScale)) * 2 - 1

			cell:setCivilizationParams(livingScale, populationScale)
		end
	end

	for i = 1, self.CONNECT_ITERATIONS do
		self:_connectCells()
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

function DimensionBuilder:_getCellIndex(i, j)
	return (j - 1) * self.width + (i - 1)
end

function DimensionBuilder:getCell(i, j)
	return self.cells[self:_getCellIndex(i, j)]
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

function DimensionBuilder:getCivilizationFromParams(livingScale, populationScale)
	local bestDistance = math.huge
	local bestCivilization
	for i = 1, #CivilizationContentConfig do
		local civilization = CivilizationContentConfig[i]
		local distance = (Vector(livingScale, populationScale) - Vector(civilization.livingScale, civilization.populationScale)):getLengthSquared()
		if distance <= bestDistance then
			bestDistance = distance
			bestCivilization = civilization
		end
	end

	return bestCivilization
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
				local newSubConfig = newConfig[category] or { config = {} }

				newSubConfig.constructor = newSubConfig.constructor or content.constructor
				if newSubConfig.constructor ~= content.constructor then
					Log.warn(
						"Content config for '%s' (sub-config '%s') has mismatch constructor ('%s' vs '%s'); might be a problem.",
						rootConfig.id, category, newSubConfig.constructor, content.constructor)
				end

				newSubConfig.config.min = math.min(newSubConfig.config.min or content.config.min or 0, content.config.min or newSubConfig.config.min or 0)
				newSubConfig.config.max = math.max(newSubConfig.config.max or content.config.max or 0, content.config.max or newSubConfig.config.min or 0)
				newSubConfig.priority = content.priority or newSubConfig.priority

				for key, values in pairs(content.config) do
					if type(values) == 'table' then
						newSubConfig.config[key] = newSubConfig.config[key] or {}

						for j = 1, #content.config[key] do
							local valueConfig = content.config[key][j]

							local newValueConfig
							for k = 1, #newSubConfig.config[key] do
								if newSubConfig.config[key][k].resource == valueConfig.resource then
									newValueConfig = newSubConfig.config[key][k]
									break
								end
							end

							if not newValueConfig then
								newValueConfig = { resource = valueConfig.resource }

								table.insert(newSubConfig.config[key], newValueConfig)
							end

							newValueConfig.tier = math.min(valueConfig.tier or 1, newValueConfig.tier or valueConfig.tier or 1)
							newValueConfig.weight = (newValueConfig.weight or 0) + valueConfig.weight
							newValueConfig.props = newValueConfig.props or valueConfig.props or {}
						end

						local index = 1
						while index < #newSubConfig.config[key] do
							if newSubConfig.config[key][index].weight <= 0 then
								table.remove(newSubConfig.config[key], index)
							else
								index = index + 1
							end
						end
					end
				end

				newConfig[category] = newSubConfig
			end
		end
	end

	local newSortedConfig = {}
	for key, content in pairs(newConfig) do
		table.insert(newSortedConfig, content)
		content.key = key
	end

	table.sort(newSortedConfig, function(a, b)
		return (a.priority or math.huge) < (b.priority or math.huge)
	end)

	return newSortedConfig
end

return DimensionBuilder
