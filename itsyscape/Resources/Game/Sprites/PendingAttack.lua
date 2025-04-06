--------------------------------------------------------------------------------
-- Resources/Game/Sprites/PendingAttack.lua
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

local PendingAttack = Class(Sprite)
PendingAttack.FADE_DURATION = 0.2
PendingAttack.WIDTH = 120
PendingAttack.HEIGHT = 8
PendingAttack.DROP_SHADOW = 4
PendingAttack.STACKS = false

function PendingAttack:new(...)
	Sprite.new(self, ...)

	self.previousTime = false
	self.currentTime = false
	self.previousDuration = false
	self.currentDuration = false
	self.done = false
	self.fadeInTime = 0
	self.fadeOutTime = 0

	self.ready = false
end

function PendingAttack:isDone(time)
	return self.done and self.fadeOutTime >= self.FADE_DURATION
end

function PendingAttack:updateDuration(time, duration)
	if self.currentTime and time > self.currentTime then
		self:reset()
	end

	self.previousTime = self.currentTime
	self.previousDuration = self.currentDuration
	self.currentTime = time
	self.currentDuration = duration
end

function PendingAttack:reset()
	self.previousTime = false
	self.currentTime = false
	self.previousDuration = false
	self.currentDuration = false
end

function PendingAttack:finish()
	self.done = true
end

function PendingAttack:update(delta)
	self.fadeInTime = math.min(self.fadeInTime + delta, self.FADE_DURATION)

	if self.done then
		self.fadeOutTime = math.min(self.fadeOutTime + delta, self.FADE_DURATION)
	end
end

function PendingAttack:draw(position, time)
	local alpha
	if self.done then
		alpha = 1 - math.clamp(self.fadeOutTime / self.FADE_DURATION)
	else
		alpha = math.clamp(self.fadeInTime / self.FADE_DURATION)
	end

	local barColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.pendingAttackDuration"), alpha)
	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.pendingAttackTime"), alpha)

	local x = position.x - self.WIDTH / 2
	local y = position.y + 6

	local frameDelta = _APP:getFrameDelta()
	local time = math.lerp(self.previousTime or self.currentTime or 0, self.currentTime or 0, frameDelta)
	local duration = math.lerp(self.previousDuration or self.currentDuration or 1, self.currentDuration or 1, frameDelta)
	local delta = math.clamp(time / math.max(duration - 0.2, 0.2))

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

	love.graphics.setColor(0, 0, 0, alpha * 0.5)

	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, self.WIDTH, self.HEIGHT, 2)

	love.graphics.setLineWidth(1)
	love.graphics.setColor(1, 1, 1, 1)
end

return PendingAttack
