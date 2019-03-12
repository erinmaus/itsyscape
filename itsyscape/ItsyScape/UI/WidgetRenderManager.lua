--------------------------------------------------------------------------------
-- ItsyScape/UI/WidgetRenderManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http//mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local ToolTip = require "ItsyScape.UI.ToolTip"

local WidgetRenderManager = Class()
WidgetRenderManager.TOOL_TIP_DURATION = 0.5

function WidgetRenderManager:new(inputProvider)
	self.renderers = {}
	self.defaultRenderer = WidgetRenderer()
	self.cursor = { widget = false, state = {}, x = 0, y = 0 }
	self.input = inputProvider
	self.toolTip = false
end

function WidgetRenderManager:getCursor()
	return self.cursor.widget
end

function WidgetRenderManager:setCursor(widget)
	self.cursor = { widget = widget or false, state = {}, x = 0, y = 0 }

	if widget then
		local x, y = widget:getPosition()
		local p = widget:getParent()
		while p do
			local px, py = p:getPosition()
			local sx, sy = p:getScroll()
			x = x - sx + px
			y = y - sy + py

			p = p:getParent()
		end

		local mouseX, mouseY = love.mouse.getPosition()
		self.cursor.x = x - mouseX
		self.cursor.y = y - mouseY
	end
end

function WidgetRenderManager:setToolTip(duration, ...)
	self.toolTip = ToolTip(...)
	self.toolTip:setDuration(duration or WidgetRenderManager.TOOL_TIP_DURATION)
	self.toolTip:setPosition(love.mouse.getPosition())
end

function WidgetRenderManager:unsetToolTip()
	self.toolTip = false
end

function WidgetRenderManager:getToolTip()
	return self.toolTip
end

function WidgetRenderManager:hasRenderer(widgetType)
	return self:getRenderer(widgetType) ~= nil
end

function WidgetRenderManager:getRenderer(widgetType)
	while widgetType do
		if self.renderers[widgetType] then
			return self.renderers[widgetType]
		else
			widgetType = widgetType._PARENT
		end
	end

	return nil
end

function WidgetRenderManager:addRenderer(widgetType, widgetRenderer)
	assert(Class.isDerived(widgetType, Widget), "widgetType must be Widget")
	assert(not self.renderers[widgetType], "widget renderer already exists")

	self.renderers[widgetType] = widgetRenderer
end

function WidgetRenderManager:getDefaultRenderer(widgetRenderer)
	return self.defaultRenderer
end

function WidgetRenderManager:setDefaultRenderer(widgetRenderer)
	self.defaultRenderer = widgetRenderer
end

function WidgetRenderManager:start()
	for _, renderer in pairs(self.renderers) do
		renderer:start()
	end

	if self.defaultRenderer then
		self.defaultRenderer:start()
	end

	self.hovered = {}

	do
		local mx, my = love.mouse.getPosition()
		self.topHovered = self.input:getWidgetUnderPoint(
			mx, my,
			0, 0, nil,
			function(w)
				return w:getIsFocusable() or w:getToolTip()
			end)
	end

	local currentTime = love.timer.getTime()
	for widget, time in self.input:getHoveredWidgets() do
		local duration = currentTime - time
		if duration >= WidgetRenderManager.TOOL_TIP_DURATION then
			self.hovered[widget] = false
		end
	end
end

function WidgetRenderManager:stop()
	if self.cursor.widget then
		love.graphics.push('all')
		love.graphics.translate(self.cursor.x, self.cursor.y)
		love.graphics.translate(love.mouse.getPosition())
		self:draw(self.cursor.widget, self.cursor.state, true)
		love.graphics.pop()
	end

	if self.toolTip then
		if self.toolTip:getDuration() < 0.5 then
			self.toolTip = false
		else
			love.graphics.push('all')
			self:draw(self.toolTip, {}, true)
			love.graphics.pop()
		end
	end

	for widget, toolTip in pairs(self.hovered) do
		if toolTip then
			love.graphics.push('all')
			love.graphics.translate(love.mouse.getPosition())
			self:draw(toolTip.w, toolTip.s, true)
			love.graphics.pop()
		end
	end

	for _, renderer in pairs(self.renderers) do
		renderer:stop()
	end

	if self.defaultRenderer then
		self.defaultRenderer:stop()
	end
end

function WidgetRenderManager:draw(widget, state, cursor)
	if widget == self.cursor.widget and not cursor then
		self.cursor.state = state
		return
	end

	if self.hovered[widget] ~= nil and widget:getToolTip() then
		if widget == self.topHovered then
			self.hovered[widget] = { w = ToolTip(widget:getToolTip()), s = state }
		else
			self.hovered[widget] = false
		end
	end

	if Class.isCompatibleType(widget, Interface) then
		state = widget:getState()
	end

	love.graphics.push('all')
	love.graphics.translate(widget:getPosition())

	local cornerX, cornerY = love.graphics.transformPoint(0, 0)
	if not widget:getOverflow() then
		local w, h = widget:getSize()
		if w > 0 and h > 0 then
			love.graphics.intersectScissor(cornerX, cornerY, w, h)
		end
	end

	local renderer = self:getRenderer(widget:getType()) or self.defaultRenderer
	if renderer then
		renderer:draw(widget, state)
	end

	local scrollX, scrollY = widget:getScroll()
	love.graphics.translate(-scrollX, -scrollY)

	self:drawChildren(widget, state, cursor)

	love.graphics.pop()
end

function WidgetRenderManager:drawChildren(widget, state, cursor)
	local c = {}
	for index, child in widget:iterate() do
		table.insert(c, {
			index = index,
			widget = child
		})
	end

	table.sort(c, function(a, b)
		local i = a.widget:getZDepth()
		local j = b.widget:getZDepth()
		if i < j then
			return true
		elseif i == j then
			return a.index < b.index
		end
	end)

	for i = 1, #c do
		self:draw(c[i].widget, state, cursor)
	end
end

return WidgetRenderManager
