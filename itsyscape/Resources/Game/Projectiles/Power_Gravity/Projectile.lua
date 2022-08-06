--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Power_Gravity/Projectile.lua
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
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local FogSceneNode = require "ItsyScape.Graphics.FogSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Gravity = Class(Projectile)
Gravity.DURATION = 4

Gravity.ALPHA_MULTIPLIER = 2.5
Gravity.MAX_SIZE = 2

Gravity.FOG_NEAR_MAX = 5
Gravity.FOG_NEAR_MIN = 0
Gravity.FOG_FAR      = 2.5

Gravity.SINGULARITY_COLOR   = Color(0)
Gravity.EVENT_HORIZON_COLOR = Color.fromHexString("ff9f29")

Gravity.PARTICLE_SYSTEM = {
	numParticles = 100,
	texture = "Resources/Game/Projectiles/Power_Gravity/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 6 },
			speed = { -2, -3 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0, 0, 0, 0 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 0.75 }
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
		count = { 25, 50 },
		delay = { 0.125 },
		duration = { 2 }
	}
}

function Gravity:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.singularity = DecorationSceneNode()
	self.singularity:setParent(root)

	self.eventHorizon = DecorationSceneNode()
	self.eventHorizon:setParent(root)

	self.fog = FogSceneNode()
	self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_SELF)

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(Gravity.PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Power_Gravity/Model.lstatic",
		function(model)
			do
				local material = self.singularity:getMaterial()
				material:setTextures(self:getGameView():getWhiteTexture())
				material:setIsTranslucent(true)

				self.singularity:fromGroup(model:getResource(), "Singularity")
			end

			do
				local material = self.eventHorizon:getMaterial()
				material:setTextures(self:getGameView():getWhiteTexture())
				material:setIsTranslucent(true)
				material:setIsFullLit(true)

				self.eventHorizon:fromGroup(model:getResource(), "EventHorizon")
			end
		end)
end

function Gravity:getDuration()
	return Gravity.DURATION
end

function Gravity:tick()
	if not self.position or not self.size then
		self.position = self:getTargetPosition(self:getDestination()) + Vector(0, Gravity.MAX_SIZE, 0)
	end
end

function Gravity:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local delta = self:getDelta()
		local alpha = math.abs(math.sin(delta * math.pi)) * Gravity.ALPHA_MULTIPLIER
		alpha = math.min(alpha, 1)

		root:getTransform():setLocalTranslation(self.position)
		root:getTransform():setLocalScale(Vector(Gravity.MAX_SIZE) * alpha)

		local fogValue = alpha * (Gravity.FOG_NEAR_MAX - Gravity.FOG_NEAR_MIN) + Gravity.FOG_NEAR_MIN
		self.fog:setNearDistance(fogValue + Gravity.FOG_FAR)
		self.fog:setFarDistance(fogValue)
		self.fog:setColor(Gravity.SINGULARITY_COLOR)
		self.fog:getHandle():tick()
		self.fog:setParent(root)

		self.singularity:getMaterial():setColor(Color(
			Gravity.SINGULARITY_COLOR.r,
			Gravity.SINGULARITY_COLOR.g,
			Gravity.SINGULARITY_COLOR.b,
			alpha))

		self.eventHorizon:getMaterial():setColor(Color(
			Gravity.EVENT_HORIZON_COLOR.r,
			Gravity.EVENT_HORIZON_COLOR.g,
			Gravity.EVENT_HORIZON_COLOR.b,
			alpha))
	end
end

return Gravity
