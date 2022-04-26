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
Renderer.DEFAULT_CLEAR_COLOR = Color(0.39, 0.58, 0.93, 1)

function Renderer:new(isMobile)
	self.cachedShaders = {}
	self.currentShader = false

	self.isMobile = isMobile
	if self.isMobile then
		self.mobilePass = MobileRendererPass(self)
	else
		self.finalDeferredPass = DeferredRendererPass(self)
		self.finalForwardPass = ForwardRendererPass(self)
	end

	self.width = 0
	self.height = 0

	self.clearColor = Renderer.DEFAULT_CLEAR_COLOR

	self.cull = true
	self.startTime = love.timer.getTime()
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
				shader:send("scape_Time", love.timer.getTime() - self.startTime)
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

if _DEBUG then
	function Renderer:renderNode(node, delta)
		local debugStats = self.debugStats or {}

		local nodeName = node:getDebugInfo().shortName
		local stat = debugStats[nodeName] or { min = math.huge, max = -math.huge, currentTotal = 0, samples = 0 }

		local before = love.timer.getTime()
		node:beforeDraw(self, delta)
		node:draw(self, delta)
		node:afterDraw(self, delta)
		local after = love.timer.getTime()
		local duration = after - before

		stat.min = math.min(stat.min, duration)
		stat.max = math.max(stat.max, duration)
		stat.currentTotal = stat.currentTotal + duration
		stat.samples = stat.samples + 1

		debugStats[nodeName] = stat
		self.debugStats = debugStats
	end

	function Renderer:dumpStatsToCSV(filename)
		local debugStats = {}
		do
			local unsortedDebugStats = self.debugStats or {}
			for nodeName, stats in pairs(unsortedDebugStats) do
				table.insert(debugStats, {
					nodeName = nodeName,
					stats = stats
				})
			end

			table.sort(debugStats, function(a, b)
				return a.nodeName < b.nodeName
			end)
		end

		local file = io.open(filename, "w")

		for i = 1, #debugStats do
			local stats = debugStats[i].stats
			local nodeName = debugStats[i].nodeName
			local f = string.format(
				"%s, %f, %f, %f, %f, %f\n",
				nodeName, stats.min, stats.max, stats.currentTotal, stats.samples, stats.currentTotal / stats.samples)

			file:write(f)
		end
	end
else
	function Renderer:renderNode(node, delta)
		node:beforeDraw(self, delta)
		node:draw(self, delta)
		node:afterDraw(self, delta)
	end

	function Renderer:dumpStatsToCSV()
		-- Nothing.
	end
end

return Renderer
