--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Decoration.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local StringBuilder = require "ItsyScape.Common.StringBuilder"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Vector = require "ItsyScape.Common.Math.Vector"

local Decoration = Class()
Decoration.Feature = Class()

function Decoration.Feature:new(tileID, position, rotation, scale)
	self.tileID = tileID or false
	self.position = position or Vector(0)
	self.rotation = rotation or Quaternion(0)
	self.scale = scale or Vector(1)
end

function Decoration.Feature:getID()
	return self.tileID
end

function Decoration.Feature:getPosition()
	return self.position
end

function Decoration.Feature:setPosition(value)
	self.position = value or self.position
end

function Decoration.Feature:getRotation()
	return self.rotation
end

function Decoration.Feature:setRotation(value)
	self.rotation = value or self.rotation
end

function Decoration.Feature:getScale()
	return self.scale
end

function Decoration.Feature:setScale(value)
	self.scale = value or self.scale
end

function Decoration:new(d, skeleton)
	self.tileSetID = false
	self.features = {}

	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Decoration:loadFromFile(filename)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result)
end

function Decoration:loadFromTable(t)
	self.tileSetID = t.tileSetID or self.tileSetID

	for i = 1, #t do
		local feature = t[i]
		local position = Vector(unpack(feature.position or { 0, 0, 0 }))
		local rotation = Quaternion(unpack(feature.rotation or { 0, 0, 0, 1 }))
		local scale = Vector(unpack(feature.scale or { 1, 1, 1 }))
		table.insert(self.features, Decoration.Feature(
			feature.id,
			position,
			rotation,
			scale
		))
	end
end

function Decoration:add(id, position, rotation, scale)
	local feature = Decoration.Feature(
			id,
			position,
			rotation,
			scale
		)
	table.insert(self.features, feature)

	return feature
end

function Decoration:remove(feature)
	for i = 1, #self.features do
		if self.features[i] == feature then
			table.remove(self.features, i)
			return true
		end
	end

	return false
end

function Decoration:toString()
	local r = StringBuilder()

	r:pushLine("{")
	r:pushIndent(1)
	r:pushFormatLine("tileSetID = %q,", self:getTileSetID())

	for i = 1, #self.features do
		local feature = self.features[i]

		r:pushIndent(1)
		r:pushLine("{")
		do
			local position = feature:getPosition()
			local rotation = feature:getRotation()
			local scale = feature:getScale()

			r:pushIndent(2)
			r:pushFormatLine("id = %q,", feature:getID())
			r:pushIndent(2)
			r:pushFormatLine(
				"position = { %f, %f, %f },",
				position.x, position.y, position.z)
			r:pushIndent(2)
			r:pushFormatLine(
				"rotation = { %f, %f, %f, %f },",
				rotation.x, rotation.y, rotation.z, rotation.w)
			r:pushIndent(2)
			r:pushFormatLine(
				"scale = { %f, %f, %f },",
				scale.x, scale.y, scale.z)
		end
		r:pushIndent(1)
		r:pushLine("},")
	end
	r:pushLine("}")

	return r:toString()
end

Decoration.RAY_TEST_RESULT_FEATURE = 1
Decoration.RAY_TEST_RESULT_POSITION = 2

function Decoration:testRay(ray, staticMesh)
	local result = {}

	local transform = love.math.newTransform()
	for feature in self:iterate() do
		do
			transform:reset()

			local position = feature:getPosition()
			transform:translate(position.x, position.y, position.z)

			local rotation = feature:getRotation()
			transform:applyQuaternion(
				rotation.x,
				rotation.y,
				rotation.z,
				rotation.w)

			local scale = feature:getScale()
			transform:scale(
				scale.x,
				scale.y,
				scale.z)
		end

		local group = feature:getID()

		-- Assumes indices 1-3 are vertex positions. Bad.
		if staticMesh:hasGroup(group) then
			local vertices = staticMesh:getVertices(group)
			for i = 1, #vertices, 3 do
				local v1 = vertices[i]
				local v2 = vertices[i + 1]
				local v3 = vertices[i + 2]

				v1 = Vector(transform:transformPoint(unpack(v1)))
				v2 = Vector(transform:transformPoint(unpack(v2)))
				v3 = Vector(transform:transformPoint(unpack(v3)))

				local s, p = ray:hitTriangle(v2, v1, v3)
				if s then
					table.insert(result, {
						feature,
						p
					})
				end
			end
		end
	end

	return result
end

function Decoration:getTileSetID()
	return self.tileSetID
end

function Decoration:iterate()
	local index = 1

	return function()
		local current = self.features[index]
		if index <= #self.features then
			index = index + 1
		end

		return current
	end
end

return Decoration
