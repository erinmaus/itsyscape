--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ForwardRendererPass.lua
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
local Light = require "ItsyScape.Graphics.Light"
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"

-- Base renderer pass type. Manages logic for a specific pass.
local ForwardRendererPass = Class(RendererPass)

-- Maximum number of lights that can be rendered at once.
ForwardRendererPass.MAX_LIGHTS = 16

function ForwardRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.lBuffer = false

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Forward/Base.frag.glsl",
		"Resources/Renderers/Forward/Base.vert.glsl")

	self.lightTypes = {}
	self.nodeTypes = {}
end

function ForwardRendererPass:setLBuffer(value)
	if not self.lBuffer then
		self.lBuffer = false
	else
		self.lBuffer = value
	end
end

function ForwardRendererPass:walk(node, delta)
	local projection, view = self:getRenderer():getCamera():getTransforms()
	local nodes = node:walkByPosition(view, projection, delta, self:getRenderer():getCullEnabled())

	for i = 1, #nodes do
		local n = nodes[i]
		local material = n:getMaterial()

		if (material:getIsTranslucent() or material:getIsFullLit()) and
		   not Class.isCompatibleType(n, LightSceneNode)
		then
			table.insert(self.nodes, n)
		end
	end
end

function ForwardRendererPass:walkLights(node, delta)
	local nodeType = node:getType()
	if self.lightTypes[nodeType] or
	   not self.nodeTypes[nodeType] and node:isCompatibleType(LightSceneNode)
	then
		self.lightTypes[nodeType] = true
		if node:getIsGlobal() then
			table.insert(self.globalLights, node)
		else
			table.insert(self.lights, node)
		end
	else
		self.nodeTypes[nodeType] = true
	end

	for child in node:iterate() do
		self:walkLights(child, delta)
	end
end

function ForwardRendererPass:beginDraw(scene, delta)
	self.nodes = {}
	self.lights = {}
	self.globalLights = {}

	self:walk(scene, delta)
	self:walkLights(scene, delta)
end

function ForwardRendererPass:endDraw(scene, delta)
	-- Nothing.
end

local function setLightProperties(shader, index, light)
	index = index - 1

	for key, value in pairs(light) do
		if type(key) == 'string' then
			local uniform = string.format("scape_Lights[%d].%s", index, key)

			if shader:hasUniform(uniform) then
				shader:send(uniform, value)
			end
		end
	end
end

function ForwardRendererPass:drawNodes(scene, delta)
	local previousShader = nil
	local currentShaderProgram = nil
	local numGlobalLights = math.min(#self.globalLights, ForwardRendererPass.MAX_LIGHTS)

	local projection, view = self:getRenderer():getCamera():getTransforms()
	local viewProjection = projection * view

	for i = 1, #self.nodes do
		local node = self.nodes[i]

		local material = node:getMaterial()
		local shader = material:getShader()
		if shader then
			local numLights
			if previousShader ~= shader then
				currentShaderProgram = self:useShader(material:getShader())
				previousShader = shader

				if material:getIsFullLit() then
					local light = Light()
					light:setAmbience(1.0)
					setLightProperties(currentShaderProgram, 1, light)

					numLights = 1
				else
					for i = 1, numGlobalLights do
						local p = self.globalLights[i]
						local light = p:toLight(delta)

						setLightProperties(currentShaderProgram, i, light)
					end

					numLights = numGlobalLights
				end

				-- TODO: Local lights
				currentShaderProgram:send("scape_NumLights", numLights)
			end

			local d = node:getTransform():getGlobalDeltaTransform(delta)
			if currentShaderProgram:hasUniform("scape_WorldMatrix") then
				currentShaderProgram:send("scape_WorldMatrix", d)
			end

			if currentShaderProgram:hasUniform("scape_NormalMatrix") then
				currentShaderProgram:send("scape_NormalMatrix", d:inverseTranspose())
			end

			if material:getIsZWriteDisabled() then
				love.graphics.setDepthMode('lequal', false)
			end

			node:beforeDraw(self:getRenderer(), delta)
			node:draw(self:getRenderer(), delta)
			node:afterDraw(self:getRenderer(), delta)

			if material:getIsZWriteDisabled() then
				love.graphics.setDepthMode('lequal', true)
			end
		end
	end
end

function ForwardRendererPass:draw(scene, delta)
	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('lequal', true)
	love.graphics.setBlendMode('alpha')

	self:getRenderer():getCamera():apply()
	self:drawNodes(scene, delta)
end

return ForwardRendererPass
