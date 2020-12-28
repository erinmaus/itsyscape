--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/RandomColorEmitter.lua
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

local RandomColorEmitter = Class(ParticleEmitter)

function RandomColorEmitter:new()
	ParticleEmitter.new(self)
	self:setColors()
end

function RandomColorEmitter:setColors(...)
	if select('#', ...) > 0 then
		self.colors = { ... }
	else
		self.colors = { { 1, 1, 1, 1 } }
	end
end

function RandomColorEmitter:emitSingleParticle(particle)
	local colorIndex = math.random(#self.colors)
	local color = self.colors[colorIndex]

	particle.colorRed = color[1]
	particle.colorGreen = color[2]
	particle.colorBlue = color[3]
	particle.colorAlpha = color[4]
end

return RandomColorEmitter
