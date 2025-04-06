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
PendingPower.STACKS = false

function PendingPower:new(...)
	Sprite.new(self, ...)

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
	self.fadeInTime = math.min(self.fadeInTime + delta, self.FADE_DURATION)

	if self.done then
		self.fadeOutTime = math.min(self.fadeOutTime + delta, self.FADE_DURATION)
	end
end

function PendingPower:draw(position, time)
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

	local textDelta = math.abs(math.sin(love.timer.getTime() * math.pi))
	local textColorFrom = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.specialWarningFrom"), alpha)
	local textColorTo = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.specialWarningTo"), alpha)
	local textColor = textColorFrom:lerp(textColorTo, textDelta)

	love.graphics.setColor(textColor:get())
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, self.WIDTH, self.HEIGHT, 2)
	love.graphics.setLineWidth(1)

	love.graphics.setColor(1, 1, 1, 1)
end

return PendingPower
