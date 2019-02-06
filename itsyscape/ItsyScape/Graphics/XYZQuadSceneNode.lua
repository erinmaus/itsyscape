--------------------------------------------------------------------------------
-- ItsyScape/Graphics/XYZQuadSceneNode.lua
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

local XYZQuadSceneNode = Class(SceneNode)
XYZQuadSceneNode.DEFAULT_SHADER = ShaderResource()
do
	XYZQuadSceneNode.DEFAULT_SHADER:loadFromFile("Resources/Shaders/StaticModel")
end

XYZQuadSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ "VertexNormal", 'float', 3 },
	{ "VertexColor", 'float', 4 },
	{ "VertexTexture", 'float', 2 }
}

function XYZQuadSceneNode:new(x, y, z)
	x = x or 1
	y = y or 1
	z = z or 1

	SceneNode.new(self)

	self:getMaterial():setShader(XYZQuadSceneNode.DEFAULT_SHADER)

	local MESH_DATA = {
		{ -x, -y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
		{  x, -y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0 },
		{  x,  y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
		{ -x, -y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0 },
		{  x,  y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 },
		{ -x,  y, -z, 0, 0, 1, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0 }
	}

	self.mesh = love.graphics.newMesh(
		XYZQuadSceneNode.MESH_FORMAT,
		MESH_DATA,
		'triangles',
		'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)
	self.mesh:setAttributeEnabled("VertexNormal", true)
	self.mesh:setAttributeEnabled("VertexColor", true)
	self.mesh:setAttributeEnabled("VertexTexture", true)

	self.isBillboarded = false

	self:setBounds(-Vector.ONE, Vector.ONE)
end

function XYZQuadSceneNode:getIsBillboarded()
	return self.isBillboarded
end

function XYZQuadSceneNode:setIsBillboarded(value)
	if value then
		self.isBillboarded = true
	else
		self.isBillboarded = false
	end
end

function XYZQuadSceneNode:draw(renderer, delta)
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

	love.graphics.draw(self.mesh)
end

return XYZQuadSceneNode
