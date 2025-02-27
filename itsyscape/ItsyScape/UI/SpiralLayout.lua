--------------------------------------------------------------------------------
-- ItsyScape/UI/SpiralLayout.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Vector = require "ItsyScape.Common.Math.Vector"
local Variables = require "ItsyScape.Game.Variables"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local Layout = require "ItsyScape.UI.Layout"
local Widget = require "ItsyScape.UI.Widget"

local SpiralLayout = Class(Layout)
SpiralLayout.DEFAULT_RADIUS = 256
SpiralLayout.DEFAULT_NUM_OPTIONS = 8

function SpiralLayout:new()
	Layout.new(self)

	self.innerPanel = Widget()
	self.onChildSelected = Callback()
	self.onChildVisible = Callback()

	self.onBlurChild:register(self._blurChild)
	self.onFocusChild:register(self._focusChild)
	self:setData(GamepadSink, GamepadSink())

	self.currentFocusedChildIndex = 1
	self.nextFocusedChildIndex = false
	self.visibleWidgets = {}

	self.radius = self.DEFAULT_RADIUS
	self.numOptions = self.DEFAULT_NUM_OPTIONS
	self.numPreOptions = self.DEFAULT_NUM_PRE_OPTIONS
	self.numPostOptions = self.DEFAULT_NUM_POST_OPTIONS
	self.squish = self.DEFAULT_SQUISH

	self.currentAngle = 0

	self.currentXAxisValue = 0
	self.currentYAxisValue = 0
	self.previousXAxisValue = 0
	self.previousYAxisValue = 0
	self.hasAxisInput = false

	self:addChild(self.innerPanel)
end

function SpiralLayout:getInnerPanel()
	return self.innerPanel
end

function SpiralLayout:setRadius(value)
	self.radius = value or self.DEFAULT_RADIUS
	self:performLayout()
end

function SpiralLayout:getRadius()
	return self.radius
end

function SpiralLayout:setNumOptions(value)
	self.numOptions = value or self.DEFAULT_NUM_OPTIONS
	self:performLayout()
end

function SpiralLayout:getNumOptions()
	return self.numOptions
end

function SpiralLayout:getOverflow()
	return true
end

function SpiralLayout:getFocusedChildIndex()
	return self.currentFocusedChildIndex
end

function SpiralLayout:focus(reason)
	Layout.focus(self, reason)

	self.currentFocusedChildIndex = math.clamp(self.currentFocusedChildIndex, 1, self:getNumChildren()) + 1

	local child = self:getChildAt(self.currentFocusedChildIndex)
	if not child then
		return
	end

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	inputProvider:setFocusedWidget(child, reason)
	self:onChildSelected(child, nil)
end

function SpiralLayout:_blurChild(widget)
	local previousParent = widget
	local currentParent = widget:getParent()
	while currentParent and currentParent ~= self do
		previousParent = currentParent
		currentParent = currentParent:getParent()
	end
end

function SpiralLayout:_focusChild(widget)
	local previousParent = widget
	local currentParent = widget:getParent()
	while currentParent and currentParent ~= self do
		previousParent = currentParent
		currentParent = currentParent:getParent()
	end

	if currentParent ~= self then
		return
	end

	self.nextFocusedChildIndex = false
	for index, widget in self:iterate() do
		if widget == previousParent then
			if self.currentFocusedChildIndex ~= index then
				self:onChildSelected(widget, self:getChildAt(self.currentFocusedChildIndex or 1))
			end

			self.currentFocusedChildIndex = index
			self.nextFocusedChildIndex = index
			break
		end
	end
end

function SpiralLayout:_setCurrentAngle(angle, focus)
	local minAngle = 0
	local maxAngle = (self:getNumChildren() - 1) / self.numOptions * math.pi * 2

	-- TODO use modulo if this is a performance issue
	while angle < minAngle do
		angle = angle + maxAngle
	end

	while angle > maxAngle do
		angle = angle - maxAngle
	end

	angle = math.clamp(angle, minAngle, maxAngle)
	self.currentAngle = angle

	if focus then
		local nextFocusedChildIndex = math.floor(self.currentAngle / 2 / math.pi * self.numOptions) + 1
		nextFocusedChildIndex = math.clamp(nextFocusedChildIndex, 1, (self:getNumChildren() - 1)) + 1

		local childWidget = self:getChildAt(nextFocusedChildIndex)
		local inputProvider = self:getInputProvider()

		if childWidget and inputProvider and not childWidget:getIsFocused() then
			inputProvider:setFocusedWidget(childWidget, "select")
		end
	end

	self:performLayout()
end

function SpiralLayout:addChild(child)
	Layout.addChild(self, child)

	self:performLayout()
end

local PREVIOUS_FADE_OUT_ANGLE = 2 * math.pi
local PREVIOUS_ANGLE = 3 * math.pi
local CURRENT_ANGLE = 4 * math.pi
local NEXT_ANGLE = 4.5 * math.pi
local NEXT_FADE_OUT_ANGLE =  5 * math.pi

function SpiralLayout:performLayout()
	Layout.performLayout(self)

	if self:getNumChildren() <= 1 then
		return
	end

	local currentIndex = self.currentFocusedChildIndex or 1
	local targetAngle = currentIndex / self.numOptions * (math.pi * 2)
	local targetCurrentAngleDifference = targetAngle - self.currentAngle - math.pi / 8

	local step = self.numOptions / (math.pi * 2)
	local numPreviousOptions = math.ceil((CURRENT_ANGLE - PREVIOUS_ANGLE) * step)
	local numPreCapOptions = math.ceil((PREVIOUS_ANGLE - PREVIOUS_FADE_OUT_ANGLE) * step)
	local numNextOptions = math.ceil((NEXT_ANGLE - CURRENT_ANGLE) * step)
	local numPostCapOptions = math.ceil((NEXT_FADE_OUT_ANGLE - NEXT_ANGLE) * step)

	local minIndex = -(numPreviousOptions + numPreCapOptions) - 1
	local maxIndex = numNextOptions + numPostCapOptions + 1

	local previousFadeOutInterval = (PREVIOUS_ANGLE - PREVIOUS_FADE_OUT_ANGLE) / numPreCapOptions
	local previousInterval = (CURRENT_ANGLE - PREVIOUS_ANGLE) / numPreviousOptions
	local nextInterval = (NEXT_ANGLE - CURRENT_ANGLE) / numNextOptions
	local nextFadeOutInterval = (NEXT_FADE_OUT_ANGLE - NEXT_ANGLE) / numPostCapOptions

	table.clear(self.visibleWidgets)
	self.visibleWidgets[self.innerPanel] = true

	for i = minIndex, maxIndex do
		local absoluteIndex = math.wrapIndex(i + currentIndex, 0, self:getNumChildren() - 1)
		absoluteIndex = absoluteIndex + 1

		print("i", i, "absoluteIndex", absoluteIndex)

		local widget = self:getChildAt(absoluteIndex)

		local angle
		if i <= -numPreviousOptions then
			local index = numPreCapOptions - math.abs(i + numPreviousOptions)
			angle = index * previousFadeOutInterval + PREVIOUS_FADE_OUT_ANGLE
			widget:setZDepth(-1)
		elseif i > numNextOptions then
			local index = i - numNextOptions
			angle = index * nextFadeOutInterval + NEXT_ANGLE
			widget:setZDepth(1)
		elseif i < 0 then
			angle = (numPreviousOptions - math.abs(i)) * previousInterval + PREVIOUS_ANGLE
			widget:setZDepth(1)
		elseif i > 0 then
			angle = i * nextInterval + CURRENT_ANGLE
			widget:setZDepth(1)
		else
			angle = CURRENT_ANGLE
			widget:setZDepth(1)
		end

		angle = angle + targetCurrentAngleDifference

		local delta
		if angle <= PREVIOUS_ANGLE then
			delta = (angle - PREVIOUS_FADE_OUT_ANGLE) / (PREVIOUS_ANGLE - PREVIOUS_FADE_OUT_ANGLE)
		elseif angle >= NEXT_ANGLE then
			delta = 1 - ((angle - NEXT_ANGLE) / (NEXT_FADE_OUT_ANGLE - NEXT_ANGLE))
		else
			delta = 1
		end

		self:onChildVisible(widget, delta)

		local radius = -(angle / (math.pi * 2) * self.radius) / 4
		local x = math.cos(-angle) * radius
		local y = math.sin(-angle) * radius

		local w, h = widget:getSize()
		x = x - w / 2
		y = y - h / 2

		widget:setPosition(x, y)

		self.visibleWidgets[widget] = true
	end
end

function SpiralLayout:isChildVisible(childWidget)
	return self.visibleWidgets[childWidget] == true
end

local KEYBIND_X_AXIS = Variables.Path("keybinds", "ui", "xAxis")
local KEYBIND_Y_AXIS = Variables.Path("keybinds", "ui", "yAxis")
local KEYBIND_AXIS_SENSITIVITY = Variables.Path("keybinds", "ui", "axisSensitivity")
local KEYBIND_RADIAL_DRAG = Variables.Path("keybinds", "ui", "radialDrag")

function SpiralLayout:gamepadAxis(joystick, axis, value)
	Layout.gamepadAxis(self, joystick, axis, value)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	local inputConfig = inputProvider:getConfig()

	local xAxis = inputConfig:get(KEYBIND_X_AXIS)
	local yAxis = inputConfig:get(KEYBIND_Y_AXIS)
	local axisSensitivity = inputConfig:get(KEYBIND_AXIS_SENSITIVITY)

	if not (axis == xAxis or axis == yAxis) then
		return
	end

	local xAxisValue = inputProvider:getGamepadAxis(joystick, xAxis)
	local yAxisValue = inputProvider:getGamepadAxis(joystick, yAxis)

	self.hasAxisInput = math.abs(xAxisValue) > axisSensitivity or math.abs(yAxisValue) > axisSensitivity
	self.currentXAxisValue = xAxisValue
	self.currentYAxisValue = yAxisValue
end

function SpiralLayout:_updateInput()
	local drag
	do
		local inputProvider = self:getInputProvider()
		local inputConfig = inputProvider and inputProvider:getConfig()
		local radialDrag = inputConfig and inputConfig:get(KEYBIND_RADIAL_DRAG)

		drag = radialDrag or 1
	end

	local currentAxis = (Vector(-self.currentXAxisValue, self.currentYAxisValue)):getNormal()
	local currentAngle = math.atan2(currentAxis.y, currentAxis.x)

	local previousAngle
	if self.previousXAxisValue == 0 and self.previousYAxisValue == 0 then
		previousAngle = currentAngle
	else
		local previousAxis = (Vector(-self.previousXAxisValue, self.previousYAxisValue)):getNormal()
		previousAngle = math.atan2(previousAxis.y, previousAxis.x)
	end

	local difference = math.diffAngle(currentAngle, previousAngle) * drag
	self:_setCurrentAngle(self.currentAngle - difference, true)
end

function SpiralLayout:update(delta)
	Layout.update(self, delta)

	if self.nextFocusedChildIndex then
		self:_setCurrentAngle((self.nextFocusedChildIndex - 1) / (self.numOptions - 1) * math.pi * 2, false)
	end

	if self.hasAxisInput then
		self:_updateInput()
	end

	self.previousXAxisValue = self.currentXAxisValue
	self.previousYAxisValue = self.currentYAxisValue
	self.hasAxisInput = false

	self.nextFocusedChildIndex = false
end

return SpiralLayout
