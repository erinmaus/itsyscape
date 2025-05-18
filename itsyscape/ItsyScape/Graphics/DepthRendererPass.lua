--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DepthRendererPass.lua
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
local NDepthRendererPass = require "nbunny.optimaus.depthrendererpass"

local DepthRendererPass = Class(RendererPass)

function DepthRendererPass:new(renderer, gBuffer)
	RendererPass.new(self, renderer)

	self.gBuffer = gBuffer
	self._rendererPass = NDepthRendererPass(self.gBuffer)
end

function DepthRendererPass:getHandle()
	return self._rendererPass
end

return DepthRendererPass
