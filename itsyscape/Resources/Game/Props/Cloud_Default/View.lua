--------------------------------------------------------------------------------
-- Resources/Game/Props/Cloud_Default/View.lua
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
local ShaderResource = require "ItsyScape.Graphics.ShaderResource"

local Cloud = Class(PropView)
Cloud.MIN_PARTICLE_COUNT   = 1
Cloud.MAX_PARTICLE_COUNT   = 2

Cloud.SHADER = ShaderResource()
do
	Cloud.SHADER:loadFromFile("Resources/Shaders/Cloud")
end

Cloud.PARTICLES = function(position, radius, wind, inColor, outColor)
	radius = math.max(radius or 1, 1)
	wind = wind or Vector.ZERO

	local minCount = math.ceil((1 + math.sqrt(radius)) * Cloud.MIN_PARTICLE_COUNT)
	local maxCount = math.ceil((1 + math.sqrt(radius)) * Cloud.MAX_PARTICLE_COUNT)

	return {
		texture = "Resources/Game/Props/Cloud_Default/Particle.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				position = { position:get() },
				radius = { 0, radius / 2 },
				speed = { radius / 16, radius / 8 },
				normal = { true }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ inColor:get() }
				}
			},
			{
				type = "RandomLifetimeEmitter",
				lifetime = { 4, 6 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 0.5, 1.25 }
			},
			{
				type = "RandomRotationEmitter",
				rotation = { 0, 360 },
				velocity = { 30, 60 }
			}
		},

		paths = {
			{
				type = "ColorPath",
				fadeInPercent = { 0.3 },
				fadeInColor = { inColor:get() },
				fadeOutPercent = { 0.6 },
				fadeOutColor = { outColor:get() },
			},
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
			count = { minCount, maxCount },
			delay = { 1 / 4 },
			duration = math.huge
		}
	}
end

function Cloud:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.clouds = {}
	self.previousSunPosition = Vector()
	self.currentSunPosition = Vector()
end

function Cloud:_getWind()
	return Vector(unpack(self:getProp():getState().wind or {}))
end

function Cloud:_getInColor()
	local state = self:getProp():getState()
	return Color(unpack(state.color or {}))
end

function Cloud:_getOutColor()
	local state = self:getProp():getState()
	return Color(unpack(state.color or {}))
end

function Cloud:updateParticle(cloudInfo, wind, inColor, outColor, alpha)
	local cloud = self.clouds[cloudInfo.id] or { node = ParticleSceneNode(), ready = false }
	self.clouds[cloudInfo.id] = cloud

	local position = cloudInfo.position and Vector(unpack(cloudInfo.position)) or cloud.position
	local radius = cloudInfo.radius or cloud.radius

	if not cloud.ready or (
		position ~= cloud.position or
		radius ~= cloud.radius or
		wind ~= cloud.wind or
		inColor ~= cloud.inColor or
		outColor ~= cloud.outColor
	) then
		local cloudParticleSystemDef = Cloud.PARTICLES(
			position,
			radius,
			wind,
			inColor,
			outColor)

		cloud.position = position
		cloud.radius = radius
		cloud.wind = wind
		cloud.inColor = inColor
		cloud.outColor = outColor

		cloud.node:initParticleSystemFromDef(cloudParticleSystemDef, self:getResources())

		if not cloud.ready then
			cloud.node:onWillRender(function(renderer, delta)
				local shader = renderer:getCurrentShader()
				if shader:hasUniform("scape_SunPosition") then
					shader:send("scape_SunPosition", { self.previousSunPosition:lerp(self.currentSunPosition, delta):get() })
				end
			end)

			cloud.node:getMaterial():setShader(Cloud.SHADER)
			cloud.node:getMaterial():setIsFullLit(false)
			cloud.node:getMaterial():setIsZWriteDisabled(true)
		end

		cloud.ready = true
	end

	if not cloud.node:getParent() then
		cloud.node:setParent(self:getRoot())
	end

	local adjustedAlpha = math.clamp(math.sin(alpha * math.pi) * 2.5)
	cloud.node:getMaterial():setColor(Color(1, 1, 1, adjustedAlpha))

	cloud.visited = true
end

function Cloud:getIsStatic()
	return false
end

function Cloud:tick()
	PropView.tick(self)

	local state = self:getProp():getState()

	self.previousSunPosition = self.currentSunPosition
	self.currentSunPosition = state.sun and Vector(unpack(state.sun)) or Vector()

	for _, cloudInfo in pairs(self.clouds) do
		cloudInfo.visited = false
	end

	for _, cloudInfo in ipairs(state.clouds or {}) do
		self:updateParticle(cloudInfo, self:_getWind(), self:_getInColor(), self:_getOutColor(), state.alpha or 0.5)
	end

	for id, cloudInfo in pairs(self.clouds) do
		if not cloudInfo.visited then
			self.clouds[id].node:setParent(nil)
			self.clouds[id] = nil
		end
	end
end

return Cloud
