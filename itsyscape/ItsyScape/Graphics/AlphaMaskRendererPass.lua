--------------------------------------------------------------------------------
-- ItsyScape/Graphics/AlphaMaskRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local ABuffer = require "ItsyScape.Graphics.ABuffer"
local NAlphaMaskRendererPass = require "nbunny.optimaus.alphamaskrendererpass"

local AlphaMaskRendererPass = Class(RendererPass)

AlphaMaskRendererPass.DEPTH_INDEX         = 0
AlphaMaskRendererPass.OUTLINE_INDEX       = 1
AlphaMaskRendererPass.ALPHA_Z_INDEX       = 2

function AlphaMaskRendererPass:new(renderer, depthBuffer)
	RendererPass.new(self, renderer)

	self.aBuffer = ABuffer()
	self._rendererPass = NAlphaMaskRendererPass(self.aBuffer:getHandle(), depthBuffer)
end

function AlphaMaskRendererPass:getHandle()
	return self._rendererPass
end

function AlphaMaskRendererPass:getABuffer()
	return self._rendererPass:getABuffer()
end

return AlphaMaskRendererPass
