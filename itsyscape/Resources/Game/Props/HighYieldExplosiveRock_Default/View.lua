--------------------------------------------------------------------------------
-- Resources/Game/Props/HighYieldExplosiveRock_Default/View.lua
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

local HighYieldExplosiveRock = Class(RockView)
HighYieldExplosiveRock.MIN_FLICKER_TIME = 10 / 60
HighYieldExplosiveRock.MAX_FLICKER_TIME = 20 / 60
HighYieldExplosiveRock.MIN_ATTENUATION = 1.5
HighYieldExplosiveRock.MAX_ATTENUATION = 3.5
HighYieldExplosiveRock.COLOR = Color(1, 0, 0)

function HighYieldExplosiveRock:new(...)
	RockView.new(self, ...)

	self.flickerTime = 0
end

function HighYieldExplosiveRock:load()
	RockView.load(self)

	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(self.COLOR)
end

function HighYieldExplosiveRock:flicker()
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

function HighYieldExplosiveRock:getTextureFilename()
	return "Resources/Game/Props/HighYieldExplosiveRock_Default/Texture.png"
end

function HighYieldExplosiveRock:getDepletedTextureFilename()
	return "Resources/Game/Props/HighYieldExplosiveRock_Default/Texture_Depleted.png"
end

function HighYieldExplosiveRock:update(delta)
	RockView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function HighYieldExplosiveRock:tick()
	RockView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return HighYieldExplosiveRock
