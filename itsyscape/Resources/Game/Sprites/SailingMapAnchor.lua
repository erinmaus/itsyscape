--------------------------------------------------------------------------------
-- Resources/Game/Sprites/SailingMapAnchor.lua
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
local patchy = require "patchy"

local SailingMapAnchor = Class(Sprite)
SailingMapAnchor.MIN_WIDTH = 200
SailingMapAnchor.SHADOW_OFFSET = 2
SailingMapAnchor.PADDING = 8
SailingMapAnchor.DISTANCE = 64

function SailingMapAnchor:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf@20",
		function(bigFont)
			self.bigFont = bigFont
		end)
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/Serif/Bold.ttf@16",
		function(smallFont)
			self.smallFont = smallFont
		end)
	resources:queueEvent(
		function()
			self.background = patchy.load("Resources/Renderers/Widget/Panel/Parchment.9.png")
		end)
	resources:queueEvent(function()
		self.ready = true
	end)

	self.ready = false
end

function SailingMapAnchor:spawn(prop)
	Sprite.spawn(self)

	self.prop = prop
end

function SailingMapAnchor:isDone(time)
	return false
end

function SailingMapAnchor:draw(position, time)
	if not self.ready then
		return
	end

	local mouseX, mouseY = love.mouse.getPosition()
	local distance = math.sqrt((mouseX - position.x) ^ 2 + (mouseY - position.y) ^ 2)
	if distance > SailingMapAnchor.DISTANCE then
		return
	end

	local state = self.prop:getState()
	local name = state.name or "Unknown location"
	local description = state.description or "This place is mysterious."
	local distance = string.format("Distance: %d km", state.distance or 0)

	local bigFont = self.bigFont:getResource()
	local smallFont = self.smallFont:getResource()

	local bigFontHeight = bigFont:getHeight()
	local nameWidth = math.max(bigFont:getWidth(name), SailingMapAnchor.MIN_WIDTH)
	local smallFontHeight = smallFont:getHeight()
	local descriptionHeight
	do
		local width, text = smallFont:getWrap(description, nameWidth)
		descriptionHeight = smallFontHeight * #text
	end

	local width, height
	do
		height = smallFontHeight + descriptionHeight + bigFontHeight + SailingMapAnchor.PADDING * 2
		width = nameWidth + SailingMapAnchor.PADDING * 2
	end

	self.background:draw(
		position.x - nameWidth / 2 - SailingMapAnchor.PADDING,
		position.y - smallFontHeight - descriptionHeight - bigFontHeight - SailingMapAnchor.PADDING,
		width,
		height)

	love.graphics.setFont(bigFont)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		name,
		position.x - nameWidth / 2 + SailingMapAnchor.SHADOW_OFFSET,
		position.y - smallFontHeight - descriptionHeight - bigFontHeight + SailingMapAnchor.SHADOW_OFFSET,
		nameWidth,
		'center')
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		name,
		position.x - nameWidth / 2,
		position.y - smallFontHeight - descriptionHeight - bigFontHeight,
		nameWidth,
		'center')

	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		description,
		position.x - nameWidth / 2 + SailingMapAnchor.SHADOW_OFFSET,
		position.y - smallFontHeight - descriptionHeight + SailingMapAnchor.SHADOW_OFFSET,
		nameWidth,
		'justify')
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		description,
		position.x - nameWidth / 2,
		position.y - smallFontHeight - descriptionHeight,
		nameWidth,
		'justify')

	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		distance,
		position.x - nameWidth / 2 + SailingMapAnchor.SHADOW_OFFSET,
		position.y - smallFontHeight + SailingMapAnchor.SHADOW_OFFSET,
		nameWidth,
		'left')
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		distance,
		position.x - nameWidth / 2,
		position.y - smallFontHeight,
		nameWidth,
		'left')
end

return SailingMapAnchor
