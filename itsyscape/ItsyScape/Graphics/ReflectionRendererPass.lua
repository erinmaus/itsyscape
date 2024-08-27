--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ReflectionRendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local RendererPass = require "ItsyScape.Graphics.RendererPass"
local NReflectionRendererPass = require "nbunny.optimaus.reflectionrendererpass"

local ReflectionRendererPass = Class(RendererPass)

ReflectionRendererPass.DEPTH_INDEX                 = 0
ReflectionRendererPass.REFLECTION_PROPERTIES_INDEX = 1
ReflectionRendererPass.POSITION_INDEX              = 2
ReflectionRendererPass.NORMAL_INDEX                = 3

function ReflectionRendererPass:new(renderer, gBuffer)
	RendererPass.new(self, renderer)

	self._rendererPass = NReflectionRendererPass(gBuffer)
end

function ReflectionRendererPass:getHandle()
	return self._rendererPass
end

function ReflectionRendererPass:getRBuffer()
	return self._rendererPass:getRBuffer()
end

return ReflectionRendererPass
