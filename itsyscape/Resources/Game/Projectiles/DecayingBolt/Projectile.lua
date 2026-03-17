--------------------------------------------------------------------------------
-- ItsyScape/Resources/Game/Projectiles/DecayingBolt/Projectile.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Tween = require "ItsyScape.Common.Math.Tween"
local Quaternion = require "ItsyScape.Common.Math.Quaternion"
local Color = require "ItsyScape.Graphics.Color"
local GBuffer = require "ItsyScape.Graphics.GBuffer"
local Projectile = require "ItsyScape.Graphics.Projectile"
local LightBeamSceneNode = require "ItsyScape.Graphics.LightBeamSceneNode"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"

local DecayingBolt = Class(Projectile)
DecayingBolt.SHADER = ShaderResource()
do
	DecayingBolt.SHADER:loadFromFile("Resources/Shaders/DecayingBolt")
end

DecayingBolt.PARTICLE_SYSTEM = {
	numParticles = 500,
	texture = "Resources/Game/Projectiles/DecayingBolt/Particle.png",
	columns = 4,
	soft = true,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 1 },
			speed = { 2, 4 },
			lifeTime = { 3, 0.25 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 0, 1 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.5, 0.5, 0.5, 0 },
				{ 0.5, 0.5, 0.5, 0 },
				{ Color.fromHexString("ff9f29", 0):get() }
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 0.5, 1.0 }
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
			fadeInPercent = { 0.25 },
			fadeOutPercent = { 0.75 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 10, 15 },
		delay = { 1 / 30 },
		duration = { 2 }
	}
}

DecayingBolt.BOLT_DELTA = 0.5
DecayingBolt.DURATION   = 2
DecayingBolt.CLAMP_BOTTOM = true

function DecayingBolt:load()
	Projectile.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(DecayingBolt.PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)
	self.particles:getMaterial():setShader(DecayingBolt.SHADER)
	self.particles:getMaterial():setIsFullLit(true)
	self.particles:onWillRender(function(renderer, delta)
		local shader = renderer:getCurrentShader()
		if shader:hasUniform("scape_ScreenTexture") then
			shader:send("scape_ScreenTexture", renderer:getDeferredPass():getGBuffer():getCanvas(GBuffer.COLOR_INDEX))
		end
	end)

	self:updateParticles()
end

function DecayingBolt:updateParticles()
	local spawnPosition = self:getTargetPosition(self:getSource())
	local sourceMin, sourceMax = self:getSource():getBounds()
	local size = (sourceMax - sourceMin) * (2 / 4)
	spawnPosition = spawnPosition + Vector(0, size.y, 0)

	local hitPosition = self:getTargetPosition(self:getDestination())
	local length = (spawnPosition - hitPosition):getLength()
	local delta = Tween.sineEaseOut(self:getDelta())
	self.particles:updateLocalPosition(((-spawnPosition:direction(hitPosition) * 4) + spawnPosition):lerp(hitPosition + spawnPosition:direction(hitPosition) * 2, delta))
	self.particles:updateLocalDirection(-spawnPosition:direction(hitPosition))
end

function DecayingBolt:getDuration()
	return DecayingBolt.DURATION
end

function DecayingBolt:update(...)
	Projectile.update(self, ...)

	self:updateParticles()
end

return DecayingBolt
