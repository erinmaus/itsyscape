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
local DeferredRendererPass = require "ItsyScape.Graphics.DeferredRendererPass"
local ForwardRendererPass = require "ItsyScape.Graphics.ForwardRendererPass"
local MobileRendererPass = require "ItsyScape.Graphics.MobileRendererPass"

-- Renderer type. Manages rendering resources and logic.
local Renderer = Class()

function Renderer:new(isMobile)
	self.cachedShaders = {}
	self.currentShader = false

	self.isMobile = isMobile or false
	if self.isMobile then
		self.mobilePass = MobileRendererPass(self)
	else
		self.finalDeferredPass = DeferredRendererPass(self)
		self.finalForwardPass = ForwardRendererPass(self)
	end

	self.width = 0
	self.height = 0

	self.clearColor = Color(0.39, 0.58, 0.93, 1)

	self.cull = true
end

function Renderer:getCullEnabled()
	return self.cull
end

function Renderer:setCullEnabled(value)
	if value then
		self.cull = true
	else
		self.cull = false
	end
end

function Renderer:getClearColor()
	return self.clearColor
end

function Renderer:setClearColor(value)
	self.clearColor = value or self.clearColor
end

function Renderer:getCamera()
	return self.camera
end

function Renderer:setCamera(value)
	self.camera = value or self.camera
end

function Renderer:clean()
	self:releaseCachedShaders()
end

function Renderer:drawFinalStep(scene, delta)
	if self.isMobile then
		self.mobilePass:beginDraw(scene, delta)
		self.mobilePass:draw(scene, delta)
		self.mobilePass:endDraw(scene, delta)
	else
		self.finalDeferredPass:beginDraw(scene, delta)
		self.finalDeferredPass:draw(scene, delta)
		self.finalDeferredPass:endDraw(scene, delta)

		local cBuffer = self.finalDeferredPass:getCBuffer()

		cBuffer:use()
		self.finalForwardPass:beginDraw(scene, delta)
		self.finalForwardPass:draw(scene, delta)
		self.finalForwardPass:endDraw(scene, delta)
	end
end

function Renderer:draw(scene, delta, width, height)
	if not width or not height then
		width, height = love.window.getMode()
	end

	scene:frame(delta)

	if width ~= self.width or height ~= self.height then
		self.width = width
		self.height = height

		if self.isMobile then
			self.mobilePass:resize(width, height)
		else
			self.finalDeferredPass:resize(width, height)
			self.finalForwardPass:resize(width, height)
		end
	end

	self:drawFinalStep(scene, delta)

	self:setCurrentShader(false)
end

function Renderer:getOutputBuffer()
	if self.isMobile then
		return self.mobilePass:getMBuffer()
	else
		return self.finalDeferredPass:getCBuffer()
	end
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

function Renderer:setCurrentShader(shader)
	if not shader then
		self.currentShader = false
	else
		if self.currentShader ~= shader then
			self.currentShader = shader
			love.graphics.setShader(shader)

			if shader:hasUniform("scape_Time") then
				shader:send("scape_Time", love.timer.getTime())
			end
		end
	end
end

function Renderer:getCurrentShader(shader)
	return self.currentShader
end

function Renderer:getCachedShader(rendererPassType, shader)
	if not self.cachedShaders[renderPassType] or 
	   not self.cachedShaders[renderPassType][shader] then
		return nil
	end

	return self.cachedShaders[renderPassType][shader]
end

function Renderer:addCachedShader(rendererPassType, shader, pixelSource, vertexSource)
	local shaders = self.cachedShaders[rendererPassType] or {}
	local s = shaders[shader]

	if not s then
		s = love.graphics.newShader(pixelSource, vertexSource)
		shaders[shader] = s
	end

	self.cachedShaders[rendererPassType] = shaders

	return s
end

function Renderer:releaseCachedShaders()
	for _, shaders in pairs(self.cachedShaders) do
		for _, shader in pairs(shaders) do
			shader:release()
		end
	end

	self.cachedShaders = {}
end

return Renderer
