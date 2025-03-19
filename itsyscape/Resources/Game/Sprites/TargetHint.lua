--------------------------------------------------------------------------------
-- Resources/Game/Sprites/TargetHint.lua
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

local TargetHint = Class(Sprite)
TargetHint.MIN_WIDTH = 200
TargetHint.SHADOW_OFFSET = 1
TargetHint.PADDING = 8
TargetHint.DISTANCE = 64

function TargetHint:new(...)
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
			self.background = patchy.load("Resources/Game/UI/Panels/ToolTip.png")
		end)
	resources:queueEvent(function()
		self.ready = true
	end)

	self.ready = false
end

function TargetHint:spawn(prop)
	Sprite.spawn(self)

	self.prop = prop
end

function TargetHint:isDone(time)
	return false
end

function TargetHint:draw(position, time)
	if not self.ready then
		return
	end

	local state = self.prop:getState()
	local name = state.name or "???"
	local description = state.description or "What am I supposed to do...?"

	local bigFont = self.bigFont:getResource()
	local smallFont = self.smallFont:getResource()

	local bigFontHeight = bigFont:getHeight()
	local nameWidth = math.max(bigFont:getWidth(name), TargetHint.MIN_WIDTH)
	local smallFontHeight = smallFont:getHeight()
	local descriptionHeight
	do
		local width, text = smallFont:getWrap(description, nameWidth)
		descriptionHeight = smallFontHeight * #text
	end

	local width, height
	do
		height = descriptionHeight + bigFontHeight + TargetHint.PADDING * 2
		width = nameWidth + TargetHint.PADDING * 2
	end

	self.background:draw(
		position.x - nameWidth / 2 - TargetHint.PADDING,
		position.y - smallFontHeight - descriptionHeight - bigFontHeight - TargetHint.PADDING,
		width,
		height,
		nil,
		love.graphics.draw)

	love.graphics.setFont(bigFont)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.printf(
		name,
		position.x - nameWidth / 2 + TargetHint.SHADOW_OFFSET,
		position.y - smallFontHeight - descriptionHeight - bigFontHeight + TargetHint.SHADOW_OFFSET,
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
		position.x - nameWidth / 2 + TargetHint.SHADOW_OFFSET,
		position.y - smallFontHeight - descriptionHeight + TargetHint.SHADOW_OFFSET,
		nameWidth,
		'justify')
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf(
		description,
		position.x - nameWidth / 2,
		position.y - smallFontHeight - descriptionHeight,
		nameWidth,
		'justify')
end

return TargetHint
