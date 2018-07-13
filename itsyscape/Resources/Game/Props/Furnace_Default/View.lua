--------------------------------------------------------------------------------
-- Resources/Game/Props/Furnace_Default/View.lua
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
local PropView = require "ItsyScape.Graphics.PropView"
local StaticMeshResource = require "ItsyScape.Graphics.StaticMeshResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local FurnaceView = Class(PropView)
FurnaceView.MIN_FLICKER_TIME = 10 / 60
FurnaceView.MAX_FLICKER_TIME = 20 / 60
FurnaceView.MIN_ATTENUATION = 0.5
FurnaceView.MAX_ATTENUATION = 1.5
FurnaceView.MIN_COLOR_BRIGHTNESS = 0.9
FurnaceView.MAX_COLOR_BRIGHTNESS = 1.0

function FurnaceView:new(prop, gameView)
	PropView.new(self, prop, gameView)

	self.flickerTime = 0
end

function FurnaceView:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	local mesh = resources:load(
		StaticMeshResource,
		"Resources/Game/Props/Furnace_Default/Furnace.lstatic")
	local texture = resources:load(
		TextureResource,
		"Resources/Game/Props/Furnace_Default/Texture.png")

	self.decoration = DecorationSceneNode()
	self.decoration:fromGroup(mesh:getResource(), "Furnace")
	self.decoration:getMaterial():setTextures(texture)
	self.decoration:setParent(root)

	self.light = PointLightSceneNode()
	self.light:getTransform():setLocalTranslation(Vector(0, 2, 0))
	self.light:setParent(root)

	self:flicker()
end

function FurnaceView:flicker()
	local flickerWidth = FurnaceView.MAX_FLICKER_TIME - FurnaceView.MIN_FLICKER_TIME
	self.flickerTime = math.random() * flickerWidth + FurnaceView.MIN_FLICKER_TIME

	local scale = 1.0 + (self:getProp():getScale():getLength() - math.sqrt(3))
	local attenuationWidth = FurnaceView.MAX_ATTENUATION - FurnaceView.MIN_ATTENUATION
	local attenuation = math.random() * attenuationWidth + FurnaceView.MAX_ATTENUATION
	self.light:setAttenuation(attenuation)

	local brightnessWidth = FurnaceView.MAX_COLOR_BRIGHTNESS - FurnaceView.MIN_COLOR_BRIGHTNESS
	local brightness = math.random() * brightnessWidth + FurnaceView.MAX_COLOR_BRIGHTNESS
	local color = Color(brightness, brightness, brightness, 1)
	self.light:setColor(color)
end

function FurnaceView:update(delta)
	PropView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function FurnaceView:tick()
	PropView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return FurnaceView
