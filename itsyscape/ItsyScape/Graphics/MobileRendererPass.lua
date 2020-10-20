--------------------------------------------------------------------------------
-- ItsyScape/Graphics/MobileRendererPass.lua
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
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local MBuffer = require "ItsyScape.Graphics.MBuffer"

-- Base renderer pass type. Manages logic for a specific pass.
local MobileRendererPass = Class(RendererPass)

-- Maximum number of lights that can be rendered at once.
MobileRendererPass.MAX_LIGHTS = 16

-- Maximum number of fog that can be rendered at once.
MobileRendererPass.MAX_FOG = 4

function MobileRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Mobile/Base.frag.glsl",
		"Resources/Renderers/Mobile/Base.vert.glsl")

	self.lightTypes = {}
	self.nodeTypes = {}

	self.mBuffer = MBuffer()
end

function MobileRendererPass:getMBuffer()
	return self.mBuffer
end

function MobileRendererPass:resize(width, height)
	self.mBuffer:resize(width, height)
end

function MobileRendererPass:walk(node, delta)
	local projection, view = self:getRenderer():getCamera():getTransforms()
	local nodes = node:walkByMaterial(view, projection, delta, self:getRenderer():getCullEnabled())

	for i = 1, #nodes do
		local n = nodes[i]
		local material = n:getMaterial()

		if not Class.isCompatibleType(n, LightSceneNode) then
			if material:getIsTranslucent() or material:getIsFullLit() then
				table.insert(self.translucentNodes, n)
			else
				table.insert(self.opaqueNodes, n)
			end
		end
	end
end

function MobileRendererPass:walkLights(node, delta)
	local nodeType = node:getType()
	if self.lightTypes[nodeType] or
	   not self.nodeTypes[nodeType] and node:isCompatibleType(LightSceneNode)
	then
		self.lightTypes[nodeType] = true
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

function MobileRendererPass:beginDraw(scene, delta)
	self.translucentNodes = {}
	self.opaqueNodes = {}
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

function MobileRendererPass:endDraw(scene, delta)
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

function MobileRendererPass:drawNodes(nodes, delta)
	local previousShader = nil
	local currentShaderProgram = nil
	local numGlobalLights = math.min(#self.globalLights, MobileRendererPass.MAX_LIGHTS)
	local numFog = math.min(#self.fog, MobileRendererPass.MAX_FOG)
	local camera = self:getRenderer():getCamera()

	for i = 1, #nodes do
		local node = nodes[i]
		local deltaTransform = node:getTransform():getGlobalDeltaTransform(delta)

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

					local remainingLights = math.min(math.max(#self.lights - numGlobalLights, 0), MobileRendererPass.MAX_LIGHTS)
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

					setFogProperties(
						currentShaderProgram,
						i,
						f,
						camera:getEye())
				end

				currentShaderProgram:send("scape_NumFogs", numFog)
			end

			if currentShaderProgram:hasUniform("scape_WorldMatrix") then
				currentShaderProgram:send("scape_WorldMatrix", deltaTransform)
			end

			if currentShaderProgram:hasUniform("scape_NormalMatrix") then
				currentShaderProgram:send("scape_NormalMatrix", deltaTransform:inverseTranspose())
			end

			node:beforeDraw(self:getRenderer(), delta)
			node:draw(self:getRenderer(), delta)
			node:afterDraw(self:getRenderer(), delta)
		end
	end
end

function MobileRendererPass:draw(scene, delta)
	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('lequal', true)
	love.graphics.setBlendMode('alpha')
	
	self.mBuffer:use()
	love.graphics.clear(self:getRenderer():getClearColor():get())

	self:getRenderer():getCamera():apply()
	self:drawNodes(self.opaqueNodes, delta)

	love.graphics.setDepthMode('lequal', false)

	self:getRenderer():getCamera():apply()
	self:drawNodes(self.translucentNodes, delta)
end

return MobileRendererPass
