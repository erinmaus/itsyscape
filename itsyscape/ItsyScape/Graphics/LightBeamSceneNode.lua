--------------------------------------------------------------------------------
-- ItsyScape/Graphics/LightBeamSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

LightBeamSceneNode = Class(SceneNode)
LightBeamSceneNode.SHADER = ShaderResource()
do
	LightBeamSceneNode.SHADER:loadFromFile("Resources/Shaders/LightBeam")
end

LightBeamSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 }
}

LightBeamSceneNode.QUAD = {
	{ -1,  0,  0 },
	{  1,  0,  0 },
	{  1,  1,  0 },
	{ -1,  0,  0 },
	{  1,  1,  0 },
	{ -1,  1,  0 },

	{  0,  0, -1 },
	{  0,  1, -1 },
	{  0,  1,  1 },
	{  0,  0, -1 },
	{  0,  1,  1 },
	{  0,  0,  1 }
}

function LightBeamSceneNode:new()
	SceneNode.new(self)

	self:getMaterial():setShader(LightBeamSceneNode.SHADER)
	self:getMaterial():setIsFullLit(true)

	self.size = 1 / 8
	self.path = {}
	self.vertices = {}
end

function LightBeamSceneNode:getBeamSize()
	return self.size
end

function LightBeamSceneNode:setBeamSize(value)
	self.size = value or self.size
end

function LightBeamSceneNode:initVertexCache(count)
	local length = count

	if length < #self.vertices then
		for i = #self.vertices, length + 1, -1 do
			self.vertices[i] = nil
		end
	else
		for i = #self.vertices + 1, length do
			self.vertices[i] = { 0, 0, 0 }
		end
	end
end

function LightBeamSceneNode:same(path)
	local oldPath = self.path

	if #oldPath ~= #path then
		return false
	end

	for i = 1, #path do
		local s = path[i]
		local t = oldPath[i]

		local sA = s.a
		local tA = t.a
		if #sA ~= #tA then
			return false
		end

		for i = 1, #sA do
			if math.floor(sA[i] * 10) ~= math.floor(tA[i] * 10) then
				return false
			end
		end

		local sB = s.b
		local tB = t.b
		if #sB ~= #tB then
			return false
		end

		for i = 1, #sB do
			if math.floor(sB[i] * 10) ~= math.floor(tB[i] * 10) then
				return false
			end
		end
	end

	return true
end

-- https://github.com/liballeg/allegro5/blob/e8457df9492158f2c5f41676e70f0b98c7f5deeb/addons/primitives/high_primitives.c#L1127
function LightBeamSceneNode:buildSeamless(path)
	local min, max = Vector(math.huge), Vector(-math.huge)

	self:initVertexCache(#path * 2)

	if #path < 2 then
		self:release()
		return
	end

	if self:same(path) then
		return
	else
		self.path = {}
		for i = 1, #path do
			self.path[i] = {
				a = { unpack(path[i].a) },
				b = { unpack(path[i].b) }
			}
		end
	end

	local vertices = self.vertices
	local currentDirection, previousDirection
	local halfSize = self.size / 2
	local t, n
	local sign = 1

	local index = 1
	for i = 1, #path - 1 do
		local current = Vector(unpack(path[i].a))
		local next = Vector(unpack(path[i + 1].a))

		currentDirection = ((next - current) * Vector.PLANE_XY):getNormal()

		if i == 1 then
			t = Vector(-halfSize * currentDirection.x, halfSize * currentDirection.x)
			n = Vector.ZERO
		else
			local dot = currentDirection:dot(previousDirection)
			if dot < 0 then
				t = (previousDirection - currentDirection):getNormal()
				local cosine = t:dot(currentDirection)

				n = -halfSize * t / cosine
				t = Vector(
					-halfSize * t.y * cosine,
					halfSize * t.x * cosine)
				sign = -sign
			else
				t = Vector(
					currentDirection.y + previousDirection.y,
					-(currentDirection.x + previousDirection.y)):getNormal()

				local cosine = t.x * -currentDirection.y + t.y * currentDirection.x
				local newNormalLength = halfSize / cosine

				t = t * newNormalLength
				n = Vector.ZERO
			end
		end

		vertices[index][1] = current.x - sign * t.x + n.x
		vertices[index][2] = current.y - sign * t.y + n.y
		vertices[index][3] = current.z

		vertices[index + 1][1] = current.x + sign * t.x + n.x
		vertices[index + 1][2] = current.y + sign * t.y + n.y
		vertices[index + 1][3] = current.z

		index = index + 2

		previousDirection = currentDirection
	end

	t = Vector(-halfSize * previousDirection.x, halfSize * previousDirection.y)
	local current = Vector(unpack(path[#path].a))

	vertices[index][1] = current.x - sign * t.x + n.x
	vertices[index][2] = current.y - sign * t.y + n.y
	vertices[index][3] = current.z

	vertices[index + 1][1] = current.x + sign * t.x + n.x
	vertices[index + 1][2] = current.y + sign * t.y + n.y
	vertices[index + 1][3] = current.z

	self.mesh = love.graphics.newMesh(
		LightBeamSceneNode.MESH_FORMAT,
		self.vertices,
		'strip',
		'dynamic')
	self.mesh:setAttributeEnabled("VertexPosition", true)

	self:setBounds(Vector(-9999), Vector(9999))
end

function LightBeamSceneNode:build(path)
	local min, max = Vector(math.huge), Vector(-math.huge)
	local size = self.size

	self:initVertexCache(#path * #LightBeamSceneNode.QUAD)

	if #path < 1 then
		self:release()
		return
	end

	if self:same(path) then
		return
	else
		self.path = {}
		for i = 1, #path do
			self.path[i] = {
				a = { unpack(path[i].a) },
				b = { unpack(path[i].b) }
			}
		end
	end

	local VERTICES = LightBeamSceneNode.QUAD
	local vertexIndex = 1

	for i = 1, #path do
		local p = path[i]

		local a = Vector(unpack(p.a))
		local b = Vector(unpack(p.b))
		min = min:min(a)
		max = max:max(b)

		local direction = b - a
		local length = direction:getLength()
		direction = direction * (1.0 / length)

		for i = 1, #VERTICES do
			local input = VERTICES[i]
			local output = self.vertices[vertexIndex]
			output[1] = input[1] * size + a.x + input[2] * direction.x * length
			output[2] = input[2] * size + a.y + input[2] * direction.y * length
			output[3] = input[3] * size + a.z + input[2] * direction.z * length

			vertexIndex = vertexIndex + 1
		end
	end

	self.mesh = love.graphics.newMesh(
		LightBeamSceneNode.MESH_FORMAT,
		self.vertices,
		'triangles',
		'dynamic')
	self.mesh:setAttributeEnabled("VertexPosition", true)

	self:setBounds(Vector(-9999), Vector(9999))
end

function LightBeamSceneNode:release()
	if self.mesh then
		self.mesh:release()
		self.mesh = nil
	end
end

function LightBeamSceneNode:draw(renderer, delta)
	local mesh = self.mesh
	if mesh then
		love.graphics.push('all')
		love.graphics.setBlendMode('add')
		love.graphics.setMeshCullMode('none')
		love.graphics.setDepthMode('lequal', false)
		love.graphics.draw(mesh)
		love.graphics.setDepthMode('lequal', true)
		love.graphics.draw(mesh)
		love.graphics.pop()
	end
end

return LightBeamSceneNode
