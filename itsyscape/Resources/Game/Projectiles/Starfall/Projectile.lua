--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/Starfall/Projectile.lua
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
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local Projectile = require "ItsyScape.Graphics.Projectile"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local Starfall = Class(Projectile)

Starfall.DURATION = 6

Starfall.LIGHT_RADIUS_MAX = 30
Starfall.FOG_RADIUS_MAX   = 8

Starfall.SINGULARITY_COLOR   = Color(1)
Starfall.EVENT_HORIZON_COLOR = Color(0)

Starfall.ALPHA_MULTIPLIER = 2.5

Starfall.STAR_PARTICLE_SYSTEM = {
	texture = "Resources/Game/Projectiles/Starfall/Particle.png",

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 14, 14.5 },
			speed = { 0 },
			acceleration = { -0.5, -1 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1, 1, 1, 1 }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			lifetime = { 4, 4 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25, 0.35 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.05 },
			fadeOutPercent = { 0.95 },
		},
		{
			type = "TwinklePath",
			speed = { math.pi }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 75, 125 },
		delay = { 0.5 },
		duration = { 2 }
	}
}

Starfall.STAR_PARTICLE_SYSTEM_PATH_COLLAPSE = {
	{
		type = "FadeInOutPath",
		fadeInPercent = { 0.05 },
		fadeOutPercent = { 0.95 },
	},
	{
		type = "TwinklePath",
		speed = math.pi
	},
	{
		type = "SingularityPath",
		position = { 0, 0, 0 },
		speed = 20
	}
}

Starfall.STAR_PARTICLE_SYSTEM_PATH_EXPLODE = {
	{
		type = "FadeInOutPath",
		fadeInPercent = { 0.05 },
		fadeOutPercent = { 0.9 },
	},
	{
		type = "TwinklePath",
		speed = math.pi
	},
	{
		type = "SingularityPath",
		position = { 0, 0, 0 },
		speed = -25
	}
}

Starfall.COLLAPSE_THRESHOLD = 1.5 / 6
Starfall.EXPLODE_THRESHOLD = 2.5 / 6

Starfall.FOG_FAR_OFFSET = 1.5

function Starfall:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.singularity = DecorationSceneNode()
	self.singularity:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Projectiles/Starfall/Model.lstatic",
		function(model)
			local whiteTexture = self:getGameView():getWhiteTexture()

			do
				local material = self.singularity:getMaterial()
				material:setTextures(whiteTexture)
				material:setIsTranslucent(true)
				material:setIsFullLit(true)

				self.singularity:fromGroup(model:getResource(), "Singularity")
			end
		end)

	self.fog = FogSceneNode()
	self.fog:setFollowMode(FogSceneNode.FOLLOW_MODE_SELF)
	self.fog:setParent(root)

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(Starfall.STAR_PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)
end

function Starfall:getDuration()
	return Starfall.DURATION
end

function Starfall:tick()
	if not self.position then
		self.position = self:getTargetPosition(self:getDestination())
	end
end

function Starfall:update(elapsed)
	Projectile.update(self, elapsed)

	if self.position then
		local root = self:getRoot()
		local delta = self:getDelta()
		local singularityDelta = math.min(math.abs(math.sin(delta * math.pi)) * Starfall.ALPHA_MULTIPLIER, 1)

		if delta >= Starfall.EXPLODE_THRESHOLD and not self.exploded then
			self.exploded = true
			self.particles:initPathsFromDef(Starfall.STAR_PARTICLE_SYSTEM_PATH_EXPLODE)
		elseif delta >= Starfall.COLLAPSE_THRESHOLD and not self.collapsed then
			self.collapsed = true
			self.particles:initPathsFromDef(Starfall.STAR_PARTICLE_SYSTEM_PATH_COLLAPSE)
		end

		root:getTransform():setLocalTranslation(self.position)

		local lightDelta = math.max(delta - Starfall.COLLAPSE_THRESHOLD, 0) / (1 - Starfall.COLLAPSE_THRESHOLD)
		local lightRadius = math.sin(lightDelta * math.pi) * Starfall.LIGHT_RADIUS_MAX
		self.light:setAttenuation(lightRadius)

		local fogDelta = math.max(delta - Starfall.EXPLODE_THRESHOLD, 0) / (1 - Starfall.EXPLODE_THRESHOLD)
		local fogRadius = math.sin(fogDelta * math.pi) * Starfall.FOG_RADIUS_MAX
		self.fog:setNearDistance(fogRadius + Starfall.FOG_FAR_OFFSET)
		self.fog:setFarDistance(fogRadius)

		self.singularity:getTransform():setLocalScale(Vector(fogRadius))
		self.singularity:getMaterial():setColor(Color(
			Starfall.SINGULARITY_COLOR.r,
			Starfall.SINGULARITY_COLOR.g,
			Starfall.SINGULARITY_COLOR.b,
			alpha))
	end

	self:ready()
end

return Starfall
