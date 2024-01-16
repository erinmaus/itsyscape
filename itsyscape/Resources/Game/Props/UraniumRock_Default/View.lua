--------------------------------------------------------------------------------
-- Resources/Game/Props/UraniumRock_Default/View.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local RockView = require "Resources.Game.Props.Common.RockView2"
local PointLightSceneNode = require "ItsyScape.Graphics.PointLightSceneNode"

local UraniumRock = Class(RockView)
UraniumRock.MIN_FLICKER_TIME = 10 / 60
UraniumRock.MAX_FLICKER_TIME = 20 / 60
UraniumRock.MIN_ATTENUATION = 1.5
UraniumRock.MAX_ATTENUATION = 3.5
UraniumRock.COLOR = Color(0, 1, 0)

function UraniumRock:new(...)
	RockView.new(self, ...)

	self.flickerTime = 0
end

function UraniumRock:load()
	RockView.load(self)

	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(self.COLOR)
end

function UraniumRock:flicker()
	if self.light then
		local state = self:getProp():getState()
		local isDepleted = state and state.resource and state.resource.depleted

		local flickerWidth = self.MAX_FLICKER_TIME - self.MIN_FLICKER_TIME
		self.flickerTime = love.math.random() * flickerWidth + self.MIN_FLICKER_TIME

		local attenuationWidth = self.MAX_ATTENUATION - self.MIN_ATTENUATION
		local attenuation = love.math.random() * attenuationWidth + self.MAX_ATTENUATION
		self.light:setAttenuation(isDepleted and 0 or attenuation)
	end
end

function UraniumRock:getTextureFilename()
	return "Resources/Game/Props/UraniumRock_Default/Texture.png"
end

function UraniumRock:getDepletedTextureFilename()
	return "Resources/Game/Props/UraniumRock_Default/Texture_Depleted.png"
end

function UraniumRock:update(delta)
	RockView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function UraniumRock:tick()
	RockView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return UraniumRock
