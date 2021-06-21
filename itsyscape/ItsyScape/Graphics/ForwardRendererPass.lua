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
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local Light = require "ItsyScape.Graphics.Light"
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"

-- Base renderer pass type. Manages logic for a specific pass.
local ForwardRendererPass = Class(RendererPass)

-- Maximum number of lights that can be rendered at once.
ForwardRendererPass.MAX_LIGHTS = 16

-- Maximum number of fog that can be rendered at once.
ForwardRendererPass.MAX_FOG = 4

function ForwardRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.lBuffer = false

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Mobile/Base.frag.glsl",
		"Resources/Renderers/Mobile/Base.vert.glsl")

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
		if node:isCompatibleType(FogSceneNode) then
			table.insert(self.fog, node)
		else
			if node:getIsGlobal() then
				table.insert(self.globalLights, node)
			else
				table.insert(self.lights, node)
			end
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
	self.fog = {}
	self.lights = {}
	self.globalLights = {}

	self:walk(scene, delta)
	self:walkLights(scene, delta)

	local nodeX, nodeY, nodeZ = self:getRenderer():getCamera():getPosition():get()
	table.sort(self.lights, function(a, b)
		local distanceA
		do
			local transform = a:getTransform():getGlobalDeltaTransform(delta)
			local x, y, z = transform:transformPoint(0, 0, 0)
			distanceA = (x - nodeX) ^ 2 + (y - nodeY) ^ 2 + (z - nodeZ) ^ 2
		end

		local distanceB
		do
			local transform = b:getTransform():getGlobalDeltaTransform(delta)
			local x, y, z = transform:transformPoint(0, 0, 0)
			distanceB = (x - nodeX) ^ 2 + (y - nodeY) ^ 2 + (z - nodeZ) ^ 2
		end

		return distanceA < distanceB
	end)
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

local function setFogProperties(shader, index, fog, eye)
	index = index - 1

	function setFogProperty(key, value)
		local uniform = string.format("scape_Fog[%d].%s", index, key)
		if shader:hasUniform(uniform) then
			shader:send(uniform, value)
		end
	end

	setFogProperty("near", fog:getNearDistance())
	setFogProperty("far", fog:getFarDistance())
	setFogProperty("position", { eye.x, eye.y, eye.z })
	setFogProperty("color", { fog:getColor():get() })
end

function ForwardRendererPass:drawNodes(scene, delta)
	local previousShader = nil
	local currentShaderProgram = nil
	local numGlobalLights = math.min(#self.globalLights, ForwardRendererPass.MAX_LIGHTS)
	local numFog = math.min(#self.fog, ForwardRendererPass.MAX_FOG)

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

				if material:getIsFullLit() or numGlobalLights == 0 then
					local light = Light()
					light:setAmbience(1.0)
					setLightProperties(currentShaderProgram, 1, light)

					numLights = 1
				else
					for j = 1, numGlobalLights do
						local p = self.globalLights[j]
						local light = p:toLight(delta)

						setLightProperties(currentShaderProgram, j, light)
					end

					local remainingLights = math.min(math.max(#self.lights - numGlobalLights, 0), ForwardRendererPass.MAX_LIGHTS)
					for j = 1, remainingLights do
						local p = self.lights[j]
						local light = p:toLight(delta)

						setLightProperties(
							currentShaderProgram,
							numGlobalLights - 1 + j,
							light)
					end

					numLights = numGlobalLights + math.max(remainingLights, 1) - 1
				end

				currentShaderProgram:send("scape_NumLights", numLights)

				for i = 1, numFog do
					local f = self.fog[i]

					local eye
					if f:getFollowMode() == f.FOLLOW_MODE_EYE then
						eye = self:getRenderer():getCamera():getEye()
					elseif f:getFollowMode() == f.FOLLOW_MODE_TARGET then
						eye = self:getRenderer():getCamera():getPosition()
					else
						eye = Vector.ZERO
					end

					setFogProperties(
						currentShaderProgram,
						i,
						f,
						eye)
				end

				currentShaderProgram:send("scape_NumFogs", numFog)
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
