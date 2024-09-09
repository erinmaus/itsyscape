--------------------------------------------------------------------------------
-- ItsyScape/Graphics/OutlinePostProcessPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Noise = require "ItsyScape.Graphics.Noise"
local PostProcessPass = require "ItsyScape.Graphics.PostProcessPass"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NGBuffer = require "nbunny.optimaus.gbuffer"

local OutlinePostProcessPass = Class(PostProcessPass)
OutlinePostProcessPass.ID = PostProcessPass.newID()

OutlinePostProcessPass.X_NOISE = Noise {
	scale = 64,
	octaves = 1
}

OutlinePostProcessPass.Y_NOISE = Noise {
	scale = 64,
	octaves = 1,
	offset = Vector(0, 1, 0)
}

function OutlinePostProcessPass:new(...)
	PostProcessPass.new(self, ...)

	self.isEnabled = true
	self.depthStep = 0
	self.normalStep = 0.3
	self.minOutlineThickness = 3
	self.maxOutlineThickness = 7
	self.nearOutlineDistance = 20
	self.farOutlineDistance = 32
	self.minOutlineDepthAlpha = 0.5
	self.maxOutlineDepthAlpha = 1.0
	self.outlineFadeDepth = 20
	self.outlineTurbulence = 0.25
end

function OutlinePostProcessPass:setIsEnabled(value)
	self.isEnabled = value
end

function OutlinePostProcessPass:getIsEnabled()
	return self.isEnabled
end

function OutlinePostProcessPass:setDepthStep(value)
	self.depthStep = value
end

function OutlinePostProcessPass:getDepthStep()
	return self.depthStep
end

function OutlinePostProcessPass:setNormalStep(value)
	self.normalStep = value
end

function OutlinePostProcessPass:getNormalStep()
	return self.normalStep
end

function OutlinePostProcessPass:setMinOutlineThickness(value)
	self.minOutlineThickness = value
end

function OutlinePostProcessPass:getMinOutlineThickness()
	return self.minOutlineThickness
end

function OutlinePostProcessPass:setMaxOutlineThickness(value)
	self.maxOutlineThickness = value
end

function OutlinePostProcessPass:getMaxOutlineThickness()
	return self.maxOutlineThickness
end

function OutlinePostProcessPass:setNearOutlineDistance(value)
	self.nearOutlineDistance = value
end

function OutlinePostProcessPass:getNearOutlineDistance()
	return self.nearOutlineDistance
end

function OutlinePostProcessPass:setFarOutlineDistance(value)
	self.farOutlineDistance = value
end

function OutlinePostProcessPass:getFarOutlineDistance()
	return self.farOutlineDistance
end

function OutlinePostProcessPass:setMinOutlineDepthAlpha(value)
	self.minOutlineDepthAlpha = value
end

function OutlinePostProcessPass:getMinOutlineDepthAlpha()
	return self.minOutlineDepthAlpha
end

function OutlinePostProcessPass:setMaxOutlineDepthAlpha(value)
	self.maxOutlineDepthAlpha = value
end

function OutlinePostProcessPass:getMaxOutlineDepthAlpha()
	return self.maxOutlineDepthAlpha
end

function OutlinePostProcessPass:setOutlineFadeDepth(value)
	self.outlineFadeDepth = value
end

function OutlinePostProcessPass:getOutlineFadeDepth()
	return self.outlineFadeDepth
end

function OutlinePostProcessPass:setOutlineTurbulence(value)
	self.outlineTurbulence = value
end

function OutlinePostProcessPass:getOutlineTurbulence()
	return self.outlineTurbulence
end

function OutlinePostProcessPass:load(resources)
	PostProcessPass.load(self, resources)

	self.depthOutlineShader = self:loadPostProcessShader("DepthOutline")
	self.customOutlineShader = self:loadPostProcessShader("CustomOutline")
	self.alphaOutlineShader = self:loadPostProcessShader("AlphaOutline")
	self.initializeJumpFloodShader = self:loadPostProcessShader("InitJumpFlood")
	self.jumpFloodShader = self:loadPostProcessShader("JumpFlood")
	self.composeOutlineShader = self:loadPostProcessShader("ComposeOutline")
	self.jitterOutlineShader = self:loadPostProcessShader("JitterOutline")

	self.outlineBuffer = NGBuffer("rgba8", "rgba8")
	self.normalBlurBuffer = NGBuffer("rgba16f", "rgba16f")
	self.distanceBuffer = NGBuffer("rgba16f", "rgba16f")
end

function OutlinePostProcessPass:_drawDepthOutline(width, height)
	local camera = self:getRenderer():getCamera()
	local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	self:bindShader(
		self.depthOutlineShader,
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_NormalTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.NORMAL_OUTLINE_INDEX),
		"scape_OutlineThresholdTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.NORMAL_OUTLINE_INDEX),
		"scape_OutlineColorTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.OUTLINE_COLOR_INDEX),
		"scape_DepthStep", self.depthStep,
		"scape_NormalStep", self.normalStep)

	love.graphics.draw(alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX))
end

function OutlinePostProcessPass:_drawCustomOutlines(width, height)
	local camera = self:getRenderer():getCamera()
	local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
	local outlineRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_OUTLINE)

	love.graphics.setDepthMode("lequal", false)
	self:bindShader(
		self.customOutlineShader,
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_DepthTexture", outlineRendererPass:getOBuffer():getCanvas(outlineRendererPass.DEPTH_INDEX))

	love.graphics.draw(outlineRendererPass:getOBuffer():getCanvas(outlineRendererPass.OUTLINE_INDEX))
end

function OutlinePostProcessPass:_drawAlphaOutlines(width, height)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)
	self:bindShader(
		self.alphaOutlineShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_AlphaMaskTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.ALPHA_MASK_INDEX),
		"scape_OutlineColorTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.OUTLINE_COLOR_INDEX))

	love.graphics.draw(alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.ALPHA_Z_INDEX))
end

function OutlinePostProcessPass:_drawParticleOutlines(width, height)
	local particleOutlineRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_PARTICLE_OUTLINE)

	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)
	self:bindShader(
		self.alphaOutlineShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_AlphaMaskTexture", particleOutlineRendererPass:getOBuffer():getCanvas(particleOutlineRendererPass.ALPHA_MASK_INDEX),
		"scape_OutlineColorTexture", particleOutlineRendererPass:getOBuffer():getCanvas(particleOutlineRendererPass.OUTLINE_COLOR_INDEX))

	love.graphics.draw(particleOutlineRendererPass:getOBuffer():getCanvas(particleOutlineRendererPass.ALPHA_MASK_INDEX))
end

function OutlinePostProcessPass:_generateOutlines(width, height)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)

	love.graphics.setCanvas(self.outlineBuffer:getCanvas(2))
	self:_drawDepthOutline(width, height)

	love.graphics.setCanvas({
		self.outlineBuffer:getCanvas(2),
		depthstencil = alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX)
	})
	self:_drawCustomOutlines(width, height)

	love.graphics.setBlendMode("alpha", "alphamultiply")
	self:_drawAlphaOutlines(width, height)
	self:_drawParticleOutlines(width, height)
end

function OutlinePostProcessPass:_jumpFlood(width, height)
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)

	local currentOutlineBuffer = self.distanceBuffer:getCanvas(1)
	local nextOutlineBuffer = self.distanceBuffer:getCanvas(2)

	local halfWidth = math.floor(width / 2)
	local halfHeight = math.floor(height / 2)

	self:bindShader(
		self.initializeJumpFloodShader,
		"scape_TextureSize", { halfWidth, halfHeight })

	love.graphics.setCanvas(currentOutlineBuffer)
	love.graphics.clear(0, 0, 0, 1)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))

	love.graphics.setCanvas(nextOutlineBuffer)
	love.graphics.clear(0, 0, 0, 1)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))

	self:bindShader(
		self.jumpFloodShader,
		"scape_TextureSize", { halfWidth, halfHeight },
		"scape_MaxDistance", math.huge)
	
	local currentDistanceX, currentDistanceY
	repeat
		self:bindShader(
			self.jumpFloodShader,
			"scape_JumpDistance", { (currentDistanceX or 1) / width, (currentDistanceY or 1) / height })

		love.graphics.setCanvas(nextOutlineBuffer)
		love.graphics.clear(0, 0, 0, 1)

		love.graphics.draw(currentOutlineBuffer)

		currentDistanceX = math.max((currentDistanceX or width) / 2, 1)
		currentDistanceY = math.max((currentDistanceY or height) / 2, 1)
		currentOutlineBuffer, nextOutlineBuffer = nextOutlineBuffer, currentOutlineBuffer
	until currentDistanceX <= 1 and currentDistanceY <= 1

	return currentOutlineBuffer
end

function OutlinePostProcessPass:_composeOutline(currentOutlineBuffer, width, height)
	local camera = self:getRenderer():getCamera()
	local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setCanvas(self.outlineBuffer:getCanvas(1))
	love.graphics.setBlendMode("replace", "premultiplied")
	self:bindShader(
		self.composeOutlineShader,
		"scape_DepthTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX),
		"scape_OutlineTexture", self.outlineBuffer:getCanvas(2),
		"scape_OutlineColorTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.OUTLINE_COLOR_INDEX),
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_TexelSize", { 1 / currentOutlineBuffer:getWidth(), 1 / currentOutlineBuffer:getHeight() },
		"scape_MinOutlineThickness", self.minOutlineThickness,
		"scape_MaxOutlineThickness", self.maxOutlineThickness,
		"scape_NearOutlineDistance", self.nearOutlineDistance,
		"scape_FarOutlineDistance", self.farOutlineDistance,
		"scape_MinOutlineDepthAlpha", self.minOutlineDepthAlpha,
		"scape_MaxOutlineDepthAlpha", self.maxOutlineDepthAlpha,
		"scape_OutlineFadeDepth", self.outlineFadeDepth)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.draw(currentOutlineBuffer, 0, 0, 0, 2, 2)
	love.graphics.setColor(1, 1, 1, 1)
end

function OutlinePostProcessPass:_updateNoise(width, height)
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

	self.noiseWidth = noiseWidth
	self.noiseHeight = noiseHeight
end

function OutlinePostProcessPass:_finish(width, height)
	love.graphics.setCanvas(self:getRenderer():getOutputBuffer():getColor())
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.setDepthMode("always", false)
	love.graphics.setColorMask(true, true, true, false)

	self:bindShader(
		self.jitterOutlineShader,
		"scape_NoiseTextureX", self.outlineNoiseTextureX,
		"scape_NoiseTextureY", self.outlineNoiseTextureY,
		"scape_NoiseTexelSize", { 1 / self.noiseWidth, 1 / self.noiseHeight },
		"scape_OutlineTurbulence", self.outlineTurbulence)

	love.graphics.draw(self.outlineBuffer:getCanvas(1))
end

function OutlinePostProcessPass:draw(width, height)
	PostProcessPass.draw(self, width, height)

	if not self.isEnabled then
		return
	end

	local halfWidth = math.floor(width / 2)
	local halfHeight = math.floor(height / 2)

	self.outlineBuffer:resize(width, height)
	self.outlineBuffer:getCanvas(1):setFilter("linear", "linear")
	self.outlineBuffer:getCanvas(2):setFilter("linear", "linear")

	self.normalBlurBuffer:resize(width, height)
	self.normalBlurBuffer:getCanvas(1):setFilter("linear", "linear")
	self.normalBlurBuffer:getCanvas(2):setFilter("linear", "linear")

	self.distanceBuffer:resize(halfWidth, halfHeight)
	self.distanceBuffer:getCanvas(1):setFilter("nearest", "nearest")
	self.distanceBuffer:getCanvas(2):setFilter("nearest", "nearest")

	love.graphics.setColor(1, 1, 1, 1)

	self:_generateOutlines(width, height)
	local currentOutlineBuffer = self:_jumpFlood(width, height)
	self:_composeOutline(currentOutlineBuffer, width, height)
	self:_updateNoise(width, height)
	self:_finish(width, height)
end

return OutlinePostProcessPass
