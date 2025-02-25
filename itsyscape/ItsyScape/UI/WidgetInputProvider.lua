--------------------------------------------------------------------------------
-- ItsyScape/UI/WidgetInputProvider.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Variables = require "ItsyScape.Game.Variables"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local Widget = require "ItsyScape.UI.Widget"

local WidgetInputProvider = Class()

local DIRECTION_X_AXIS = Variables.Path("direction", "xAxis")
local DIRECTION_Y_AXIS = Variables.Path("direction", "yAxis")
local DIRECTION_AXIS_SENSITIVITY = Variables.Path("direction", "axisSensitivity")
local DIRECTION_MIN_TIME = Variables.Path("direction", "minTime")
local DIRECTION_START_TIME = Variables.Path("direction", "startTime")
local DIRECTION_ACCELERATION_STEP = Variables.Path("direction", "accelerationStep")

function WidgetInputProvider:new(root)
	assert(Class.isCompatibleType(root, Widget), "root is not Widget")

	self.root = root
	self.focusedWidget = false
	self.clickedWidgets = {}
	self.hoveredWidgetsTime = {}
	self.hoveredWidgets = {}
	self.joysticks = {}
	self.currentJoystickIndex = 1
	self.currentJoystick = false

	self.config = Variables("Resources/Game/Variables/Input.json")
end

function WidgetInputProvider:getHoveredWidgets()
	local index = 1
	local widget = nil
	return function()
		widget = self.hoveredWidgets[index]
		index = index + 1
		return widget, self.hoveredWidgetsTime[widget]
	end
end

function WidgetInputProvider:setFocusedWidget(widget, reason)
	local current = self:getFocusedWidget()
	if current then
		current:blur()
	end

	self.focusedWidget = widget or false
	if self.focusedWidget then
		self.focusedWidget:focus(reason or 'force')
	end
end

function WidgetInputProvider:getFocusedWidget()
	if self.focusedWidget then
		if not self.focusedWidget:getIsFocused() or not self.focusedWidget:hasParent(self.root) then
			self.focusedWidget = false
		end
	end

	if self.focusedWidget then
		return self.focusedWidget
	else
		return nil
	end
end

function WidgetInputProvider:getWidgetsUnderPoint(x, y, px, py, widget, overflow, result)
	px = px or 0
	py = py or 0
	widget = widget or self.root
	result = result or {}

	local wx, wy = widget:getPosition()
	local ww, wh = widget:getSize()
	local ox, oy = px, py

	if (x >= ox + wx and x < ox + wx + ww and
	   y >= oy + wy and y < oy + wy + wh)
	   or (overflow and widget:getOverflow())
	then
		local sx, sy = widget:getScroll()
		widget:zIterate()

		for i = #widget.zSortedChildren, 1, -1 do
			local w = widget.zSortedChildren[i]
			self:getWidgetsUnderPoint(
				x, y,
				px + wx - sx,
				py + wy - sy,
				w,
				overflow,
				result)
		end

		if not widget:getOverflow() then
			table.insert(result, 1, widget)
			result[widget] = true
		end
	end

	return result
end

function WidgetInputProvider:getFocusableWidgets(widget, result)
	result = result or {}
	widget = widget or self.root

	if widget:getIsFocusable() then
		table.insert(result, widget)
	end

	for _, childWidget in widget:zIterate() do
		self:getFocusableWidgets(childWidget, result)
	end

	return result
end

function WidgetInputProvider:isBlocking(x, y)
	x, y = love.graphics.getScaledPoint(x, y)

	local widget = self:getWidgetUnderPoint(x, y, nil, nil, nil, function(w)
		return not w:getIsClickThrough()
	end, true)

	return (widget ~= self.root and widget) or next(self.clickedWidgets) ~= nil, widget
end

function WidgetInputProvider:getWidgetUnderPoint(x, y, px, py, widget, filter, overflow)
	local widgets = self:getWidgetsUnderPoint(x, y, px, py, widget, overflow)

	for i = #widgets, 1, -1 do
		local widget = widgets[i]
		local hasParent

		for j = #widgets, i, -1 do
			if widgets[j]:hasParent(widget) or
			   widgets[j]:isSiblingOf(widget)
			then
				hasParent = true
			else
				hasParent = false
				break
			end
		end

		if hasParent and not filter or filter(widget) then
			return widget
		end
	end

	return nil
end

function WidgetInputProvider:mousePress(x, y, button)
	x, y = love.graphics.getScaledPoint(x, y)

	local function clickedWidgetFilter(w)
		return not w:getIsClickThrough()
	end

	local function clickableWidgetFilter(w)
		return w:getIsFocusable() and not w:getIsClickThrough()
	end

	local clickedWidget = self:getWidgetUnderPoint(x, y, nil, nil, nil, clickedWidgetFilter, true)
	local clickableWidget = self:getWidgetUnderPoint(x, y, nil, nil, nil, clickableWidgetFilter, true)
	local canClick = clickedWidget and clickableWidget and (clickedWidget == clickableWidget or clickedWidget:hasParent(clickableWidget))

	if canClick then
		self.clickedWidgets[button] = clickableWidget
		clickableWidget:mousePress(x, y, button)
	end

	if self.focusedWidget ~= clickableWidget then
		local oldFocusedWidget = self:getFocusedWidget()
		if oldFocusedWidget then
			oldFocusedWidget:blur()
		end

		self.focusedWidget = canClick and clickableWidget or false
		if self.focusedWidget then
			self.focusedWidget:focus('click')
		end
	end
end

function WidgetInputProvider:mouseRelease(x, y, button)
	x, y = love.graphics.getScaledPoint(x, y)
	local function f(w)
		return w:getIsFocusable() and not w:getIsClickThrough()
	end

	local widget = self:getWidgetUnderPoint(x, y, nil, nil, nil, f, true)
	if widget then
		widget:mouseRelease(x, y, button)
	end

	if self.clickedWidgets[button] and self.clickedWidgets[button] ~= widget then
		self.clickedWidgets[button]:mouseRelease(x, y, button)
	end
	self.clickedWidgets[button] = nil
end

function WidgetInputProvider:mouseMove(x, y, dx, dy)
	x, y = love.graphics.getScaledPoint(x, y)
	local function f(w)
		return w:getIsFocusable()
	end

	local top = self:getWidgetUnderPoint(x, y, nil, nil, nil, f, true)

	local widgets = self:getWidgetsUnderPoint(x, y, nil, nil, nil, true)
	for _, widget in ipairs(widgets) do
		if not self.hoveredWidgets[widget] then
			widget:mouseEnter(x, y, widget == top or top == nil)
		end
	end

	for _, widget in ipairs(self.hoveredWidgets) do
		if not widgets[widget] then
			widget:mouseLeave(x, y)
		end
	end

	self.hoveredWidgets = widgets

	local oldTimes = self.hoveredWidgetsTime
	self.hoveredWidgetsTime = {}
	for _, widget in pairs(self.hoveredWidgets) do
		if oldTimes[widget] then
			self.hoveredWidgetsTime[widget] = oldTimes[widget]
		else
			self.hoveredWidgetsTime[widget] = love.timer.getTime()
		end
	end

	for _, widget in ipairs(self.hoveredWidgets) do
		widget:mouseMove(x, y, dx, dy)
	end

	for _, w in pairs(self.clickedWidgets) do
		w:mouseMove(x, y, dx, dy)
	end
end

function WidgetInputProvider:mouseScroll(x, y)
	local mouseX, mouseY = love.graphics.getScaledPoint(itsyrealm.mouse.getPosition())
	local widgets = self:getWidgetsUnderPoint(mouseX, mouseY, nil, nil, nil, true)

	for _, widget in ipairs(widgets) do
		widget:mouseScroll(x, y)
	end
end

function WidgetInputProvider:joystickAdd(joystick)
	local index = self.currentJoystickIndex
	self.currentJoystickIndex = self.currentJoystickIndex + 1

	local _, id = joystick:getID()
	self.joysticks[id] = {
		index = index,
		axis = {},
		joystick = joystick,
		directionChange = 0,
		directionX = 0,
		directionY = 0,
		lastDirectionAxis = false,
		elapsed = 0,
		velocity = 0
	}

	if not self.currentJoystick then
		self.currentJoystick = joystick
	end
end

function WidgetInputProvider:joystickRemove(joystick)
	local _, id = joystick:getID()
	self.joysticks[id] = nil

	if self.currentJoystick then
		local _, currentID = self.currentJoystick:getID()
		if currentID == id then
			self.currentJoystick = nil
		end
	end

	if not self.currentJoystick then
		local currentJoystick = nil
		for _, joystickInfo in pairs(self.joysticks) do
			if not currentJoystick or joystickInfo.index < currentJoystick.index then
				currentJoystick = joystickInfo
			end
		end

		if currentJoystick then
			self.currentJoystick = currentJoystick.joystick
		end
	end
end

function WidgetInputProvider:gamepadRelease(...)
	local widget = self:getFocusedWidget()
	if widget then
		widget:gamepadRelease(...)
	end
end

function WidgetInputProvider:gamepadPress(...)
	local widget = self:getFocusedWidget()
	if widget then
		widget:gamepadPress(...)
	end
end

function WidgetInputProvider:gamepadAxis(joystick, axis, value)
	local widget = self:getFocusedWidget()
	if widget then
		widget:gamepadAxis(joystick, axis, value)
	end

	local _, id = joystick:getID()
	local joystickInfo = self.joysticks[id]
	if joystickInfo then
		joystickInfo.axis[axis] = value
	end
end

function WidgetInputProvider:tryFocusNext(widget, e)
	if widget:getIsFocusable() and widget ~= self:getFocusedWidget() then
		local f = self:getFocusedWidget()
		if f then
			f:blur()
		end
		
		widget:focus(e)
		self.focusedWidget = widget

		return true
	end

	for _, child in widget:iterate() do
		if self:focusNext(child) then
			return true
		end
	end
end

function WidgetInputProvider:focusNext(w, e)
	w = w or self.root

	if self:tryFocusNext(w, e) then
		return true
	end

	-- This is broken.
	--[[elseif w:getParent() then
		local p = w:getParent()
		local passedFocus = false
		for _, child in p:iterate() do
			if not passedFocus then
				if child == w then
					passedFocus = true
				end
			else
				if self:focusNext(child, e) then
					return true
				end
			end
		end

		for _, child in p:iterate() do
			if self:focusNext(child, e) then
				return true
			end
		end
	end]]

	return false
end

function WidgetInputProvider:keyDown(key, ...)
	local captured
	do
		local f = self:getFocusedWidget()
		if f then
			captured = f:keyDown(key, ...)
		else
			captured = false
		end
	end

	if not captured then
		if key == 'tab' then
			self:focusNext(self.focusedWidget, 'key')
		elseif key == 'escape' and self.focusedWidget then
			self.focusedWidget:blur()
			self.focusedWidget = false
		end
	end
end

function WidgetInputProvider:keyUp(...)
	local f = self:getFocusedWidget()
	if f then
		f:keyUp(...)
	end
end

function WidgetInputProvider:type(...)
	local f = self:getFocusedWidget()
	if f then
		f:type(...)
	end
end

function WidgetInputProvider:_updateGamepadFocus(directionX, directionY)
	local focusedWidget = self:getFocusedWidget()
	local focusableWidgets = self:getFocusableWidgets()

	if not focusedWidget and #focusableWidgets == 0 then
		return
	end

	local hasGamepadSink
	do
		local current = focusedWidget
		while current and not Class.isCompatibleType(current, GamepadSink) do
			current = current and current:getParent()
		end

		hasGamepadSink = Class.isCompatibleType(current, GamepadSink)
	end

	if hasGamepadSink then
		return
	end

	if not focusedWidget then
		self:setFocusedWidget(focusableWidgets[1], "gamepad")
		return
	end

	local focusedWidgetX, focusedWidgetY = focusedWidget:getAbsolutePosition()
	local focusedWidgetWidth, focusedWidgetHeight = focusedWidget:getSize()

	local focusableWidget
	local focusableWidgetDistance = math.huge
	for _, widget in ipairs(focusableWidgets) do
		local x, y = widget:getAbsolutePosition()
		local w, h = widget:getSize()

		local dx = (x + w / 2) - (focusedWidgetX + focusedWidgetWidth / 2)
		local dy = (y + h / 2) - (focusedWidgetY + focusedWidgetHeight / 2)

		if ((directionX ~= 0 and math.zerosign(dx) == directionX) or
		    (directionY ~= 0 and math.zerosign(dy) == directionY)) and
		   focusedWidget ~= widget
		then
			local distance = math.sqrt(dx ^ 2 + dy ^ 2)

			if distance < focusableWidgetDistance then
				focusableWidgetDistance = distance
				focusableWidget = widget
			end
		end
	end

	if focusableWidget then
		self:setFocusedWidget(focusableWidget, "gamepad")
	end
end

function WidgetInputProvider:_updateGamepad(delta)
	if not self.currentJoystick then
		return
	end

	local _, id = self.currentJoystick:getID()
	local joystickInfo = self.joysticks[id]
	if not joystickInfo then
		return
	end

	local xAxis = self.config:get(DIRECTION_X_AXIS)
	local yAxis = self.config:get(DIRECTION_Y_AXIS)
	local axisSensitivity = self.config:get(DIRECTION_AXIS_SENSITIVITY)

	local isXEngaged = math.abs(joystickInfo.axis[xAxis] or 0) > axisSensitivity
	local isYEngaged = math.abs(joystickInfo.axis[yAxis] or 0) > axisSensitivity

	if not (isXEngaged or isYEngaged) then
		return
	end

	local xAxisValue = joystickInfo.axis[xAxis] or 0
	local yAxisValue = joystickInfo.axis[yAxis] or 0

	local directionX, directionY
	if math.abs(xAxisValue) >= math.abs(yAxisValue) then
		directionX = math.zerosign(xAxisValue)
		directionY = 0
	else
		directionX = 0
		directionY = math.zerosign(yAxisValue)
	end

	if joystickInfo.directionX ~= directionX or joystickInfo.directionY ~= directionY then
		joystickInfo.velocity = self.config:get(DIRECTION_START_TIME)
		joystickInfo.elapsed = 0
	end

	joystickInfo.directionX = directionX
	joystickInfo.directionY = directionY

	joystickInfo.elapsed = joystickInfo.elapsed - delta
	if joystickInfo.elapsed < 0 then
		self:_updateGamepadFocus(directionX, directionY)

		joystickInfo.velocity = math.max(joystickInfo.velocity - self.config:get(DIRECTION_ACCELERATION_STEP), self.config:get(DIRECTION_MIN_TIME))
		joystickInfo.elapsed = joystickInfo.velocity
	end
end

function WidgetInputProvider:update(delta)
	self:_updateGamepad(delta)
end

return WidgetInputProvider
