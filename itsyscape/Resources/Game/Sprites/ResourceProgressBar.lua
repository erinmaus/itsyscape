--------------------------------------------------------------------------------
-- Resources/Game/Sprites/ResourceProgressBar.lua
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

local ResourceProgressBar = Class(Sprite)
ResourceProgressBar.WIDTH           = 120
ResourceProgressBar.HEIGHT          = 8
ResourceProgressBar.PROGRESS_HEIGHT = 8
ResourceProgressBar.DROP_SHADOW     = 4

ResourceProgressBar.STACKS = false

function ResourceProgressBar:new(...)
	Sprite.new(self, ...)
end

function ResourceProgressBar:spawn(prop)
	Sprite.spawn(self)

	self.prop = prop
end

function ResourceProgressBar:getIsDepleted()
	local state = self.prop:getState()

	if state.resource and (state.resource.depleted or state.resource.ready) then
		return true
	end
end

function ResourceProgressBar:isDone(time)
	return time > 1.5
end

function ResourceProgressBar:update(delta)
	Sprite.update(self, delta)

	if not self:getIsDepleted() then
		self:getSpriteManager():reset(self)
	end
end

function ResourceProgressBar:draw(position, time)
	local alpha = 1 - math.clamp(math.max((time - 1) / 0.5))

	local x = position.x - self.WIDTH / 2
	local y = position.y - self.HEIGHT

	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.progress"), alpha)
	local remainderColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.remainder"), alpha)

	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle(
		"fill",
		x + self.DROP_SHADOW, y + self.DROP_SHADOW,
		self.WIDTH,
		self.HEIGHT, 2)

	love.graphics.setColor(remainderColor:get())
	love.graphics.rectangle("fill", x, y, self.WIDTH, self.HEIGHT, 2)

	local state = self.prop:getState()
	if state.resource and state.resource.progress then
		local percent = state.resource.progress / 100
		local w = math.min(self.WIDTH * (1 - percent), math.floor(self.WIDTH * 0.95))
		if percent > 0 and percent < 1 then
			w = math.min(math.max(w, math.floor(self.WIDTH * 0.1)), math.floor(self.WIDTH * 0.95))
		end

		love.graphics.setColor(progressColor:get())
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

return ResourceProgressBar
