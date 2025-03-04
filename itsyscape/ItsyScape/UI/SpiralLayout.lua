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
SpiralLayout.DEFAULT_OUTER_RADIUS = 128
SpiralLayout.DEFAULT_INNER_RADIUS = 96
SpiralLayout.DEFAULT_NUM_OPTIONS = 8
SpiralLayout.DEFAULT_SQUISH = 1.2

SpiralLayout.InnerPanelWrapper = Class(Widget)

function SpiralLayout.InnerPanelWrapper:getOverflow()
	return true
end

function SpiralLayout:new()
	Layout.new(self)

	self.innerPanelWrapper = SpiralLayout.InnerPanelWrapper()
	self.innerPanel = Widget()
	self.cursor = Widget()

	self.innerPanelWrapper:addChild(self.innerPanel)
	self.innerPanelWrapper:addChild(self.cursor)

	self.onChildSelected = Callback()
	self.onChildVisible = Callback()
	self.onMoveCursor = Callback()

	self.onBlurChild:register(self._blurChild)
	self.onFocusChild:register(self._focusChild)
	self:setData(GamepadSink, GamepadSink())

	self.currentFocusedChildIndex = 1
	self.nextFocusedChildIndex = false
	self.visibleWidgets = {}

	self.innerRadius = self.DEFAULT_RADIUS
	self.outerRadius = self.DEFAULT_OUTER_RADIUS
	self.numVisibleOptions = self.DEFAULT_NUM_OPTIONS
	self.squish = self.DEFAULT_SQUISH

	self.targetAngle = 0
	self.currentAngle = 0

	self.currentXAxisValue = 0
	self.currentYAxisValue = 0
	self.previousXAxisValue = 0
	self.previousYAxisValue = 0
	self.hasAxisInput = false

	self:addChild(self.innerPanelWrapper)
end

function SpiralLayout:getInnerPanel()
	return self.innerPanel
end

function SpiralLayout:setRadius(innerValue, outerValue)
	self.innerRadius = value or self.DEFAULT_INNER_RADIUS
	self.outerRadius = value or self.DEFAULT_OUTER_RADIUS

	self:performLayout()
end

function SpiralLayout:getRadius()
	return self.innerRadius, self.outerRadius
end

function SpiralLayout:setSquish(value)
	self.squish = value or self.DEFAULT_SQUISH
end

function SpiralLayout:getSquish()
	return self.squish
end

function SpiralLayout:setNumVisibleOptions(value)
	self.numVisibleOptions = value or self.DEFAULT_NUM_OPTIONS
	self:performLayout()
end

function SpiralLayout:getNumVisibleOptions()
	return self.numVisibleOptions
end

function SpiralLayout:getOverflow()
	return true
end

function SpiralLayout:getFocusedChildIndex()
	return self.currentFocusedChildIndex
end

function SpiralLayout:focus(reason)
	Layout.focus(self, reason)

	self.currentFocusedChildIndex = math.clamp(self.currentFocusedChildIndex, 1, self:getNumOptions())

	local child = self:getOptionAt(self.currentFocusedChildIndex)
	if not child then
		return
	end

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	inputProvider:setFocusedWidget(child, reason)
	self:onChildSelected(child, nil)
	self:onChildVisible(child, 1)
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
		local optionIndex = index - 1
		if widget == previousParent then
			if self.currentFocusedChildIndex ~= optionIndex then
				self:onChildSelected(widget, self:getOptionAt(self.currentFocusedChildIndex or 1))
			end

			self.currentFocusedChildIndex = optionIndex
			self.nextFocusedChildIndex = optionIndex
			break
		end
	end
end

function SpiralLayout:_setAngle(currentAngle, focus)
	local minAngle = 0
	local maxAngle = (self:getNumOptions() - 1) / (self.numVisibleOptions - 1) * (math.pi * 2)

	-- TODO use modulo if this is a performance issue
	while currentAngle < minAngle do
		currentAngle = currentAngle + maxAngle
	end

	while currentAngle > maxAngle do
		currentAngle = currentAngle - maxAngle
	end

	currentAngle = math.clamp(currentAngle, minAngle, maxAngle)
	self.currentAngle = currentAngle

	if focus then
		local nextFocusedChildIndex = math.floor(self.currentAngle / (math.pi * 2) * (self.numVisibleOptions - 1)) + 1
		nextFocusedChildIndex = math.clamp(nextFocusedChildIndex, 1, self:getNumOptions())

		Log.error("nextFocusedChildIndex %d, currentFocusedChildIndex %d", nextFocusedChildIndex, self.currentFocusedChildIndex)

		local childWidget = self:getOptionAt(nextFocusedChildIndex)
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

function SpiralLayout:getNumOptions()
	return self:getNumChildren() - 1
end

function SpiralLayout:getNumRemainingOptions()
	return self:getNumOptions() % self:getNumVisibleOptions()
end

function SpiralLayout:getOptionAt(index)
	local numOptions = self:getNumChildren()
	if index < 0 then
		index = index + self:getNumOptions() + 1
	end

	index = math.clamp(index, 1, numOptions)
	return self:getChildAt(index + 1)
end

function SpiralLayout:performLayout()
	Layout.performLayout(self)

	if self:getNumChildren() <= 1 then
		return
	end

	local currentIndex = self.currentFocusedChildIndex or 1
	local targetAngle = (currentIndex - 1) / (self.numVisibleOptions - 1) * (math.pi * 2)
	local targetCurrentAngleDifference = targetAngle - self.currentAngle
	local globalDelta = math.clamp(targetCurrentAngleDifference / (math.pi * 2 / self.numVisibleOptions))
	local offsetAngle = targetAngle % (math.pi * 2)

	local minIndex = -math.floor(self.numVisibleOptions / 2)
	local maxIndex = math.ceil(self.numVisibleOptions / 2) + 1

	table.clear(self.visibleWidgets)
	self.visibleWidgets[self.innerPanelWrapper] = true

	for i = minIndex, maxIndex do
		local absoluteIndex = math.wrapIndex(i + currentIndex, 0, self:getNumChildren() - 1)
		local widget = self:getOptionAt(absoluteIndex)

		local mu = i / self.numVisibleOptions
		local currentMu = i / self.numVisibleOptions
		local nextMu = (i + 1) / self.numVisibleOptions
		local mu = math.lerp(currentMu, nextMu, globalDelta)

		local relativeAngle = i / self.numVisibleOptions * (math.pi * 2)
		local angle = relativeAngle + offsetAngle
		local widgetDelta = 1 - math.abs(mu * 2)
		widgetDelta = math.clamp(math.sin(widgetDelta * (math.pi / 2)) * self.squish)
		local radiusDelta = mu + 0.5
		radiusDelta = math.clamp(math.sin(radiusDelta * (math.pi / 2)) * self.squish)
		local radius = math.lerp(self.innerRadius, self.outerRadius, radiusDelta)

		self:onChildVisible(widget, widgetDelta)

		local x = math.cos(angle) * radius
		local y = math.sin(angle) * radius

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
	currentAngle = currentAngle % (math.pi * 2)

	local previousAngle
	if self.previousXAxisValue == 0 and self.previousYAxisValue == 0 then
		previousAngle = 0
	else
		local previousAxis = (Vector(-self.previousXAxisValue, self.previousYAxisValue)):getNormal()
		previousAngle = math.atan2(previousAxis.y, previousAxis.x)
	end
	previousAngle = previousAngle % (math.pi * 2)

	local focusedAngle = ((self.currentFocusedChildIndex or 1) / self:getNumVisibleOptions() * (math.pi * 2))
	focusedAngle = currentAngle % (math.pi * 2)

	local difference = math.diffAngle(currentAngle, previousAngle) * drag
	self:_setAngle(self.currentAngle - difference, true)
end

function SpiralLayout:update(delta)
	Layout.update(self, delta)

	if self.nextFocusedChildIndex then
		local targetAngle = ((self.nextFocusedChildIndex - 1) / (self:getNumVisibleOptions() - 1)) * math.pi * 2
		self:_setAngle(targetAngle, false)
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
