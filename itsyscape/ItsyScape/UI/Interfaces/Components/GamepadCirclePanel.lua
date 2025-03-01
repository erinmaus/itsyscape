--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/GamepadCirclePanel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Utility = require "ItsyScape.Game.Utility"
local Drawable = require "ItsyScape.UI.Drawable"

local GamepadCirclePanel = Class(Drawable)
function GamepadCirclePanel:new()
	Drawable.new(self)

	self.isEnabled = false

	self.outlineColor = Color.fromHexString("ffcc00", 0.75)
	self.innerOutlineThickness = 8
	self.outerOutlineThickness = 4

	self.radiusFudge = 4
	self.radiusSpeed = math.pi / 4

	self.fillColor = Color(0, 0, 0, 0.5)
end

function GamepadCirclePanel:enable()
	self.isEnabled = true
end

function GamepadCirclePanel:disable()
	self.isEnabled = false
end

function GamepadCirclePanel:getIsEnabled()
	return self.isEnabled
end

function GamepadCirclePanel:setOutlineColor(value)
	self.outlineColor = value
end

function GamepadCirclePanel:getOutlineColor()
	return self.outlineColor
end

function GamepadCirclePanel:setFillColor(value)
	self.fillColor = value
end

function GamepadCirclePanel:getFillColor()
	return self.fillColor
end

function GamepadCirclePanel:setOutlineThickness(innerValue, outerValue)
	self.innerOutlineThickness = innerValue or self.innerOutlineThickness
	self.outerOutlineThickness = outerValue or self.outerOutlineThickness
end

function GamepadCirclePanel:getOutlineThickness()
	return self.innerOutlineThickness, self.outerOutlineThickness
end

function GamepadCirclePanel:setRadius(fudgeValue, speedValue)
	self.radiusFudge = fudgeValue or self.radiusFudge
	self.radiusSpeed = speedValue or self.radiusSpeed
end

function GamepadCirclePanel:getRadius()
	return self.radiusFudge, self.radiusSpeed
end

function GamepadCirclePanel:draw(...)
	Drawable.draw(self, ...)

	local x, y = self:getPosition()
	local target = self:getParent() or self

	local w, h = target:getSize()
	x = x + w / 2
	y = y + h / 2

	local radius = math.min(w, h) / 2

	love.graphics.push("all")

	love.graphics.setColor(self.fillColor:get())
	itsyrealm.graphics.circle("fill", x, y, radius)

	if self:_isEnabled() then
		love.graphics.setColor(self.outlineColor:get())

		love.graphics.setLineWidth(self.outerOutlineThickness)
		itsyrealm.graphics.circle("line", x, y, radius)

		local fudge = math.sin(love.timer.getTime() * self.radiusSpeed) * self.radiusFudge
		love.graphics.setLineWidth(self.innerOutlineThickness)
		itsyrealm.graphics.circle("line", x, y, radius + fudge)
	end

	love.graphics.pop()
end

return GamepadCirclePanel
