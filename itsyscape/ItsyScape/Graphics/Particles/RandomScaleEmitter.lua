--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomScaleEmitter.lua
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

local RandomScaleEmitter = Class(ParticleEmitter)

function RandomScaleEmitter:new()
	ParticleEmitter.new(self)
	self:setScale()
	self:setScaleX()
	self:setScaleY()
end

function RandomScaleEmitter:setScale(min, max)
	self.minScale = min or 1
	self.maxScale = max or self.minScale
end

function RandomScaleEmitter:setScaleX(min, max)
	self.minScaleX = min or 1
	self.maxScaleX = max or self.minScaleX
end

function RandomScaleEmitter:setScaleY(min, max)
	self.minScaleY = min or 1
	self.maxScaleY = max or self.minScaleY
end

function RandomScaleEmitter:emitSingleParticle(particle)
	local scale = math.random() * (self.maxScale - self.minScale) + self.minScale
	local scaleX = math.random() * (self.maxScaleX - self.minScaleX) + self.minScaleX
	local scaleY = math.random() * (self.maxScaleY - self.minScaleY) + self.minScaleY

	particle.scaleX = scale * scaleX
	particle.scaleY = scale * scaleY
end

return RandomScaleEmitter
