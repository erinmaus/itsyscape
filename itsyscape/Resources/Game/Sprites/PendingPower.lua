--------------------------------------------------------------------------------
-- Resources/Game/Sprites/PendingPower.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local PendingPower = Class(Sprite)
PendingPower.FADE_DURATION = 0.2
PendingPower.WIDTH = 120
PendingPower.HEIGHT = 8
PendingPower.OFFSET = 14
PendingPower.DROP_SHADOW = 4

function PendingPower:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@22",
		function(font)
			self.font = font
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/UI/Icons/Concepts/Powers.png",
		function(icon)
			self.warningIcon = icon
		end)

	self.pendingTurns = false
	self.currentTurn = false
	self.interval = false
	self.previousTime = false
	self.currentTime = false
	self.maxDelta = false
	self.done = false
	self.fadeInTime = 0
	self.fadeOutTime = 0

	self.ready = false
end

function PendingPower:isDone(time)
	return self.done and self.fadeOutTime >= self.FADE_DURATION
end

function PendingPower:updateDuration(turns, time, interval)
	self.pendingTurns = self.pendingTurns or turns

	local currentTurn = (self.pendingTurns - turns) + 1 
	if currentTurn ~= self.currentTurn then
		self.currentTurn = currentTurn
		self.previousTime = false
	else
		self.previousTime = self.currentTime
	end

	self.interval = interval
	self.currentTime = time
end

function PendingPower:reset()
	self.previousDelta = false
	self.pendingTurns = false
	self.currentTurn = false
	self.interval = false
	self.previousTime = false
	self.currentTime = false
	self.maxDelta = false

	if self.done then
		self.fadeInTime = self.FADE_DURATION - self.fadeOutTime
	end

	self.done = false
	self.fadeOutTime = 0
end

function PendingPower:finish()
	self.done = true
end

function PendingPower:update(delta)
	if self.warningIcon and self.font then
		self.fadeInTime = math.min(self.fadeInTime + delta, self.FADE_DURATION)
	end

	if self.done then
		self.fadeOutTime = math.min(self.fadeOutTime + delta, self.FADE_DURATION)
	end
end

function PendingPower:draw(position, time)
	if not self.warningIcon or not self.font then
		return
	end

	local alpha
	if self.done then
		alpha = 1 - math.clamp(self.fadeOutTime / self.FADE_DURATION)
	else
		alpha = math.clamp(self.fadeInTime / self.FADE_DURATION)
	end

	local barColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.remainder"), alpha)
	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier2Fire"), alpha)

	local x = position.x - self.WIDTH / 2
	local y = position.y - self.HEIGHT - self.OFFSET

	local frameDelta = _APP:getFrameDelta()
	local duration = (self.interval or 1) * ((self.pendingTurns or 1) + 1)
	local time = math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, frameDelta)
	time = time + (self.currentTurn or 1) * (self.interval or 1)
	local delta = math.clamp(time / math.max(duration - 0.2, 0.2))
	delta = math.max(delta, self.maxDelta or delta)
	self.maxDelta = delta

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle(
		"fill",
		x + self.DROP_SHADOW, y + self.DROP_SHADOW,
		self.WIDTH,
		self.HEIGHT, 2)

	love.graphics.setColor(barColor:get())
	love.graphics.rectangle("fill", x, y, self.WIDTH, self.HEIGHT, 2)

	love.graphics.setColor(progressColor:get())
	love.graphics.rectangle("fill", x, y, math.floor(self.WIDTH * delta), self.HEIGHT, math.min(2, self.WIDTH * delta / 2))

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle(
		"fill",
		x + math.floor(self.WIDTH * delta) - 1,
		y,
		2,
		self.HEIGHT)

	local iconDelta = math.abs(math.sin(love.timer.getTime() * math.pi))
	local iconAlpha = iconDelta * 0.5 + 0.5
	local textColorFrom = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.specialWarningFrom"), alpha)
	local textColorTo = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.specialWarningTo"), alpha)
	local textColor = textColorFrom:lerp(textColorTo, iconDelta)

	love.graphics.setColor(textColor:get())
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, self.WIDTH, self.HEIGHT, 2)
	love.graphics.setLineWidth(1)

	-- local oldFont = love.graphics.getFont()
	-- local font = self.font:getResource()
	-- love.graphics.setFont(font)

	-- local icon = self.warningIcon:getResource()
	-- local iconWidth = icon:getWidth() * 0.75
	-- local iconHeight = icon:getWidth() * 0.75
	-- local textWidth = self.WIDTH - iconWidth - 2
	-- local textX, textY = x + iconWidth + 2, y - self.HEIGHT - math.max(math.max(iconHeight, self.font:getResource():getHeight()) - self.HEIGHT, 0)

	-- love.graphics.setColor(0, 0, 0, alpha)
	-- love.graphics.printf("SPECIAL", textX - 2, textY - 2, textWidth, "center")
	-- love.graphics.printf("SPECIAL", textX + 2, textY - 2, textWidth, "center")
	-- love.graphics.printf("SPECIAL", textX + 2, textY + 2, textWidth, "center")
	-- love.graphics.printf("SPECIAL", textX - 2, textY + 2, textWidth, "center")

	-- love.graphics.setColor(textColor:get())
	-- love.graphics.printf("SPECIAL", textX, textY, textWidth, "center")

	-- love.graphics.setColor(1, 1, 1, iconAlpha * alpha)
	-- love.graphics.draw(icon, x, textY, 0, 0.75, 0.75)

	love.graphics.setColor(1, 1, 1, 1)
	--love.graphics.setFont(oldFont)
end

return PendingPower
