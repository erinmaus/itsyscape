--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Renderer.lua
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
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local DeferredRendererPass = require "ItsyScape.Graphics.DeferredRendererPass"
local DepthRendererPass = require "ItsyScape.Graphics.DepthRendererPass"
local ForwardRendererPass = require "ItsyScape.Graphics.ForwardRendererPass"
local OutlineRendererPass = require "ItsyScape.Graphics.OutlineRendererPass"
local ParticleOutlineRendererPass = require "ItsyScape.Graphics.ParticleOutlineRendererPass"
local AlphaMaskRendererPass = require "ItsyScape.Graphics.AlphaMaskRendererPass"
local ShadowRendererPass = require "ItsyScape.Graphics.ShadowRendererPass"
local ShimmerRendererPass = require "ItsyScape.Graphics.ShimmerRendererPass"
local ReflectionRendererPass = require "ItsyScape.Graphics.ReflectionRendererPass"
local LBuffer = require "ItsyScape.Graphics.LBuffer"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local NShaderCache = require "nbunny.optimaus.shadercache"
local NRenderer = require "nbunny.optimaus.renderer"
local NGBuffer = require "nbunny.optimaus.gbuffer"
local NGL = require "nbunny.gl"

-- Renderer type. Manages rendering resources and logic.
local Renderer = Class()
Renderer.DEFAULT_CLEAR_COLOR = Color(0.39, 0.58, 0.93, 1)

Renderer.NodeDebugStats = Class(DebugStats)
Renderer.PassDebugStats = Class(DebugStats)

function Renderer.NodeDebugStats:process(node, renderer, delta)
	node:beforeDraw(renderer, delta)
	node:draw(renderer, delta)
	node:afterDraw(renderer, delta)
end

function Renderer.PassDebugStats:process(pass, scene, delta)
	pass:beginDraw(scene, delta)
	pass:draw(scene, delta)
	pass:endDraw(scene, delta)
end

function Renderer:new(conf)
	conf = conf or {}

	self._renderer = NRenderer(self)
	self._time = love.timer.getTime()

	local shadowsEnabled = not conf or (conf.shadows == nil or conf.shadows == true or (type(conf.shadows) == "number" and conf.shadows >= 1))
	local shadowQuality = shadowsEnabled and ((conf and type(conf.shadows) == "number" and conf.shadows >= 1 and math.floor(conf.shadows)) or nil)
	local outlinesEnabled = not conf or (conf.outlines == nil or not not conf.outlines)
	local reflectionsEnabled = not conf or (conf.reflections == nil or not not conf.reflections)

	Log.info("Created renderer (shadows = %s, outlines = %s, reflections = %s).", shadowsEnabled, outlinesEnabled, reflectionsEnabled)

	self.shadowPass = ShadowRendererPass(self, shadowQuality)
	self.outlinePass = OutlineRendererPass(self)
	self.finalDeferredPass = DeferredRendererPass(self, self.shadowPass)
	self.depthPass = DepthRendererPass(self, self.finalDeferredPass:getGBuffer())
	self.finalForwardPass = ForwardRendererPass(self, self.finalDeferredPass)
	self.alphaMaskPass = AlphaMaskRendererPass(self, self.finalDeferredPass:getHandle():getDepthBuffer())
	self.particleOutlinePass = ParticleOutlineRendererPass(self, self.finalDeferredPass:getHandle():getDepthBuffer())
	self.shimmerPass = ShimmerRendererPass(self, self.finalDeferredPass:getHandle():getDepthBuffer())
	self.reflectionPass = ReflectionRendererPass(self, self.finalDeferredPass:getHandle():getGBuffer())
	self.passesByID = {
		[self.shadowPass:getID()] = self.shadowPass,
		[self.outlinePass:getID()] = self.outlinePass,
		[self.finalDeferredPass:getID()] = self.finalDeferredPass,
		[self.depthPass:getID()] = self.depthPass,
		[self.finalForwardPass:getID()] = self.finalForwardPass,
		[self.alphaMaskPass:getID()] = self.alphaMaskPass,
		[self.particleOutlinePass:getID()] = self.particleOutlinePass,
		[self.shimmerPass:getID()] = self.shimmerPass,
		[self.reflectionPass:getID()] = self.reflectionPass,
	}

	if shadowsEnabled then
		self._renderer:addRendererPass(self.shadowPass:getHandle())
	end

	self._renderer:addRendererPass(self.depthPass:getHandle())
	self._renderer:addRendererPass(self.finalDeferredPass:getHandle())
	self._renderer:addRendererPass(self.finalForwardPass:getHandle())

	if outlinesEnabled then
		self._renderer:addRendererPass(self.outlinePass:getHandle())
		self._renderer:addRendererPass(self.alphaMaskPass:getHandle())
		self._renderer:addRendererPass(self.particleOutlinePass:getHandle())
		self._renderer:addRendererPass(self.shimmerPass:getHandle())
	end

	if reflectionsEnabled then
		self._renderer:addRendererPass(self.reflectionPass:getHandle())
	end
	
	self.nodeDebugStats = Renderer.NodeDebugStats()
	self.passDebugStats = Renderer.PassDebugStats()
end

function Renderer:getDeferredPass()
	return self.finalDeferredPass
end

function Renderer:getForwardPass()
	return self.finalForwardPass
end

function Renderer:getHandle()
	return self._renderer
end

function Renderer:getCullEnabled()
	return self._renderer:getCamera():getIsCullEnabled()
end

function Renderer:setCullEnabled(value)
	return self._renderer:getCamera():setIsCullEnabled(value or false)
end

function Renderer:getClearColor()
	return Color(self._renderer:getClearColor())
end

function Renderer:setClearColor(value)
	return self._renderer:setClearColor((value or Renderer.DEFAULT_CLEAR_COLOR):get())
end

function Renderer:getCamera()
	return self.camera
end

function Renderer:setCamera(value)
	self.camera = value or self.camera
end

function Renderer:getNodeDebugStats()
	return self.nodeDebugStats
end

function Renderer:getPassDebugStats()
	return self.passDebugStats
end

function Renderer:clean()
	-- Nothing.
end

function Renderer:getCurrentShader()
	return self._renderer:getCurrentShader()
end

function Renderer:getCurrentPass()
	local passID = self._renderer:getCurrentPassID()
	return self.passesByID[passID]
end

function Renderer:getPassByID(passID)
	return self.passesByID[passID]
end

function Renderer:draw(scene, delta, width, height, postProcessPasses)
	if not width or not height then
		width, height = love.window.getMode()
	end

	local projection, view = self.camera:getTransforms()
	local eye, target = self.camera:getEye(), self.camera:getPosition()
	local rotation = self.camera:getCombinedRotation()
	local boundingSpherePosition, boundingSphereRadius = self.camera:getBoundingSphere()
	local isClipPlaneEnabled, clipPlaneNormal, clipPlanePosition = self.camera:getClipPlane()
	if isClipPlaneEnabled then
		local normal = clipPlaneNormal:getNormal()
		local d = -normal:dot(clipPlanePosition)

		self._renderer:getCamera():setClipPlane(normal.x, normal.y, normal.z, d)
	else
		self._renderer:getCamera():unsetClipPlane()
	end

	self._renderer:getCamera():update(view, projection)
	self._renderer:getCamera():setFieldOfView(self.camera:getFieldOfView())
	self._renderer:getCamera():setNear(self.camera:getNear())
	self._renderer:getCamera():setFar(self.camera:getFar())
	self._renderer:getCamera():moveEye(eye:get())
	self._renderer:getCamera():moveTarget(target:get())
	self._renderer:getCamera():rotate(rotation:get())
	self._renderer:getCamera():updateBoundingSphere(boundingSpherePosition.x, boundingSpherePosition.y, boundingSpherePosition.z, boundingSphereRadius)

	love.graphics.push("all")
	self._renderer:draw(scene:getHandle(), delta, width, height)
	love.graphics.pop()

	if postProcessPasses then
		for _, postProcessPass in ipairs(postProcessPasses) do
			love.graphics.push("all")
			postProcessPass:draw(width, height)
			love.graphics.pop()
		end
	end
end

function Renderer:getOutputBuffer()
	return self.finalDeferredPass:getHandle():getCBuffer()
end

function Renderer:present(alpha)
	local buffer = self:getOutputBuffer()

	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.origin()

	if alpha then
		love.graphics.setBlendMode("alpha", "premultiplied")
	else
		love.graphics.setBlendMode("replace")
	end

	love.graphics.setDepthMode("always", false)
	love.graphics.draw(buffer:getColor())
end

function Renderer:presentCurrent()
	local buffer = self:getOutputBuffer()

	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.setBlendMode('alpha')
	love.graphics.setDepthMode('always', false)
	love.graphics.draw(buffer:getColor())
end

function Renderer:renderNode(node, delta)
	self.nodeDebugStats:measure(node, self, delta)
end

function Renderer:getTime()
	return love.timer.getTime() - self._time
end

function Renderer:setIsChildRenderer(value)
	return self._renderer:setIsChildRenderer(value or false)
end

function Renderer:getIsChildRenderer()
	return self._renderer:getIsChildRenderer()
end

return Renderer
