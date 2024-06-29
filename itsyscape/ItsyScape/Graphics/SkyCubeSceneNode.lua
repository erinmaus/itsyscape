--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SkyCubeSceneNode.lua
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

local SkyCubeSceneNode = Class(SceneNode)

SkyCubeSceneNode.SHADER = ShaderResource()
do
	SkyCubeSceneNode.SHADER:loadFromFile("Resources/Shaders/Skybox")
end

SkyCubeSceneNode.MESH_FORMAT = {
	{ "VertexPosition", 'float', 3 },
	{ "VertexTexture", 'float', 2 },
}


SkyCubeSceneNode.MESH_DATA = {
	-- Front.
	{ -1, -1,  1, 0, 0, },
	{  1, -1,  1, 0, 0, },
	{  1,  1,  1, 0, 1, },
	{ -1, -1,  1, 0, 0, },
	{  1,  1,  1, 0, 1, },
	{ -1,  1,  1, 0, 1, },

	-- Back.
	{  1, -1, -1, 0, 0, },
	{ -1, -1, -1, 0, 0, },
	{  1,  1, -1, 0, 1, },
	{  1,  1, -1, 0, 1, },
	{ -1, -1, -1, 0, 0, },
	{ -1,  1, -1, 0, 1, },

	-- Left.
	{ -1, -1, -1, 0, 0, },
	{ -1, -1,  1, 0, 0, },
	{ -1,  1,  1, 0, 1, },
	{ -1,  1, -1, 0, 1, },
	{ -1, -1, -1, 0, 0, },
	{ -1,  1,  1, 0, 1, },

	-- Right.
	{  1,  1,  1, 0, 1, },
	{  1, -1,  1, 0, 0, },
	{  1, -1, -1, 0, 0, },
	{  1,  1,  1, 0, 1, },
	{  1, -1, -1, 0, 0, },
	{  1,  1, -1, 0, 1, },

	-- Top
	{  1,  1, -1, 0, 1, },
	{ -1,  1, -1, 0, 1, },
	{  1,  1,  1, 0, 1, },
	{ -1,  1, -1, 0, 1, },
	{ -1,  1,  1, 0, 1, },
	{  1,  1,  1, 0, 1, },

	-- Bottom.
	{ -1, -1, -1, 0, 0, },
	{  1, -1, -1, 0, 0, },
	{  1, -1,  1, 0, 0, },
	{  1, -1,  1, 0, 0, },
	{ -1, -1,  1, 0, 0, },
	{ -1, -1, -1, 0, 0, },
}

function SkyCubeSceneNode:new()
	SceneNode.new(self)

	self:setBounds(-Vector.ONE, Vector.ONE)
	self:getMaterial():setShader(SkyCubeSceneNode.SHADER)
	self:getMaterial():setIsCullDisabled(true)
	self:getMaterial():setIsZWriteDisabled(true)
	self:getMaterial():setIsFullLit(true)
	self:getMaterial():setOutlineThreshold(-1)

	self.vertices = {}
	for _, vertex in ipairs(SkyCubeSceneNode.MESH_DATA) do
		table.insert(self.vertices, { unpack(vertex) })
	end

	self.mesh = love.graphics.newMesh(
		SkyCubeSceneNode.MESH_FORMAT,
		self.vertices,
		'triangles',
		'static')
	self.mesh:setAttributeEnabled("VertexPosition", true)
	self.mesh:setAttributeEnabled("VertexTexture", true)

	self.currentTopClearColor = Color(0, 0, 0, 1)
	self.previousTopClearColor = false

	self.currentBottomClearColor = Color(0, 0, 0, 1)
	self.previousBottomClearColor = false
end

function SkyCubeSceneNode:setTopClearColor(value)
	self.currentTopClearColor = value
end

function SkyCubeSceneNode:getTopClearColor()
	return self.currentTopClearColor
end

function SkyCubeSceneNode:setPreviousTopClearColor(value)
	self.previousTopClearColor = value
end

function SkyCubeSceneNode:getPreviousTopClearColor()
	return self.previousTopClearColor
end

function SkyCubeSceneNode:setBottomClearColor(value)
	self.currentBottomClearColor = value
end

function SkyCubeSceneNode:getBottomClearColor()
	return self.currentBottomClearColor
end

function SkyCubeSceneNode:setPreviousBottomClearColor(value)
	self.previousBottomClearColor = value
end

function SkyCubeSceneNode:getPreviousBottomClearColor()
	return self.previousBottomClearColor
end

function SkyCubeSceneNode:tick(frameDelta)
	self.previousTopClearColor = (self.previousTopClearColor or self.currentTopClearColor):lerp(self.currentTopClearColor, frameDelta)
	self.previousBottomClearColor = (self.previousBottomClearColor or self.currentBottomClearColor):lerp(self.currentBottomClearColor, frameDelta)

	SceneNode.tick(self, frameDelta)
end

function SkyCubeSceneNode:_updateMesh(renderer)
	local camera = renderer:getCamera()
	local projection, view = camera:getTransforms()
	local projectionView = projection * view

	for i, vertex in ipairs(SkyCubeSceneNode.MESH_DATA) do
		local x, y, z = unpack(vertex)
		x, y, z = projectionView:inverseTransformPoint(unpack(vertex))

		local otherVertex = self.vertices[i]
		otherVertex[1] = x
		otherVertex[2] = y
		otherVertex[3] = z
	end

	self.mesh:setVertices(self.vertices)
end

function SkyCubeSceneNode:draw(renderer, frameDelta)
	local shader = renderer:getCurrentShader()
	if shader then
		if shader:hasUniform("scape_TopClearColor") then
			local topClearColor = self.previousTopClearColor:lerp(self.currentTopClearColor, frameDelta)
			shader:send("scape_TopClearColor", { topClearColor:get() })
		end

		if shader:hasUniform("scape_BottomClearColor") then
			local bottomClearColor = self.previousBottomClearColor:lerp(self.currentBottomClearColor, frameDelta)
			shader:send("scape_BottomClearColor", { bottomClearColor:get() })
		end
	end

	self:_updateMesh(renderer)
	love.graphics.draw(self.mesh)
end

return SkyCubeSceneNode
