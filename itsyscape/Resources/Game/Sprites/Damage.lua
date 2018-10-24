--------------------------------------------------------------------------------
-- Resources/Game/Sprites/Damage.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Tween = require "ItsyScape.Common.Math.Tween"
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"
local TextureResource = require "ItsyScape.Graphics.TextureResource"

local Damage = Class(Sprite)
Damage.SPRING_TIME = 0.25
Damage.LIFE = 1

function Damage:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		FontResource,
		"Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24",
		function(font)
			self.font = font
		end)

	self.ready = false
end

function Damage:spawn(damageType, damage)
	self.damage = damage or 0
	self.damageType = damageType or 'none'

	local resources = self:getSpriteManager():getResources()
	resources:queue(
		TextureResource,
		string.format("Resources/Game/Sprites/Damage/%s.png", self.damageType),
		function(texture)
			self.texture = texture:getResource()
		end)
	resources:queueEvent(function()
		self.ready = true
	end)
end

function Damage:isDone(time)
	return time > Damage.LIFE
end

function Damage:draw(position, time)
	if not self.ready then
		return
	end

	local delta = math.min(time, Damage.SPRING_TIME) / Damage.SPRING_TIME
	local mu = math.min(time - Damage.SPRING_TIME) / (Damage.LIFE - Damage.SPRING_TIME)

	local font = self.font:getResource()

	love.graphics.setFont(font)
	local text = tostring(self.damage)
	local width = font:getWidth(text)
	local height = font:getHeight()

	local y = math.sin(mu * math.pi * 4) * 8

	if self.texture then
		local w, h = self.texture:getWidth(), self.texture:getHeight()

		local scale = Tween.powerEaseInOut(delta, 2)
		local rotation = math.pi + Tween.sineEaseInOut(delta) * math.pi * 2
		love.graphics.draw(
			self.texture,
			position.x, position.y + y, rotation, scale, scale, w / 2, h / 2)
	end

	do
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(
			text,
			position.x + 2 - width / 2,
			position.y + 2 - height / 2 + y,
			font:getWidth(text),
			'center')
	end

	do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(
			text,
			position.x - width / 2,
			position.y - height / 2 + y,
			font:getWidth(text),
			'center')
	end
end

return Damage
