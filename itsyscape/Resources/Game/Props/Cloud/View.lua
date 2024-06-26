--------------------------------------------------------------------------------
-- Resources/Game/Props/Cloud/View.lua
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

local Cloud = Class(PropView)
Cloud.MIN_PARTICLE_COUNT   = 1
Cloud.MAX_PARTICLE_COUNT   = 3

Cloud.PARTICLES = function(position, radius, wind, inColor. outColor)
	radius = radius or 1
	wind = wind or Vector.ZERO

	local minCount = (math.pi * radius ^ 2) * Cloud.MIN_PARTICLE_COUNT
	local maxCount = (math.pi * radius ^ 2) * Cloud.MAX_PARTICLE_COUNT

	return {
		texture = "Resources/Game/Props/Cloud/Particle.png",
		columns = 4,

		emitters = {
			{
				type = "RadialEmitter",
				position = { position:get() },
				radius = { 0, radius }
			},
			{
				type = "RandomColorEmitter",
				colors = {
					{ inColor:get() }
				}
			},
			{
				type = "RandomLifetimeEmitter",
				lifetime = { 2, 2.5 }
			},
			{
				type = "RandomScaleEmitter",
				scale = { 1.5 }
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
				fadeInPercent = { 0.1 },
				fadeOutPercent = { 0.9 },
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

function Cloud:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.clouds = {}
end

function Cloud:_getInColor()
	local state = self:getProp():getState()

	return state.color

	--local gameView = self:getGameView()
	--local camera = gameView:getCamera()

	--local sun = Vector(state.sun or {})

	--local directionToSun = (gameView:getEye() - gameView:getTarget()):getNormal()
	--local angle = math.acos(math.dot(direction, ))
end

function Cloud:_getOutColor()
	local state = self:getProp():getState()

	return state.color
end

function Cloud:update(delta)
	PropView.update(self, delta)

	-- todo update cloud color when it covers sun
end

function Cloud:updateParticle(cloudInfo, inColor, outColor)
	local cloud = self.clouds[cloudInfo.id] or { node = ParticleSceneNode(), ready = false }
	self.clouds[cloudInfo.id] = cloud

	local position = cloudInfo.position and Vector(unpack(cloudInfo.position)) or cloud.position,
	local radius = cloudInfo.radius or cloud.radius
	local wind = cloudInfo.wind and Vector(unpack(cloudInfo.wind)) or cloud.wind

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
	end

	if not cloud.node:getParent() then
		cloud.node:setParent(self:getRoot())
	end

	cloud.visited = true
end

function Cloud:getIsStatic()
	return false
end

function Cloud:tick()
	PropView.tick(self)

	local transform = self:getRoot():getTransform()
	transform:setLocalTranslation(Vector.ZERO)
	transform:setPreviousTransform(Vector.ZERO)

	for _, cloudInfo in pairs(self.clouds) do
		cloudInfo.visited = false
	end

	for _, cloudInfo in ipairs(state.clouds or {}) do
		self:updateParticle(cloudInfo, self:_getInColor(), self:_getOutColor())
	end

	for id, cloudInfo in pairs(self.clouds) do
		if not cloudInfo.visited then
			self.clouds[id].node:setParent(nil)
			self.clouds[id] = nil
		else
			cloudInfo.node:updateLocalPosition(self:getProp():getPosition())
		end
	end
end

return Cloud
