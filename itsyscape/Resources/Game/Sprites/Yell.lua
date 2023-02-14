--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Yell.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"

local Yell = Class(Sprite)
Yell.DURATION = 1.0

function Yell:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@48",
		function(font)
			self.font = font
		end)

	self.ready = false
end

function Yell:spawn(message, color, duration)
	self.message = message
	self.color = color or Color(1, 1, 0, 1)
	self.duration = duration or Yell.DURATION

	local resources = self:getSpriteManager():getResources()
	resources:queueEvent(function()
		self.ready = true
	end)
end

function Yell:isDone(time)
	return time > self.duration
end

function Yell:draw(position, time)
	if not self.ready then
		return false
	end

	local oldFont = love.graphics.getFont()
	local font = self.font:getResource()

	love.graphics.setFont(font)
	local width = font:getWidth(self.message)

	do
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(
			self.message,
			position.x + 2 - width / 2,
			position.y + 2,
			width,
			'center')
	end

	do
		love.graphics.setColor(self.color.r, self.color.g, self.color.b, 1)
		love.graphics.printf(
			self.message,
			position.x - width / 2,
			position.y,
			width,
			'center')
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return Yell
