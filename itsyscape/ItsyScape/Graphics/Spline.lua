--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Spline.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local serpent = require "serpent"
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local MapCurve = require "ItsyScape.World.MapCurve"

local Spline = Class()
Spline.Feature = Class()

function Spline.Feature:new(id, curve, color, texture)
	self.id = id
	self.curve = curve
	self.color = color or Color()
	self.texture = texture or 1
end

function Spline.Feature:setID(value)
	self.id = value
end

function Spline.Feature:getID()
	return self.id
end

function Spline.Feature:setCurve(value)
	self.curve = value
end

function Spline.Feature:getCurve()
	return self.curve
end

function Spline.Feature:setColor(value)
	self.color = value
end

function Spline.Feature:getColor()
	return self.color
end

function Spline.Feature:setTexture(value)
	self.texture = value
end

function Spline.Feature:getTexture()
	return self.texture
end

function Spline.Feature:serialize()
	return {
		id = self:getID(),
		curve = self.curve:toConfig(),
		color = { self.color:get() },
		texture = self.texture
	}
end

function Spline.Feature:map(func, staticMesh, index)
	local group = self:getID()

	-- Assumes indices 1-3 are vertex positions and 4-6 are normal. Bad.
	if staticMesh:hasGroup(group) then
		local vertices = staticMesh:getVertices(group)
		for i = 1, #vertices, 3 do
			local v1 = vertices[i]
			local v2 = vertices[i + 1]
			local v3 = vertices[i + 2]

			v1 = self.curve:transform(Vector(unpack(v1)))
			v2 = self.curve:transform(Vector(unpack(v2)))
			v3 = self.curve:transform(Vector(unpack(v3)))

			local s = v2 - v3
			local t = v1 - v3

			func(v1, v2, v3, s:cross(t):getNormal(), self, index)
		end
	end
end

function Spline:new(d)
	self.tileSetID = false
	self.isWall = false
	self.features = {}

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Spline:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

function Spline:loadFromTable(t)
	self.tileSetID = t.tileSetID or self.tileSetID
	self.isWall = t.isWall or false

	for i = 1, #t do
		local feature = t[i]
		local curve = MapCurve(nil, feature.curve)
		local color = Color(unpack(feature.color or { 1, 1, 1, 1 }))
		local texture = feature.texture
		self:add(feature.id, curve, color, texture)
	end
end

function Spline:add(id, curve, color, texture)
	local feature = Spline.Feature(id, curve, color, texture)
	table.insert(self.features, feature)

	return feature
end

function Spline:remove(feature)
	for i = 1, #self.features do
		if self.features[i] == feature then
			table.remove(self.features, i)
			return true
		end
	end

	return false
end

function Spline:toString()
	return serpent.block(self:serialize(), { comment = false })
end

function Spline:serialize()
	local result = {
		tileSetID = self:getTileSetID(),
		isWall = self:getIsWall()
	}

	for i = 1, #self.features do
		table.insert(result, self.features[i]:serialize())
	end

	return result
end

Spline.RAY_TEST_RESULT_FEATURE = 1
Spline.RAY_TEST_RESULT_POSITION = 2
Spline.RAY_TEST_RESULT_INDEX = 3

function Spline:map(func, staticMesh)
	local result = {}

	for feature, index in self:iterate() do
		feature:map(func, staticMesh, index)
	end
end

function Spline:testRay(ray, staticMesh)
	local result = {}

	self:map(function(v1, v2, v3, _, feature, index)
		local s, p = ray:hitTriangle(v2, v1, v3)
		if s then
			table.insert(result, {
				feature,
				p,
				index
			})
		end
	end, staticMesh)

	return result
end

function Spline:getIsWall()
	return self.isWall
end

function Spline:getTileSetID()
	return self.tileSetID
end

function Spline:iterate()
	local index = 1

	return function()
		local previousIndex = index

		local current = self.features[index]
		if index <= #self.features then
			index = index + 1
		end

		return current, previousIndex
	end
end

function Spline:getNumFeatures()
	return #self.features
end

function Spline:getFeatureByIndex(index)
	return self.features[index]
end

return Spline
