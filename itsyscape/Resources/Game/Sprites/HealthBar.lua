--------------------------------------------------------------------------------
-- Resources/Game/Sprites/HealthBar.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"

local HealthBar = Class(Sprite)
HealthBar.WIDTH = 120
HealthBar.HEIGHT          = 8
HealthBar.PROGRESS_HEIGHT = 8
HealthBar.DROP_SHADOW     = 4

HealthBar.STACKS = false

function HealthBar:new(...)
	Sprite.new(self, ...)
end

function HealthBar:spawn(actor)
	Sprite.spawn(self)

	self.actor = actor
end

function HealthBar:isDone(time)
	return time > 6 or not self:getSpriteManager():getGameView():getView(self.actor)
end

function HealthBar:draw(position, time)
	local alpha = 1 - math.clamp(math.max((time - 5.5) / 0.5))

	local x = position.x - self.WIDTH / 2
	local y = position.y - self.HEIGHT

	local damageColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.damage"), alpha)
	local hitpointsColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.hitpoints"), alpha)

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle(
		"fill",
		x + self.DROP_SHADOW, y + self.DROP_SHADOW,
		self.WIDTH,
		self.HEIGHT, 2)

	love.graphics.setColor(hitpointsColor:get())
	love.graphics.rectangle("fill", x, y, self.WIDTH, self.HEIGHT, 2)

	if self.actor:getCurrentHitpoints() < self.actor:getMaximumHitpoints() then
		local percent = self.actor:getCurrentHitpoints() / self.actor:getMaximumHitpoints()
		local w = math.min(self.WIDTH * (1 - percent), math.floor(self.WIDTH * 0.95))
		if self.actor:getCurrentHitpoints() > 0 then
			w = math.min(math.max(w, math.floor(self.WIDTH * 0.1)), math.floor(self.WIDTH * 0.95))
		end

		love.graphics.setColor(damageColor:get())
		love.graphics.rectangle(
			"fill",
			x + self.WIDTH - w,
			y - (self.PROGRESS_HEIGHT - self.HEIGHT),
			w,
			self.PROGRESS_HEIGHT,
			math.min(2, w / 2))

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle(
			"fill",
			x + self.WIDTH - w - 2,
			y - (self.PROGRESS_HEIGHT - self.HEIGHT),
			2,
			self.PROGRESS_HEIGHT)
	end

	love.graphics.setColor(0, 0, 0, alpha * 0.5)
	love.graphics.setLineWidth(2)
	love.graphics.rectangle("line", x, y, self.WIDTH, self.HEIGHT, 2)
	love.graphics.setLineWidth(1)

	love.graphics.setColor(1, 1, 1, 1)
end

return HealthBar
