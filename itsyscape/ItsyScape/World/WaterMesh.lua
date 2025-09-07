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

local WaterMesh = Class()

-- Vertex format.
WaterMesh.FORMAT = {
    { "VertexPosition", 'float', 3 },
    { "VertexNormal", 'float', 3 },
    { "VertexTexture", 'float', 2 }
}

function WaterMesh:new(width, height, textureScale, i, j, positionScale)
	self.vertices = {}
	self.width = width
	self.height = height
	self.textureScale = textureScale or 4
	self.i = i or 0
	self.j = j or 0
	self.positionScale = positionScale or 1

	self:_buildMesh()
end

function WaterMesh:getScale()
	return self.textureScale
end

function WaterMesh:release()
	self.mesh:release()
	self.mesh = false
end

function WaterMesh:getBounds()
	return self.min, self.max
end

function WaterMesh:getMesh()
	return self.mesh
end

function WaterMesh:draw(texture, ...)
	if self.mesh then
		self.mesh:setTexture(texture)
		love.graphics.draw(self.mesh, ...)
	end
end

function WaterMesh:_buildMesh()
	self.min = Vector(math.huge):keep()
	self.max = Vector(-math.huge):keep()

	for j = 1, self.height do
		for i = 1, self.width do
			self:_addFlat(i, j)
		end

		if coroutine.running() then
			coroutine.yield()
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
		texture.x / self.textureScale, texture.y / self.textureScale
	}

	self.min:min(position):keep(self.min)
	self.max:max(position):keep(self.max)

	table.insert(self.vertices, vertex)
end

function WaterMesh:_addFlat(i, j)
	local offsetI = i - 0.5
	local offsetJ = j - 0.5

	local E = 0.5
	local topLeft = Vector(-E + offsetI, 0, -E + offsetJ)
	local topRight = Vector(E + offsetI, 0, -E + offsetJ)
	local bottomLeft = Vector(-E + offsetI, 0, E + offsetJ)
	local bottomRight = Vector(E + offsetI, 0, E + offsetJ)

	local normal = Vector.UNIT_Y
	do
		self:_addVertex(topRight, normal, Vector(((i + self.i) + 1) / self.positionScale, (j + self.j) / self.positionScale))
		self:_addVertex(bottomLeft, normal, Vector((i + self.i) / self.positionScale, ((j + self.j) + 1) / self.positionScale))
		self:_addVertex(bottomRight, normal, Vector(((i + self.i) + 1) / self.positionScale, ((j + self.j) + 1) / self.positionScale))
	end
	do
		self:_addVertex(topRight, normal, Vector(((i + self.i) + 1) / self.positionScale, (j + self.j) / self.positionScale))
		self:_addVertex(topLeft, normal, Vector((i + self.i) / self.positionScale, (j + self.j) / self.positionScale))
		self:_addVertex(bottomLeft, normal, Vector((i + self.i) / self.positionScale, ((j + self.j) + 1) / self.positionScale))
	end
end

return WaterMesh
