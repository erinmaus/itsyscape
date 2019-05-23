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
	local length = count * #LightBeamSceneNode.QUAD

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

function LightBeamSceneNode:build(path)
	local min, max = Vector(math.huge), Vector(-math.huge)
	local size = self.size

	self:initVertexCache(#path)

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
