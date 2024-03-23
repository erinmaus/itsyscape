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
Renderer.DISTANCE_SHADER = ShaderResource()
Renderer.COMPOSE_SHADER = ShaderResource()
do
	Renderer.OUTLINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Outline")
	Renderer.CUSTOM_OUTLINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/CustomOutline")
	Renderer.INIT_DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/InitDistance")
	Renderer.DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/JumpDistance")
	Renderer.COMPOSE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Compose")
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
	scale = 128,
	octaves = 1,
	lacunarity = 1,
	offset = Vector(37, 47, 17)
}

Renderer.Y_NOISE = NoiseBuilder {
	persistence = 4,
	scale = 128,
	octaves = 1,
	lacunarity = 1,
	offset = Vector(73, 14, 64)
}

function Renderer:new()
	self._renderer = NRenderer(self)

	self.outlinePass = OutlineRendererPass(self)
	self.finalDeferredPass = DeferredRendererPass(self)
	self.finalForwardPass = ForwardRendererPass(self, self.finalDeferredPass)
	self.passesByID = {
		[self.outlinePass:getID()] = self.outlinePass,
		[self.finalDeferredPass:getID()] = self.finalDeferredPass,
		[self.finalForwardPass:getID()] = self.finalForwardPass
	}

	self._renderer:addRendererPass(self.outlinePass:getHandle())
	self._renderer:addRendererPass(self.finalDeferredPass:getHandle())
	self._renderer:addRendererPass(self.finalForwardPass:getHandle())

	self.nodeDebugStats = Renderer.NodeDebugStats()
	self.passDebugStats = Renderer.PassDebugStats()

	self.outlineBuffer = NGBuffer("rgba32f", "rgba8")
	self.distanceBuffer = NGBuffer("rgba32f", "rgba32f")
	self.outlinePostProcessShader = love.graphics.newShader(Renderer.OUTLINE_SHADER:getResource():getSource())
	self.customOutlinePostProcessShader = love.graphics.newShader(Renderer.CUSTOM_OUTLINE_SHADER:getResource():getSource())
	self.initDistancePostProcessShader = love.graphics.newShader(Renderer.INIT_DISTANCE_SHADER:getResource():getSource())
	self.distancePostProcessShader = love.graphics.newShader(Renderer.DISTANCE_SHADER:getResource():getSource())
	self.composePostProcessShader = love.graphics.newShader(Renderer.COMPOSE_SHADER:getResource():getSource())
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
	local buffer = self:getOutputBuffer()
	self.outlinePostProcessShader:send("scape_Near", self.camera:getNear())
	self.outlinePostProcessShader:send("scape_Far", self.camera:getFar())
	--self.outlinePostProcessShader:send("scape_MinDepth", 0.125)
	self.outlinePostProcessShader:send("scape_MaxDepth", -100)
	self.outlinePostProcessShader:send("scape_OutlineThickness", 5)
	self.outlinePostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })

	love.graphics.push("all")
	love.graphics.origin()

	self.outlineBuffer:resize(width, height)
	love.graphics.setShader()
	love.graphics.setCanvas(self.outlineBuffer:getCanvas(1))
	love.graphics.draw(buffer:getDepthStencil())

	love.graphics.setCanvas(self.outlineBuffer:getCanvas(2))
	love.graphics.clear(1, 1, 1, 1)
	love.graphics.setShader(self.outlinePostProcessShader)
	love.graphics.setBlendMode("alpha")
	love.graphics.setDepthMode("always", false)
	love.graphics.draw(buffer:getDepthStencil())

	love.graphics.setShader(self.customOutlinePostProcessShader)
	love.graphics.setColor(0, 0, 0, 1)
	self.customOutlinePostProcessShader:send("scape_TexelSize", { 1.0 / width, 1.0 / height })
	self.customOutlinePostProcessShader:send("scape_OutlineThickness", 2.5)
	love.graphics.setBlendMode("alpha")
	love.graphics.setDepthMode("always", false)
	love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	-- love.graphics.setCanvas(buffer:getColor())
	-- love.graphics.setShader()
	-- love.graphics.setBlendMode("replace")
	-- love.graphics.setDepthMode("always", false)
	-- love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	-- local scale = 1
	-- local smallBufferWidth = width / scale
	-- local smallBufferHeight = height / scale
	-- self.distanceBuffer:resize(smallBufferWidth, smallBufferHeight)

	-- love.graphics.setBlendMode("replace")
	-- love.graphics.setDepthMode("always", false)
	-- love.graphics.setColor(1, 1, 1, 1)

	-- local currentBuffer = self.distanceBuffer:getCanvas(1)
	-- local nextBuffer = self.distanceBuffer:getCanvas(2)

	-- love.graphics.setShader(self.initDistancePostProcessShader)
	-- love.graphics.scale(1 / scale, 1 / scale, 1)
	-- love.graphics.setCanvas(currentBuffer)
	-- love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))
	-- love.graphics.setCanvas(nextBuffer)
	-- love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	-- love.graphics.origin()
	-- love.graphics.setShader(self.distancePostProcessShader)

	-- --self.distancePostProcessShader:send("scape_TextureSize", { smallBufferWidth, smallBufferHeight })
	-- self.distancePostProcessShader:send("scape_MaxDistance", math.huge)

	-- local log2 = function(x)
	-- 	return math.log(x) / math.log(2)
	-- end

	-- local currentX = smallBufferWidth
	-- local currentY = smallBufferHeight
	-- local n = 1
	-- local steps = math.ceil(log2(math.max(smallBufferWidth, smallBufferHeight))) + 1
	-- while currentX > 1 or currentY > 1 do
	-- 	self.distancePostProcessShader:send("scape_JumpDistance", { currentX / smallBufferWidth, currentY / smallBufferHeight })
	-- 	love.graphics.setCanvas(nextBuffer)
	-- 	love.graphics.draw(currentBuffer)

	-- 	currentBuffer, nextBuffer = nextBuffer, currentBuffer

	-- 	n = n + 1
	-- 	if n > steps then
	-- 		break
	-- 	end

	-- 	currentX = currentX / 2
	-- 	if currentX < 1 then
	-- 		currentX = 1
	-- 	end

	-- 	currentY = currentY / 2
	-- 	if currentY < 1 then
	-- 		currentY = 1
	-- 	end
	-- end

	local noiseWidth = width / 8
	local noiseHeight = height / 8

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

	--love.graphics.setCanvas(self.outlineBuffer:getCanvas(2))
	love.graphics.setCanvas(buffer:getColor())
	--love.graphics.setBlendMode("alpha", "premultiplied")
	--love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setBlendMode("alpha")
	love.graphics.setShader()
	--self.composePostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })
	love.graphics.setShader(self.composePostProcessShader)
	self.composePostProcessShader:send("scape_NoiseTextureX", self.outlineNoiseTextureX)
	self.composePostProcessShader:send("scape_NoiseTextureY", self.outlineNoiseTextureY)
	self.composePostProcessShader:send("scape_NoiseTexelSize", { 1 / noiseWidth, 1 / noiseHeight })
	self.composePostProcessShader:send("scape_OutlineTurbulence", 0.75)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))
	--love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))
	--self.composePostProcessShader:send("scape_OutlineTexture", )
	--love.graphics.draw(buffer:getColor())

	--love.graphics.setCanvas(buffer:getColor())

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
	self._renderer:getCamera():update(view, projection)
	self._renderer:getCamera():moveEye(eye:get())
	self._renderer:getCamera():moveTarget(target:get())
	self._renderer:getCamera():rotate(rotation:get())
	self._renderer:draw(scene:getHandle(), delta, width, height)
	self:_drawOutlines(width, height)
end

function Renderer:getOutputBuffer()
	return self.finalDeferredPass:getHandle():getCBuffer()
end

function Renderer:present()
	local buffer = self:getOutputBuffer()

	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.origin()
	love.graphics.setBlendMode('replace')
	love.graphics.setDepthMode('always', false)
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
