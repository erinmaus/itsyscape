--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/ParticleGreeble.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local Greeble = require "Resources.Game.Props.Common.Greeble"

local ParticleGreeble = Class(Greeble)

ParticleGreeble.PARTICLES = {}
ParticleGreeble.MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/Particle",
	texture = false,

	properties = {
		isTranslucent = true,
		isFullLit = true,
		isShadowCaster = false
	}
})

function ParticleGreeble:new(...)
	Greeble.new(self, ...)

	self.particles = ParticleSceneNode()
end

function ParticleGreeble:getParticles()
	return self.particles
end

function ParticleGreeble:load()
	Greeble.load(self)

	local resources = self:getResources()
	local root = self:getRoot()
	
	if self.PARTICLES ~= ParticleGreeble.PARTICLES then
		self.particles:initParticleSystemFromDef(self.PARTICLES, resources)
	end
	self.MATERIAL:apply(self.particles, resources)
	self.particles:setParent(root)
end

function ParticleGreeble:regreebilize(t, ...)
	Greeble.regreebilize(self, t, ...)

	self:load()
end

return ParticleGreeble
