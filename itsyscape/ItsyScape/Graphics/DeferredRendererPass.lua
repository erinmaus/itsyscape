--------------------------------------------------------------------------------
-- ItsyScape/Graphics/DeferredRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NDeferredRendererPass = require "nbunny.optimaus.deferredrendererpass"

local DeferredRendererPass = Class(RendererPass)

function DeferredRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self._rendererPass = NDeferredRendererPass()

	self.isFullLit = false
end

function DeferredRendererPass:getHandle()
	return self._rendererPass
end

function DeferredRendererPass:getGBuffer()
	return self._rendererPass:getGBuffer()
end

function DeferredRendererPass:getCBuffer()
	return self._rendererPass:getCBuffer()
end

function DeferredRendererPass:getIsFullLit()
	return self.isFullLit
end

function DeferredRendererPass:setIsFullLit(value)
	self.isFullLit = value or false
end

return DeferredRendererPass
