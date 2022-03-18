--------------------------------------------------------------------------------
-- ItsyScape/Graphics/QuadSceneNode.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SceneNode = require "ItsyScape.Graphics.SceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local QuadSceneNode = Class(SceneNode)
QuadSceneNode.DEFAULT_SHADER = ShaderResource()
do
	QuadSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

QuadSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ "VertexNormal", 'float', 3 },
	{ "VertexColor", 'float', 4 },
	{ "VertexTexture", 'float', 2 }
}

QuadSceneNode.MESH_DATA = {
	{ -1, -1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
	{  1, -1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0 },
	{  1,  1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
	{ -1, -1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
	{  1,  1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
	{ -1,  1, 0, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0 }
}

function QuadSceneNode:new()
	SceneNode.new(self)

	self:getMaterial():setShader(QuadSceneNode.DEFAULT_SHADER)

	self.mesh = love.graphics.newMesh(
		QuadSceneNode.MESH_FORMAT,
		QuadSceneNode.MESH_DATA,
		'triangles',
		'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)
	self.mesh:setAttributeEnabled("VertexNormal", true)
	self.mesh:setAttributeEnabled("VertexColor", true)
	self.mesh:setAttributeEnabled("VertexTexture", true)

	self.isBillboarded = false

	self:setBounds(-Vector.ONE, Vector.ONE)
end

function QuadSceneNode:getIsBillboarded()
	return self.isBillboarded
end

function QuadSceneNode:setIsBillboarded(value)
	if value then
		self.isBillboarded = true
	else
		self.isBillboarded = false
	end
end

function QuadSceneNode:draw(renderer, delta)
	local shader = renderer:getCurrentShader()
	local diffuseTexture = self:getMaterial():getTexture(1)
	if shader:hasUniform("scape_DiffuseTexture") and
	   diffuseTexture and diffuseTexture:getIsReady()
	then
		shader:send("scape_DiffuseTexture", diffuseTexture:getResource())
	end

	if self.isBillboarded then
		local camera = renderer:getCamera()
		local projection, view = camera:getTransforms()

		local m = { view:getMatrix() }
		m[1] = 1.0
		m[2] = 0.0
		m[3] = 0.0

		m[5] = 0.0
		m[6] = 1.0
		m[7] = 0.0

		m[9] = 0.0
		m[10] = 0.0
		m[11] = 1.0

		view:setMatrix(unpack(m))
		love.graphics.applyTransform(view)
	end

	love.graphics.setMeshCullMode('none')
	love.graphics.draw(self.mesh)
end

return QuadSceneNode
