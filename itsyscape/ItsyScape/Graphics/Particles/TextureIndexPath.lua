--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/TextureIndexPath.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ParticlePath = require "ItsyScape.Graphics.ParticlePath"

local TextureIndexPath = Class(ParticlePath)

function TextureIndexPath:new()
	ParticlePath.new(self)
	self:setTextures()
end

function TextureIndexPath:setTextures(min, max)
	min = min or 1
	max = max or min

	self.minTexture = math.min(min, max)
	self.maxTexture = math.max(min, max)
end

function TextureIndexPath:update(particle, delta)
	local percentAge = particle.age / particle.lifetime
	local index = percentAge * (self.maxTexture - self.minTexture) + self.minTexture

	particle.textureIndex = math.floor(index)
end

return TextureIndexPath
