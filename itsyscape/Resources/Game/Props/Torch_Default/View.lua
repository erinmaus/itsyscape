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
local Tween = require "ItsyScape.Common.Math.Tween"
local Color = require "ItsyScape.Graphics.Color"
local DecorationSceneNode = require "ItsyScape.Graphics.DecorationSceneNode"
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local TorchView = Class(PropView)
TorchView.MIN_FLICKER_TIME = 10 / 60
TorchView.MAX_FLICKER_TIME = 20 / 60
TorchView.MIN_ATTENUATION = 5
TorchView.MAX_ATTENUATION = 8
TorchView.MIN_COLOR_BRIGHTNESS = 0.9
TorchView.MAX_COLOR_BRIGHTNESS = 1.0
TorchView.SCALE_DURATION = 0.5
TorchView.MIN_Y_SCALE = 0.9
TorchView.MAX_Y_SCALE = 1.0
TorchView.MIN_XZ_SCALE = 0.9
TorchView.MAX_XZ_SCALE = 1.1

function TorchView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.flickerTime = 0
	self.scaleTime = 0
end

function TorchView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/Torch_Default/Torch.lstatic",
		function(mesh)
			self.mesh = mesh
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Props/Torch_Default/Torch.png",
		function(texture)
			self.texture = texture
		end)
	resources:queueEvent(function()
		self.torchBase = DecorationSceneNode()
		self.torchBase:fromGroup(self.mesh:getResource(), "Torch")
		self.torchBase:getMaterial():setTextures(self.texture)
		self.torchBase:setParent(root)

		self.flames = DecorationSceneNode()
		self.flames:fromGroup(self.mesh:getResource(), "Flames")
		self.flames:getMaterial():setTextures(self.texture)
		self.flames:setParent(root)

		self.light = PointLightSceneNode()
		self.light:getTransform():setLocalTranslation(Vector(0, 3, 0))
		self.light:setParent(root)

		self:flicker()
	end)
end

function TorchView:flicker()
	if self.light then
		local flickerWidth = TorchView.MAX_FLICKER_TIME - TorchView.MIN_FLICKER_TIME
		self.flickerTime = math.random() * flickerWidth + TorchView.MIN_FLICKER_TIME

		local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
		local attenuationWidth = TorchView.MAX_ATTENUATION - TorchView.MIN_ATTENUATION
		local attenuation = math.random() * attenuationWidth + TorchView.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = TorchView.MAX_COLOR_BRIGHTNESS - TorchView.MIN_COLOR_BRIGHTNESS
		local brightness = math.random() * brightnessWidth + TorchView.MAX_COLOR_BRIGHTNESS
		local color = Color(brightness, brightness, brightness, 1)
		self.light:setColor(color)

		local state = self:getProp():getState()
		if not state.lit then
			self.flames:getMaterial():setColor(Color(1, 1, 1, 0))
		else
			self.flames:getMaterial():setColor(Color(1, 1, 1, 1))
		end
	end
end

function TorchView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
	self.scaleTime = self.scaleTime - delta

	if self.scaleTime < 0 then
		self.scaleTime = TorchView.SCALE_DURATION
		local yScaleWidth = TorchView.MAX_Y_SCALE - TorchView.MIN_Y_SCALE
		local xzScaleWidth = TorchView.MAX_XZ_SCALE - TorchView.MIN_XZ_SCALE
		local yScale = math.random() * yScaleWidth + TorchView.MIN_Y_SCALE
		local xzScale = math.random() * xzScaleWidth + TorchView.MIN_XZ_SCALE

		self.flamesPreviousYScale = self.flamesYScale
		self.flamesPreviousXZScale = self.flamesXZScale
		do
			if not self.flamesPreviousYScale then
				self.flamesPreviousYScale = math.random() * yScaleWidth + TorchView.MIN_Y_SCALE
			end

			if not self.flamesPreviousXZScale then
				self.flamesPreviousXZScale = math.random() * xzScaleWidth + TorchView.MIN_XZ_SCALE
			end
		end

		self.flamesYScale = yScale
		self.flamesXZScale = xzScale
	end

	if self.flames then
		local delta = 1 - self.scaleTime / TorchView.SCALE_DURATION
		local mu = Tween.sineEaseOut(delta)
		local previousScale = Vector(self.flamesPreviousXZScale, self.flamesPreviousYScale, self.flamesPreviousXZScale)
		local currentScale = Vector(self.flamesXZScale, self.flamesYScale, self.flamesXZScale)
		local scale = previousScale:lerp(currentScale, mu)

		self.flames:getTransform():setLocalScale(scale)
		self.flames:getTransform():setPreviousTransform(nil, nil, scale)
	end
end

function TorchView:tick()
	PropView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return TorchView
