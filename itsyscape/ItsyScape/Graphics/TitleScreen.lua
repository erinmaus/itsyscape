--------------------------------------------------------------------------------
-- ItsyScape/Graphics/TitleScreen.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local TitleScreen = Class()
TitleScreen.FADE_IN_DURATION_SECONDS  = 0.5
TitleScreen.SLIDE_IN_DURATION_SECONDS = 0.5 + 1 / 3
TitleScreen.CURTAIN_DURATION_SECONDS  = 3 / 4
TitleScreen.CURTAIN_DURATION_SCALE    = 24

TitleScreen.SLIDE_SCALE = 1 / 4

TitleScreen.NUM_TOP_CURTAINS = 12
TitleScreen.NUM_MIDDLE_CURTAINS = 10
TitleScreen.NUM_BOTTOM_CURTAINS = 8

function TitleScreen:new(gameView, id)
	self.gameView = gameView
	self.resources = gameView:getResourceManager()
	self.logoTime = 0
	self.opaqueTime = 0
	self.showLogo = true
	self.isApplicationReady = false

	self:load()
end

function TitleScreen:getGameView()
	return self.gameView
end

function TitleScreen:getResources()
	return self.resources
end

function TitleScreen:setIsApplicationReady(value)
	self.isApplicationReady = value
end

function TitleScreen:getIsApplicationReady()
	return self.isApplicationReady
end

function TitleScreen:isReady()
	local isTranslucent = self.opaqueTime > TitleScreen.FADE_IN_DURATION_SECONDS
	local isResourceQueueEmpty = not self.resources:getIsPending()
	local isApplicationReady = self.isApplicationReady
	return isApplicationReady and isTranslucent and isResourceQueueEmpty
end

function TitleScreen:load()
	self.resources:queue(
		TextureResource,
		"Resources/Game/TitleScreens/Logo.png",
		function(texture)
			self.logo = texture
		end)
end

function TitleScreen:update(delta)
	if not self.resources:getIsPending() and self.isApplicationReady then
		self.logoTime = self.logoTime + delta
		self.opaqueTime = self.opaqueTime + delta
	end
end

function TitleScreen:enableLogo()
	self.showLogo = true
end

function TitleScreen:disableLogo()
	self.showLogo = false
end

function TitleScreen:draw()
	self:drawTitle()
end

function TitleScreen._calculateAlpha(time, duration1, duration2)
	local value = (time - duration1) / (duration2 or duration1)
	local delta = math.max(math.min(value, 1), 0)
	local tweenedDelta = Tween.sineEaseOut(delta)
	return tweenedDelta
end

function TitleScreen:drawTitle()
	local width, height = love.window.getMode()

	love.graphics.setBlendMode('alpha')

	local opaqueAlpha = 1 - TitleScreen._calculateAlpha(self.opaqueTime, TitleScreen.FADE_IN_DURATION_SECONDS)
	love.graphics.setColor(0, 0, 0, opaqueAlpha)
	love.graphics.rectangle('fill', 0, 0, width, height)

	if self.logo and self.showLogo then
		love.graphics.setColor(1, 1, 1, 1)
		local logoSlide = TitleScreen._calculateAlpha(self.logoTime, TitleScreen.SLIDE_IN_DURATION_SECONDS)

		love.graphics.draw(
			self.logo:getResource(),
			width / 2 + self.logo:getWidth() / 4 * logoSlide,
			height / 4,
			0,
			0.5 + 0.5 * (1 - logoSlide),
			0.5 + 0.5 * (1 - logoSlide),
			self.logo:getWidth() / 2,
			self.logo:getHeight() / 2)
	end
end

return TitleScreen
