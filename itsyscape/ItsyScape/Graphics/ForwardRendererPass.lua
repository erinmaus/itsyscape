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
local LightSceneNode = require "ItsyScape.Graphics.LightSceneNode"

-- Base renderer pass type. Manages logic for a specific pass.
local ForwardRendererPass = Class(RendererPass)

-- Maximum number of lights that can be rendered at once.
ForwardRendererPass.MAX_LIGHTS = 16

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
	if a.screenPosition.z < b.screenPosition.z then
		return true
	elseif a.screenPosition.z > b.screenPosition.z then
		return false
	else
		return a.node:getMaterial() < b.node:getMaterial()
	end
end

function ForwardRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.lBuffer = false

	self:loadBaseShaderFromFile(
		"Resources/Renderers/Forward/Base.frag.glsl",
		"Resources/Renderers/Forward/Base.vert.glsl")
end

function ForwardRendererPass:setLBuffer(value)
	if not self.lBuffer then
		self.lBuffer = false
	else
		self.lBuffer = value
	end
end

function ForwardRendererPass:walk(node, delta)
	if node:isCompatibleType(LightSceneNode) then
		if node:getIsGlobal() then
			table.insert(self.globalLights, PendingNode(node, delta))
		else
			table.insert(self.lights, PendingNode(node, delta))
		end
	else
		local material = node:getMaterial()
		if material:getIsTranslucent() then
			table.insert(self.nodes, PendingNode(node, delta))
		end
	end

	for child in node:iterate() do
		self:walk(child, delta)
	end
end

function ForwardRendererPass:sortPendingNodes()
	table.sort(self.nodes)
	table.sort(self.lights)
end

function ForwardRendererPass:beginDraw(scene, delta)
	self.nodes = {}
	self.lights = {}
	self.globalLights = {}

	self:walk(scene, delta)
	self:sortPendingNodes()
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

	for i = 1, #self.nodes do
		local node = self.nodes[i].node

		local material = node:getMaterial()
		local shader = material:getShader()
		if shader then
			if previousShader ~= shader then
				currentShaderProgram = self:useShader(material:getShader())
				previousShader = shader

				for i = 1, numGlobalLights do
					local p = self.globalLights[i]
					local light = p.node:toLight(delta)
					light:setPosition(p.worldPosition)

					setLightProperties(currentShaderProgram, i, light)
				end
			end

			-- TODO: Local lights
			currentShaderProgram:send("scape_NumLights", numGlobalLights)

			node:beforeDraw(self:getRenderer(), delta)
			node:draw(self:getRenderer(), delta)
			node:afterDraw(self:getRenderer(), delta)
		end
	end
end

function ForwardRendererPass:draw(scene, delta)
	love.graphics.setMeshCullMode('back')
	love.graphics.setDepthMode('less', true)

	self:getRenderer():getCamera():apply()
	self:drawNodes(scene, delta)
end

return ForwardRendererPass
