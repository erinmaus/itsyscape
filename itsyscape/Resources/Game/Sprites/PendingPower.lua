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
PendingPower.HEIGHT = 24
PendingPower.OFFSET = 26

function PendingPower:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24",
		function(font)
			self.font = font
		end)
	resources:queue(
		TextureResource,
		"Resources/Game/UI/Icons/Concepts/Warning.png",
		function(icon)
			self.warningIcon = icon
		end)

	self.pendingTurns = false
	self.currentTurn = false
	self.interval = false
	self.previousTime = false
	self.currentTime = false
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
	self.pendingTurns = false
	self.currentTurn = false
	self.interval = false
	self.previousTime = false
	self.currentTime = false

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
	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.zeal.tier1Fire"), alpha)

	local x = position.x - self.WIDTH / 2
	local y = position.y - self.HEIGHT - self.OFFSET

	local frameDelta = _APP:getFrameDelta()
	local time = math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, frameDelta)
	time = time + ((self.currentTurn or 1) - 1) * (self.interval or 1)
	local duration = (self.interval or 1) * (self.pendingTurns or 1)
	local delta = math.clamp(time / math.max(duration - 0.2, 0.2))

	love.graphics.setColor(barColor:get())
	love.graphics.rectangle("fill", x, y, self.WIDTH, self.HEIGHT, 4)

	love.graphics.setColor(progressColor:get())
	love.graphics.rectangle("fill", x, y, math.floor(self.WIDTH * delta), self.HEIGHT, math.min(4, self.WIDTH * delta / 2))

	local iconAlpha = math.abs(math.sin(love.timer.getTime() * math.pi)) * 0.5 + 0.5
	local textColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.warning"), alpha * iconAlpha)

	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font:getResource())

	local textX, textY = x, y - self.HEIGHT - math.max(self.font:getResource():getHeight() - self.HEIGHT, 0)

	love.graphics.setColor(0, 0, 0, iconAlpha * alpha)
	love.graphics.printf("SPECIAL", textX - 2, textY - 2, self.WIDTH, "center")
	love.graphics.printf("SPECIAL", textX + 2, textY - 2, self.WIDTH, "center")
	love.graphics.printf("SPECIAL", textX + 2, textY + 2, self.WIDTH, "center")
	love.graphics.printf("SPECIAL", textX - 2, textY + 2, self.WIDTH, "center")

	love.graphics.setColor(textColor:get())
	love.graphics.printf("SPECIAL", textX, textY, self.WIDTH, "center")

	local icon = self.warningIcon:getResource()
	love.graphics.setColor(1, 1, 1, iconAlpha * alpha)
	love.graphics.draw(icon, x - icon:getWidth() - 8, textY + 2)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(oldFont)
end

return PendingPower
