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
	{ "VertexColor", 'float', 4 },
}


SkyCubeSceneNode.MESH_DATA = {
	-- Front.
	{ -1, -1,  1, 0, 0, 1.0, 0.0, 0.0, 1.0, },
	{  1, -1,  1, 0, 0, 1.0, 0.0, 0.0, 1.0, },
	{  1,  1,  1, 0, 1, 1.0, 0.0, 0.0, 1.0, },
	{ -1, -1,  1, 0, 0, 1.0, 0.0, 0.0, 1.0, },
	{  1,  1,  1, 0, 1, 1.0, 0.0, 0.0, 1.0, },
	{ -1,  1,  1, 0, 1, 1.0, 0.0, 0.0, 1.0, },

	-- Back.
	{  1, -1, -1, 0, 0, 0.0, 1.0, 0.0, 1.0, },
	{ -1, -1, -1, 0, 0, 0.0, 1.0, 0.0, 1.0, },
	{  1,  1, -1, 0, 1, 0.0, 1.0, 0.0, 1.0, },
	{  1,  1, -1, 0, 1, 0.0, 1.0, 0.0, 1.0, },
	{ -1, -1, -1, 0, 0, 0.0, 1.0, 0.0, 1.0, },
	{ -1,  1, -1, 0, 1, 0.0, 1.0, 0.0, 1.0, },

	-- Left.
	{ -1, -1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0, },
	{ -1, -1,  1, 0, 0, 0.0, 0.0, 1.0, 1.0, },
	{ -1,  1,  1, 0, 1, 0.0, 0.0, 1.0, 1.0, },
	{ -1,  1, -1, 0, 1, 0.0, 0.0, 1.0, 1.0, },
	{ -1, -1, -1, 0, 0, 0.0, 0.0, 1.0, 1.0, },
	{ -1,  1,  1, 0, 1, 0.0, 0.0, 1.0, 1.0, },

	-- Right.
	{  1,  1,  1, 0, 1, 1.0, 0.0, 1.0, 1.0, },
	{  1, -1,  1, 0, 0, 1.0, 0.0, 1.0, 1.0, },
	{  1, -1, -1, 0, 0, 1.0, 0.0, 1.0, 1.0, },
	{  1,  1,  1, 0, 1, 1.0, 0.0, 1.0, 1.0, },
	{  1, -1, -1, 0, 0, 1.0, 0.0, 1.0, 1.0, },
	{  1,  1, -1, 0, 1, 1.0, 0.0, 1.0, 1.0, },

	-- Top
	{  1,  1, -1, 0, 1, 1.0, 1.0, 0.0, 1.0, },
	{ -1,  1, -1, 0, 1, 1.0, 1.0, 0.0, 1.0, },
	{  1,  1,  1, 0, 1, 1.0, 1.0, 0.0, 1.0, },
	{ -1,  1, -1, 0, 1, 1.0, 1.0, 0.0, 1.0, },
	{ -1,  1,  1, 0, 1, 1.0, 1.0, 0.0, 1.0, },
	{  1,  1,  1, 0, 1, 1.0, 1.0, 0.0, 1.0, },

	-- Bottom.
	{ -1, -1, -1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
	{  1, -1, -1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
	{  1, -1,  1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
	{  1, -1,  1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
	{ -1, -1,  1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
	{ -1, -1, -1, 0, 0, 1.0, 0.5, 0.0, 1.0, },
}

function SkyCubeSceneNode:new()
	SceneNode.new(self)

	self:setBounds(-Vector.ONE, Vector.ONE)
	self:getMaterial():setShader(SkyCubeSceneNode.SHADER)
	self:getMaterial():setIsCullDisabled(true)
	self:getMaterial():setIsZWriteDisabled(false)
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
	self.mesh:setAttributeEnabled("VertexColor", true)

	self.currentTopClearColor = Color(0, 0, 0, 1)
	self.previousTopClearColor = false
	self.tickedTopClearColor = false

	self.currentBottomClearColor = Color(0, 0, 0, 1)
	self.previousBottomClearColor = Color(0, 0, 0, 1)
	self.tickedBottomClearColor = false
end

function SkyCubeSceneNode:setTopClearColor(value)
	self.currentTopClearColor:from(value:get())
end

function SkyCubeSceneNode:getTopClearColor()
	return self.currentTopClearColor
end

function SkyCubeSceneNode:setPreviousTopClearColor(value)
	if not value then
		self.tickedTopClearColor = false
	else
		self.previousTopClearColor:from(value:get())
	end
end

function SkyCubeSceneNode:getPreviousTopClearColor()
	return self.previousTopClearColor
end

function SkyCubeSceneNode:setBottomClearColor(value)
	self.currentBottomClearColor:from(value:get())
end

function SkyCubeSceneNode:getBottomClearColor()
	return self.currentBottomClearColor
end

function SkyCubeSceneNode:setPreviousBottomClearColor(value)
	if not value then
		self.tickedBottomClearColor = false
	else
		self.previousBottomClearColor:from(value:get())
	end
end

function SkyCubeSceneNode:getPreviousBottomClearColor()
	return self.previousBottomClearColor
end

function SkyCubeSceneNode:tick(frameDelta)
	local pb = self.tickedBottomClearColor and self.previousBottomClearColor or self.currentBottomClearColor
	local pt = self.tickedTopClearColor and self.previousTopClearColor or self.currentTopClearColor

	pt:lerp(self.currentTopClearColor, frameDelta, self.previousTopClearColor)
	pb:lerp(self.currentBottomClearColor, frameDelta, self.previousBottomClearColor)

	SceneNode.tick(self, frameDelta)
end

do
	local topClearColor, bottomClearColor = Color(), Color()
	local topClearColorUniform, bottomClearColorUniform = {}, {}
	local identity = love.math.newTransform()

	function SkyCubeSceneNode:draw(renderer, frameDelta)
		local pb = self.tickedBottomClearColor and self.previousBottomClearColor or self.currentBottomClearColor
		local pt = self.tickedTopClearColor and self.previousTopClearColor or self.currentTopClearColor
		pt:lerp(self.currentTopClearColor, frameDelta, topClearColor)
		pb:lerp(self.currentBottomClearColor, frameDelta, bottomClearColor)

		topClearColorUniform[1], topClearColorUniform[2], topClearColorUniform[3], topClearColorUniform[4] = topClearColor:get()
		bottomClearColorUniform[1], bottomClearColorUniform[2], bottomClearColorUniform[3], bottomClearColorUniform[4] = bottomClearColor:get()

		local shader = renderer:getCurrentShader()
		if shader then
			if shader:hasUniform("scape_TopClearColor") then
				shader:send("scape_TopClearColor", topClearColorUniform)
			end

			if shader:hasUniform("scape_BottomClearColor") then
				shader:send("scape_BottomClearColor", bottomClearColorUniform)
			end

			if shader:hasUniform("scape_WorldMatrix") then
				shader:send("scape_WorldMatrix", identity)
			end
		end

		love.graphics.setFrontFaceWinding("cw")
		love.graphics.draw(self.mesh)
		love.graphics.setFrontFaceWinding("ccw")
	end
end

return SkyCubeSceneNode
