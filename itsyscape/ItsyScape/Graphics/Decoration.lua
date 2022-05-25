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
local Color = require "ItsyScape.Graphics.Color"
local NDecoration = require "nbunny.optimaus.decoration"
local NDecorationFeature = require "nbunny.optimaus.decorationfeature"

local Decoration = Class()
Decoration.Feature = Class()

function Decoration.Feature:new(handle)
	self._handle = handle
end

function Decoration.Feature:getHandle()
	return self._handle
end

function Decoration.Feature:setID(value)
	self:getHandle():setID(value)
end

function Decoration.Feature:getID()
	return self:getHandle():getID()
end

function Decoration.Feature:getPosition()
	return Vector(self:getHandle():getPosition())
end

function Decoration.Feature:setPosition(value)
	self:getHandle():setPosition(value:get())
end

function Decoration.Feature:getRotation()
	return Quaternion(self:getHandle():getRotation())
end

function Decoration.Feature:setRotation(value)
	self:getHandle():setRotation(value:get())
end

function Decoration.Feature:getScale()
	return Vector(self:getHandle():getScale())
end

function Decoration.Feature:setScale(value)
	self:getHandle():setScale(value:get())
end

function Decoration.Feature:getColor()
	return Color(self:getHandle():getColor())
end

function Decoration.Feature:setColor(value)
	self:getHandle():setColor(value:get())
end

function Decoration.Feature:serialize()
	return {
		id = self:getID(),
		position = { self:getHandle():getPosition() },
		rotation = { self:getHandle():getRotation() },
		scale = { self:getHandle():getScale() },
		color = { self:getHandle():getColor() }
	}
end

function Decoration:new(d)
	self.tileSetID = false
	self.features = {}
	self._handle = NDecoration()

	if type(d) == 'string' then
		self:loadFromFile(d)
	elseif type(d) == 'table' then
		self:loadFromTable(d)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Decoration:getHandle()
	return self._handle
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
		local color = Color(unpack(feature.color or { 1, 1, 1, 1 }))
		self:add(feature.id, position, rotation, scale, color)
	end
end

function Decoration:add(id, position, rotation, scale, color)
	local description = Decoration.Feature(NDecorationFeature())
	description:setID(id)
	description:setPosition(position or Vector(0))
	description:setRotation(rotation or Quaternion(0))
	description:setScale(scale or Vector(1))
	description:setColor(color or Color(1))

	local feature = Decoration.Feature(self:getHandle():addFeature(description:getHandle()))

	table.insert(self.features, feature)

	return feature
end

function Decoration:remove(feature)
	for i = 1, #self.features do
		if self.features[i] == feature then
			table.remove(self.features, i)
			break
		end
	end

	return self:getHandle():removeFeature(feature:getHandle())
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
			local color = feature:getColor()

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
			r:pushIndent(2)
			r:pushFormatLine(
				"color = { %f, %f, %f, %f },",
				color.r, color.g, color.b, color.a)
		end
		r:pushIndent(1)
		r:pushLine("},")
	end
	r:pushLine("}")

	return r:toString()
end

function Decoration:serialize()
	local result = {
		tileSetID = self:getTileSetID()
	}

	for i = 1, #self.features do
		table.insert(result, self.features[i]:serialize())
	end

	return result
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
