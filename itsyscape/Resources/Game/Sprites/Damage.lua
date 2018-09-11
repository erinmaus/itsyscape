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
local Sprite = require "ItsyScape.Graphics.Sprite"
local FontResource = require "ItsyScape.Graphics.FontResource"

local Damage = Class(Sprite)

function Damage:new(...)
	Sprite.new(self, ...)

	local resources = self:getSpriteManager():getResources()
	self.font = resources:load(FontResource, "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf@24")
end

function Damage:spawn(damageType, damage)
	self.damage = damage or 0
	self.damageType = damageType or 'none'
end

function Damage:isDone(time)
	return time > 1
end

function Damage:draw(position)
	local font = self.font:getResource()

	love.graphics.setFont(font)
	local text = tostring(self.damage)
	local width = font:getWidth(text)

	if self.damageType == 'heal' then
		love.graphics.setColor(0, 0, 1, 0.5)
	else
		love.graphics.setColor(1, 0, 0, 0.5)
	end
	love.graphics.rectangle(
		'fill',
		position.x - (width * 1.5) / 2,
		position.y,
		width * 1.5,
		font:getHeight())

	do
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.printf(
			text,
			position.x + 1 - width / 2,
			position.y + 1,
			font:getWidth(text),
			'center')
	end

	do
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.printf(
			text,
			position.x - width / 2,
			position.y,
			font:getWidth(text),
			'center')
	end
end

return Damage
