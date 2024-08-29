--------------------------------------------------------------------------------
-- ItsyScape/Graphics/SSRPostProcessPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local SSRPostProcessPass = Class(PostProcessPass)
SSRPostProcessPass.ID = PostProcessPass.newID()

function SSRPostProcessPass:load(resources)
	PostProcessPass.load(self, resources)

	self.mapTextureCoordinatesShader = self:loadPostProcessShader("MapTextureCoordinatesSSR")
	self.buildColorShader = self:loadPostProcessShader("BuildColorSSR")
	self.combineShader = self:loadPostProcessShader("CombineSSR")
	self.blurShader = self:loadPostProcessShader("Blur")

	self.textureCoordinatesBuffer = NGBuffer("rgba16f")
	self.colorBuffer = NGBuffer("rgba8", "rgba8", "rgba8")

	self.minSecondPassSteps = 20
	self.maxSecondPassSteps = 60
	self.maxFirstPassSteps = 90
	self.resolution = 0.5
	self.maxDistanceViewSpace = 14
end

function SSRPostProcessPass:setMinMaxSecondPassSteps(min, max)
	self.minSecondPassSteps = math.min(min or self.minSecondPassSteps, max or self.minSecondPassSteps)
	self.maxSecondPassSteps = math.max(min or self.maxSecondPassSteps, max or self.maxSecondPassSteps)
end

function SSRPostProcessPass:getMinMaxSecondPassSteps()
	return self.minSecondPassSteps, self.maxSecondPassSteps
end

function SSRPostProcessPass:setMaxFirstPassSteps(value)
	self.maxFirstPassSteps = value or self.maxFirstPassSteps
end

function SSRPostProcessPass:getMaxFirstPassSteps()
	return self.maxFirstPassSteps
end

function SSRPostProcessPass:setResolution(value)
	self.resolution = value or self.resolution
end

function SSRPostProcessPass:getResolution()
	return self.resolution
end

function SSRPostProcessPass:setMaxDistanceViewSpace(value)
	self.maxDistanceViewSpace = value or self.maxDistanceViewSpace
end

function SSRPostProcessPass:getMaxDistanceViewspace()
	return self.maxDistanceViewSpace
end

function SSRPostProcessPass:draw(width, height)
	PostProcessPass.draw(self, width, height)

	local reflectionRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_REFLECTION)
	if not reflectionRendererPass:getHandle():getHasReflections() then
		return
	end

	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)

	self.textureCoordinatesBuffer:resize(width, height)
	self.textureCoordinatesBuffer:use()

	love.graphics.clear(0, 0, 0, 0)

	local projection, view = self:getRenderer():getCamera():getTransforms()
	local cameraDirecion = (self:getRenderer():getCamera():getEye() - self:getRenderer():getCamera():getPosition()):getNormal()
	self:bindShader(self.mapTextureCoordinatesShader,
		"scape_Projection", projection,
		"scape_View", view,
		"scape_CameraDirection", { cameraDirecion:get() },
		"scape_MaxDistanceViewSpace", self.maxDistanceViewSpace,
		"scape_MinSecondPassSteps", self.minSecondPassSteps,
		"scape_MaxSecondPassSteps", self.maxSecondPassSteps,
		"scape_MaxFirstPassSteps", self.maxFirstPassSteps,
		"scape_Resolution", self.resolution,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_NormalTexture", reflectionRendererPass:getRBuffer():getCanvas(reflectionRendererPass.NORMAL_INDEX),
		"scape_PositionTexture", reflectionRendererPass:getRBuffer():getCanvas(reflectionRendererPass.POSITION_INDEX),
		"scape_ReflectionPropertiesTexture", reflectionRendererPass:getRBuffer():getCanvas(reflectionRendererPass.REFLECTION_PROPERTIES_INDEX))
	love.graphics.draw(self:getRenderer():getOutputBuffer():getColor())
	
	self.colorBuffer:resize(width, height)

	love.graphics.setCanvas(self.colorBuffer:getCanvas(1))
	love.graphics.clear(0, 0, 0, 0)
	self:bindShader(self.buildColorShader,
		"scape_ColorTexture", self:getRenderer():getOutputBuffer():getColor(),
		"scape_TexelSize", { 1 / width, 1 / height })
	love.graphics.draw(self.textureCoordinatesBuffer:getCanvas(1))
	
	love.graphics.setCanvas(self.colorBuffer:getCanvas(2))
	love.graphics.clear(0, 0, 0, 0)
	self:bindShader(
		self.blurShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_Direction", { 0, 1 })
		love.graphics.draw(self.colorBuffer:getCanvas(1))
		
	love.graphics.setCanvas(self.colorBuffer:getCanvas(3))
	love.graphics.clear(0, 0, 0, 0)
	self:bindShader(
		self.blurShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_Direction", { 1, 0 })
	love.graphics.draw(self.colorBuffer:getCanvas(2))
		
	love.graphics.setCanvas(self.colorBuffer:getCanvas(2))
	love.graphics.clear(0, 0, 0, 0)
	self:bindShader(
		self.blurShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_Direction", { 0, 1 })
	love.graphics.draw(self.colorBuffer:getCanvas(3))
		
	love.graphics.setCanvas(self.colorBuffer:getCanvas(3))
	love.graphics.clear(0, 0, 0, 0)
	self:bindShader(
		self.blurShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_Direction", { 1, 0 })
	love.graphics.draw(self.colorBuffer:getCanvas(2))

	love.graphics.setCanvas(self:getRenderer():getOutputBuffer():getColor())
	self:bindShader(self.combineShader,
		"scape_ClearColorTexture", self.colorBuffer:getCanvas(1),
		"scape_BlurColorTexture", self.colorBuffer:getCanvas(2),
		"scape_ReflectionPropertiesTexture", reflectionRendererPass:getRBuffer():getCanvas(reflectionRendererPass.REFLECTION_PROPERTIES_INDEX))
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.colorBuffer:getCanvas(1))
end

return SSRPostProcessPass
