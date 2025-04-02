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
HealthBar.GOAL_HEIGHT     = 24
HealthBar.PROGRESS_HEIGHT = 28

function HealthBar:new(...)
	Sprite.new(self, ...)
end

function HealthBar:spawn(actor)
	Sprite.spawn(self)

	self.actor = actor
end

function HealthBar:isDone(time)
	return time > 6
end

function HealthBar:draw(position, time)
	local x = position.x - HealthBar.WIDTH / 2
	local y = position.y - HealthBar.GOAL_HEIGHT

	local alpha = 1 - math.max((time - 5.5) / 0.5)
	local damageColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.damage"), alpha)
	local hitpointsColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.combat.health.hitpoints"), alpha)

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle('fill', x + 1, y + 1, HealthBar.WIDTH, HealthBar.GOAL_HEIGHT)

	love.graphics.setColor(hitpointsColor:get())
	love.graphics.rectangle('fill', x, y, HealthBar.WIDTH, HealthBar.GOAL_HEIGHT, 4)

	if self.actor:getCurrentHitpoints() < self.actor:getMaximumHitpoints() then
		local percent = self.actor:getCurrentHitpoints() / self.actor:getMaximumHitpoints()
		local w = HealthBar.WIDTH * (1 - percent)
		if self.actor:getCurrentHitpoints() > 0 then
			w = math.min(math.max(w, 1), HealthBar.WIDTH - 1)
		end

		love.graphics.setColor(damageColor:get())
		love.graphics.rectangle(
			'fill',
			x + HealthBar.WIDTH - w,
			y - (HealthBar.PROGRESS_HEIGHT - HealthBar.GOAL_HEIGHT),
			w,
			HealthBar.PROGRESS_HEIGHT,
			4)

		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle(
			'fill',
			x + HealthBar.WIDTH - w - 2,
			y - (HealthBar.PROGRESS_HEIGHT - HealthBar.GOAL_HEIGHT),
			2,
			HealthBar.PROGRESS_HEIGHT)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return HealthBar
