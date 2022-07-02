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
local NModelResourceInstance = require "nbunny.optimaus.modelresourceinstance"

local Model = Class()
function Model:new(d, skeleton, handle)
	self._handle = handle or NModelResourceInstance()

	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Model:getHandle()
	return self._handle
end

function Model:loadFromFile(filename, skeleton)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result, skeleton)
end

function Model:bindSkeleton(skeleton)
	local vertices = {}

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

		positionOffset = postionOffset + self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	local min, max = Vector(math.huge), Vector(-math.huge)

	-- Convert bone names to bone indices.
	-- Also update min max.
	for i = 1, #self.vertices do
		local vertex = { unpack(self.vertices[i]) }
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

		local p = Vector(unpack(self.vertices[i], positionOffset + 1, positionOffset + positionCount))
		min = min:min(p)
		max = max:max(p)
	end

	local mesh = love.graphics.newMesh(self.format, vertices, 'triangles', 'static')
	for _, element in ipairs(self.format) do
		mesh:setAttributeEnabled(element[1], true)
	end

	self:getHandle():setMesh(mesh)

	self.min = min
	self.max = max

	self.skeleton = skeleton or false
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

	self:bindSkeleton(skeleton)
end

function Model:getBounds()
	return self.min, self.max
end

function Model:getSkeleton()
	return self.skeleton
end

function Model:getMesh()
	return self:getHandle():getMesh()
end

function Model:getFormat()
	return self.format
end

function Model:release()
	self:getHandle():setMesh()
end

return Model
