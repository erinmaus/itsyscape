--------------------------------------------------------------------------------
-- Resources/Game/Props/Common/Greeble/FlickerGreeble.lua
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
local Greeble = require "Resources.Game.Props.Common.Greeble"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local FlickerGreeble = Class(Greeble)

FlickerGreeble.OFFSET = Vector(0):keep()
FlickerGreeble.MIN_FLICKER_TIME = 10 / 60
FlickerGreeble.MAX_FLICKER_TIME = 20 / 60
FlickerGreeble.MIN_ATTENUATION = 2
FlickerGreeble.MAX_ATTENUATION = 3.5
FlickerGreeble.MIN_COLOR_BRIGHTNESS = 0.9
FlickerGreeble.MAX_COLOR_BRIGHTNESS = 1.0
FlickerGreeble.COLORS = {
	Color(1, 0.5, 0, 1)
}

function FlickerGreeble:new(prop, gameView)
	Greeble.new(self, prop, gameView)

	self.flickerTime = 0
end

function FlickerGreeble:load()
	Greeble.load(self)

	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:getTransform():setLocalTranslation(self.OFFSET)
	self.light:setParent(root)
	self:flicker()
end

function FlickerGreeble:getLight()
	return self.light
end

function FlickerGreeble:flicker()
	if self.light then
		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = love.math.random() * flickerWidth + self.MIN_FLICKER_TIME

		local min, max = self:getProp():getBounds()
		local size = max - min
		local scale = 1.0 + size:getLength()
		local attenuationWidth = self.MAX_ATTENUATION - self.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION
		self.light:setAttenuation(attenuation)

		local brightnessWidth = self.MAX_COLOR_BRIGHTNESS - self.MIN_COLOR_BRIGHTNESS
		local brightness = love.math.random() * brightnessWidth + self.MAX_COLOR_BRIGHTNESS

		local baseColor = self.COLORS[love.math.random(#self.COLORS)]
		local color = Color(brightness * baseColor.r, brightness * baseColor.g, brightness * baseColor.b, 1)
		self.light:setColor(color)
	end
end

function FlickerGreeble:update(delta)
	Greeble.update(self, delta)

	self.flickerTime = self.flickerTime - delta

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return FlickerGreeble
