--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Decapitate/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Projectile = require "ItsyScape.Graphics.Projectile"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Decapitate = Class(Projectile)

Decapitate.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/Power_Decapitate/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 2, 3 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.8, 0.2, 0.2, 0.0 },
				{ 1.0, 0.2, 0.2, 0.0 },
				{ 0.5, 0.1, 0.1, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 0.7 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.3 },
			fadeOutPercent = { 0.7 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 25, 30 },
		delay = { 0.125 },
		duration = { 0.5 }
	}
}

Decapitate.DURATION = 1.5

function Decapitate:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Decapitate.PARTICLE_SYSTEM, resources)
end

function Decapitate:getDuration()
	return Decapitate.DURATION
end

function Decapitate:update(elapsed)
	Projectile.update(self, elapsed)

	local headPosition, bodyPosition
	do
		local gameView = self:getGameView()
		local actorView = gameView:getActor(self:getDestination())
		if actorView then
			local headTransform = actorView:getLocalBoneTransform("head")
			headPosition = Vector(headTransform:transformPoint(0, 0, 0))

			local bodyTransform = actorView:getSceneNode():getTransform():getGlobalTransform()
			bodyPosition = Vector(bodyTransform:transformPoint(0, 0, 0))
		else
			headPosition = Vector.ZERO
			bodyPosition = Vector.ZERO
		end
	end

	local root = self:getRoot()
	root:getTransform():setLocalTranslation(headPosition + bodyPosition)
end

return Decapitate

