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

function ParticleOutlineRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.oBuffer = ParticleOBuffer()
	self._rendererPass = NParticleOutlineRendererPass(self.oBuffer:getHandle())
end

function ParticleOutlineRendererPass:getHandle()
	return self._rendererPass
end

function ParticleOutlineRendererPass:getOBuffer()
	return self._rendererPass:getOBuffer()
end

return ParticleOutlineRendererPass