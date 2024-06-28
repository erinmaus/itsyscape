--------------------------------------------------------------------------------
-- Resources/Game/Props/Moon_Default/View.lua
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
local DirectionalLightSceneNode = require "ItsyScape.Graphics.DirectionalLightSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Moon = Class(PropView)

Moon.PARTICLE_SYSTEM = {
	texture = "Resources/Game/Props/Moon_Default/Particle.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 3 },
			speed = { 1, 2 },
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
			scale = { 1, 1.5 }
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
			fadeOutPercent = { 0.4 },
			tween = { 'sineEaseOut' }
		},
		{
			type = "TextureIndexPath",
			textures = { 1, 4 }
		}
	},

	emissionStrategy = {
		type = "RandomDelayEmissionStrategy",
		count = { 1, 3 },
		delay = { 1 / 30 },
		duration = { math.huge }
	}
}

function Moon:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.moonExterior = DecorationSceneNode()
	self.moonExterior:setParent(root)

	self.moonInterior = DecorationSceneNode()
	self.moonInterior:setParent(root)

	self.light = DirectionalLightSceneNode()
	--self.light:setParent(root)

	self.particles = ParticleSceneNode()
	self.particles:initParticleSystemFromDef(Moon.PARTICLE_SYSTEM, resources)
	self.particles:setParent(root)

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Moon_Default/Texture.png",
		function(texture)
			self.exteriorTexture = texture
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Moon_Default/Model.lstatic",
		function(model)
			self.moonExterior:getMaterial():setTextures(self.exteriorTexture)
			self.moonExterior:getTransform():setLocalScale(Vector(5))
			self.moonExterior:fromGroup(model:getResource(), "Moon")
		end)

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Moon_Default/Model.lstatic",
		function(model)
			local whiteTexture = self:getGameView():getWhiteTexture()
			self.moonInterior:getMaterial():setTextures(whiteTexture)
			self.moonInterior:getTransform():setLocalScale(Vector(3.5))
			self.moonInterior:fromGroup(model:getResource(), "Moon")

			self:_updateColor()
		end)
end

function Moon:_updateColor()
	local state = self:getProp():getState()
	if state.color then
		local color = Color(unpack(state.color))

		if self.moonInterior then
			self.moonInterior:getMaterial():setColor(color)
		end

		if self.particles then
			self.particles:getMaterial():setColor(color)
		end
	end
end

function Moon:_updateLight()
	local state = self:getProp():getState()
	if state.normal then
		local normal = -Vector(unpack(state.normal))
		self.light:setDirection(normal)
	end
end

function Moon:getIsStatic()
	return false
end

function Moon:tick()
	PropView.tick(self)

	self:_updateColor()
	self:_updateLight()
end

return Moon
