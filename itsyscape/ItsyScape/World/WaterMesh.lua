--------------------------------------------------------------------------------
-- ItsyScape/World/WaterMesh.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"

WaterMesh = Class()

-- Vertex format.
WaterMesh.FORMAT = {
    { "VertexPosition", 'float', 3 },
    { "VertexNormal", 'float', 3 },
    { "VertexTexture", 'float', 2 }
}

function WaterMesh:new(width, height, scale)
	self.vertices = {}
	self.width = width
	self.height = height
	self.scale = scale or 3

	self:_buildMesh()
end

function WaterMesh:release()
	self.mesh:release()
end

function WaterMesh:draw(texture, ...)
	self.mesh:setTexture(texture)
	love.graphics.draw(self.mesh, ...)
end

function WaterMesh:_buildMesh()
	for j = 1, self.height do
		for i = 1, self.width do
			self:_addFlat(i - 0.5, j - 0.5)
		end
	end

	self.mesh = love.graphics.newMesh(WaterMesh.FORMAT, self.vertices, 'triangles', 'static')
	for i = 1, #WaterMesh.FORMAT do
		self.mesh:setAttributeEnabled(WaterMesh.FORMAT[i][1], true)
	end
end

function WaterMesh:_addVertex(position, normal, texture)
	local vertex = {
		position.x, position.y, position.z,
		normal.x, normal.y, normal.z,
		position.x * 1 / self.scale, position.z * 1 / self.scale
	}

	table.insert(self.vertices, vertex)
end

function WaterMesh:_addFlat(i, j)
	local E = 0.5
	local topLeft = Vector(-E + i, 0, -E + j)
	local topRight = Vector(E + i, 0, -E + j)
	local bottomLeft = Vector(-E + i, 0, E + j)
	local bottomRight = Vector(E + i, 0, E + j)

	local normal = Vector.UNIT_Y
	do
		self:_addVertex(topRight, normal, Vector(1, 0))
		self:_addVertex(bottomLeft, normal, Vector(0, 1))
		self:_addVertex(bottomRight, normal, Vector(1, 1))
	end
	do
		self:_addVertex(topRight, normal, Vector(1, 0))
		self:_addVertex(topLeft, normal, Vector(0, 0))
		self:_addVertex(bottomLeft, normal, Vector(0, 1))
	end
end

return WaterMesh
