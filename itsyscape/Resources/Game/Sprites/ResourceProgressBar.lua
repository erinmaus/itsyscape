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
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"

local ResourceProgressBar = Class(Sprite)
ResourceProgressBar.WIDTH = 50
ResourceProgressBar.HEIGHT = 10

function ResourceProgressBar:new(...)
	Sprite.new(self, ...)
end

function ResourceProgressBar:spawn(prop)
	Sprite.spawn(self)

	self.prop = prop
end

function ResourceProgressBar:isDone(time)
	local state = self.prop:getState()

	if state.resource and (state.resource.depleted or state.resource.ready) then
		return true
	end

	return false
end

function ResourceProgressBar:draw(position, time)
	local x = position.x - ResourceProgressBar.WIDTH / 2
	local y = position.y - ResourceProgressBar.HEIGHT

	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.rectangle('fill', x + 1, y + 1, ResourceProgressBar.WIDTH, ResourceProgressBar.HEIGHT)

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle('fill', x, y, ResourceProgressBar.WIDTH, ResourceProgressBar.HEIGHT)

	local state = self.prop:getState()
	if state.resource then
		local percent = state.resource.progress / 100
		local w = ResourceProgressBar.WIDTH * percent
		if percent > 0 then
			w = math.min(math.max(w, 1), ResourceProgressBar.WIDTH - 1)
		end

		love.graphics.setColor(0, 0, 1, 1)
		love.graphics.rectangle(
			'fill',
			x,
			y,
			w,
			ResourceProgressBar.HEIGHT)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return ResourceProgressBar
