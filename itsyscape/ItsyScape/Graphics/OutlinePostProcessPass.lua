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

local OutlinePostProcessPass = Class()
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

function OutlinePostProcessPass:load(resources)
	OutlinePostProcessPass.load(self, resources)

	self.depthOutlineShader = self:loadPostProcessShader("DepthOutline")
	self.customOutlineShader = self:loadPostProcessShader("CustomOutline")
	self.alphaOutlineShader = self:loadPostProcessShader("AlphaOutline")
	self.initializeJumpFloodShader = self:loadPostProcessShader("InitJumpFlood")
	self.jumpFloodShader = self:loadPostProcessShader("JumpFlood")
	self.composeOutlineShader = self:loadPostProcessShader("ComposeOutline")
	self.jitterOutlineShader = self:loadPostProcessShader("JitterOutline")

	self.outlineBuffer = NGBuffer("rgba8", "rgba8")
	self.distanceBuffer = NGBuffer("rgba16f", "rgba16f")
end

function OutlinePostProcessPass:_drawDepthOutline(width, height, uniforms)
	local camera = self:getRenderer():getCamera()
	local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	self:bindShader(
		self.depthOutlineShader,
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_NormalTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.NORMAL_OUTLINE_INDEX),
		"scape_OutlineColorTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.OUTLINE_COLOR_INDEX),
		"scape_DepthStep", uniforms["DepthStep"] or 0)

	love.graphics.draw(alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX))
end

function OutlinePostProcessPass:_drawDepthOutline(width, height, uniforms)
	local camera = self:getRenderer():getCamera()
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	self:bindShader(
		self.depthOutlineShader,
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_NormalTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.NORMAL_OUTLINE_INDEX),
		"scape_OutlineColorTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.OUTLINE_COLOR_INDEX),
		"scape_DepthStep", uniforms["DepthStep"] or 0)

	love.graphics.draw(alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX))
end

function OutlinePostProcessPass:_drawCustomOutlines(width, height, uniforms)
	local outlineRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_OUTLINE)

	love.graphics.setDepthMode("lequal", false)
	self:bindShader(
		self.customOutlineShader,
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_DepthTexture", deferredRendererPass:getDepthBuffer())

	love.graphics.draw(outlineRendererPass:getOBuffer():getCanvas(outlineRendererPass.OUTLINE_INDEX))
end

function OutlinePostProcessPass:_drawAlphaOutlines(width, height, uniforms)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)
	self:bindShader(
		self.alphaOutlineShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_AlphaMaskTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.ALPHA_MASK_INDEX),
		"scape_OutlineColorTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.OUTLINE_COLOR_INDEX))

	love.graphics.draw(alphaMaskRendererPass:getOBuffer():getCanvas(alphaMaskRendererPass.OUTLINE_INDEX))
end

function OutlinePostProcessPass:_drawParticleOutlines(width, height, uniforms)
	local particleOutlineRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_PARTICLE_OUTLINE)

	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)
	self:bindShader(
		self.alphaOutlineShader,
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_AlphaMaskTexture", particleOutlineRendererPass:getABuffer():getCanvas(particleOutlineRendererPass.ALPHA_MASK_INDEX),
		"scape_OutlineColorTexture", particleOutlineRendererPass:getABuffer():getCanvas(particleOutlineRendererPass.OUTLINE_COLOR_INDEX))

	love.graphics.draw(particleOutlineRendererPass:getOBuffer():getCanvas(particleOutlineRendererPass.OUTLINE_INDEX))
end

function OutlinePostProcessPass:_generateOutlines(width, height, uniforms)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setCanvas({
		self.outlineBuffer:getCanvas(2),
		depthstencil = alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX)
	})
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)

	self:_drawDepthOutline(width, height, uniforms)
	self:_drawCustomOutlines(width, height, uniforms)
	self:_drawAlphaOutlines(width, height, uniforms)
	self:_drawParticleOutlines(width, height, uniforms)
end

function OutlinePostProcessPass:_jumpFlood(width, height, uniforms)
	love.graphics.setBlendMode("replace", "premultiplied")
	love.graphics.setDepthMode("always", false)

	local currentOutlineBuffer = self.distanceBuffer:getCanvas(1)
	local nextOutlineBuffer = self.distanceBuffer:getCanvas(2)

	self:bindShader(
		self.initializeJumpFloodShader,
		"scape_TextureSize", { width, height })

	love.graphics.setCanvas(currentOutlineBuffer)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))

	love.graphics.setCanvas(nextOutlineBuffer)
	love.graphics.draw(self.outlineBuffer:getCanvas(2))

	self:bindShader(
		self.jumpFloodShader,
		"scape_TextureSize", { width, height },
		"scape_MaxDistance", math.huge)
	
	local currentDistanceX, currentDistanceY
	repeat
		self:bindShader(
			self.jumpFloodShader,
			"scape_JumpDistance", { (currentDistanceX or 1) / width, (currentDistanceY or 1) / height })

		love.graphics.setCanvas(nextOutlineBuffer)
		love.graphics.draw(currentOutlineBuffer)

		currentDistanceX = math.max((currentDistanceX or width) / 2, 1)
		currentDistanceY = math.max((currentDistanceY or height) / 2, 1)
		currentOutlineBuffer, nextOutlineBuffer = nextOutlineBuffer, currentOutlineBuffer
	until currentDistanceX <= 1 and currentDistanceY <= 1
end

function OutlinePostProcessPass:_composeOutline(width, height, uniforms)
	local camera = self:getRenderer():getCamera()
	local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
	local alphaMaskRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_ALPHA_MASK)

	love.graphics.setBlendMode("replace", "premultiplied")
	self:bindShader(
		self.composeOutlineShader,
		"scape_DepthTexture", alphaMaskRendererPass:getABuffer():getCanvas(alphaMaskRendererPass.DEPTH_INDEX),
		"scape_OutlineTexture", self.outlineBuffer:getCanvas(2),
		"scape_OutlineColorTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.OUTLINE_COLOR_INDEX),
		"scape_Near", camera:getNear(),
		"scape_Far", camera:getFar(),
		"scape_TexelSize", { 1 / width, 1 / height },
		"scape_MinOutlineThickness", uniforms["MinOutlineThickness"] or 3,
		"scape_MaxOutlineThickness", uniforms["MaxOutlineThickness"] or 7,
		"scape_NearOutlineDistance", uniforms["NearOutlineDistance"] or 20,
		"scape_FarOutlineDistance", uniforms["FarOutlineDistance"] or 32,
		"scape_MinOutlineDepthAlpha", uniforms["MinOutlineDepthAlpha"] or 0.5,
		"scape_MaxOutlineDepthAlpha", uniforms["MaxOutlineDepthAlpha"] or 1.0,
		"scape_OutlineFadeDepth", uniforms["OutlineFadeDepth"] or 20)

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.draw(currentOutlineBuffer)
	love.graphics.setColor(1, 1, 1, 1)
end

function OutlinePostProcessPass:_updateNoise(width, height, uniforms)
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
end

function OutlinePostProcessPass:_finish(width, height, uniforms)
	love.graphics.setCanvas(self:getRenderer():getOutputBuffer():getColor())
	love.graphics.setBlendMode("multiply", "premultiplied")
	love.graphics.setDepthMode("always", false)
	love.graphics.setColorMask(true, true, true, false)

	self:bindShader(
		self.jitterOutlineShader,
		"scape_NoiseTextureX", self.outlineNoiseTextureX,
		"scape_NoiseTextureY", self.outlineNoiseTextureY,
		"scape_NoiseTexelSize", { 1 / self.noiseWidth, 1 / self.noiseHeight },
		"scape_OutlineTurbulence", uniforms["OutlineTurbulence"])

	love.graphics.draw(self.outlineBuffer:getCanvas(1))
end

function OutlinePostProcessPass:draw(width, height, uniforms)
	self.outlineBuffer:resize(width, height)
	self.outlineBuffer:getCanvas(1):setFilter("linear", "linear")
	self.outlineBuffer:getCanvas(2):setFilter("linear", "linear")

	self.distanceBuffer:resize(width, height)
	self.distanceBuffer:getCanvas(1):setFilter("nearest", "nearest")
	self.distanceBuffer:getCanvas(2):setFilter("nearest", "nearest")

	love.graphics.setColor(1, 1, 1, 1)

	self:_generateOutlines(width, height, uniforms)
	self:_jumpFlood(width, height, uniforms)
	self:_composeOutline(width, height, uniforms)
	self:_updateNoise(width, height, uniforms)
	self:_finish(width, height, uniforms)
end

return OutlinePostProcessPass
