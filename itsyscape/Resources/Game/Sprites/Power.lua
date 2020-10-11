--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Power.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Power = Class(Sprite)
Power.FLOAT_HEIGHT = 32
Power.DURATION = 1.5

Power.SCALE_BOUNCE_MULTIPLIER = 1.25
Power.MIN_SCALE = 1
Power.MAX_OFFSET = 3
Power.RANDOM_INTERVAL = 1 / 25
Power.SCALE = 1.5

function Power:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24",
		function(font)
			self.font = font
		end)

	self.ready = false
end

function Power:spawn(power, powerName)
	local resources = self:getSpriteManager():getResources()
	local filename = string.format("Resources/Game/Powers/%s/Icon.png", power)

	resources:queue(
		TextureResource,
		filename,
		function(icon)
			self.icon = icon
		end)
	resources:queueEvent(function()
		self.ready = true
	end)

	-- We want the localized name, not the internal ID.
	self.power = powerName
end

function Power:isDone(time)
	return time > Power.DURATION
end

function Power:draw(position, time)
	if not self.ready then
		return
	end

	local randomDifference = time - (self.randomTime or 0)
	if randomDifference > Power.RANDOM_INTERVAL or not self.randomTime then
		self.textOffsetX = (math.random() * 2) - 1
		--self.textOffsetX = 0
		self.textOffsetX = self.textOffsetX * Power.MAX_OFFSET
		--self.textOffsetX = 0
		self.textOffsetY = (math.random() * 2) - 1
		--self.textOffsetY = 0
		self.textOffsetY = self.textOffsetY * Power.MAX_OFFSET
		--self.textOffsetY = 0

		self.iconOffsetX = (math.random() * 2) - 1
		--self.iconOffsetX = 0
		self.iconOffsetX = self.iconOffsetX * Power.MAX_OFFSET
		--self.iconOffsetX = 0
		self.iconOffsetY = (math.random() * 2) - 1
		--self.iconOffsetY = 0
		self.iconOffsetY = self.iconOffsetY * Power.MAX_OFFSET
		--self.iconOffsetY = 0

		self.randomTime = time
	end

	local alphaDelta = 1 - (math.max(time - 0.5, 0) / (Power.DURATION - 0.5))
	local alpha = Tween.sineEaseOut(alphaDelta)

	local oldFont = love.graphics.getFont()

	local font = self.font:getResource()
	local icon = self.icon:getResource()
	icon:setFilter('linear', 'linear')

	love.graphics.setFont(font)
	local text = string.format("%s!", self.power:upper())
	local textWidth = font:getWidth(text)

	local iconHalfWidth = icon:getWidth() / 2
	local iconHalfHeight = icon:getHeight() / 2

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		icon,
		position.x - iconHalfWidth - textWidth / 2 + self.iconOffsetX,
		position.y + iconHalfHeight + self.iconOffsetY,
		0,
		Power.SCALE,
		Power.SCALE,
		iconHalfWidth,
		iconHalfHeight)

	do
		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.printf(
			text,
			position.x + 1 + self.textOffsetX,
			position.y + 1 + self.textOffsetY,
			font:getWidth(text),
			'center',
			0,
			Power.SCALE,
			Power.SCALE,
			textWidth / 2,
			0)
	end

	do
		love.graphics.setColor(1, 1, 1, alpha)
		love.graphics.printf(
			text,
			position.x + self.textOffsetX,
			position.y + self.textOffsetY,
			font:getWidth(text),
			'center',
			0,
			Power.SCALE,
			Power.SCALE,
			textWidth / 2,
			0)
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return Power
