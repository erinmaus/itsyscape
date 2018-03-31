--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DeferredRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
-------------------------------------------------------------------------------

local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local LBuffer = require "ItsyScape.Graphics.LBuffer"

-- Deferred renderer pass.
--
-- Renders everything into a giant buffer (GBuffer), then applies lighting
-- after.
local DeferredRendererPass = Class(RendererPass)

DeferredRendererPass.DEFAULT_PIXEL_SHADER = [[
vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	return color;
}
]]

DeferredRendererPass.DEFAULT_VERTEX_SHADER = [[
vec4 performTransform(mat4 modelViewProjectionMatrix, vec4 position)
{
	return modelViewProjectionMatrix * position;
}
]]

local PendingNode, PendingNodeMetatable = Class()

function PendingNode:new(node, delta)
	self.node = node

	local transform = node:getTransform():getGlobalDeltaTransform(delta)
	local wx, wy, wz = transform:transformPoint(0, 0, 0)
	self.worldPosition = Vector(wx, wy, wz)

	local sx, sy, sz = love.graphics.project(wx, wy, wz)
	self.screenPosition = Vector(sx, sy, sz)
end

function PendingNodeMetatable.__lt(a, b)
	if a.node:getMaterial() < b.node:getMaterial() then
		return true
	else
		return a.screenPosition.z < b.screenPosition.z
	end
end

function DeferredRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.gBuffer = false
	self.lBuffer = false

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Deferred/Base.frag.glsl",
		"Resources/Renderers/Deferred/Base.vert.glsl")

	self.defaultShader = ShaderResource(
		DeferredRendererPass.DEFAULT_PIXEL_SHADER,
		DeferredRendererPass.DEFAULT_VERTEX_SHADER)
end

function DeferredRendererPass:getGBuffer()
	return self.gBuffer
end

function DeferredRendererPass:getLBuffer()
	return self.lBuffer
end

function DeferredRendererPass:walk(node, delta)
	local material = node:getMaterial()
	if not material:getIsTranslucent() then
		table.insert(self.nodes, PendingNode(node, delta))
	end

	for child in node:iterate() do
		self:walk(child, delta)
	end
end

function DeferredRendererPass:sortPendingNodes()
	table.sort(self.nodes)
end

function DeferredRendererPass:beginDraw(scene, delta)
	self.nodes = {}

	self:walk(scene, delta)
	self:sortPendingNodes()
end

function DeferredRendererPass:endDraw(scene, delta)
	-- Nothing.
end

function DeferredRendererPass:drawNodes(scene, delta)
	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('less', true)

	if self.gBuffer then
		self.gBuffer:use()
		love.graphics.clear(0, 0, 0, 0)

		self:getRenderer():getCamera():apply()
	else
		error("no GBuffer")
	end

	local previousShader = nil
	for i = 1, #self.nodes do
		local node = self.nodes[i].node

		local material = node:getMaterial()
		local shader = material:getShader() or self.defaultShader
		if shader then
			if previousShader ~= shader then
				self:useShader(shader)
				previousShader = shader
			end

			node:beforeDraw(self:getRenderer(), delta)
			node:draw(self:getRenderer(), delta)
			node:afterDraw(self:getRenderer(), delta)
		end
	end
end

function DeferredRendererPass:drawLights(scene, delta)
	-- TODO
	love.graphics.setDepthMode('always', false)

	if not self.lBuffer then
		error("no LBuffer")
	end

	self.lBuffer:use()
	love.graphics.setShader()
	love.graphics.origin()
	love.graphics.draw(self.gBuffer:getColor())
end

function DeferredRendererPass:resize(width, height)
	if not self.gBuffer then
		self.gBuffer = GBuffer(width, height)
	else
		self.gBuffer:resize(width, height)
	end

	if not self.lBuffer then
		self.lBuffer = LBuffer(self.gBuffer)
	else
		self.lBuffer:resize(self.gBuffer)
	end
end

function DeferredRendererPass:draw(scene, delta)
	self:drawNodes(scene, delta)
	self:drawLights(scene, delta)
end

return DeferredRendererPass
