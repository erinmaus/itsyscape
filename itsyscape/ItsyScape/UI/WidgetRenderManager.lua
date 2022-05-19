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
local DebugStats = require "ItsyScape.Graphics.DebugStats"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local ToolTip = require "ItsyScape.UI.ToolTip"

local WidgetRenderManager = Class()

WidgetRenderManager.DebugStats = Class(DebugStats)

function WidgetRenderManager.DebugStats:process(renderer, widget, state)
	renderer:draw(widget, state)
end

WidgetRenderManager.TOOL_TIP_DURATION = 0.5

function WidgetRenderManager:new(inputProvider)
	self.renderers = {}
	self.defaultRenderer = WidgetRenderer()
	self.cursor = { widget = false, state = {}, x = 0, y = 0 }
	self.input = inputProvider
	self.toolTips = {}
	self.debugStats = WidgetRenderManager.DebugStats()
end

function WidgetRenderManager:getDebugStats()
	return self.debugStats
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

		local mouseX, mouseY = love.graphics.getScaledPoint(love.mouse.getPosition())
		self.cursor.x = x - mouseX
		self.cursor.y = y - mouseY
	end
end

function WidgetRenderManager:setToolTip(duration, ...)
	local toolTip = ToolTip(...)
	toolTip:setDuration(duration or WidgetRenderManager.TOOL_TIP_DURATION)
	toolTip:setPosition(love.graphics.getScaledPoint(love.mouse.getPosition()))

	self.toolTips[toolTip] = true

	return toolTip
end

function WidgetRenderManager:unsetToolTip(toolTip)
	if toolTip then
		self.toolTips[toolTip] = nil
	end
end

function WidgetRenderManager:getToolTips()
	local toolTips = {}
	for toolTip in pairs(self.toolTips) do
		table.insert(toolTips, toolTip)
	end

	return toolTips
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
		local mx, my = love.graphics.getScaledPoint(love.mouse.getPosition())

		self.topHovered = self.input:getWidgetUnderPoint(
			mx, my,
			0, 0, nil,
			function(w)
				return w:getIsFocusable() or w:getToolTip()
			end)
	end

	do
		local _, _, sx, sy = love.graphics.getScaledMode()
		love.graphics.scale(sx, sy)
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
		love.graphics.translate(love.graphics.getScaledPoint(love.mouse.getPosition()))
		self:draw(self.cursor.widget, self.cursor.state, true)
		love.graphics.pop()
	end

	local toolTips = self:getToolTips()
	for i = 1, #toolTips do
		local toolTip = toolTips[i]

		if toolTip:getDuration() < 0.5 then
			self.toolTips[toolTip] = nil
		else
			love.graphics.push('all')
			self:draw(toolTip, {}, true)
			love.graphics.pop()
		end
	end

	for widget, toolTip in pairs(self.hovered) do
		if toolTip then
			love.graphics.push('all')
			love.graphics.translate(love.graphics.getScaledPoint(love.mouse.getPosition()))
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
			local _, _, scaleX, scaleY = love.graphics.getScaledMode()
			love.graphics.intersectScissor(cornerX, cornerY, w * scaleX, h * scaleY)
		end
	end

	local renderer = self:getRenderer(widget:getType()) or self.defaultRenderer
	if renderer then
		self.debugStats:measure(renderer, widget, state)
	end

	local scrollX, scrollY = widget:getScroll()
	love.graphics.translate(-scrollX, -scrollY)

	self:drawChildren(widget, state, cursor)

	love.graphics.pop()
end

function WidgetRenderManager:drawChildren(widget, state, cursor)
	for _, child in widget:zIterate() do
		self:draw(child, state, cursor)
	end
end

return WidgetRenderManager
