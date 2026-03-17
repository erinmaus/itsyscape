--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/SnipeSplosion/Projectile.lua
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
local DecorationMaterial = require "ItsyScape.Graphics.DecorationMaterial"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local Material = require "ItsyScape.Graphics.Material"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Splosion = Class(Projectile)

Splosion.SPLOSION_MATERIAL = DecorationMaterial({
	shader = "Resources/Shaders/WarpedAlphaCutoff",
	texture = "Resources/Game/Projectiles/Power_Decapitate/Splosion.png",

	properties = {
		isFullLit = true,
		isTranslucent = true,
		glassThickness = 1,
		color = "cc3333"
	}
})

Splosion.PARTICLE_SYSTEM = {
	numParticles = 50,
	texture = "Resources/Game/Projectiles/SnipeSplosion/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0 },
			speed = { 3, 4 },
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
		count = { 30, 50 },
		delay = { 0.125 },
		duration = { 1 }
	}
}

Splosion.DURATION = 2

Splosion.FROM_SCALE = Vector(0.5)
Splosion.TO_SCALE   = Vector(12)

function Splosion:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particleSystem = ParticleSceneNode()
	self.particleSystem:setParent(root)
	self.particleSystem:initParticleSystemFromDef(Splosion.PARTICLE_SYSTEM, resources)

	local model = resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Power_Decapitate/Splosion.lstatic",
		function(mesh)
			self.splosionSceneNode = DecorationSceneNode()
			self.splosionSceneNode:fromGroup(mesh:getResource(), "splosion")
			self.splosionSceneNode:setParent(root)

			self.SPLOSION_MATERIAL:apply(self.splosionSceneNode, resources)
		end)
end

function Splosion:getDuration()
	return Splosion.DURATION
end

function Splosion:tick()
	if not self.spawnPosition then
		self.spawnPosition = self:getTargetPosition(self:getDestination()):keep()

		self:playAnimation(self:getDestination(), "SFX_Power_Snipe")
	end
end

function Splosion:update(elapsed)
	Projectile.update(self, elapsed)

	if self.spawnPosition then
		local root = self:getRoot()
		root:getTransform():setLocalTranslation(self.spawnPosition)

		self:ready()
	end

	if self.splosionSceneNode then
		local delta = Tween.sineEaseOut(math.clamp(self:getDelta()))

		local transform = self.splosionSceneNode:getTransform()
		transform:setLocalScale(self.FROM_SCALE:lerp(self.TO_SCALE, delta))

		local material = self.splosionSceneNode:getMaterial()
		material:send(Material.UNIFORM_FLOAT, "scape_AlphaCutoff", delta)
		material:setAlpha(math.clamp(math.sin(delta * math.pi) * 2))
	end
end

return Splosion
