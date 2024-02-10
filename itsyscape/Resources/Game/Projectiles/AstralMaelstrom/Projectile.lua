--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/AstralMaelstrom/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local Projectile = require "ItsyScape.Graphics.Projectile"
local QuadSceneNode = require "ItsyScape.Graphics.QuadSceneNode"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local AstralMaelstrom = Class(Projectile)
AstralMaelstrom.CLAMP_BOTTOM = true

AstralMaelstrom.DROP_OFF  = 4
AstralMaelstrom.ELEVATION = 32

AstralMaelstrom.FALL_DURATION = 1.5
AstralMaelstrom.DURATION = 3

AstralMaelstrom.SIZE = 4

AstralMaelstrom.PARTICLE_SYSTEM_FIRE = {
	texture = "Resources/Game/Projectiles/AstralMaelstrom/Fire.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 8, 12 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1.5, 2 }
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
		count = { 30, 60 },
		delay = { 1 / 30 },
		duration = { 1.5 }
	}
}

AstralMaelstrom.PARTICLE_SYSTEM_SMOKE = {
	texture = "Resources/Game/Projectiles/AstralMaelstrom/Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 8 },
			yRange = { 0, 0 },
			position = { 0, 8, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 3, 5 },
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 0.4, 0.4, 0.4, 0.0 },
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 0.75, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1.5, 2.5 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 30, 60 },
			acceleration = { -40, -20 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.8 },
			tween = { 'sineEaseOut' }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 1 / 30 },
		duration = { 1 }
	}
}

AstralMaelstrom.PARTICLE_SYSTEM_TRAIL = {
	texture = "Resources/Game/Projectiles/AstralMaelstrom/Fire.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 4 },
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 5, 7 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 0.4, 0.0, 0.0 },
				{ 0.9, 0.4, 0.0, 0.0 },
				{ 1, 0.5, 0.0, 0.0 },
				{ 0.9, 0.5, 0.0, 0.0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.75, 1.0 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 1.5, 2 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { -180, 180 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.1 },
			fadeOutPercent = { 0.9 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "GravityPath",
			gravity = { 0, -10, 0 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 20, 30 },
		delay = { 1 / 30 },
		duration = { 1 }
	}
}

function AstralMaelstrom:getTextureFilename()
	return "Resources/Game/Projectiles/AstralMaelstrom/Texture.png"
end

function AstralMaelstrom:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.quad = QuadSceneNode()
	self.quad:setParent(root)
	self.quad:setIsBillboarded(false)
	self.quad:getTransform():setLocalScale(Vector(AstralMaelstrom.SIZE))

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.quad:getMaterial():setTextures(texture)
		end)

	self.splosionParticleSystem = ParticleSceneNode()
	self.splosionParticleSystem:setParent(root)
	self.splosionParticleSystem:initParticleSystemFromDef(AstralMaelstrom.PARTICLE_SYSTEM_FIRE, resources)
	self.splosionParticleSystem:pause()

	self.smokeParticleSystem = ParticleSceneNode()
	self.smokeParticleSystem:setParent(root)
	self.smokeParticleSystem:initParticleSystemFromDef(AstralMaelstrom.PARTICLE_SYSTEM_SMOKE, resources)
	self.smokeParticleSystem:pause()

	self.trailParticleSystem = ParticleSceneNode()
	self.trailParticleSystem:setParent(root)
	self.trailParticleSystem:initParticleSystemFromDef(AstralMaelstrom.PARTICLE_SYSTEM_TRAIL, resources)
end

function AstralMaelstrom:getDuration()
	return self.DURATION
end

function AstralMaelstrom:tick()
	Projectile.tick(self)

	if not self.isReady then
		self.startPosition = self:getTargetPosition(self:getDestination()) + Vector(0, AstralMaelstrom.ELEVATION, 0)
		self.hitPosition = self:getTargetPosition(self:getDestination())

		self.splosionParticleSystem:getTransform():setLocalTranslation(self.hitPosition)
		self.smokeParticleSystem:getTransform():setLocalTranslation(self.hitPosition)
		self.isReady = true
	end
end

function AstralMaelstrom:update(delta)
	Projectile.update(self, delta)

	if not self.isReady then
		return
	end

	local delta = self:getDelta()
	local hitPosition = self.hitPosition - Vector(0, AstralMaelstrom.DROP_OFF, 0)
	local position = self.startPosition:lerp(hitPosition, math.min(delta / (self.FALL_DURATION / self.DURATION), 1))

	if delta > 0.5 and position.y <= self.hitPosition.y then
		self.splosionParticleSystem:play()
		self.smokeParticleSystem:play()

		if not self.playedSfx then
			self.playedSfx = true
			self:playAnimation(self:getDestination(), "SFX_Nuke")
		end
	end

	local angle = self:getTime() * math.pi * 2
	local rotation = Quaternion.fromAxisAngle(Vector.UNIT_Z, angle)
	self.quad:getTransform():setLocalRotation(rotation)
	self.quad:getTransform():setLocalTranslation(position)
	self.trailParticleSystem:updateLocalPosition(position)

	self:ready()
end

return AstralMaelstrom
