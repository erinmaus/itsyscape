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
local NVoronoiPointsBuffer = require "nbunny.world.voronoipointsbuffer"
local NVoronoiDiagram = require "nbunny.world.voronoidiagram"

local ZoneMap = Class()

ZoneMap.Properties = Class()
function ZoneMap.Properties:new(i, j, param1, param2)
	self.i = i
	self.j = j
	self.param1 = param1
	self.param2 = param2
end

function ZoneMap.Properties:getPosition()
	return self.i, self.j
end

function ZoneMap.Properties:getParams()
	return self.param1, self.param2
end

function ZoneMap.Properties:_setPolygon(value)
	self._polygon = value
end

function ZoneMap.Properties:contains(x, z)
	if self._polygon then
		return self._polygon:inside(x, z)
	end

	return false
end

function ZoneMap:new()
	self.zones = {}
	self.isDirty = false
end

function ZoneMap:hasZone(i, j)
	return self:getZoneProperties(i, j) ~= nil
end

function ZoneMap:getZoneProperties(i, j)
	for i = 1, #self.zones do
		local zone = self.zones[i]
		local zoneI, zoneJ = zone:getPosition()
		if zoneI == i and zoneJ == j then
			return zone
		end
	end

	return nil
end

function ZoneMap:iterateZones()
	return ipairs(self.zones)
end

function ZoneMap:assignZone(i, j, param1, param2)
	if self:hasZone(i, j) then
		Log.error("Zone exists for (%d, %d); cannot create another.", i, j)
		return
	end

	table.insert(self.zones, ZoneMap.Properties(i, j, param1, param2))
	self.isDirty = true
end

function ZoneMap:getZone(x, z)
	if self.isDirty then
		self:_buildVoronoi()
	end

	for _, zone in self:iterateZones() do
		if zone:contains(x, z) then
			return zone
		end
	end

	return nil
end

function ZoneMap:_buildVoronoi()
	self._points = NVoronoiPointsBuffer(#self.zones)
	for index, zone in self:iterateZones() do
		self._points:set(index - 1, zone:getPosition())
	end

	self._diagram = NVoronoiDiagram(self._points)

	for i = 1, self._diagram:getNumPolygons() do
		local polygonIndex = i - 1
		local polygon = self._diagram:getPolygonAtIndex(polygonIndex)

		local zoneIndex = self._diagram:getPointIndexFromPolygon(polygonIndex) + 1
		self.zones[zoneIndex]:_setPolygon(polygon)
	end

	self.isDirty = false
end

return ZoneMap
