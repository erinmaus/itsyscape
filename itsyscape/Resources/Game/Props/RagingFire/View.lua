--------------------------------------------------------------------------------
-- Resources/Game/Props/Torch_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Color = require "ItsyScape.Graphics.Color"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local RagingFireView = Class(PropView)
RagingFireView.MIN_FLICKER_TIME = 5 / 30
RagingFireView.MAX_FLICKER_TIME = 15 / 30
RagingFireView.MIN_ATTENUATION_PERCENT = 0.8
RagingFireView.MAX_ATTENUATION_PERCENT = 1.2
RagingFireView.MIN_COLOR_BRIGHTNESS = 0.9
RagingFireView.MAX_COLOR_BRIGHTNESS = 1.0
RagingFireView.MIN_SPEED_PERCENT    = 0.2
RagingFireView.MAX_SPEED_PERCENT    = 0.3
RagingFireView.MIN_PARTICLE_COUNT   = 4
RagingFireView.MAX_PARTICLE_COUNT   = 6

RagingFireView.FIRE_PARTICLES = function(radius, wind)
	radius = radius or 1
	wind = wind or Vector.ZERO

	local minCount = (math.pi * radius ^ 2) * RagingFireView.MIN_PARTICLE_COUNT
	local maxCount = (math.pi * radius ^ 2) * RagingFireView.MAX_PARTICLE_COUNT

	return {
		texture = "Resources/Game/Props/RagingFire/Flame.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, radius },
				yRange = { 0, 0 }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { RagingFireView.MIN_SPEED_PERCENT * wind.y, RagingFireView.MAX_SPEED_PERCENT * wind.y },
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
				lifetime = { 1, 1.5 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.25 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { 30, 60 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.2 },
				fadeOutPercent = { 0.8 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "GravityPath",
				gravity = { wind:get() }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 4 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { minCount, maxCount },
			delay = { 1 / 16 },
			duration = math.huge
		}
	}
end

RagingFireView.SMOKE_PARTICLES = function(radius, wind)
	radius = radius or 1
	wind = wind or Vector.ZERO

	local minCount = (math.pi * radius ^ 2) * RagingFireView.MIN_PARTICLE_COUNT
	local maxCount = (math.pi * radius ^ 2) * RagingFireView.MAX_PARTICLE_COUNT

	local normal = wind:getNormal()

	return {
		texture = "Resources/Game/Props/RagingFire/Smoke.png",
		columns = 1,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { 0, radius - 0.5 },
				yRange = { 0, 0 },
				position = { normal.x * radius, radius * 2, normal.z * radius }
			},
			{
				type = "DirectionalEmitter",
				direction = { 0, 1, 0 },
				speed = { RagingFireView.MIN_SPEED_PERCENT * wind.y, RagingFireView.MAX_SPEED_PERCENT * wind.y },
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
				lifetime = { 0.8, 1.2 }
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
			},
			{
				type = "GravityPath",
				gravity = { wind:get() }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { minCount, maxCount },
			delay = { 1 / 16 },
			duration = math.huge
		}
	}
end

function RagingFireView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.flickerTime = 0
end

function RagingFireView:getTextureFilename()
	return Class.ABSTRACT()
end

function RagingFireView:getModelFilename()
	return Class.ABSTRACT()
end

function RagingFireView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	self.flames = ParticleSceneNode()
	--self.flames:initParticleSystemFromDef(RagingFireView.FIRE_PARTICLES(), resources)
	self.flames:setParent(root)

	self.smoke = ParticleSceneNode()
	--self.smoke:initParticleSystemFromDef(RagingFireView.SMOKE_PARTICLES(), resources)
	self.smoke:setParent(root)
end

function RagingFireView:flicker()
	local flickerWidth = RagingFireView.MAX_FLICKER_TIME - RagingFireView.MIN_FLICKER_TIME
	self.flickerTime = love.math.random() * flickerWidth + RagingFireView.MIN_FLICKER_TIME

	local scale = math.max(1.0 + self:getProp():getScale():getLength(), 1.0)
	local attenuationWidth = RagingFireView.MAX_ATTENUATION_PERCENT - RagingFireView.MIN_ATTENUATION_PERCENT
	local attenuation = scale * (love.math.random() * attenuationWidth + RagingFireView.MAX_ATTENUATION_PERCENT)
	self.light:setAttenuation(attenuation)

	local brightnessWidth = RagingFireView.MAX_COLOR_BRIGHTNESS - RagingFireView.MIN_COLOR_BRIGHTNESS
	local brightness = love.math.random() * brightnessWidth + RagingFireView.MAX_COLOR_BRIGHTNESS
	local color = Color(brightness, brightness, brightness, 1)
	self.light:setColor(color)
end

function RagingFireView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function RagingFireView:initParticles()
	local resources = self:getResources()

	local fire = RagingFireView.FIRE_PARTICLES(
		self.currentRadius,
		self.currentDirection)
	self.flames:initParticleSystemFromDef(fire, resources)

	local smoke = RagingFireView.SMOKE_PARTICLES(
		self.currentRadius,
		self.currentDirection)
	self.smoke:initParticleSystemFromDef(smoke, resources)
end

function RagingFireView:tick()
	PropView.tick(self)

	local rootTransform = self:getRoot():getTransform()
	rootTransform:setLocalScale(Vector.ONE)
	self:getRoot():tick()

	if self.flickerTime < 0 then
		self:flicker()
	end

	local state = self:getProp():getState()

	local scale = self:getProp():getScale()
	local radius = math.max((1.0 + (scale * Vector.PLANE_XZ):getLength()) / 2, 1.0)
	local direction = Vector(unpack(state.direction or { 0, 1, 0 }))
	if self.currentDirection ~= direction or
	   self.currentRadius ~= radius
	then
		self.currentDirection = direction
		self.currentRadius = radius

		self:initParticles()
	end
end

return RagingFireView
