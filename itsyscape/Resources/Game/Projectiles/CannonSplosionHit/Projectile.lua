--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/CannonSplosionHit/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Vector = require "ItsyScape.Common.Math.Vector"
local CacheRef = require "ItsyScape.Game.CacheRef"
local Projectile = require "ItsyScape.Graphics.Projectile"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local Material = require "ItsyScape.Graphics.Material"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Splosion = Class(Projectile)

Splosion.PARTICLE_SYSTEM_FIRE = {
	numParticles = 200,
	texture = "Resources/Game/Projectiles/CannonSplosionHit/Fire.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 2.5, 2.5 },
			speed = { 2, 3 },
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
		count = { 30, 60 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Splosion.PARTICLE_SYSTEM_SMOKE = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/CannonSplosionHit/Smoke.png",
	columns = 1,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.5 },
			yRange = { 0, 0 },
			position = { 1, 1.5, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 1.5, 2.5 },
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
			scale = { 0.5, 0.7 }
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
		delay = { 0.125 },
		duration = { 1.5 }
	}
}

Splosion.DURATION = 2

Splosion.FROM_SCALE = Vector(0)
Splosion.TO_SCALE   = Vector(8)

Splosion.SPLOSION_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/WarpedAlphaCutoff",
	texture = "Resources/Game/Projectiles/CannonSplosionHit/Splosion.png",

	properties = {
		isFullLit = true,
		isTranslucent = true,
		glassThickness = 1,
		color = "ff6600"
	}
})

function Splosion:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystemFire = ParticleSceneNode()
	self.particleSystemFire:setParent(root)
	self.particleSystemFire:initParticleSystemFromDef(self.PARTICLE_SYSTEM_FIRE, resources)

	self.particleSystemSmoke = ParticleSceneNode()
	self.particleSystemSmoke:setParent(root)
	self.particleSystemSmoke:initParticleSystemFromDef(self.PARTICLE_SYSTEM_SMOKE, resources)

	local model = resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/CannonSplosionHit/Splosion.lstatic",
		function(mesh)
			self.splosionSceneNode = DecorationSceneNode()
			self.splosionSceneNode:fromGroup(mesh:getResource(), "splosion")
			self.splosionSceneNode:setParent(root)

			self.SPLOSION_MATERIAL:apply(self.splosionSceneNode, resources)
		end)
end

function Splosion:getDuration()
	return self.DURATION
end

function Splosion:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination())
	end
end

function Splosion:update(elapsed)
	Projectile.update(self, elapsed)

	if self.splosionSceneNode then
		local delta = Tween.sineEaseOut(math.clamp(self:getDelta()))

		local transform = self.splosionSceneNode:getTransform()
		transform:setLocalScale(self.FROM_SCALE:lerp(self.TO_SCALE, delta))

		local material = self.splosionSceneNode:getMaterial()
		material:send(Material.UNIFORM_FLOAT, "scape_AlphaCutoff", delta)
		material:setAlpha(math.clamp(math.sin(delta * math.pi) * 2))
	end

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end
end

return Splosion
