--------------------------------------------------------------------------------
-- Resources/Game/Props/Lamp_IsabelleTower/View.lua
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

local Lamp = Class(PropView)
Lamp.MIN_FLICKER_TIME = 10 / 60
Lamp.MAX_FLICKER_TIME = 20 / 60
Lamp.MIN_ATTENUATION = 5
Lamp.MAX_ATTENUATION = 8
Lamp.MIN_COLOR_BRIGHTNESS = 0.7
Lamp.MAX_COLOR_BRIGHTNESS = 1.0

Lamp.FLAME = {
	numParticles = 50,
	texture = "Resources/Game/Props/Lamp_IsabelleTower/Flame.png",
	columns = 4,

	emitters = {
		{
			type = "RadialEmitter",
			radius = { 0, 0.25 },
			position = { 0, 0.4, 0 },
			yRange = { 0, 0 },
			lifetime = { 1.5, 0.4 }
		},
		{
			type = "DirectionalEmitter",
			direction = { 0, 1, 0 },
			speed = { 0.5, 0.5 },
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
			type = "RandomScaleEmitter",
			scale = { 0.1 }
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
		delay = { 1 / 30 }
	}
}

function Lamp:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.flickerTime = 0
end

function Lamp:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)

	self.decoration = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/Lamp_IsabelleTower/Lamp.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Lamp_IsabelleTower/Lamp.lstatic",
		function(mesh)
			self.decoration:fromGroup(mesh:getResource(), "lamp")
			self.decoration:getMaterial():setTextures(self.texture)
			self.decoration:getMaterial():setIsFullLit(true)
			self.decoration:getMaterial():setIsZWriteDisabled(true)
			self.decoration:getMaterial():setZBias(0.01)
			self.decoration:getMaterial():setOutlineThreshold(0.5)
			self.decoration:setParent(root)
		end)
	resources:queueEvent(function()
		self.flames = ParticleSceneNode()
		self.flames:initParticleSystemFromDef(Lamp.FLAME, resources)
		self.flames:setParent(self.decoration)
	end)
end


function Lamp:flicker()
	if self.light and self.flames then
		local flickerWidth = Lamp.MAX_FLICKER_TIME - Lamp.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + Lamp.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = Lamp.MAX_ATTENUATION - Lamp.MIN_ATTENUATION
		local attenuation = math.random() * attenuationWidth + Lamp.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = Lamp.MAX_COLOR_BRIGHTNESS - Lamp.MIN_COLOR_BRIGHTNESS
		local brightness = math.random() * brightnessWidth + Lamp.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness, brightness, brightness, 1)
		self.light:setColor(color)
	end
end

function Lamp:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function Lamp:tick()
	PropView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return Lamp
