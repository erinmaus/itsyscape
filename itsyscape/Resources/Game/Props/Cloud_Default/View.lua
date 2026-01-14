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

local QUEUE = {}

Cloud.PARTICLES = function(position, radius, wind, inColor, outColor, definition)
	radius = math.max(radius or 1, 1)
	wind = wind or Vector.ZERO

	local minCount = math.ceil((1 + math.sqrt(radius)) * Cloud.MIN_PARTICLE_COUNT)
	local maxCount = math.ceil((1 + math.sqrt(radius)) * Cloud.MAX_PARTICLE_COUNT)

	definition = definition or {
		texture = "Resources/Game/Props/Cloud_Default/Particle.png",
		numParticles = 25,
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				position = { 0, 0, 0 },
				radius = { 0, 0 },
				speed = { 0, 0 },
				normal = { true }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ 0, 0, 0, 1 }
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
				fadeInColor = { 0, 0, 0, 0 },
				fadeOutPercent = { 0.6 },
				fadeOutColor = { 0, 0, 0, 0 },
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
			duration = { math.huge }
		}
	}

	definition.emitters[1].position[1], definition.emitters[1].position[2], definition.emitters[1].position[3] = position:get()
	definition.emitters[1].radius[1], definition.emitters[1].radius[2] = 0, radius / 2
	definition.emitters[1].speed[1], definition.emitters[1].speed[2] = radius / 32, radius / 16
	definition.emitters[2].colors[1], definition.emitters[2].colors[2], definition.emitters[2].colors[3], definition.emitters[2].colors[4] = inColor:get()
	definition.paths[1].fadeInColor[1], definition.paths[1].fadeInColor[2], definition.paths[1].fadeInColor[3], definition.paths[1].fadeInColor[4] = inColor:get()
	definition.paths[1].fadeOutColor[1], definition.paths[1].fadeOutColor[2], definition.paths[1].fadeOutColor[3], definition.paths[1].fadeOutColor[4] = outColor:get()

	return definition
end

function Cloud:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.clouds = {}
	self.previousSunPosition = Vector():keep()
	self.currentSunPosition = Vector():keep()
end

function Cloud:_getWind(result)
	return result:from(unpack(self:getProp():getState().wind or {}))
end

function Cloud:_getInColor(result)
	local state = self:getProp():getState()
	return result:from(unpack(state.color))
end

function Cloud:_getOutColor(result)
	local state = self:getProp():getState()
	return result:from(unpack(state.color or {}))
end

do
	local position = Vector()
	function Cloud:updateParticle(cloudInfo, wind, inColor, outColor, alpha)
		local cloud = self.clouds[cloudInfo.id] or table.remove(QUEUE) or { node = ParticleSceneNode(), ready = false }
		self.clouds[cloudInfo.id] = cloud

		local position = cloudInfo.position and position:from(unpack(cloudInfo.position)) or cloud.position
		local radius = cloudInfo.radius or cloud.radius

		if not cloud.ready or (
			position ~= cloud.position or
			radius ~= cloud.radius or
			wind ~= cloud.wind or
			inColor ~= cloud.inColor or
			outColor ~= cloud.outColor
		) then
			cloud.particleSystemDef = Cloud.PARTICLES(
				position,
				radius,
				wind,
				inColor,
				outColor,
				cloud.particleSystemDef)

			cloud.position = (cloud.position or Vector()):from(position:get())
			cloud.radius = radius
			cloud.wind = (cloud.wind or Vector()):from(wind:get())
			cloud.wind = wind:keep()
			cloud.inColor = (cloud.inColor or Color()):from(inColor:get())
			cloud.outColor = (cloud.outColor or Color()):from(outColor:get())

			cloud.node:initParticleSystemFromDef(cloud.particleSystemDef, self:getResources())

			if not cloud.ready then
				cloud.node:getMaterial():setShader(Cloud.SHADER)
				cloud.node:getMaterial():setIsFullLit(false)
				cloud.node:getMaterial():setIsZWriteDisabled(false)
			end

			cloud.ready = true
		end

		if not cloud.node:getParent() then
			cloud.node:setParent(self:getRoot())
		end

		local adjustedAlpha = math.clamp(math.sin(alpha * math.pi) * 2.5)
		cloud.node:getMaterial():getHandle():setColor(1, 1, 1, adjustedAlpha)

		cloud.visited = true
	end
end

function Cloud:getIsStatic()
	return false
end

do
	local wind = Vector()
	local inColor = Color()
	local outColor = Color()
	local currentSunPosition = Vector()
	local empty = {}

	function Cloud:tick()
		PropView.tick(self)

		local state = self:getProp():getState()

		self.currentSunPosition:copy(self.previousSunPosition)

		currentSunPosition:from(unpack(state.sun or empty))
		currentSunPosition:copy(self.currentSunPosition)

		for _, cloudInfo in pairs(self.clouds) do
			cloudInfo.visited = false
		end

		for _, cloudInfo in ipairs(state.clouds or empty) do
			self:updateParticle(cloudInfo, self:_getWind(wind), self:_getInColor(inColor), self:_getOutColor(outColor), state.alpha or 0.5)
		end

		for id, cloudInfo in pairs(self.clouds) do
			if not cloudInfo.visited then
				table.insert(QUEUE, cloudInfo)

				self.clouds[id].node:setParent(nil)
				self.clouds[id] = nil
			end
		end
	end
end

return Cloud
