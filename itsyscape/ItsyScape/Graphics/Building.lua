--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Building.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"

local Building = Class()

Building.DecorationGroupFeature = Class()

function Building.DecorationGroupFeature:new(id, material)
	self.id = id
	self.material = material
end

function Building.DecorationGroupFeature:getID()
	return self.id
end

function Building.DecorationGroupFeature:getMaterial()
	return self.material
end

function Building.DecorationGroupFeature:serialize()
	return {
		id = self.id,
		material = self.material
	}
end

Building.DecorationGroup = Class()

function Building.DecorationGroup:new(name)
	self.name = name
	self.features = {}
end

function Building.DecorationGroup:getName()
	return self.name
end

function Building.DecorationGroup:addFeature(feature)
	table.insert(self.features, feature)
end

function Building.DecorationGroup:iterate()
	return ipairs(self.features)
end

function Building.DecorationGroup:serialize()
	local result = { name = self.name, features = {} }
	for _, feature in ipairs(self.features) do
		table.insert(result, feature:serialize())
	end
end

Building.Material = Class()

function Building.Material:new(name, material)
	self.name = name
	self.material = material
end

function Building.Material:getName()
	return self.name
end

function Building.Material:getMaterial()
	return self.material
end

function Building.Material:serialize()
	return {
		name = self.name,
		material = self.material:serialize()
	}
end

function Building:new(d)
	self.materials = {}
	self.materialsByName = {}

	self.decorationGroups = {}
	self.decorationGroupsByName = {}

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	end
end

function Building:getMaterials()
	local materials = {}
	for _, material in ipairs(self.materials) do
		materials[material:getName()] = material:getMaterial()
	end

	return materials
end

function Building:getMaterialByIndex(index)
	return self.materials[index]
end

function Building:getMaterialByName(name)
	return self.materialsByName[name]
end

function Building:getDecorationGroupByIndex(index)
	return self.decorationGroups[index]
end

function Building:getDecorationGroupByName(name)
	return self.decorationGroupsByName[name]
end

function Building:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

function Building:loadFromTable(d)
	table.clear(self.materials)
	table.clear(self.materialsByName)
	table.clear(self.decorationGroups)
	table.clear(self.decorationGroupsByName)

	for _, material in ipairs(d.materials) do
		local m = Building.Material(material.name, DecorationMaterial(material.material))

		table.insert(self.materials, m)
		self.materialsByName[m:getName()] = m
	end

	for _, decoration in ipairs(d.decorations) do
		local g = Building.DecorationGroup(decoration.name)
		for i, feature in ipairs(decoration.features) do
			local f = Building.DecorationGroupFeature(feature.id, feature.material)
			g:addFeature(f)
		end

		table.insert(self.decorationGroups, g)
		self.decorationGroupsByName[g:getName()] = g
	end
end

function Building:iterateMaterials()
	return ipairs(self.materials)
end

function Building:iterateGroups()
	return ipairs(self.decorationGroups)
end

return Building
