--------------------------------------------------------------------------------
-- ItsyScape/Graphics/Particles/GravityPath.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ParticlePath = require "ItsyScape.Graphics.ParticlePath"

local GravityPath = Class(ParticlePath)

function GravityPath:new()
	ParticlePath.new(self)
	self:setGravity()
end

function GravityPath:setGravity(x, y, z)
	self.gravityX = x or 0
	self.gravityY = y or -10
	self.gravityZ = z or 0
end

function GravityPath:update(particle, delta)
	local percentAge = 1
	particle.velocityX = particle.velocityX + self.gravityX * delta * percentAge
	particle.velocityY = particle.velocityY + self.gravityY * delta * percentAge
	particle.velocityZ = particle.velocityZ + self.gravityZ * delta * percentAge
end

return GravityPath
