--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Model.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"

local Model = Class()
function Model:new(d, skeleton)
	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function Model:loadFromFile(filename, skeleton)
	local data = "return " .. love.filesystem.read(filename)
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})()

	self:loadFromTable(result)
end

function Model:bindSkeleton(skeleton)
	local vertices = {}

	-- Gets the number of bone indices and the offset.
	local LOVE_VERTEX_FORMAT_COUNT_INDEX = 3
	local LOVE_VERTEX_FORMAT_NAME_INDEX = 1
	local boneIndexOffset = 0
	local maxBonesPerVertex = 0
	for i = 1, #self.format do
		if self.format[i][LOVE_VERTEX_FORMAT_NAME_INDEX] == 'VertexBoneIndex' then
			maxBonesPerVertex = self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
			break
		end
		boneIndexOffset = boneIndexOffset + self.format[i][LOVE_VERTEX_FORMAT_COUNT_INDEX]
	end

	-- Convert bone names to bone indices.
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
	end

	-- Generate mesh.
	if self.mesh then
		self.mesh:release()
	end

	self.mesh = love.graphics.newMesh(self.format, vertices, 'triangles', 'static')
	for _, element in ipairs(self.format) do
		self.mesh:setAttributeEnabled(element[1], true)
	end

	self.skeleton = skeleton or false
end

function Model:loadFromTable(t, skeleton)
	local format = t.format or {
		{ 'VertexPosition', 'float', 3 },
		{ 'VertexNormal', 'float', 3 },
		{ 'VertexTexture', 'float', 3 },
		{ 'VertexBoneIndex', 'float', 4 },
		{ 'VertexBoneWeight', 'float', 4 },
	}
	local vertices = t.vertices or { { 0, 0, 0, 0, 0, 1, 0, 0, false, false, false, false, 0, 0, 0, 0 } }

	self.vertices = vertices
	self.format = format

	self:bindSkeleton(skeleton)
end

function Model:getSkeleton()
	return self.skeleton
end

function Model:getMesh()
	return self.mesh
end

function Model:getFormat()
	return self.format
end

function Model:release()
	if self.mesh then
		self.mesh:release()
		self.mesh = false
	end
end

return Model
