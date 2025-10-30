--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/StatBar.lua
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
local Drawable = require "ItsyScape.UI.Drawable"

local StatBar = Class(Drawable)

function StatBar:new()
	Drawable.new(self)

	self.currentProgress = 0
	self.maximumProgress = 1
	self.progressColor = Color(1)
	self.remainderColor = Color(0)
	self.namedProgressColor = false
	self.namedRemainderColor = false
	self.dropShadow = 4
	self.borderRadius = 4
end


function StatBar:getOverflow()
	return true
end

function StatBar:setNamedColors(progress, remainder)
	self.namedProgressColor = progress or false
	self.namedRemainderColor = remainder or false
end

function StatBar:getNamedColors()
	return self.namedProgressColor, self.namedRemainderColor
end

function StatBar:setColors(progress, remainder)
	self.progressColor = progress or self.progressColor
	self.remainderColor = remainder or self.remainderColor
end

function StatBar:getColors()
	return self.progressColor, self.remainderColor
end

function StatBar:getProgress()
	return self.currentProgress, self.maximumProgress
end

function StatBar:updateProgress(current, maximum)
	self.currentProgress = current or self.currentProgress
	self.maximumProgress = maximum or self.maximumProgress
end

function StatBar:draw(resources, state)
	Drawable.draw(self, resources, state)

	local progressColor = self.namedProgressColor and Config.get("Config", "COLOR", "color", self.namedProgressColor)
	progressColor = progressColor and Color.fromHexString(progressColor) or self.progressColor

	local remainderColor = self.namedRemainderColor and Config.get("Config", "COLOR", "color", self.namedRemainderColor)
	remainderColor = remainderColor and Color.fromHexString(remainderColor) or self.remainderColor

	local w, h = self:getSize()

	love.graphics.setColor(0, 0, 0, 1)
	itsyrealm.graphics.rectangle("fill", self.dropShadow, self.dropShadow, w, h, self.borderRadius)

	love.graphics.setColor(remainderColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, w, h, self.borderRadius)

	local delta = math.clamp(self.currentProgress / self.maximumProgress)

	love.graphics.setColor(progressColor:get())
	itsyrealm.graphics.rectangle("fill", 0, 0, math.floor(delta * w), h, math.min(self.borderRadius, w * delta / 2))

	love.graphics.setColor(1, 1, 1, 0.5)
	itsyrealm.graphics.rectangle("fill", math.floor(w * delta), 0, self.borderRadius, h, self.borderRadius)

	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.setLineWidth(self.borderRadius)
	itsyrealm.graphics.rectangle("line", 0, 0, w, h, self.borderRadius)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
end

return StatBar
