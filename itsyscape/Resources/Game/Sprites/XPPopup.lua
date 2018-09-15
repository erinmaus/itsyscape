--------------------------------------------------------------------------------
-- Resources/Game/Sprites/XPPopup.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local XPPopup = Class(Sprite)
XPPopup.FLOAT_HEIGHT = 32
XPPopup.DURATION = 1.0

function XPPopup:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	self.font = resources:load(FontResource, "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24")
end

function XPPopup:spawn(skill, xp)
	local resources = self:getSpriteManager():getResources()
	local filename = string.format("Resources/Game/UI/Icons/Skills/%s.png", skill)
	self.skillIcon = resources:load(TextureResource, filename)
	self.xp = xp
end

function XPPopup:isDone(time)
	return time > XPPopup.DURATION
end

function XPPopup:draw(position, time)
	local oldFont = love.graphics.getFont()

	local font = self.font:getResource()
	local icon = self.skillIcon:getResource()

	love.graphics.setFont(font)
	local text = "+" .. tostring(self.xp)
	local width = font:getWidth(text)

	local alpha = 1 - (math.max(time - 0.5, 0) / XPPopup.DURATION)
	local offset = -(time / XPPopup.DURATION) * XPPopup.FLOAT_HEIGHT

	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		icon,
		position.x - icon:getWidth() / 2 - width / 2,
		position.y + offset + icon:getHeight() / 2,
		0,
		0.5,
		0.5,
		icon:getWidth() / 2,
		icon:getHeight() / 2)

	do
		love.graphics.setColor(0, 0, 0, alpha)
		love.graphics.printf(
			text,
			position.x + 1 - width / 2,
			position.y + 1 + offset,
			font:getWidth(text),
			'center')
	end

	do
		love.graphics.setColor(1, 1, 1, alpha)
		love.graphics.printf(
			text,
			position.x - width / 2,
			position.y + offset,
			font:getWidth(text),
			'center')
	end

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return XPPopup
