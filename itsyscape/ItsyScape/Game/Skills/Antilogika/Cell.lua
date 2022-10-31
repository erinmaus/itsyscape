--------------------------------------------------------------------------------
-- ItsyScape/Game/Skills/Antilogika/Cell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"

local Cell = Class()

Cell.MutateMapResult = Class()

function Cell.MutateMapResult:new(t)
	t = t or {}

	self.tileSetIDs = {}

	for key in pairs(t.tileSetIDs) do
		table.insert(self.tileSetIDs, key)
	end

	self.zones = {}
	self.zoneWeights = {}

	for key, weight in pairs(t.zones) do
		table.insert(self.zones, key)
		self.zoneWeights[key] = weight
	end
end

function Cell.MutateMapResult:getTileSetIDs()
	return self.tileSetIDs
end

function Cell.MutateMapResult:getZones()
	return self.zones
end

function Cell.MutateMapResult:getBestZone()
	local bestZone = self.zones[1]
	local bestWeight = self.zoneWeights[bestZone]
	for i = 2, #self.zones do
		local key = self.zones[i]
		local weight = self.zoneWeights[key]

		if weight > bestWeight then
			bestZone = key
			bestWeight = weight
		end
	end

	return bestZone
end

Cell.Anchor = Class()

function Cell.Anchor:new(anchor, neighbor)
	self.anchor = anchor
	self.neighbor = neighbor
end

function Cell.Anchor:getAnchor()
	return self.anchor
end

function Cell.Anchor:getNeighbor()
	return self.neighbor
end

function Cell:new(i, j, rng)
	self.i = i
	self.j = j
	self.rng = rng

	self.neighbors = {}
end

function Cell:getRNG()
	return self.rng
end

function Cell:getPosition()
	return self.i, self.j
end

function Cell:setCivilizationParams(livingScale, populationScale)
	self.livingScale = livingScale
	self.populationScale = populationScale
end

function Cell:getCivilizationParams()
	return self.livingScale, self.populationScale
end

function Cell:addNeighbor(anchor, neighbor)
	for i = 1, #self.neighbors do
		if self.neighbors[i]:getAnchor() == anchor then
			table.remove(self.neighbors, i)
			break
		end
	end

	table.insert(self.neighbors, Cell.Anchor(anchor, neighbor))
end

function Cell:hasNeighbor(anchor)
	for i = 1, #self.neighbors do
		if self.neighbors[i]:getAnchor() == anchor then
			return true
		end
	end

	return false
end

function Cell:iterateNeighbors()
	return ipairs(self.neighbors)
end

function Cell:mutateMap(map, dimensionBuilder)
	local rngState = self.rng:getState()

	local tileSetIDs = {}
	local zones = {}

	for i = 1, map:getWidth() do
		for j = 1, map:getHeight() do
			local x = self.i + (i - 1) / (map:getWidth())
			local z = self.j + (j - 1) / (map:getHeight())

			local zone = dimensionBuilder:getZone(x, z)
			zones[zone] = (zones[zone] or 0) + 1

			local tile = map:getTile(i, j)
			tile.flat = zone:sampleTileFlat(x, z)
			tile.edge = zone:sampleTileEdge(x, z)

			for s = 1, 2 do
				for t = 1, 2 do
					local xOffset = (s - 1) / map:getWidth()
					local zOffset = (t - 1) / map:getHeight()

					local subTileX = x + xOffset
					local subTileZ = z + zOffset

					local subZone = dimensionBuilder:getZone(subTileX, subTileZ)
					local sample = subZone:sample(subTileX, subTileZ)

					tile[tile:getCornerName(s, t)] = sample
					tile.tileSetID = zone:getTileSetID()

					tileSetIDs[zone:getTileSetID()] = true
				end
			end
		end
	end

	self.rng:setState(rngState)

	return Cell.MutateMapResult {
		tileSetIDs = tileSetIDs,
		zones = zones
	}
end

function Cell:populateLights(mapScript, prop, lights)
	for i = 1, #lights do
		local lightConfig = lights[i]

		local light = Utility.spawnPropAtPosition(
			mapScript,
			prop,
			0, 0, 0,
			0)
		local lightPeep = light:getPeep()

		for key, value in pairs(lightConfig) do
			local p = "set" .. key
			if lightPeep[p] then
				lightPeep[p](lightPeep, value)
			end
		end
	end
end

function Cell:populate(mutateMapResult, map, mapScript, dimensionBuilder)
	local rngState = self.rng:getState()

	local zones = mutateMapResult:getZones()

	local contentIDs = {}
	for i = 1, #zones do
		local c = zones[i]:getContent()
		for j = 1, #c do
			table.insert(contentIDs, c[j])
		end
	end

	local contentConfig = dimensionBuilder:buildContentConfig(contentIDs)
	local dimensionConfig = dimensionBuilder:getDimensionConfig()
	local civilization = dimensionBuilder:getCivilizationFromParams(self:getCivilizationParams())

	local relevantContentIDs = {}
	for i = 1, #civilization.content do
		relevantContentIDs[civilization.content[i]] = true
	end

	for i = 1, #dimensionConfig.atmosphere do
		relevantContentIDs[dimensionConfig.atmosphere[i]] = true
	end

	Log.info("Cell (%d, %d) is a '%s' civilization.", self.i, self.j, civilization.id)

	for _, content in ipairs(contentConfig) do
		if relevantContentIDs[content.key] then
			local ConstructorType = require(string.format("ItsyScape.Game.Skills.Antilogika.%sConstructor", content.constructor))
			local constructor = ConstructorType(self, content.config)
			constructor:place(map, mapScript)
		end
	end

	local lightingConfig = mutateMapResult:getBestZone():getLightingConfig()
	self:populateLights(mapScript, "AmbientLight_Default", lightingConfig.ambient or {})
	self:populateLights(mapScript, "DirectionalLight_Default", lightingConfig.directional or {})
	self:populateLights(mapScript, "Fog_Default", lightingConfig.fog or {})

	self.rng:setState(rngState)
end

return Cell
