--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Model.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

local Model = Class()
function Model:new(d, skeleton)
	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	end
end

function Model:loadFromFile(filename, skeleton)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result, skeleton)
end

function Model:_bindSkeleton(skeleton)
	local vertices = self.mappedVertices or {}
	table.clear(vertices)

	local LOVE_VERTEX_FORMAT_COUNT_INDEX = 3
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1

	-- Gets the number of bone indices and the offset.
	local boneIndexOffset = 0
	local maxBonesPerVertex = 0
	local numPositionComponents = 0
	for i = 1, #self.format do
		if self.format[i][LOVE_VERTEX_FORMAT_NAME_INDEX] == 'VertexBoneIndex' then
			maxBonesPerVertex = self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
			break
		end
		boneIndexOffset = boneIndexOffset + self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	local positionOffset = 0
	local positionCount = 0
	for i = 1, #self.format do
		if self.format[i][LOVE_VERTEX_FORMAT_NAME_INDEX] == 'VertexPosition' then
			positionCount = self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
			break
		end

		positionOffset = positionOffset + self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	local min, max = Vector(math.huge), Vector(-math.huge)

	-- Convert bone names to bone indices.
	-- Also update min max.
	for i = 1, #self.vertices do
		local vertex = vertices[i] or {}

		for j, value in ipairs(self.vertices[i]) do
			vertex[j] = value
		end

		vertices[i] = vertex

		for j = 1, maxBonesPerVertex do
			local boneIndex = boneIndexOffset + j
			if vertex[boneIndex] then
				if skeleton then
					vertex[boneIndex] = skeleton:getBoneIndex(vertex[boneIndex]) or 1
				else
					vertex[boneIndex] = 1
				end
			else
				vertex[boneIndex] = 1
			end
		end

		local x, y, z = unpack(self.vertices[i], positionOffset + 1, positionOffset + positionCount)
		min.x = math.min(min.x, x)
		min.y = math.min(min.y, y)
		min.z = math.min(min.z, z)
		max.x = math.max(max.x, x)
		max.y = math.max(max.y, y)
		max.z = math.max(max.z, z)
	end

	if #vertices > 1 then
		local mesh = love.graphics.newMesh(self.format, vertices, 'triangles', 'static')
		for _, element in ipairs(self.format) do
			mesh:setAttributeEnabled(element[1], true)
		end

		self.mesh = mesh
	end

	self.min = min
	self.max = max

	self.skeleton = skeleton or false
	self.mappedVertices = vertices
end

function Model:loadFromTable(t, skeleton)
	local format = t.format or {
		{ 'VertexPosition', 'float', 3 },
		{ 'VertexNormal', 'float', 3 },
		{ 'VertexTexture', 'float', 2 },
		{ 'VertexBoneIndex', 'float', 4 },
		{ 'VertexBoneWeight', 'float', 4 },
	}
	local vertices = t.vertices or { { 0, 0, 0, 0, 0, 1, 0, 0, false, false, false, false, 0, 0, 0, 0 } }

	self.vertices = vertices
	self.format = format

	self:_bindSkeleton(skeleton)
end

function Model.fromMappedVertices(format, mappedVertices, count, min, max, skeleton)
	local model = Model(skeleton, nil)

	model.format = format
	model.vertices = {}

	model.mappedVertices = {}
	for i = 1, count do
		model.mappedVertices[i] = { unpack(mappedVertices[i]) }
	end

	model.min = min
	model.max = max
	model.skeleton = skeleton

	if count > 1 then
		local mesh = love.graphics.newMesh(format, model.mappedVertices, 'triangles', 'static')
		for _, element in ipairs(format) do
			mesh:setAttributeEnabled(element[1], true)
		end

		model.mesh = mesh
	end

	return model
end

function Model:getBounds()
	return self.min, self.max
end

function Model:getSkeleton()
	return self.skeleton
end

function Model:getMesh()
	return self.mesh
end

function Model:getVertices()
	return self.mappedVertices
end

function Model:getFormat()
	return self.format
end

return Model
