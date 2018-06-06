--------------------------------------------------------------------------------
-- ItsyScape/UI/WidgetRenderManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local Widget = require "ItsyScape.UI.Widget"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"

local WidgetRenderManager = Class()

function WidgetRenderManager:new()
	self.renderers = {}
	self.defaultRenderer = WidgetRenderer()
	self.cursor = { widget = false, state = {}, x = 0, y = 0 }
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

function WidgetRenderManager:hasRenderer(widgetType)
	return self:getRenderer(widgetType) ~= nil
end

function WidgetRenderManager:getRenderer(widgetType)
	return self.renderers[widgetType]
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
end

function WidgetRenderManager:stop()
	if self.cursor.widget then
		love.graphics.push('all')
		love.graphics.translate(self.cursor.x, self.cursor.y)
		love.graphics.translate(love.mouse.getPosition())
		self:draw(self.cursor.widget, self.cursor.state, true)
		love.graphics.pop()
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

	if Class.isCompatibleType(widget, Interface) then
		state = widget:getState()
	end

	love.graphics.push('all')
	love.graphics.translate(widget:getPosition())

	local cornerX, cornerY = love.graphics.transformPoint(0, 0)
	if not widget:getOverflow() then
		local w, h = widget:getSize()
		love.graphics.intersectScissor(cornerX, cornerY, w, h)
	end

	local renderer = self:getRenderer(widget:getType()) or self.defaultRenderer
	if renderer then
		renderer:draw(widget, state)
	end

	local scrollX, scrollY = widget:getScroll()
	love.graphics.translate(-scrollX, -scrollY)

	for _, child in widget:iterate() do
		self:draw(child, state)
	end

	love.graphics.pop()
end

return WidgetRenderManager
