--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/GamepadCircleCursor.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Drawable = require "ItsyScape.UI.Drawable"

local GamepadCircleCursor = Class(Drawable)

local MODE_INACTIVE = "inactive"
local MODE_ACTIVE = "active"

function GamepadCircleCursor:new()
	Drawable.new(self)

	self.isEnabled = false
	self.activeOutlineColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadCircleCursor.active"))
	self.inactiveOutlineColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.gamepadCircleCursor.inactive"))
	self.activeOutlineThickness = 6
	self.inactiveOutlineThickness = 4
	self.activeArcLength = 1.5 / 32 * math.pi * 2
	self.inactiveArcLength = 1 / 32  * math.pi * 2
	self.activityTimeDuration = 1 / 3
	self.activityTimePendingInterval = 1 / 3
	self.activityTimeElapsed = 0
	self.currentActivityTime = 0
	self.radiusFudge = 32

	self.swingDuration = 1 / 4
	self.swingTime = 0
	self.previousAngle = false
	self.currentAngle = false
	self.activityMode = MODE_INACTIVE

	self:setZDepth(10000)

	self.targetLayout = false
end

function GamepadCircleCursor:getOverflow()
	return true
end

function GamepadCircleCursor:enable()
	self.isEnabled = true
end

function GamepadCircleCursor:disable()
	self.isEnabled = false
end

function GamepadCircleCursor:setTargetLayout(layout)
	self.targetLayout = layout
	self.previousAngle = self.targetLayout:getCursorAngle()
	self.currentAngle = self.targetLayout:getCursorAngle()
	self.activityTimeElapsed = self.activityTimeDuration
end

function GamepadCircleCursor:getIsEnabled()
	return self.isEnabled
end

function GamepadCircleCursor:setOutlineColor(inactiveValue, activeValue)
	self.inactiveOutlineColor = inactiveValue
	self.activeOutlineColor = activeValue
end

function GamepadCircleCursor:getOutlineColor()
	return self.inactiveOutlineThickness, self.activeOutlineThickness
end

function GamepadCircleCursor:setOutlineThickness(inactiveValue, activeValue)
	self.inactiveOutlineThickness = inactiveValue or self.inactiveOutlineThickness
	self.activeOutlineThickness = activeValue or self.activeOutlineThickness
end

function GamepadCircleCursor:getOutlineThickness()
	return self.inactiveOutlineThickness, self.activeOutlineThickness
end

function GamepadCircleCursor:setArcLength(inactiveValue, activeValue)
	self.inactiveArcLength = inactiveValue or self.inactiveArcLength
	self.activeArcLength = activeValue or self.activeArcLength
end

function GamepadCircleCursor:getArcLength()
	return self.inactiveArcLength, self.activeArcLength
end

function GamepadCircleCursor:setRadius(fudgeValue, speedValue)
	self.radiusFudge = fudgeValue or self.radiusFudge
	self.radiusSpeed = speedValue or self.radiusSpeed
end

function GamepadCircleCursor:getRadius()
	return self.radiusFudge, self.radiusSpeed
end

function GamepadCircleCursor:_updateTarget(delta)
	if not self.targetLayout then
		return
	end

	self.swingTime = math.min(self.swingTime + delta, self.swingDuration)

	local totalDuration = self.activityTimeDuration + self.activityTimePendingInterval
	local nextAngle = self.targetLayout:getFocusedOptionAngle()

	if nextAngle ~= self.currentAngle then
		self.previousAngle = math.lerpAngle(self.previousAngle, self.currentAngle, math.clamp(self.swingTime / self.swingDuration))
		self.currentAngle = nextAngle

		if self.activityMode == MODE_INACTIVE then
			self.activityTimeElapsed = math.max(totalDuration - self.activityTimeElapsed, 0)
			self.activityMode = MODE_ACTIVE
		end

		self.swingTime = 0
	else
		if self.activityMode == MODE_ACTIVE and self.activityTimeElapsed >= totalDuration then
			self.activityTimeElapsed = 0
			self.activityMode = MODE_INACTIVE
		end
	end

	self.activityTimeElapsed = math.min(self.activityTimeElapsed + delta, totalDuration)
end

function GamepadCircleCursor:update(delta)
	Drawable.update(self, delta)

	self:_updateTarget(delta)
end

local color = Color()
function GamepadCircleCursor:draw(...)
	Drawable.draw(self, ...)

	if not self.targetLayout then
		return
	end

	local delta = math.clamp(math.max(self.activityTimeElapsed, 0) / self.activityTimeDuration)

	if self.activityMode == MODE_INACTIVE then
		delta = 1 - delta
	end

	local mu = Tween.sineEaseInOut(delta)

	self.inactiveOutlineColor:lerp(self.activeOutlineColor, mu, color)
	local arcLength = math.lerp(self.inactiveArcLength, self.activeArcLength, mu)
	local lineWidth = math.lerp(self.inactiveOutlineThickness, self.activeOutlineThickness, mu)

	local angle = math.lerpAngle(self.previousAngle, self.currentAngle, math.clamp(self.swingTime / self.swingDuration))
	local angle1 = angle - arcLength
	local angle2 = angle + arcLength

	local _, outerRadius = self.targetLayout:getRadius()
	outerRadius = outerRadius + self.radiusFudge

	local parentWidth, parentHeight = (self:getParent() or self.targetLayout):getSize()
	local x, y = parentWidth / 2, parentHeight / 2

	love.graphics.push("all")

	local r, g, b, a = color:get()
	love.graphics.setLineWidth(lineWidth)

	love.graphics.setColor(r, g, b, mu * 0.25)
	itsyrealm.graphics.arc("fill", "pie", x, y, outerRadius, angle1, angle2)

	love.graphics.setColor(r, g, b, 1)
	itsyrealm.graphics.arc("line", "open", x, y, outerRadius, angle1, angle2)

	itsyrealm.graphics.circle(
		"fill",
		x + math.cos(angle1) * outerRadius,
		y + math.sin(angle1) * outerRadius,
		lineWidth / 2)
	itsyrealm.graphics.circle(
		"fill",
		x + math.cos(angle2) * outerRadius,
		y + math.sin(angle2) * outerRadius,
		lineWidth / 2)

	love.graphics.pop()
end

return GamepadCircleCursor
