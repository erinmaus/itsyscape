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
			end,
			true)
	end

	do
		local _, _, sx, sy = love.graphics.getScaledMode()
		itsyrealm.graphics.scale(sx, sy)
	end

	local currentTime = love.timer.getTime()
	for widget, time in self.input:getHoveredWidgets() do
		local duration = currentTime - time
		if duration >= WidgetRenderManager.TOOL_TIP_DURATION then
			self.hovered[widget] = false
		end
	end

	itsyrealm.graphics.clearPseudoScissor()
end

function WidgetRenderManager:stop()
	local mouseX, mouseY = love.graphics.getScaledPoint(love.mouse.getPosition())
	if self.cursor.widget then
		itsyrealm.graphics.translate(self.cursor.x, self.cursor.y)
		itsyrealm.graphics.translate(mouseX, mouseY)
		self:draw(self.cursor.widget, self.cursor.state, true)
		itsyrealm.graphics.translate(-self.cursor.x, -self.cursor.y)
		itsyrealm.graphics.translate(-mouseX, -mouseY)
	end

	local toolTips = self:getToolTips()
	for i = 1, #toolTips do
		local toolTip = toolTips[i]

		if toolTip:getDuration() < 0.5 then
			self.toolTips[toolTip] = nil
		else
			self:draw(toolTip, {}, true)
		end
	end

	for widget, toolTip in pairs(self.hovered) do
		if toolTip then
			itsyrealm.graphics.translate(mouseX, mouseY)
			self:draw(toolTip.w, toolTip.s, true)
			itsyrealm.graphics.translate(-mouseX, -mouseY)
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
	do
		local _, _, w, h = itsyrealm.graphics.getPseudoScissor()

		if (w == 0 or h == 0) and not (widget:getParent() and widget:getParent():getOverflow()) then
			return
		end
	end

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

	local widgetX, widgetY = widget:getPosition()

	itsyrealm.graphics.translate(widgetX, widgetY)

	local pushedScissor = false

	local cornerX, cornerY = itsyrealm.graphics.transformPoint(0, 0)
	if not widget:getOverflow() then
		local w, h = widget:getSize()
		if w > 0 and h > 0 then
			pushedScissor = true

			local _, _, scaleX, scaleY = love.graphics.getScaledMode()
			itsyrealm.graphics.intersectPseudoScissor(cornerX, cornerY, w * scaleX, h * scaleY)
		end

		local sw, sh = widget:getScrollSize()
		local sx, sy = widget:getScroll()
		if sw > w or sh > h or sx > 0 or sy > 0 then
			itsyrealm.graphics.applyPseudoScissor()
		end
	end

	local renderer = self:getRenderer(widget:getType()) or self.defaultRenderer
	if renderer then
		local _, _, w, h = itsyrealm.graphics.getPseudoScissor()

		if (w > 0 and h > 0) or widget:getOverflow() then
			self.debugStats:measure(renderer, widget, state)
		end
	end

	local scrollX, scrollY = widget:getScroll()
	itsyrealm.graphics.translate(-scrollX, -scrollY)

	self:drawChildren(widget, state, cursor)

	if not widget:getOverflow() and pushedScissor then
		local w, h = widget:getSize()
		if w > 0 and h > 0 then
			pop = true
			itsyrealm.graphics.popPseudoScissor()
		end

		local sw, sh = widget:getScrollSize()
		local sx, sy = widget:getScroll()
		if sw > w or sh > h or sx > 0 or sy > 0 then
			itsyrealm.graphics.resetPseudoScissor()
		end
	end

	itsyrealm.graphics.translate(scrollX, scrollY)
	itsyrealm.graphics.translate(-widgetX, -widgetY)
end

function WidgetRenderManager:drawChildren(widget, state, cursor)
	for _, child in widget:zIterate() do
		self:draw(child, state, cursor)
	end
end

return WidgetRenderManager
