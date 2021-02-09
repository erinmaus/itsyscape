--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomTextureIndexEmitter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local ParticleEmitter = require "ItsyScape.Graphics.ParticleEmitter"

local RandomTextureIndexEmitter = Class(ParticleEmitter)

function RandomTextureIndexEmitter:new()
	ParticleEmitter.new(self)
	self:setTextureIndex()
end

function RandomTextureIndexEmitter:setTextureIndex(min, max)
	self.minTextureIndex = min or 1
	self.maxTextureIndex = max or self.minTextureIndex
end

function RandomTextureIndexEmitter:emitSingleParticle(particle)
	local textureIndex = math.random(self.minTextureIndex, self.maxTextureIndex)

	particle.textureIndex = textureIndex
end

return RandomTextureIndexEmitter
