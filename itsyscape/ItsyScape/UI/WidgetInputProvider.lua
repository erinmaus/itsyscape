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
	self.hoveredWidgets = {}
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

function WidgetInputProvider:getWidgetsUnderPoint(x, y, px, py, widget, result)
	px = px or 0
	py = py or 0
	widget = widget or self.root
	result = result or {}

	local wx, wy = widget:getPosition()
	local ww, wh = widget:getSize()

	if x >= px + wx and x < px + wx + ww and
	   y >= py + wy and y < py + wy + wh
	then
		result[widget] = true

		local sx, sy = widget:getScroll()
		for i = #widget.children, 1, -1 do
			local w = widget.children[i]
			self:getWidgetsUnderPoint(
				x, y,
				px + wx - sx,
				py + wy - sy,
				w,
				result)
		end
	end

	return result
end

function WidgetInputProvider:isBlocking(x, y)
	return self:getWidgetUnderPoint(x, y) ~= self.root
end

function WidgetInputProvider:getWidgetUnderPoint(x, y, px, py, widget, filter)
	px = px or 0
	py = py or 0
	widget = widget or self.root
	filter = filter or function(widget) return true end

	local wx, wy = widget:getPosition()
	local ww, wh = widget:getSize()

	if x >= px + wx and x < px + wx + ww and
	   y >= py + wy and y < py + wy + wh
	then
		local sx, sy = widget:getScroll()

		for i = #widget.children, 1, -1 do
			local w = widget.children[i]
			local f = self:getWidgetUnderPoint(
				x, y,
				px + wx - sx,
				py + wy - sy,
				w,
				filter)
			if f then
				return f
			end
		end
	else
		return nil
	end

	if filter(widget) then
		return widget
	else
		return nil
	end
end

function WidgetInputProvider:mousePress(x, y, button)
	local function f(w)
		return w:getIsFocusable()
	end

	local widget = self:getWidgetUnderPoint(x, y, nil, nil, nil, f)
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

	local widgets = self:getWidgetsUnderPoint(x, y)
	for widget in pairs(widgets) do
		if not self.hoveredWidgets[widget] then
			widget:mouseEnter(x, y)
		end
	end

	for widget in pairs(self.hoveredWidgets) do
		if not widgets[widget] then
			widget:mouseLeave(x, y)
		end
	end

	self.hoveredWidgets = widgets

	for widget in pairs(self.hoveredWidgets) do
		widget:mouseMove(x, y, dx, dy)
	end

	for _, w in pairs(self.clickedWidgets) do
		w:mouseMove(x, y, dx, dy)
	end
end

function WidgetInputProvider:mouseScroll(x, y)
	local widgets = self:getWidgetsUnderPoint(love.mouse.getPosition())
	for widget in pairs(widgets) do
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
	elseif w:getParent() then
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
	end

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
