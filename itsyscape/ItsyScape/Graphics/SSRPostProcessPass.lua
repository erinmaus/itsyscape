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

function SSRPostProcessPass:setRGBCurves(...)
	self.rgbCurves = { ... }
end

function SSRPostProcessPass:setHSLCurves(...)
	self.hslCurves = { ... }
end

function SSRPostProcessPass:load(resources)
	PostProcessPass.load(self, resources)

	self.mapTextureCoordinatesShader = self:loadPostProcessShader("MapTextureCoordinatesSSR")
	self.textureCoordinatesBuffer = NGBuffer("rgba8")
end

function SSRPostProcessPass:draw(width, height)
	PostProcessPass.draw(self, width, height)

    love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.setDepthMode("always", false)

    self.textureCoordinatesBuffer:resize(width, height)
    self.textureCoordinatesBuffer:use()

    love.graphics.clear(0, 0, 0, 0)

    local deferredRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_DEFERRED)
    local reflectionRendererPass = self:getRenderer():getPassByID(RendererPass.PASS_REFLECTION)
    local projection, view = self:getRenderer():getCamera():getTransforms()

    self:bindShader(self.mapTextureCoordinatesShader,
        "scape_CameraEye", { self:getRenderer():getCamera():getEye():get() },
        "scape_Projection", projection,
        "scape_View", view,
        "scape_TexelSize", { 1 / width, 1 / height },
        "scape_NormalTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.NORMAL_OUTLINE_INDEX),
        "scape_PositionTexture", deferredRendererPass:getGBuffer():getCanvas(deferredRendererPass.POSITION_INDEX),
        "scape_ReflectionPropertiesTexture", reflectionRendererPass:getRBuffer():getCanvas(reflectionRendererPass.REFLECTION_PROPERTIES_INDEX),
        "scape_ColorTexture", self:getRenderer():getOutputBuffer():getColor())
    love.graphics.draw(self:getRenderer():getOutputBuffer():getColor())

    love.graphics.setShader()
	love.graphics.setCanvas(self:getRenderer():getOutputBuffer():getColor())
    love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.textureCoordinatesBuffer:getCanvas(1))
end

return SSRPostProcessPass
