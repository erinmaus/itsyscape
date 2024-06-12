--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ShadowRendererPass.lua
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
local NShadowRendererPass = require "nbunny.optimaus.shadowrendererpass"

local ShadowRendererPass = Class(RendererPass)
ShadowRendererPass.DEFAULT_NUM_CASCADES = 3

function ShadowRendererPass:new(renderer, numCascades)
	RendererPass.new(self, renderer)

	numCascades = numCascades or ShadowRendererPass.DEFAULT_NUM_CASCADES

	self._rendererPass = NShadowRendererPass(numCascades)
end

function ShadowRendererPass:getHandle()
	return self._rendererPass
end

return ShadowRendererPass
