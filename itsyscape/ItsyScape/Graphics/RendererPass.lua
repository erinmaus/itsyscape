--------------------------------------------------------------------------------
-- ItsyScape/Graphics/RendererPass.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local NRendererPass = require "nbunny.optimaus.rendererpass"

local RendererPass = Class()

RendererPass.PASS_NONE             = 0
RendererPass.PASS_DEFERRED         = 1
RendererPass.PASS_FORWARD          = 2
RendererPass.PASS_MOBILE           = 3
RendererPass.PASS_OUTLINE          = 4
RendererPass.PASS_ALPHA_MASK       = 5
RendererPass.PASS_PARTICLE_OUTLINE = 6
RendererPass.PASS_SHADOW           = 7
RendererPass.PASS_REFLECTION       = 8
RendererPass.PASS_SHIMMER          = 9
RendererPass.PASS_MAX              = 9

function RendererPass:new(renderer)
	self.renderer = renderer
end

function RendererPass:getHandle()
	return Class.ABSTRACT()
end

function RendererPass:getID()
	return self:getHandle():getID()
end

return RendererPass
