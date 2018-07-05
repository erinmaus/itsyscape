--------------------------------------------------------------------------------
-- ItsyScape/Graphics/StaticMesh.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local StaticMesh = Class()
function StaticMesh:new(d, skeleton)
	self.groups = {}

	if type(d) == 'string' then
		self:loadFromFile(d, skeleton)
	elseif type(d) == 'table' then
		self:loadFromTable(d, skeleton)
	else
		error(("expected table or filename (string), got %s"):format(type(d)))
	end
end

function StaticMesh:loadFromFile(filename, skeleton)
	local data = "return " .. (love.filesystem.read(filename) or "")
	local chunk = assert(loadstring(data))
	local result = setfenv(chunk, {})() or {}

	self:loadFromTable(result, skeleton)
end

function StaticMesh:loadFromTable(t)
	local format = t.format or {
		{ 'VertexPosition', 'float', 3 },
		{ 'VertexNormal', 'float', 3 },
		{ 'VertexTexture', 'float', 2 },
	}

	self.format = format

	for i = 1, #t do
		self:generate(t[i])
	end
end

function StaticMesh:generate(t)
	local vertices = t or { { 0, 0, 0, 0, 0, 1, 0, 0 } }

	if t.name then
		local m = self.groups[t.name]
		if m then
			m.mesh:release()
		end
	else
		return false
	end

	local m = {
		name = t.name,
		vertices = vertices
	}

	m.mesh = love.graphics.newMesh(self.format, vertices, 'triangles', 'static')

	self.groups[t.name] = m
	for _, element in ipairs(self.format) do
		m.mesh:setAttributeEnabled(element[1], true)
	end

	return true
end

function StaticMesh:hasGroup(group)
	return self.groups[group] ~= nil
end

function StaticMesh:getMesh(group)
	return self.groups[group].mesh
end

function StaticMesh:getVertices(group)
	return self.groups[group].vertices
end

function StaticMesh:iterate()
	local c = nil

	return function()
		c = next(self.groups, c)

		return c
	end
end

function StaticMesh:getFormat()
	return self.format
end

function StaticMesh:release()
	for _, g in pairs(self.groups) do
		g.mesh:release()
	end

	self.groups = {}
end

return StaticMesh
