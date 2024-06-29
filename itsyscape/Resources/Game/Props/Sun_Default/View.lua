--------------------------------------------------------------------------------
-- Resources/Game/Props/Sun_Default/View.lua
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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"

local Sun = Class(PropView)
Sun.MIN_PARTICLE_COUNT   = 1
Sun.MAX_PARTICLE_COUNT   = 3

Sun.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/Sun_Default/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 1 },
			speed = { 0.5, 1 },
			zRange = { 0, 0 },
			acceleration = { 0, 0 }
		},
		{
			type = "RandomColorEmitter",
			colors = {
				{ 1.0, 1.0, 1.0, 0.0 },
				{ 0.9, 0.6, 0.9, 0.0 },
				{ 0.5, 0.5, 0.5, 0.0 },
				{ 1.0, 0.5, 1.0, 0.0 },
			}
		},
		{
			type = "RandomLifetimeEmitter",
			age = { 1.25, 1.5 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.5, 0.7 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 },
			velocity = { 60, 120 }

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
		count = { 5, 10 },
		delay = { 1 / 30 },
		duration = { math.huge }
	}
}

function Sun:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.sun = DecorationSceneNode()
	self.sun:setParent(root)

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(Sun.PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)

	self.light = DirectionalLightSceneNode()
	self.light:setParent(root)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Sun_Default/Model.lstatic",
		function(model)
			local whiteTexture = self:getGameView():getWhiteTexture()

			do
				local material = self.sun:getMaterial()
				material:setTextures(whiteTexture)
				material:setIsFullLit(true)
				self:_updateColor()

				self.sun:getTransform():setLocalScale(Vector(1))

				self.sun:fromGroup(model:getResource(), "Singularity")
			end
		end)
end

function Sun:_updateColor()
	local state = self:getProp():getState()
	if state.color then
		local color = Color(unpack(state.color))

		if self.sun then
			self.sun:getMaterial():setColor(color)
		end

		if self.particles then
			self.particles:getMaterial():setColor(color)
		end
	end

	if state.skyColor then
		local skyColor = Color(unpack(state.skyColor))

		local _, layer = self:getProp():getPosition()
		self:getGameView():setSkyboxColor(layer, skyColor)
	end
end

function Sun:_updateLight()
	local state = self:getProp():getState()
	if state.normal then
		local normal = -Vector(unpack(state.normal))
		self.light:setDirection(normal)
	end
end

function Sun:getIsStatic()
	return false
end

function Sun:tick()
	PropView.tick(self)

	self:_updateColor()
	self:_updateLight()
end

return Sun
