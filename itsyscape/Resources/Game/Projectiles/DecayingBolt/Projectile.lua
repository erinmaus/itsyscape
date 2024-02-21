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
	texture = "Resources/Game/Projectiles/DecayingBolt/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 0 },
			speed = { 4, 6 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 0.25, 0.25, 0.25, 0 },
				{ 0.25, 0.25, 0.25, 0 },
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
		count = { 40, 50 },
		delay = { 1 / 60 },
		duration = { 2 }
	}
}

DecayingBolt.BOLT_DELTA = 0.5
DecayingBolt.DURATION   = 4

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
end

function DecayingBolt:getDuration()
	return DecayingBolt.DURATION
end

function DecayingBolt:update(...)
	Projectile.update(self, ...)

	local spawnPosition = self:getTargetPosition(self:getSource())
	local hitPosition = self:getTargetPosition(self:getDestination())
	local length = (spawnPosition - hitPosition):getLength()
	local currentPositionDelta = math.abs(math.sin(math.pi * 2 * length * self:getDelta()))
	self.particles:updateLocalPosition(spawnPosition:lerp(hitPosition, currentPositionDelta))
end

return DecayingBolt
