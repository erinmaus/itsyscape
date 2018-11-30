--------------------------------------------------------------------------------
-- ItsyScape/MemeApplication.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Application = require "ItsyScape.Application"
local Class = require "ItsyScape.Common.Class"

local MemeApplication = Class(Application)

function MemeApplication:new()
	love.window.setMode(512, 512)

	Application.new(self)

	self.background = love.graphics.newImage("Resources/Promo/Meme1/Background1.png")
	self.center = love.graphics.newImage("Resources/Promo/Meme1/Head.png")
	self.text = love.graphics.newImage("Resources/Promo/Meme1/Text.png")

	self.elapsedTime = 0
end

function MemeApplication:update(delta)
	Application.update(self, delta)

	self.elapsedTime = self.elapsedTime + delta
end

function MemeApplication:draw()
	love.graphics.clear(1 / 255, 101 / 255, 49 / 255, 1)

	do
		local rotation = math.pi / 2 * self.elapsedTime
		love.graphics.draw(self.background, 256, 256, rotation, 0.5, 0.5, self.background:getWidth() / 2, self.background:getHeight() / 2)
	end

	do
		local rotation = math.sin(self.elapsedTime * (math.pi)) * math.pi / 4
		local offsetY = math.cos(self.elapsedTime * (math.pi)) * 16
		love.graphics.draw(self.center, 256, 256 + offsetY, rotation, 0.5, 0.5, 512, 512 + 64)
	end

	love.graphics.draw(self.text, 0, 0, 0, 0.5, 0.5)
end

return MemeApplication
