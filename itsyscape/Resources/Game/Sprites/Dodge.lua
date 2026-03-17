--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Dodge.lua
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

local Dodge = Class(Sprite)
Dodge.DURATION = 1.5
Dodge.SLIDE_IN_OUT_DISTANCE = 32
Dodge.BACKGROUND_PADDING = 8
Dodge.SCALE = 1

function Dodge:new(...)
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
		"Resources/Game/UI/Icons/Skills/Defense.png",
		function(icon)
			self.icon = icon
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/Sprites/Dodge/Dodge.png",
		function(background)
			self.background = background
		end)

	self.ready = false
end

function Dodge:spawn()
	local resources = self:getSpriteManager():getResources()

	resources:queueEvent(function()
		self.ready = true
	end)

	self.text = itsyrealm.language.get("sprite.dodge")
end

function Dodge:isDone(time)
	return time > Dodge.DURATION
end

function Dodge:draw(position, time)
	if not self.ready or not self.icon then
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
	local icon = self.icon:getResource()
	local background = self.background:getResource()
	icon:setFilter('linear', 'linear')
	background:setFilter('linear', 'linear')

	love.graphics.setFont(font)
	local textWidth = font:getWidth(self.text)

	local iconHalfWidth = icon:getWidth() / 2
	local iconHalfHeight = icon:getHeight() / 2

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		background,
		position.x,
		position.y + iconHalfHeight,
		0,
		Dodge.SCALE + 0.75,
		Dodge.SCALE + 0.75,
		background:getWidth() / 2,
		background:getHeight() / 2)

	love.graphics.draw(
		icon,
		position.x - iconHalfWidth * 2 - textWidth / 2,
		position.y + iconHalfHeight,
		0,
		Dodge.SCALE,
		Dodge.SCALE,
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
			Dodge.SCALE,
			Dodge.SCALE,
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
			Dodge.SCALE,
			Dodge.SCALE,
			textWidth / 2,
			0)
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return Dodge
