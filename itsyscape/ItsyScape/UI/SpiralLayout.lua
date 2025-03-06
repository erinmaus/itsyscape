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
local Config = require "ItsyScape.Game.Config"
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
	self.innerPanel = SpiralLayout.InnerPanelWrapper()
	self.cursor = SpiralLayout.InnerPanelWrapper()

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
	self.focusNextChild = false

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
	self.innerRadius = innerValue or self.DEFAULT_INNER_RADIUS
	self.outerRadius = outerValue or self.DEFAULT_OUTER_RADIUS

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

function SpiralLayout:getFocusedOptionIndex()
	return self.nextFocusedChildIndex or self.currentFocusedChildIndex
end

function SpiralLayout:setFocusedOptionIndex(value)
	value = math.clamp(value or self.currentFocusedChildIndex, 1, self:getNumOptions())
	if value == self.currentFocusedChildIndex then
		return
	end

	local child = self:getOptionAt(value)
	if not child then
		return
	end

	self.nextFocusedChildIndex = value

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		self.focusNextChild = true
		return
	end

	local previousFocusedChildIndex = self.currentFocusedChildIndex
	self.currentFocusedChildIndex = value

	local previousChild = self:getOptionAt(previousFocusedChildIndex)
	local currentChild = self:getOptionAt(self.currentFocusedChildIndex)

	inputProvider:setFocusedWidget(currentChild, "select")
	self:onChildSelected(currentChild, previousChild)
	self:onChildVisible(currentChild, 1)
end

function SpiralLayout:getCurrentAngle()
	return self.currentAngle
end

function SpiralLayout:setCurrentAngle(value)
	self:_setAngle(value, true)
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

	if currentParent ~= self then
		return
	end

	for index, widget in self:iterate() do
		if widget == previousParent then
			self:onChildSelected(nil, widget)
			break
		end
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
				self.currentFocusedChildIndex = optionIndex
				self.nextFocusedChildIndex = optionIndex

				self:onChildSelected(widget, self:getOptionAt(self.currentFocusedChildIndex or 1))
			end

			break
		end
	end
end

function SpiralLayout:_setAngle(currentAngle, focus)
	local minAngle = 0
	local maxAngle = (self:getNumOptions() + 1) / self.numVisibleOptions * (math.pi * 2)

	currentAngle = math.wrap(currentAngle, minAngle, maxAngle)
	self.currentAngle = currentAngle

	if focus then
		local nextFocusedChildIndex = math.floor(self.currentAngle / (math.pi * 2) * self.numVisibleOptions) + 1
		nextFocusedChildIndex = math.clamp(nextFocusedChildIndex, 1, self:getNumOptions())

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
	local remainder = math.wrapIndex(self:getNumOptions(), 1, self:getNumVisibleOptions())
	return self:getNumVisibleOptions() - remainder + 1
end

function SpiralLayout:getOptionAt(index)
	local numOptions = self:getNumChildren()
	if index < 0 then
		index = index + self:getNumOptions() + 1
	end

	index = math.clamp(index, 1, numOptions)
	return self:getChildAt(index + 1)
end

function SpiralLayout:getCurrentOption()
	return self:getOptionAt(self:getFocusedOptionIndex())
end

function SpiralLayout:performLayout()
	Layout.performLayout(self)

	if self:getNumChildren() <= 1 then
		return
	end

	local currentIndex = self.currentFocusedChildIndex or 1
	local targetAngle = (currentIndex - 1) / self.numVisibleOptions * (math.pi * 2)
	local targetCurrentAngleDifference = math.diffAngle(self.currentAngle, targetAngle)
	local globalDelta = 1 - math.clamp(targetCurrentAngleDifference / ((math.pi * 2) / self.numVisibleOptions))
	local offsetAngle = targetAngle % (math.pi * 2)

	local minIndex = -math.floor(self.numVisibleOptions / 2) + 1
	local maxIndex = math.ceil(self.numVisibleOptions / 2) + 1

	table.clear(self.visibleWidgets)
	self.visibleWidgets[self.innerPanelWrapper] = true

	for i = minIndex, maxIndex do
		local absoluteIndex = math.wrapIndex(i + currentIndex, 0, self:getNumChildren() - 1)
		local widget = self:getOptionAt(absoluteIndex)

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

function SpiralLayout:gamepadAxis(joystick, axis, value)
	Layout.gamepadAxis(self, joystick, axis, value)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if not inputProvider:isCurrentJoystick(joystick) then
		return
	end

	local xAxis = Config.get("Input", "KEYBIND", "type", "ui", "name", "xAxis")
	local yAxis = Config.get("Input", "KEYBIND", "type", "ui", "name", "yAxis")
	local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity")

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
	local drag = Config.get("Input", "KEYBIND", "type", "ui", "name", "radialDrag") or 1
	local axisSensitivity = Config.get("Input", "KEYBIND", "type", "ui", "name", "axisSensitivity")

	if math.abs(self.previousXAxisValue) < axisSensitivity and math.abs(self.previousYAxisValue) < axisSensitivity then
		local currentAxis = Vector(-self.currentXAxisValue, -self.currentYAxisValue)
		local currentAxisAngle = math.wrap(math.atan2(currentAxis.y, currentAxis.x) + math.pi, 0, math.pi * 2)

		local numRotations = math.floor((self:getFocusedOptionIndex() - 1) / self.numVisibleOptions)
		currentAngle = numRotations * math.pi * 2 + (math.pi / self.numVisibleOptions)

		self:_setAngle(currentAngle + currentAxisAngle, true)
	else
		local currentAxis = (Vector(-self.currentXAxisValue, self.currentYAxisValue))
		local currentAxisAngle = math.atan2(currentAxis.y, currentAxis.x)
		currentAxisAngle = currentAxisAngle % (math.pi * 2)

		local previousAxis = (Vector(-self.previousXAxisValue, self.previousYAxisValue))
		local previousAxisAngle = math.atan2(previousAxis.y, previousAxis.x)

		currentAngle = self.currentAngle
		previousAxisAngle = previousAxisAngle % (math.pi * 2)

		local difference = math.diffAngle(currentAxisAngle, previousAxisAngle) * drag
		self:_setAngle(self.currentAngle - difference, true)
	end
end

function SpiralLayout:update(delta)
	Layout.update(self, delta)

	if self.nextFocusedChildIndex then
		local targetAngle = ((self.nextFocusedChildIndex - 1) / (self:getNumVisibleOptions() - 1)) * math.pi * 2
		self:_setAngle(targetAngle, self.focusNextChild)

		self.nextFocusedChildIndex = false
		self.focusNextChild = false
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
