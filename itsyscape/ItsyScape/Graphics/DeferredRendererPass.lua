--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DeferredRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local LBuffer = require "ItsyScape.Graphics.LBuffer"
local AmbientLightSceneNode = require "ItsyScape.Graphics.AmbientLightSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"

-- Deferred renderer pass.
--
-- Renders everything into a giant buffer (GBuffer), then applies lighting
-- after.
local DeferredRendererPass = Class(RendererPass)
local LightShaderResourceCache = {}

DeferredRendererPass.DEFAULT_PIXEL_SHADER = [[
vec4 performEffect(vec4 color, vec2 textureCoordinate)
{
	return color;
}
]]

DeferredRendererPass.DEFAULT_VERTEX_SHADER = [[
void performTransform(
	mat4 modelViewProjectionMatrix,
	vec4 position,
	out vec3 localPosition,
	out vec4 projectedPosition)
{
	localPosition = position.xyz;
	projectedPosition = modelViewProjectionMatrix * position;
}
]]

local PendingNode, PendingNodeMetatable = Class()

function PendingNode:new(node, delta)
	self.node = node

	self.transform = node:getTransform():getGlobalDeltaTransform(delta)
	local wx, wy, wz = self.transform:transformPoint(0, 0, 0)
	self.worldPosition = Vector(wx, wy, wz) 

	local sx, sy, sz = love.graphics.project(wx, wy, wz)
	self.screenPosition = Vector(sx, sy, sz)
end

function PendingNodeMetatable.__lt(a, b)
	if a.node:getMaterial() < b.node:getMaterial() then
		return true
	elseif a.node:getMaterial() > b.node:getMaterial() then
		return false
	else
		return a.screenPosition.z < b.screenPosition.z
	end
end

function DeferredRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.gBuffer = false
	self.lBuffer = false
	self.cBuffer = false

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Deferred/Base.frag.glsl",
		"Resources/Renderers/Deferred/Base.vert.glsl")

	self.defaultShader = ShaderResource(
		DeferredRendererPass.DEFAULT_PIXEL_SHADER,
		DeferredRendererPass.DEFAULT_VERTEX_SHADER)

	self.fullLit = AmbientLightSceneNode()
	self.fullLit:setAmbience(1)
end

function DeferredRendererPass:getGBuffer()
	return self.gBuffer
end

function DeferredRendererPass:getLBuffer()
	return self.lBuffer
end

function DeferredRendererPass:getCBuffer()
	return self.cBuffer
end

function DeferredRendererPass:walk(node, delta)
	if node:isCompatibleType(LightSceneNode) then
		if node:isCompatibleType(FogSceneNode) then
			table.insert(self.fog, PendingNode(node, delta))
		else
			table.insert(self.lights, PendingNode(node, delta))
		end
	else
		local material = node:getMaterial()
		if not material:getIsTranslucent() and not material:getIsFullLit() then
			table.insert(self.nodes, PendingNode(node, delta))
		end
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
	self.lights = {}
	self.fog = {}

	self:walk(scene, delta, viewProjection, worldViewProjection)
	self:sortPendingNodes()
end

function DeferredRendererPass:endDraw(scene, delta)
	-- Nothing.
end

function DeferredRendererPass:drawNodes(scene, delta)
	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('lequal', true)

	local camera = self:getRenderer():getCamera()
	if self.gBuffer then
		self.gBuffer:use()
		love.graphics.clear(self:getRenderer():getClearColor():get())

		camera:apply()
	else
		error("no GBuffer")
	end

	local visible, invisible = 0, 0

	local projection, view = camera:getTransforms()
	local viewProjection = projection * view

	local previousShader = nil
	local currentShaderProgram
	for i = 1, #self.nodes do
		local node = self.nodes[i].node
		local transform = self.nodes[i].transform

		local material = node:getMaterial()
		local shader = material:getShader() or self.defaultShader
		if shader then
			if previousShader ~= shader then
				currentShaderProgram = self:useShader(shader)
				previousShader = shader
			end

			do
				if currentShaderProgram:hasUniform("scape_WorldMatrix") then
					currentShaderProgram:send("scape_WorldMatrix", transform)

					if currentShaderProgram:hasUniform("scape_NormalMatrix") then
						currentShaderProgram:send("scape_NormalMatrix", transform:inverseTranspose())
					end
				end

				node:beforeDraw(self:getRenderer(), delta)
				node:draw(self:getRenderer(), delta)
				node:afterDraw(self:getRenderer(), delta)
			end
		end
	end
end

function DeferredRendererPass:getLightShader(type)
	local shader = LightShaderResourceCache[type]
	if not shader then
		local pixelFilename = string.format("Resources/Renderers/Deferred/%s.frag.glsl", type)
		local vertexFilename = string.format("Resources/Renderers/Deferred/Light.vert.glsl")
		local pixelSource = love.filesystem.read(pixelFilename)
		local vertexSource = love.filesystem.read(vertexFilename)

		shader = ShaderResource(pixelSource, vertexSource)
		LightShaderResourceCache[type] = shader
	end

	local compiledShader = self:getRenderer():getCachedShader(self:getType(), shader)
	if not compiledShader then
		compiledShader = self.renderer:addCachedShader(
			self:getType(),
			shader,
			shader:getResource():getPixelSource(),
			shader:getResource():getVertexSource())
	end

	love.graphics.setShader(compiledShader)
	return compiledShader
end

function DeferredRendererPass:drawDirectionalLight(node, delta)
	local directionalLightShader = self:getLightShader('DirectionalLight')
	local light = node:toLight(delta)
	local direction = light:getPosition()
	local color = light:getColor()

	directionalLightShader:send('scape_NormalSpecularTexture', self.gBuffer:getNormalSpecular())
	directionalLightShader:send('scape_LightDirection', { direction.x, direction.y, direction.z })
	directionalLightShader:send('scape_LightColor', { color.r, color.g, color.b })

	love.graphics.setDepthMode('always', false)
	love.graphics.origin()
	love.graphics.ortho(self.gBuffer:getWidth(), self.gBuffer:getHeight())
	love.graphics.draw(self.gBuffer:getColor())
end

function DeferredRendererPass:drawAmbientLight(node, delta)
	local ambientLightShader = self:getLightShader('AmbientLight')
	local light = node:toLight(delta)
	local color = light:getColor()

	ambientLightShader:send('scape_LightAmbientCoefficient', light:getAmbience())
	ambientLightShader:send('scape_LightColor', { color.r, color.g, color.b })

	love.graphics.setDepthMode('always', false)
	love.graphics.origin()
	love.graphics.ortho(self.gBuffer:getWidth(), self.gBuffer:getHeight())
	love.graphics.draw(self.gBuffer:getColor())
end

function DeferredRendererPass:drawPointLight(node, delta)
	local directionalLightShader = self:getLightShader('PointLight')
	local light = node:toLight(delta)
	local position = light:getPosition()
	local attenuation = light:getAttenuation()
	local color = light:getColor()

	directionalLightShader:send('scape_PositionTexture', self.gBuffer:getPosition())
	directionalLightShader:send('scape_LightPosition', { position.x, position.y, position.z })
	directionalLightShader:send('scape_LightAttenuation', attenuation)
	directionalLightShader:send('scape_LightColor', { color.r, color.g, color.b })

	love.graphics.setDepthMode('always', false)
	love.graphics.origin()
	love.graphics.ortho(self.gBuffer:getWidth(), self.gBuffer:getHeight())
	love.graphics.draw(self.gBuffer:getColor())
end

function DeferredRendererPass:drawFogNode(node, delta)
	local fogShader = self:getLightShader('Fog')
	local light = node:toLight(delta)
	local fogStart = light:getPosition():getLength()
	local fogEnd = light:getAttenuation()
	local color = light:getColor()
	local eye = self:getRenderer():getCamera():getEye()

	fogShader:send('scape_PositionTexture', self.gBuffer:getPosition())
	fogShader:send('scape_FogParameters', { fogStart, fogEnd })
	fogShader:send('scape_FogColor', { color.r, color.g, color.b })
	fogShader:send('scape_CameraEye', { eye.x, eye.y, eye.z })

	do
		love.graphics.setDepthMode('always', false)
		love.graphics.origin()
		love.graphics.ortho(self.gBuffer:getWidth(), self.gBuffer:getHeight())
		love.graphics.draw(self.gBuffer:getColor())
	end
end

function DeferredRendererPass:drawLights(scene, delta)
	love.graphics.setBlendMode('add', 'premultiplied')

	if not self.lBuffer then
		error("no LBuffer")
	end

	self.lBuffer:use()
	love.graphics.clear(0, 0, 0, 1, false, false)

	if #self.lights == 0 then
		self:drawAmbientLight(self.fullLit, delta)
	else
		for i = 1, #self.lights do
			local node = self.lights[i].node
			if node:isCompatibleType(DirectionalLightSceneNode) then
				self:drawDirectionalLight(node, delta)
			elseif node:isCompatibleType(AmbientLightSceneNode) then
				self:drawAmbientLight(node, delta)
			elseif node:isCompatibleType(PointLightSceneNode) then
				self:drawPointLight(node, delta)
			end
		end
	end

	self.cBuffer:use()
	do
		love.graphics.setShader()
		love.graphics.origin()
		love.graphics.ortho(self.cBuffer:getWidth(), self.cBuffer:getHeight())
		do
			love.graphics.setBlendMode('replace')
			love.graphics.draw(self.gBuffer:getColor())
		end
		do
			love.graphics.setBlendMode('multiply', 'premultiplied')
			love.graphics.draw(self.lBuffer:getColor())
		end
	end
end

function DeferredRendererPass:drawFog(scene, delta)
	love.graphics.setBlendMode('alpha', 'premultiplied')

	if #self.fog == 0 then
		return
	end

	if not self.fBuffer then
		error("no LBuffer")
	end

	self.fBuffer:use()
	love.graphics.clear(0, 0, 0, 0, false, false)

	for i = 1, #self.fog do
		self:drawFogNode(self.fog[i].node, delta)
	end

	self.cBuffer:use()
	do
		love.graphics.setShader()
		love.graphics.origin()
		love.graphics.ortho(self.cBuffer:getWidth(), self.cBuffer:getHeight())
		love.graphics.draw(self.fBuffer:getColor())
	end
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

	if not self.fBuffer then
		self.fBuffer = LBuffer(self.gBuffer)
	else
		self.fBuffer:resize(self.gBuffer)
	end

	if not self.cBuffer then
		self.cBuffer = LBuffer(self.gBuffer)
	else
		self.cBuffer:resize(self.gBuffer)
	end
end

function DeferredRendererPass:draw(scene, delta)
	self:drawNodes(scene, delta)
	self:drawLights(scene, delta)
	self:drawFog(scene, delta)
end

return DeferredRendererPass
