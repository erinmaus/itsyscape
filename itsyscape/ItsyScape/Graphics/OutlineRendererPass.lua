--------------------------------------------------------------------------------
-- ItsyScape/Graphics/OutlineRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local OBuffer = require "ItsyScape.Graphics.OBuffer"
local NOutlineRendererPass = require "nbunny.optimaus.outlinerendererpass"

local OutlineRendererPass = Class(RendererPass)

OutlineRendererPass.OUTLINE_INDEX = 1

function OutlineRendererPass:new(renderer)
	RendererPass.new(self, renderer)

	self.oBuffer = OBuffer()
	self._rendererPass = NOutlineRendererPass(self.oBuffer:getHandle())

	self.isFullLit = false
end

function OutlineRendererPass:getHandle()
	return self._rendererPass
end

function OutlineRendererPass:getOBuffer()
	return self._rendererPass:getOBuffer()
end

return OutlineRendererPass
