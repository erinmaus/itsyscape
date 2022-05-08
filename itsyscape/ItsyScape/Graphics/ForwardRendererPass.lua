--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ForwardRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NForwardRendererPass = require "nbunny.optimaus.forwardrendererpass"

local ForwardRendererPass = Class(RendererPass)

function ForwardRendererPass:new(renderer, deferredPass)
	RendererPass.new(self, renderer)

	self._rendererPass = NForwardRendererPass(deferredPass:getCBuffer())
end

function ForwardRendererPass:getHandle()
	return self._rendererPass
end

return ForwardRendererPass
