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
local ForwardRendererPass = require "ItsyScape.Graphics.ForwardRendererPass"
local OutlineRendererPass = require "ItsyScape.Graphics.OutlineRendererPass"
local ParticleOutlineRendererPass = require "ItsyScape.Graphics.ParticleOutlineRendererPass"
local AlphaMaskRendererPass = require "ItsyScape.Graphics.AlphaMaskRendererPass"
local ShadowRendererPass = require "ItsyScape.Graphics.ShadowRendererPass"
local LBuffer = require "ItsyScape.Graphics.LBuffer"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local NShaderCache = require "nbunny.optimaus.shadercache"
local NRenderer = require "nbunny.optimaus.renderer"
local NGBuffer = require "nbunny.optimaus.gbuffer"
local NGL = require "nbunny.gl"
local NoiseBuilder = require "ItsyScape.Game.Skills.Antilogika.NoiseBuilder"

-- Renderer type. Manages rendering resources and logic.
local Renderer = Class()
Renderer.DEFAULT_CLEAR_COLOR = Color(0.39, 0.58, 0.93, 1)

Renderer.NodeDebugStats = Class(DebugStats)
Renderer.PassDebugStats = Class(DebugStats)

Renderer.OUTLINE_SHADER = ShaderResource()
Renderer.CUSTOM_OUTLINE_SHADER = ShaderResource()
Renderer.INIT_DISTANCE_SHADER = ShaderResource()
Renderer.INIT_ALPHA_DISTANCE_SHADER = ShaderResource()
Renderer.REVERSE_INIT_DISTANCE_SHADER = ShaderResource()
Renderer.DISTANCE_SHADER = ShaderResource()
Renderer.COMPOSE_SHADER = ShaderResource()
Renderer.JITTER_SHADER = ShaderResource()
Renderer.SOBEL_SHADER = ShaderResource()
Renderer.BLUR_SHADER = ShaderResource()
do
	Renderer.OUTLINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Outline")
	Renderer.CUSTOM_OUTLINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/CustomOutline")
	Renderer.INIT_DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/InitDistance")
	Renderer.INIT_ALPHA_DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/InitAlphaDistance")
	Renderer.REVERSE_INIT_DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/ReverseInitDistance")
	Renderer.DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/JumpDistance")
	Renderer.COMPOSE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Compose")
	Renderer.JITTER_SHADER:loadFromFile("Resources/Renderers/PostProcess/Jitter")
	Renderer.SOBEL_SHADER:loadFromFile("Resources/Renderers/PostProcess/Sobel")
	Renderer.BLUR_SHADER:loadFromFile("Resources/Renderers/PostProcess/Blur")
end

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

Renderer.X_NOISE = NoiseBuilder {
	persistence = 4,
	scale = 16,
	octaves = 1,
	lacunarity = 1,
	offset = Vector(37, 47, 17)
}

Renderer.Y_NOISE = NoiseBuilder {
	persistence = 4,
	scale = 16,
	octaves = 1,
	lacunarity = 1,
	offset = Vector(73, 14, 64)
}

function Renderer:new(conf)
	conf = conf or {}

	self._renderer = NRenderer(self)

	local shadowsEnabled = not conf or (conf.shadows == nil or conf.shadows == true or (type(conf.shadows) == "number" and conf.shadows >= 1))
	local shadowQuality = shadowsEnabled and ((conf and type(conf.shadows) == "number" and conf.shadows >= 1 and math.floor(conf.shadows)) or nil)

	self.shadowPass = shadowsEnabled and ShadowRendererPass(self, shadowQuality) or nil
	self.outlinePass = OutlineRendererPass(self)
	self.finalDeferredPass = DeferredRendererPass(self, self.shadowPass)
	self.finalForwardPass = ForwardRendererPass(self, self.finalDeferredPass)
	self.alphaMaskPass = AlphaMaskRendererPass(self, self.finalDeferredPass:getHandle():getDepthBuffer())
	self.particleOutlinePass = ParticleOutlineRendererPass(self, self.finalDeferredPass:getHandle():getDepthBuffer())
	self.passesByID = {
		[shadowsEnabled and self.shadowPass:getID() or 0] = self.shadowPass,
		[self.outlinePass:getID()] = self.outlinePass,
		[self.finalDeferredPass:getID()] = self.finalDeferredPass,
		[self.finalForwardPass:getID()] = self.finalForwardPass,
		[self.alphaMaskPass:getID()] = self.alphaMaskPass,
		[self.particleOutlinePass:getID()] = self.particleOutlinePass,
	}

	if shadowsEnabled then
		self._renderer:addRendererPass(self.shadowPass:getHandle())
	end

	self._renderer:addRendererPass(self.outlinePass:getHandle())
	self._renderer:addRendererPass(self.finalDeferredPass:getHandle())
	self._renderer:addRendererPass(self.finalForwardPass:getHandle())
	self._renderer:addRendererPass(self.alphaMaskPass:getHandle())
	self._renderer:addRendererPass(self.particleOutlinePass:getHandle())
	
	self.nodeDebugStats = Renderer.NodeDebugStats()
	self.passDebugStats = Renderer.PassDebugStats()

	self.outlineBuffer = NGBuffer("rgba8", "rgba8", "rgba8")
	self.distanceBuffer = NGBuffer("rgba16f", "rgba16f")
	self.blurBuffer = NGBuffer("rgba8", "rgba8")
	self.alphaBuffer = NGBuffer("rgba8", "rgba8")
	self.outlinePostProcessShader = love.graphics.newShader(Renderer.OUTLINE_SHADER:getResource():getSource())
	self.customOutlinePostProcessShader = love.graphics.newShader(Renderer.CUSTOM_OUTLINE_SHADER:getResource():getSource())
	self.initDistancePostProcessShader = love.graphics.newShader(Renderer.INIT_DISTANCE_SHADER:getResource():getSource())
	self.initAlphaDistancePostProcessShader = love.graphics.newShader(Renderer.INIT_ALPHA_DISTANCE_SHADER:getResource():getSource())
	self.reverseInitDistancePostProcessShader = love.graphics.newShader(Renderer.REVERSE_INIT_DISTANCE_SHADER:getResource():getSource())
	self.distancePostProcessShader = love.graphics.newShader(Renderer.DISTANCE_SHADER:getResource():getSource())
	self.composePostProcessShader = love.graphics.newShader(Renderer.COMPOSE_SHADER:getResource():getSource())
	self.jitterPostProcessShader = love.graphics.newShader(Renderer.JITTER_SHADER:getResource():getSource())
	self.sobelPostProcessShader = love.graphics.newShader(Renderer.SOBEL_SHADER:getResource():getSource())
	self.blurPostProcessShader = love.graphics.newShader(Renderer.BLUR_SHADER:getResource():getSource())
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

function Renderer:_drawOutlines(width, height)
	self._depthStep = self._depthStep or 0
	if love.keyboard.isDown("k") then
		self._depthStep = self._depthStep + 0.1 * love.timer.getDelta()
		print(">>> +step", self._depthStep)
	end
	if love.keyboard.isDown("l") then
		self._depthStep = self._depthStep - 0.1 * love.timer.getDelta()
		print(">>> -step", self._depthStep)
	end

	local buffer = self:getOutputBuffer()
	self.outlinePostProcessShader:send("scape_Near", self.camera:getNear())
	self.outlinePostProcessShader:send("scape_Far", self.camera:getFar())
	-- self.outlinePostProcessShader:send("scape_MinPlanarDepth", 0.00001)
	-- self.outlinePostProcessShader:send("scape_MaxPlanarDepth", 0.02)
	-- self.outlinePostProcessShader:send("scape_PlanarComparisonFactor",  math.deg(170) / math.pi)
	-- self.outlinePostProcessShader:send("scape_MinDepth", 0.005)
	-- self.outlinePostProcessShader:send("scape_MaxDepth", 0.05)
	-- self.outlinePostProcessShader:send("scape_OutlineThickness", 1)
	self.outlinePostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })
	self.outlinePostProcessShader:send("scape_NormalTexture", self.finalDeferredPass:getGBuffer():getCanvas(3))
	self.outlinePostProcessShader:send("scape_DepthStep", self._depthStep)
	--self.outlinePostProcessShader:send("scape_AlphaMaskTexture", self.alphaMaskPass:getABuffer():getCanvas(1))
	
	love.graphics.push("all")
	love.graphics.origin()

	self.blurBuffer:resize(width, height)
	self.blurBuffer:getCanvas(1):setFilter("linear", "linear")
	self.blurBuffer:getCanvas(2):setFilter("linear", "linear")
	
	self.outlineBuffer:resize(width, height)
	self.outlineBuffer:getCanvas(1):setFilter("linear", "linear")
	self.outlineBuffer:getCanvas(2):setFilter("linear", "linear")
	-- buffer:getDepthStencil():setFilter("nearest", "nearest")
	-- love.graphics.setShader()
	-- love.graphics.setCanvas(self.outlineBuffer:getCanvas(1))
	-- love.graphics.draw(buffer:getDepthStencil())
	
	love.graphics.setShader()
	love.graphics.setCanvas(self.outlineBuffer:getCanvas(3))
	love.graphics.clear(1.0, 1.0, 1.0, 1.0)
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)
	love.graphics.draw(self.alphaMaskPass:getABuffer():getCanvas(0))
	
	love.graphics.setCanvas({
		self.outlineBuffer:getCanvas(2),
		depthstencil = self.alphaMaskPass:getABuffer():getCanvas(0)
	})
	love.graphics.setShader(self.outlinePostProcessShader)
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)
	love.graphics.draw(self.finalDeferredPass:getDepthBuffer())
	
	self.outlinePass:getOBuffer():getCanvas(0):setFilter("nearest", "nearest")
	
	love.graphics.setShader(self.customOutlinePostProcessShader)
	self.customOutlinePostProcessShader:send("scape_Near", self.camera:getNear())
	self.customOutlinePostProcessShader:send("scape_Far", self.camera:getFar())
	--self.customOutlinePostProcessShader:send("scape_TexelSize", { 1.0 / width, 1.0 / height })
	--self.customOutlinePostProcessShader:send("scape_OutlineThickness", 2.5)
	self.customOutlinePostProcessShader:send("scape_DepthTexture", self.outlinePass:getOBuffer():getCanvas(0))
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("lequal", false)
	love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))
	
	love.graphics.setShader(self.sobelPostProcessShader)
	self.sobelPostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })
	self.sobelPostProcessShader:send("scape_AlphaMaskTexture", self.alphaMaskPass:getABuffer():getCanvas(1))
	love.graphics.setBlendMode("alpha", "alphamultiply")
	--love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)
	--love.graphics.draw(buffer:getColor())
	love.graphics.draw(self.alphaMaskPass:getABuffer():getCanvas(2))
	
	self.sobelPostProcessShader:send("scape_AlphaMaskTexture", self.particleOutlinePass:getOBuffer():getCanvas(1))
	love.graphics.draw(self.particleOutlinePass:getOBuffer():getCanvas(1))

	-- love.graphics.setCanvas(buffer:getColor())
	-- love.graphics.setShader()
	-- love.graphics.setBlendMode("replace", "premultiplied")
	-- love.graphics.setDepthMode("always", false)
	-- love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	-- local scale = 1
	-- local smallBufferWidth = width / scale
	-- local smallBufferHeight = height / scale
	self.distanceBuffer:resize(width, height)

	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)
	love.graphics.setColor(1, 1, 1, 1)

	local currentOutlineBuffer = self.distanceBuffer:getCanvas(1)
	currentOutlineBuffer:setFilter("nearest", "nearest")
	local nextOutlineBuffer = self.distanceBuffer:getCanvas(2)
	nextOutlineBuffer:setFilter("nearest", "nearest")
	
	love.graphics.setShader(self.initDistancePostProcessShader)
	self.initDistancePostProcessShader:send("scape_TextureSize", { width, height })
	-- love.graphics.scale(1 / scale, 1 / scale, 1)
	love.graphics.setCanvas(currentOutlineBuffer)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))
	love.graphics.setCanvas(nextOutlineBuffer)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))

	-- love.graphics.origin()
	-- love.graphics.setShader(self.distancePostProcessShader)

	love.graphics.setShader(self.distancePostProcessShader)
	self.distancePostProcessShader:send("scape_TextureSize", { width, height })
	self.distancePostProcessShader:send("scape_MaxDistance", math.huge)

	local c = 0
	
	local currentDistanceX, currentDistanceY
	repeat
		c = c + 1
		self.distancePostProcessShader:send("scape_JumpDistance", { (currentDistanceX or 1) / width, (currentDistanceY or 1) / height })
		love.graphics.setCanvas(nextOutlineBuffer)
		love.graphics.draw(currentOutlineBuffer)

		currentDistanceX = math.max((currentDistanceX or width) / 2, 1)
		currentDistanceY = math.max((currentDistanceY or height) / 2, 1)
		currentOutlineBuffer, nextOutlineBuffer = nextOutlineBuffer, currentOutlineBuffer
	until currentDistanceX <= 1 and currentDistanceY <= 1

	-- self.alphaBuffer:resize(width, height)

	-- local currentAlphaBuffer = self.alphaBuffer:getCanvas(1)
	-- currentAlphaBuffer:setFilter("nearest", "nearest")
	-- local nextAlphaBuffer = self.alphaBuffer:getCanvas(2)
	-- nextAlphaBuffer:setFilter("nearest", "nearest")
	
	-- love.graphics.setShader(self.initAlphaDistancePostProcessShader)
	-- self.initAlphaDistancePostProcessShader:send("scape_TextureSize", { width, height })
	-- love.graphics.setCanvas(currentAlphaBuffer)
	-- love.graphics.draw(self.alphaMaskPass:getABuffer():getCanvas(1))
	-- love.graphics.setCanvas(nextAlphaBuffer)
	-- love.graphics.draw(self.alphaMaskPass:getABuffer():getCanvas(1))

	-- love.graphics.setShader(self.distancePostProcessShader)
	-- self.distancePostProcessShader:send("scape_TextureSize", { width, height })
	-- self.distancePostProcessShader:send("scape_MaxDistance", math.huge)
	
	-- local currentAlphaX, currentAlphaY
	-- repeat
	-- 	self.distancePostProcessShader:send("scape_JumpDistance", { (currentAlphaX or 1) / width, (currentAlphaY or 1) / height })
	-- 	love.graphics.setCanvas(nextAlphaBuffer)
	-- 	love.graphics.draw(currentAlphaBuffer)

	-- 	currentAlphaX = math.max((currentAlphaX or width) / 2, 1)
	-- 	currentAlphaY = math.max((currentAlphaY or height) / 2, 1)
	-- 	currentAlphaBuffer, nextAlphaBuffer = nextAlphaBuffer, currentAlphaBuffer
	-- until currentAlphaX <= 1 and currentAlphaY <= 1

	-- while currentDistanceX > 1 or currentDistanceY > 1 do
	-- 	currentDistanceX = math.max(currentDistanceX / 2, 1)
	-- 	currentDistanceY = math.max(currentDistanceY / 2, 1)
	
	-- 	self.distancePostProcessShader:send("scape_JumpDistance", { currentDistanceX / width, currentDistanceY / height })
	-- 	love.graphics.setCanvas(nextOutlineBuffer)
	-- 	-- DRAW love.graphics.draw(currentOutlineBuffer)

	-- 	currentOutlineBuffer, nextOutlineBuffer = nextOutlineBuffer, currentOutlineBuffer
	-- end

	local noiseWidth = math.floor(width / 8)
	local noiseHeight = math.floor(height / 8)

	if not self.outlineNoiseTextureX or noiseWidth ~= self.outlineNoiseTextureX:getWidth() or noiseHeight ~= self.outlineNoiseTextureX:getHeight() then
		local noise = self.X_NOISE
		self.outlineNoiseTextureX = love.graphics.newImage(noise:sampleTestImage(noiseWidth, noiseHeight))
		self.outlineNoiseTextureX:setWrap("mirroredrepeat", "mirroredrepeat")
	end

	if not self.outlineNoiseTextureY or noiseWidth ~= self.outlineNoiseTextureY:getWidth() or noiseHeight ~= self.outlineNoiseTextureY:getHeight() then
		local noise = self.Y_NOISE
		self.outlineNoiseTextureY = love.graphics.newImage(noise:sampleTestImage(noiseWidth, noiseHeight))
		self.outlineNoiseTextureY:setWrap("mirroredrepeat", "mirroredrepeat")
	end

	love.graphics.setCanvas(self.outlineBuffer:getCanvas(1))
	--love.graphics.setCanvas(buffer:getColor())
	--love.graphics.setBlendMode("alpha", "premultiplied")
	--love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setShader()
	love.graphics.setShader(self.composePostProcessShader)
	self.composePostProcessShader:send("scape_DepthTexture", self.alphaMaskPass:getABuffer():getCanvas(0))
	self.composePostProcessShader:send("scape_OutlineTexture", self.outlineBuffer:getCanvas(2))
	self.composePostProcessShader:send("scape_Near", self.camera:getNear())
	self.composePostProcessShader:send("scape_Far", self.camera:getFar())
	self.composePostProcessShader:send("scape_MinOutlineThickness", 3)
	self.composePostProcessShader:send("scape_MaxOutlineThickness", 7)
	self.composePostProcessShader:send("scape_NearOutlineDistance", 20)
	self.composePostProcessShader:send("scape_FarOutlineDistance", 32)
	self.composePostProcessShader:send("scape_MinOutlineDepthAlpha", 0.0)
	self.composePostProcessShader:send("scape_MaxOutlineDepthAlpha", 1.0)
	self.composePostProcessShader:send("scape_OutlineFadeDepth", 20)
	self.composePostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.draw(currentOutlineBuffer)

	love.graphics.setShader(self.blurPostProcessShader)
	love.graphics.setCanvas(self.blurBuffer:getCanvas(1))
	self.blurPostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })
	self.blurPostProcessShader:send("scape_Direction", { 1, 0 })
	love.graphics.draw(self.outlineBuffer:getCanvas(1))

	love.graphics.setShader(self.blurPostProcessShader)
	love.graphics.setCanvas(self.blurBuffer:getCanvas(2))
	self.blurPostProcessShader:send("scape_Direction", { 0, 1 })
	love.graphics.draw(self.blurBuffer:getCanvas(1))
	
	self.jitterPostProcessShader:send("scape_NoiseTextureX", self.outlineNoiseTextureX)
	self.jitterPostProcessShader:send("scape_NoiseTextureY", self.outlineNoiseTextureY)
	self.jitterPostProcessShader:send("scape_NoiseTexelSize", { 1 / noiseWidth, 1 / noiseHeight })
	self.jitterPostProcessShader:send("scape_OutlineTurbulence", 0.75)
	love.graphics.setShader(self.jitterPostProcessShader)
	--love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))
	--self.composePostProcessShader:send("scape_OutlineTexture", )
	--love.graphics.draw(buffer:getColor())

	love.graphics.setCanvas(buffer:getColor())
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.setColorMask(true, true, true, false)
	--love.graphics.draw(self.blurBuffer:getCanvas(2))
	love.graphics.draw(self.outlineBuffer:getCanvas(1))
	love.graphics.setShader()

	love.graphics.pop()
end

function Renderer:draw(scene, delta, width, height)
	if not width or not height then
		width, height = love.window.getMode()
	end

	scene:frame(delta)

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
	self._renderer:draw(scene:getHandle(), delta, width, height)
	self:_drawOutlines(width, height)
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

return Renderer
