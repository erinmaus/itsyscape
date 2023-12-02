--------------------------------------------------------------------------------
-- Resources/Game/Props/CaesiumRock_Default/View.lua
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

local CaesiumRock = Class(RockView)
CaesiumRock.MIN_FLICKER_TIME = 10 / 60
CaesiumRock.MAX_FLICKER_TIME = 20 / 60
CaesiumRock.MIN_ATTENUATION = 1.5
CaesiumRock.MAX_ATTENUATION = 3.5
CaesiumRock.COLOR = Color(0, 0, 1)

function CaesiumRock:new(...)
	RockView.new(self, ...)

	self.flickerTime = 0
end

function CaesiumRock:load()
	RockView.load(self)

	local root = self:getRoot()

	self.light = PointLightSceneNode()
	self.light:setParent(root)
	self.light:setColor(self.COLOR)
end

function CaesiumRock:flicker()
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

function CaesiumRock:getTextureFilename()
	return "Resources/Game/Props/CaesiumRock_Default/Texture.png"
end

function CaesiumRock:getDepletedTextureFilename()
	return "Resources/Game/Props/CaesiumRock_Default/Texture_Depleted.png"
end

function CaesiumRock:update(delta)
	RockView.update(self, delta)

	self.flickerTime = self.flickerTime - delta
end

function CaesiumRock:tick()
	RockView.tick(self)

	if self.flickerTime < 0 then
		self:flicker()
	end
end

return CaesiumRock
