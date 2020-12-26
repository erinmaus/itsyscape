--------------------------------------------------------------------------------
-- ItsyScape/Graphics/ParticleShape.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local SphericalParticleShape = require "ItsyScape.Graphics.ParticleShape"

local SphericalParticleShape = Class()

function SphericalParticleShape:new()
	self.minRadius = 0
	self.maxRadius = 1
end

function SphericalParticleShape:setRadius(min, max)
	self.minRadius = 0
	self.maxRadius = 1
end

function SphericalParticleShape:getPosition()
	local vector = Vector(math.random(), math.random(), math.random())
	local normal = vector:getNormal()
	local radius = math.random() * (self.maxRadius - self.minRadius) + self.minRadius

	return normal * vector
end

return SphericalParticleShape
