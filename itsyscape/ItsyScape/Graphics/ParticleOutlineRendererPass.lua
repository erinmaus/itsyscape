--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleOutlineRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local ParticleOBuffer = require "ItsyScape.Graphics.ParticleOBuffer"
local NParticleOutlineRendererPass = require "nbunny.optimaus.particleoutlinerendererpass"

local ParticleOutlineRendererPass = Class(RendererPass)

ParticleOutlineRendererPass.DEPTH_INDEX         = 0
ParticleOutlineRendererPass.OUTLINE_INDEX       = 1

function ParticleOutlineRendererPass:new(renderer, depthBuffer)
	RendererPass.new(self, renderer)

	self.oBuffer = ParticleOBuffer()
	self._rendererPass = NParticleOutlineRendererPass(self.oBuffer:getHandle(), depthBuffer)
end

function ParticleOutlineRendererPass:getHandle()
	return self._rendererPass
end

function ParticleOutlineRendererPass:getOBuffer()
	return self._rendererPass:getOBuffer()
end

return ParticleOutlineRendererPass
