--------------------------------------------------------------------------------
-- Resources/Game/Props/StreetLamp_ViziersRock/View.lua
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

local Lamp = Class(PropView)
Lamp.MIN_FLICKER_TIME = 10 / 60
Lamp.MAX_FLICKER_TIME = 20 / 60
Lamp.MIN_ATTENUATION = 8
Lamp.MAX_ATTENUATION = 10
Lamp.MIN_COLOR_BRIGHTNESS = 0.9
Lamp.MAX_COLOR_BRIGHTNESS = 1.0
Lamp.LIGHT_OFFSET = Vector.UNIT_Y * 4
Lamp.SCALE = Vector(0.5)

function Lamp:new(...)
	PropView.new(self, ...)

	self.flickerTime = 0
end

function Lamp:load()
	PropView.load(self)

	local resources = self:getResources()
	local root = self:getRoot()

	self.node = DecorationSceneNode()

	resources:queue(
		TextureResource,
		"Resources/Game/Props/StreetLamp_ViziersRock/Texture.png",
		function(texture)
			self.texture = texture
		end)
	resources:queue(
		StaticMeshResource,
		"Resources/Game/Props/StreetLamp_ViziersRock/Model.lstatic",
		function(mesh)
			self.mesh = mesh
			self.node:fromGroup(mesh:getResource(), "StreetLamp")
			self.node:getMaterial():setTextures(self.texture)
			self.node:getTransform():setLocalScale(Lamp.SCALE)
			self.node:setParent(root)

			self.light = PointLightSceneNode()
			self.light:setParent(root)
			self.light:getTransform():setLocalTranslation(Lamp.LIGHT_OFFSET)

			self:flicker()
		end)
end

function Lamp:flicker()
	if self.light then
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
