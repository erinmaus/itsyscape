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
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local ParticleSceneNode = require "ItsyScape.Graphics.ParticleSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local FireplaceView = Class(PropView)
FireplaceView.MIN_FLICKER_TIME = 10 / 60
FireplaceView.MAX_FLICKER_TIME = 20 / 60
FireplaceView.MIN_ATTENUATION = 5
FireplaceView.MAX_ATTENUATION = 8
FireplaceView.MIN_COLOR_BRIGHTNESS = 0.9
FireplaceView.MAX_COLOR_BRIGHTNESS = 1.0

FireplaceView.FIRE_PARTICLES = {
	numParticles = 50,
	texture = "Resources/Game/Props/Common/FireplaceView_Flame.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0.5 },
			yRange = { 0, 0 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 1.5 },
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
			lifetime = { 0.4, 0.8 }
		},
		{
			type = "RandomScaleEmitter",
			scale = { 0.25 }
		},
		{
			type = "RandomRotationEmitter",
			rotation = { 0, 360 }
		}
	},

	paths = {
		{
			type = "FadeInOutPath",
			fadeInPercent = { 0.4 },
			fadeOutPercent = { 0.6 },
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
		delay = { 0.125 }
	}
}

function FireplaceView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.flickerTime = 0
end

function FireplaceView:getTextureFilename()
	return Class.ABSTRACT()
end

function FireplaceView:getModelFilename()
	return Class.ABSTRACT()
end

function FireplaceView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		self:getTextureFilename(),
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		self:getModelFilename(),
		function(mesh)
			local _, group = self:getModelFilename()
			self.decoration:fromGroup(mesh:getResource(), group)
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:setParent(root)
		end)
	resources:queueEvent(function()
		self.flames = ParticleSceneNode()
		self.flames:initParticleSystemFromDef(FireplaceView.FIRE_PARTICLES, resources)
		self.flames:getMaterial():setShader(self.shader)
		self.flames:setParent(root)
	end)
end


function FireplaceView:flicker()
	if self.light then
		local flickerWidth = FireplaceView.MAX_FLICKER_TIME - FireplaceView.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + FireplaceView.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = FireplaceView.MAX_ATTENUATION - FireplaceView.MIN_ATTENUATION
		local attenuation = math.random() * attenuationWidth + FireplaceView.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = FireplaceView.MAX_COLOR_BRIGHTNESS - FireplaceView.MIN_COLOR_BRIGHTNESS
		local brightness = math.random() * brightnessWidth + FireplaceView.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness, brightness, brightness, 1)
		self.light:setColor(color)

		local state = self:getProp():getState()
		if not state.lit then
			self.flames:setParent(nil)
			self.light:setParent(nil)
		else
			self.flames:setParent(self:getRoot())
			self.light:setParent(self:getRoot())
		end
	end
end

function FireplaceView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function FireplaceView:tick()
	PropView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return FireplaceView
