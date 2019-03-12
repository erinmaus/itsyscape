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
local Widget = require "ItsyScape.UI.Widget"

local WidgetInputProvider = Class()

function WidgetInputProvider:new(root)
	assert(Class.isCompatibleType(root, Widget), "root is not Widget")

	self.root = root
	self.focusedWidget = false
	self.clickedWidgets = {}
	self.hoveredWidgetsTime = {}
	self.hoveredWidgets = {}
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
		if not self.focusedWidget:getIsFocused() then
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

	if (x >= px + wx and x < px + wx + ww and
	   y >= py + wy and y < py + wy + wh)
	   or (overflow and widget:getOverflow())
	then
		local sx, sy = widget:getScroll()
		for i = #widget.children, 1, -1 do
			local w = widget.children[i]
			self:getWidgetsUnderPoint(
				x, y,
				px + wx - sx,
				py + wy - sy,
				w,
				overflow,
				result)
		end

		table.insert(result, 1, widget)
		result[widget] = true
	end

	return result
end

function WidgetInputProvider:isBlocking(x, y, overflow)
	local widget = self:getWidgetUnderPoint(x, y, nil, nil, nil, nil, overflow)

	return widget ~= self.root and widget
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

		if not hasParent then
			return nil
		else
			if not filter or filter(widget) then
				return widget
			end
		end
	end

	return nil
end

function WidgetInputProvider:mousePress(x, y, button)
	local function f(w)
		return w:getIsFocusable()
	end

	local widget = self:getWidgetUnderPoint(x, y, nil, nil, nil, f, false)
	if widget then
		self.clickedWidgets[button] = widget
		widget:mousePress(x, y, button)
	end

	local focusedWidget = self:getWidgetUnderPoint(x, y, nil, nil, nil, f)
	if focusedWidget ~= self.focusedWidget then
		local oldFocusedWidget = self:getFocusedWidget()
		if oldFocusedWidget then
			oldFocusedWidget:blur()
		end

		self.focusedWidget = focusedWidget or false
	end

	if focusedWidget then
		focusedWidget:focus('click')
	end
end

function WidgetInputProvider:mouseRelease(x, y, button)
	local widget = self:getWidgetUnderPoint(x, y)
	if widget then
		widget:mouseRelease(x, y, button)
	end

	if self.clickedWidgets[button] then
		self.clickedWidgets[button]:mouseRelease(x, y, button)
		self.clickedWidgets[button] = nil
	end
end

function WidgetInputProvider:mouseMove(x, y, dx, dy)
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
	local widgets = self:getWidgetsUnderPoint(love.mouse.getPosition())
	for _, widget in ipairs(widgets) do
		widget:mouseScroll(x, y)
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

return WidgetInputProvider
