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

-- Renderer type. Manages rendering resources and logic.
local Renderer = Class()
Renderer.DEFAULT_CLEAR_COLOR = Color(0.39, 0.58, 0.93, 1)

Renderer.NodeDebugStats = Class(DebugStats)
Renderer.PassDebugStats = Class(DebugStats)

Renderer.OUTLINE_SHADER = ShaderResource()
Renderer.INIT_DISTANCE_SHADER = ShaderResource()
Renderer.DISTANCE_SHADER = ShaderResource()
Renderer.COMBINE_SHADER = ShaderResource()
Renderer.COMPOSE_SHADER = ShaderResource()
do
	Renderer.OUTLINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Outline")
	Renderer.INIT_DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/InitDistance")
	Renderer.DISTANCE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Distance")
	Renderer.COMBINE_SHADER:loadFromFile("Resources/Renderers/PostProcess/Combine")
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

function Renderer:new()
	self._renderer = NRenderer(self)

	self.outlinePass = OutlineRendererPass(self)
	self.finalDeferredPass = DeferredRendererPass(self)
	self.finalForwardPass = ForwardRendererPass(self, self.finalDeferredPass)

	self._renderer:addRendererPass(self.outlinePass:getHandle())
	self._renderer:addRendererPass(self.finalDeferredPass:getHandle())
	self._renderer:addRendererPass(self.finalForwardPass:getHandle())

	self.nodeDebugStats = Renderer.NodeDebugStats()
	self.passDebugStats = Renderer.PassDebugStats()

	self.outlineBuffer = NGBuffer("rgba32f")
	self.distanceBuffer = NGBuffer("rgba16f", "rgba16f", "rgba16f")
	self.outlinePostProcessShader = love.graphics.newShader(Renderer.OUTLINE_SHADER:getResource():getSource())
	self.initDistancePostProcessShader = love.graphics.newShader(Renderer.INIT_DISTANCE_SHADER:getResource():getSource())
	self.distancePostProcessShader = love.graphics.newShader(Renderer.DISTANCE_SHADER:getResource():getSource())
	self.combinePostProcessShader = love.graphics.newShader(Renderer.COMBINE_SHADER:getResource():getSource())
	self.composePostProcessShader = love.graphics.newShader(Renderer.COMPOSE_SHADER:getResource():getSource())

	self.occlusionQueryObjects = {}
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

function Renderer:_drawOutlines(width, height)
	local buffer = self:getOutputBuffer()
	self.outlinePostProcessShader:send("scape_Near", self.camera:getNear())
	self.outlinePostProcessShader:send("scape_Far", self.camera:getFar())
	self.outlinePostProcessShader:send("scape_MinDepth", 0)
	self.outlinePostProcessShader:send("scape_MaxDepth", 1)
	self.outlinePostProcessShader:send("scape_OutlineThickness", 2)
	self.outlinePostProcessShader:send("scape_TexelSize", { 1 / width, 1 / height })

	love.graphics.push("all")
	love.graphics.origin()

	self.outlineBuffer:resize(width, height)
	love.graphics.setShader()
	love.graphics.setCanvas(self.outlineBuffer:getCanvas(1))
	love.graphics.draw(buffer:getDepthStencil())

	love.graphics.setCanvas({
		self.outlinePass:getOBuffer():getCanvas(1),
		depthstencil = buffer:getDepthStencil()
	})
	love.graphics.setShader(self.outlinePostProcessShader)
	love.graphics.setBlendMode("alpha")
	love.graphics.setDepthMode("lequal", true)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.draw(self.outlineBuffer:getCanvas(1))

	-- love.graphics.setCanvas(buffer:getColor())
	-- love.graphics.setShader()
	-- love.graphics.setBlendMode("replace")
	-- love.graphics.setDepthMode("always", false)
	-- love.graphics.setColor(1, 1, 1, 1)
	-- love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	local smallBufferWidth = width
	local smallBufferHeight = height
	self.distanceBuffer:resize(smallBufferWidth, smallBufferHeight)

	love.graphics.setBlendMode("replace")
	love.graphics.setDepthMode("always", false)
	love.graphics.setColor(1, 1, 1, 1)

	local currentBuffer = self.distanceBuffer:getCanvas(1)
	local nextBuffer = self.distanceBuffer:getCanvas(2)
	local mixBuffer = self.distanceBuffer:getCanvas(3)

	love.graphics.setShader(self.initDistancePostProcessShader)
	self.initDistancePostProcessShader:send("scape_InColor", 0.0)
	self.initDistancePostProcessShader:send("scape_OutColor", math.huge)
	love.graphics.setCanvas(currentBuffer)
	love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

	local n = 1
	love.graphics.setShader(self.distancePostProcessShader)

	local xPasses = smallBufferWidth / 8
	for i = 1, xPasses do
		local beta = (1 + (i - 1) * 2)
		local offsetX = 1.0 / smallBufferWidth
		local offsetY = 0

		self.distancePostProcessShader:send("scape_Beta", beta)
		self.distancePostProcessShader:send("scape_Offset", { offsetX, offsetY })

		local query = self.occlusionQueryObjects[n] or NGL.createAnySampleQuery()
		love.graphics.setCanvas(nextBuffer)
		NGL.beginAnySampleQuery(query)

		if i > 1 then
			NGL.beginConditionalRender(self.occlusionQueryObjects[n - 1])
		end

		love.graphics.draw(currentBuffer)
		love.graphics.flushBatch()

		if i > 1 then
			NGL.endConditionalRender()
		end

		NGL.endAnySampleQuery()
		love.graphics.setCanvas()

		self.occlusionQueryObjects[n] = query
		n = n + 1

		currentBuffer, nextBuffer = nextBuffer, currentBuffer
	end

	local yPasses = smallBufferHeight / 8
	for i = 1, yPasses do
		local beta = (1 + (i - 1) * 2)
		local offsetX = 0
		local offsetY = 1.0 / smallBufferHeight

		self.distancePostProcessShader:send("scape_Beta", beta)
		self.distancePostProcessShader:send("scape_Offset", { offsetX, offsetY })

		local query = self.occlusionQueryObjects[n] or NGL.createAnySampleQuery()
		love.graphics.setCanvas(nextBuffer)
		NGL.beginAnySampleQuery(query)

		if i > 1 then
			NGL.beginConditionalRender(self.occlusionQueryObjects[n - 1])
		end

		love.graphics.draw(currentBuffer)
		love.graphics.flushBatch()

		if i > 1 then
			NGL.endConditionalRender()
		end

		NGL.endAnySampleQuery()
		love.graphics.setCanvas()

		self.occlusionQueryObjects[n] = query
		n = n + 1

		currentBuffer, nextBuffer = nextBuffer, currentBuffer
	end

	love.graphics.setCanvas(mixBuffer)
	love.graphics.setShader(self.combinePostProcessShader)
	self.combinePostProcessShader:send("scape_Other", currentBuffer)
	love.graphics.draw(nextBuffer)

	love.graphics.setCanvas(buffer:getColor())
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setShader(self.composePostProcessShader)
	self.composePostProcessShader:send("scape_MaxDistance", 16)
	self.composePostProcessShader:send("scape_DiscardDistance", 1)
	--self.composePostProcessShader:send("scape_OutlineTexture", self.outlinePass:getOBuffer():getCanvas(1))
	--self.composePostProcessShader:send("scape_DiffuseTexture", buffer:getColor())
	love.graphics.draw(mixBuffer)
	--love.graphics.draw(self.outlinePass:getOBuffer():getCanvas(1))

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
