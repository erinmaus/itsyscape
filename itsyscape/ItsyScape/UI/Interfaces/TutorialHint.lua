--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/TutorialHint.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Drawable = require "ItsyScape.UI.Drawable"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"

local TutorialHint = Class(Interface)
TutorialHint.PADDING = 8
TutorialHint.Z_DEPTH = 8000
TutorialHint.TOOL_TIP_HEIGHT = 48

TutorialHint.Circle = Class(Drawable)
function TutorialHint.Circle:new()
	Drawable.new(self)

	self.radius = 32
end

function TutorialHint.Circle:getOverflow()
	return true
end

function TutorialHint.Circle:getRadius()
	return self.radius
end

function TutorialHint.Circle:setRadius(value)
	self.radius = value or self.radius
end

function TutorialHint.Circle:draw()
	local time = love.timer.getTime()
	local alpha = math.sin(time * math.pi * 2)

	love.graphics.setLineWidth(4)
	love.graphics.setBlendMode('alpha')
	love.graphics.setColor(0, 0, 0, alpha)
	itsyrealm.graphics.circle('line', 2, 2, self.radius)
	love.graphics.setColor(0, 1, 0, alpha)
	itsyrealm.graphics.circle('line', 0, 0, self.radius)
	love.graphics.setColor(1, 1, 1, 1)
end

TutorialHint.Rectangle = Class(Drawable)
function TutorialHint.Rectangle:getOverflow()
	return true
end

function TutorialHint.Rectangle:draw()
	local time = love.timer.getTime()
	local alpha = math.sin(time * math.pi * 2)

	love.graphics.setLineWidth(4)

	local w, h = self:getSize()
	love.graphics.setColor(0, 0, 0, alpha)
	itsyrealm.graphics.rectangle('line', 2, 2, w, h, 4, 4)
	love.graphics.setColor(0, 1, 0, alpha)
	itsyrealm.graphics.rectangle('line', 0, 0, w, h, 4, 4)
	love.graphics.setColor(1, 1, 1, 1)
end

function TutorialHint:getInputState()
	local mode

	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:getCurrentJoystick() then
		mode = "gamepad"
	elseif _MOBILE then
		mode = "mobile"
	else
		mode = "standard"
	end

	local state = self:getState()
	return {
		id = state.id[mode] == nil and state.id.standard or state.id[mode],
		style = state.style[mode] == nil and state.style.standard or state.style[mode],
		position = state.position[mode] == nil and state.position.standard or state.position[mode],
		message = state.message[mode] == nil and state.message.standard or state.message[mode],
		didPerformAction = state.didPerformAction
	}
end

function TutorialHint:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local _, _, _, _, offsetX, offsetY = love.graphics.getScaledMode()
	self:setPosition(-offsetX, -offsetY)

	self.toolTip = GamepadToolTip()
	self.toolTip:setRowSize(math.huge, self.TOOL_TIP_HEIGHT)

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)

	self:setZDepth(self.Z_DEPTH)
end

function TutorialHint:getOverflow()
	return true
end

function TutorialHint:place(widget)
	local state = self:getInputState()

	if state.message == false then
		if self.toolTip:getParent() == self then
			self:removeChild(self.toolTip)
		end

		return
	end

	local targetX, targetY = widget:getAbsolutePosition()
	local targetWidth, targetHeight = widget:getSize()

	if self.toolTip:getParent() ~= self then
		self:addChild(self.toolTip)
	end

	self.toolTip:setKeybind(state.message.keybind)

	local icon = self.toolTip:getGamepadIcon()
	icon:setController(state.message.controller)

	if type(state.message.button) == "table" then
		icon:setButtonIDs(unpack(state.message.button))
	else
		icon:setButtonID(state.message.button)
	end

	if type(state.message.action) == "table" then
		icon:setButtonActions(unpack(state.message.action))
	else
		icon:setButtonAction(state.message.action)
	end

	if type(state.message.speed) == "number" then
		icon:setSpeed(state.message.speed)
	else
		icon:setSpeed(icon.DEFAULT_SPEED)
	end

	self.toolTip:setText(state.message.label)
	self.toolTip:update(0)

	local toolTipWidth, toolTipHeight = self.toolTip:getSize()

	local x, y
	if state.position == "center" then
		if widget == self:getView():getRoot() then
			x = (targetX + targetWidth / 2) - toolTipWidth / 2
			y = (targetY + targetHeight / 2) - targetHeight / 4 - toolTipHeight / 2
		else
			x = (targetX + targetWidth / 2) - toolTipWidth / 2
			y = (targetY + targetHeight / 2) - toolTipHeight / 2
		end
	else
		if state.position == "up" then
			x = (targetX + targetWidth / 2) - toolTipWidth / 2
			y = targetY - toolTipHeight - self.PADDING * 3
		elseif state.position == "down" then
			x = (targetX + targetWidth / 2) - toolTipWidth / 2
			y = targetY + targetHeight + self.PADDING * 3
		elseif state.position == "left" then
			x = targetX - toolTipWidth - self.PADDING * 3
			y = (targetY + targetHeight / 2) - toolTipHeight / 2
		elseif state.position == "right" then
			x = targetX + targetWidth + self.PADDING * 3
			y = (targetY + targetHeight / 2) - toolTipHeight / 2
		end

		if x and y then
			local screenWidth, screenHeight = itsyrealm.graphics.getScaledMode()
			x = math.min(math.max(x, 0), screenWidth - toolTipWidth)
			y = math.min(math.max(y, 0), screenHeight - toolTipHeight)
		end
	end
	self.toolTip:setPosition(x, y)
end

function TutorialHint:getTargetWidget(Type)
	if not self.targetWidget or not self.targetWidget:isCompatibleType(Type) then
		if self.targetWidget then
			self:removeChild(self.targetWidget)
		end

		self.targetWidget = Type()
		self:addChild(self.targetWidget)
	end

	return self.targetWidget
end

function TutorialHint:highlight(widget)
	local state = self:getInputState()

	local targetX, targetY = widget:getAbsolutePosition()
	local targetWidth, targetHeight = widget:getSize()

	if state.style == "circle" then
		local circle = self:getTargetWidget(TutorialHint.Circle)

		local radius = (math.max(targetWidth, targetHeight) * (3 / 4)) + 4
		circle:setRadius(radius)
		circle:setPosition(targetX + targetWidth / 2, targetY + targetHeight / 2)
	elseif state.style == "rectangle" then
		local rectangle = self:getTargetWidget(TutorialHint.Rectangle)

		rectangle:setPosition(targetX - 4, targetY - 4)
		rectangle:setSize(targetWidth + 8, targetHeight + 8)
	end
end

function TutorialHint:update(...)
	Interface.update(self, ...)

	local state = self:getInputState()
	local uiView = self:getView()
	local widget = uiView:findWidgetByID(state.id)

	if widget then
		self:place(widget)

		if widget ~= self:getView():getRoot() then
			self:highlight(widget)
		elseif self.toolTip:getParent() then
			self:highlight(self.toolTip)
		end
	end

	if (not widget or state.message == false or state.didPerformAction) and self.targetWidget and self.targetWidget:getParent() == self then
		self:removeChild(self.targetWidget)
		self.targetWidget = nil
	end

	if state.didPerformAction and self.toolTip:getParent() == self then
		self:removeChild(self.toolTip)
	end
end

return TutorialHint
