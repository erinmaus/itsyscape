--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleEmitter.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"

local ParticleEmitter = Class()

function ParticleEmitter:new()
	-- Nothing.
end

function ParticleEmitter:emitSingleParticle(particle)
	particle.positionX = 0
	particle.positionY = 0
	particle.positionZ = 0

	particle.velocityX = 0
	particle.velocityY = 0
	particle.velocityZ = 0

	particle.accelerationX = 0
	particle.accelerationY = 0
	particle.accelerationZ = 0

	particle.rotation = 0
	particle.rotationAcceleration = 0
	particle.rotationVelocity = 0

	particle.lifetime = 0
	particle.age = 0

	particle.scaleX = 1
	particle.scaleY = 1

	particle.colorRed = 1
	particle.colorGreen = 1
	particle.colorBlue = 1
	particle.colorAlpha = 1
end

function ParticleEmitter:updateLocalPosition(localPosition)
	-- Nothing.
end

return ParticleEmitter
