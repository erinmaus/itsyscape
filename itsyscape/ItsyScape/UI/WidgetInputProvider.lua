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
	self.hoverWidget = false
	self.clickedWidgets = {}
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

function WidgetInputProvider:isBlocking(x, y)
	return self:getWidgetUnderPoint(x, y) ~= nil
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
	local widget = self:getWidgetUnderPoint(x, y)
	if widget then
		self.clickedWidgets[button] = widget
		widget:mousePress(x, y, button)
	end

	local function f(w)
		return w:getIsFocusable()
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
		focusedWidget:focus()
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
	local widget = self:getWidgetUnderPoint(x, y)
	if widget ~= self.hoverWidget then
		if self.hoverWidget then
			self.hoverWidget:mouseLeave(x, y)
		end

		if widget then
			widget:mouseEnter(x, y)
		end

		self.hoverWidget = widget
	end

	if widget then
		widget:mouseMove(x, y, dx, dy)
	end

	for _, w in pairs(self.clickedWidgets) do
		w:mouseMove(x, y, dx, dy)
	end
end

function WidgetInputProvider:tryFocusNext(widget)
	if widget:getIsFocusable() then
		local f = self:getFocusedWidget()
		if f then
			f:blur()
		end
		
		widget:focus()
		self.focusedWidget = widget

		return true
	end

	for _, child in widget:iterate() do
		if self:focusNext(child) then
			return true
		end
	end
end

function WidgetInputProvider:focusNext(w)
	w = w or self.root

	if self:tryFocusNext(w) then
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
				if self:focusNext(child) then
					return true
				end
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
			self:focusNext(self.focusedWidget)
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

return WidgetInputProvider
