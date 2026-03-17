--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Counter.lua
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

local Counter = Class(Sprite)
Counter.DURATION = 1.5
Counter.SLIDE_IN_OUT_DISTANCE = 32
Counter.BACKGROUND_PADDING = 8
Counter.SCALE = 1

function Counter:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@32",
		function(font)
			self.font = font
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Sprites/Counter/Counter.png",
		function(background)
			self.background = background
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/UI/Icons/Concepts/Off.png",
		function(icon)
			self.negateIcon = icon
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/UI/Icons/Concepts/Powers.png",
		function(icon)
			self.riteIcon = icon
		end)

	self.ready = false
end

function Counter:spawn(combatSkill)
	local resources = self:getSpriteManager():getResources()

	resources:queueEvent(function()
		self.ready = true
	end)

	self.text = itsyrealm.language.get("sprite.counter")
end

function Counter:isDone(time)
	return time > Counter.DURATION
end

function Counter:draw(position, time)
	if not self.ready then
		return
	end

	local delta = time / self.DURATION
	local mu = math.clamp(math.sin(delta * math.pi) * 2)

	local textOffsetX
	if delta > 0.5 then
		textOffsetX = self.SLIDE_IN_OUT_DISTANCE * (1 - mu)
	else
		textOffsetX = -self.SLIDE_IN_OUT_DISTANCE * (1 - mu)
	end

	local alpha = mu

	local oldFont = love.graphics.getFont()

	local font = self.font:getResource()
	local negateIcon = self.negateIcon:getResource()
	local riteIcon = self.riteIcon:getResource()
	local background = self.background:getResource()

	negateIcon:setFilter('linear', 'linear')
	riteIcon:setFilter('linear', 'linear')
	background:setFilter('linear', 'linear')

	love.graphics.setFont(font)
	local textWidth = font:getWidth(self.text)

	local iconHalfWidth = negateIcon:getWidth() / 2
	local iconHalfHeight = negateIcon:getHeight() / 2

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		background,
		position.x,
		position.y + iconHalfHeight,
		0,
		Counter.SCALE + 0.75,
		Counter.SCALE + 0.75,
		background:getWidth() / 2,
		background:getHeight() / 2)

	love.graphics.draw(
		riteIcon,
		position.x - iconHalfWidth * 2 - textWidth / 2,
		position.y + iconHalfHeight,
		0,
		Counter.SCALE,
		Counter.SCALE,
		iconHalfWidth,
		iconHalfHeight)

	love.graphics.draw(
		negateIcon,
		position.x - iconHalfWidth * 2 - textWidth / 2,
		position.y + iconHalfHeight,
		0,
		Counter.SCALE,
		Counter.SCALE,
		iconHalfWidth,
		iconHalfHeight)

	do
		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.printf(
			self.text,
			position.x + 1 + textOffsetX,
			position.y + 1,
			font:getWidth(self.text),
			'center',
			0,
			Counter.SCALE,
			Counter.SCALE,
			textWidth / 2,
			0)
	end

	do
		love.graphics.setColor(1, 1, 1, alpha)
		love.graphics.printf(
			self.text,
			position.x + textOffsetX,
			position.y,
			font:getWidth(self.text),
			'center',
			0,
			Counter.SCALE,
			Counter.SCALE,
			textWidth / 2,
			0)
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return Counter
