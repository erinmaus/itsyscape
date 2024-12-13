--------------------------------------------------------------------------------
-- Resources/Game/Props/Storm_Default/View.lua
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
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local Storm = Class(PropView)
Storm.MIN_WIND_SPEED_MULTIPLIER = 0.1
Storm.MAX_WIND_SPEED_MULTIPLIER = 0.3

Storm.MIN_ZAP_TIME_SECONDS = 0.2
Storm.MAX_ZAP_TIME_SECONDS = 0.5

Storm.LIGHTNING_STRIKE_MIN_DURATION_SECONDS = 0.5
Storm.LIGHTNING_STRIKE_MAX_DURATION_SECONDS = 0.9

Storm.LIGHTNING_STRIKE_MIN_ATTENUATION = 12
Storm.LIGHTNING_STRIKE_MAX_ATTENUATION = 16

Storm.MIN_RADIUS = 48
Storm.MAX_RADIUS = 56

Storm.LIGHTNING_RADIUS_OFFSET = 12

Storm.LIGHTNING_TIME_MULTIPLIER = 4

Storm.SHADER = ShaderResource()
do
	Storm.SHADER:loadFromFile("Resources/Shaders/Cloud")
end

Storm.PARTICLES = function(windDirection, minWindSpeed, maxWindSpeed)
	windDirection = windDirection or Vector(1, 0, 1):getNormal()

	return {
		texture = "Resources/Game/Props/Storm_Default/Particle.png",
		numParticles = 4000,
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				radius = { Storm.MIN_RADIUS, Storm.MAX_RADIUS },
				yRange = { 0.5, 0.5 },
				normal = { true }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ 1.0, 1.0, 1.0, 0.0 },
					{ 1.0, 1.0, 1.0, 0.0 },
					{ 0.2, 0.2, 0.2, 0.0 }
				}
			},
			{
				type = "DirectionalEmitter",
				direction = { windDirection:get() },
				speed = { minWindSpeed or 1, maxWindSpeed or 1.5 }
			},
			{
				type = "RandomLifetimeEmitter",
				lifetime = { 0, 20 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 5, 6 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { 10, 15 }
			}
		},

		paths = {
			{
				type = "FadeInOutPath",
				fadeInPercent = { 0.05 },
				fadeOutPercent = { 0.95 },
				tween = { 'sineEaseOut' }
			},
			{
				type = "TextureIndexPath",
				textures = { 1, 1 }
			}
		},

		emissionStrategy = {
			type = "RandomDelayEmissionStrategy",
			count = { 100, 150 },
			delay = { 1 / 60 },
			duration = { math.huge }
		}
	}
end

function Storm:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.lightning = {}
end

function Storm:load()
	PropView.load(self)

	self.currentSkyColor = Color()
	self.previousSkyColor = false

	local resources = self:getResources()
	local root = self:getRoot()

	self.particles = ParticleSceneNode()
	self.particles:getMaterial():setShader(Storm.SHADER)
	self.particles:getMaterial():setIsZWriteDisabled(false)
	self.particles:getMaterial():setIsFullLit(false)
	self.particles:getMaterial():setColor(Color(1))
	self.particles:getMaterial():setOutlineThreshold(-1)
	self.particles:setParent(root)

	self:zap()
end

function Storm:zap()
	local position = Vector(
		love.math.random() * 2 - 1,
		love.math.random() * 0.5,
		love.math.random() * 2 - 1):getNormal()
	position = position * (love.math.random() * (self.MAX_RADIUS - self.MIN_RADIUS) + self.MIN_RADIUS) + self.LIGHTNING_RADIUS_OFFSET

	local state = self:getProp():getState()
	local colors = state.colors or { { 1, 1, 1 } }
	local color = colors[love.math.random(#colors)]

	local light = PointLightSceneNode()
	light:setColor(Color(unpack(color or { 1, 1, 1 })))
	light:setParent(self:getRoot())
	light:getTransform():setLocalTranslation(position)

	local pattern = love.timer.getTime() * math.pi * 2
	local duration = love.math.random() * (self.LIGHTNING_STRIKE_MAX_DURATION_SECONDS - self.LIGHTNING_STRIKE_MIN_DURATION_SECONDS) + self.LIGHTNING_STRIKE_MIN_DURATION_SECONDS

	table.insert(self.lightning, {
		light = light,
		pattern = pattern,
		duration = duration,
		time = 0
	})

	self.pendingLightningTime = love.math.random() * (self.MAX_ZAP_TIME_SECONDS - self.MIN_ZAP_TIME_SECONDS) + self.MIN_ZAP_TIME_SECONDS
end

function Storm:tick()
	PropView.tick(self)

	local _, layer = self:getProp():getPosition()
	local windDirection, windSpeed, windPattern = self:getGameView():getWind(layer)

	if windDirection ~= self.windDirection or windSpeed ~= self.windSpeed then
		local stormParticleSystemDef = self.PARTICLES(windDirection, windSpeed * self.MIN_WIND_SPEED_MULTIPLIER, windSpeed * self.MAX_WIND_SPEED_MULTIPLIER)

		local resources = self:getResources()
		self.particles:initParticleSystemFromDef(stormParticleSystemDef, resources)

		self.windDirection = windDirection:keep()
		self.windSpeed = windSpeed
	end
end

function Storm:update(delta)
	PropView.update(self, delta)

	self.pendingLightningTime = (self.pendingLightningTime or 0) - delta
	if self.pendingLightningTime <= 0 then
		self:zap()
	end

	for i = #self.lightning, 1, -1 do
		local l = self.lightning[i]

		if l.time >= l.duration then
			l.light:setParent(nil)
			table.remove(self.lightning, i)
		else
			l.time = l.time + delta

			local pattern = l.pattern
			local time = love.timer.getTime() * self.LIGHTNING_TIME_MULTIPLIER
			local light = l.light

			local mu = math.abs(math.sin(time * pattern * self.LIGHTNING_TIME_MULTIPLIER))
			local lightDelta = math.sin(math.clamp(l.time / l.duration) * math.pi)
			local attenuation = math.lerp(self.LIGHTNING_STRIKE_MIN_ATTENUATION, self.LIGHTNING_STRIKE_MAX_ATTENUATION, mu)

			light:setAttenuation(attenuation * lightDelta)
			light:setPreviousAttenuation(attenuation * lightDelta)
		end
	end
end

return Storm
