--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShimmerRendererPass.lua
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
local NShimmerRendererPass = require "nbunny.optimaus.shimmerrendererpass"

local ShimmerRendererPass = Class(RendererPass)

ShimmerRendererPass.DEPTH_INDEX         = 0
ShimmerRendererPass.SHIMMER_COLOR_INDEX = 1

function ShimmerRendererPass:new(renderer, depthBuffer)
	RendererPass.new(self, renderer)

	self.oBuffer = ParticleOBuffer()
	self._rendererPass = NShimmerRendererPass(self.oBuffer:getHandle(), depthBuffer)
end

function ShimmerRendererPass:getHandle()
	return self._rendererPass
end

function ShimmerRendererPass:getOBuffer()
	return self._rendererPass:getOBuffer()
end

return ShimmerRendererPass
