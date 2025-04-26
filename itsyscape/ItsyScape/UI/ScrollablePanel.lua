--------------------------------------------------------------------------------
-- ItsyScape/UI/Panel.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local Panel = require "ItsyScape.UI.Panel"
local ScrollBar = require "ItsyScape.UI.ScrollBar"
local Widget = require "ItsyScape.UI.Widget"

local ScrollablePanel = Class(Panel)
ScrollablePanel.DEFAULT_SCROLL_SIZE = 16

function ScrollablePanel:new(InnerPanelType)
	Panel.new(self)

	self.scrollBarSize = ScrollablePanel.DEFAULT_SCROLL_SIZE

	self.verticalScroll = ScrollBar()
	self.verticalScroll:setZDepth(2)
	self.verticalScrollOffset = 0
	self.horizontalScroll = ScrollBar()
	self.horizontalScroll:setZDepth(2)
	self.horizontalScrollOffset = 0
	self.panel = (InnerPanelType or Panel)()

	self.verticalScroll:setTarget(self.panel)
	self.horizontalScroll:setTarget(self.panel)
	self.isVerticalScroll = false
	self.isHorizontalScroll = false

	self.floatyScrollBars = _MOBILE
	self.alwaysShowVerticalScrollBar = false
	self.alwaysShowHorizontalScrollBar = false

	Widget.addChild(self, self.panel)
end

function ScrollablePanel:getInnerPanel()
	return self.panel
end

function ScrollablePanel:setSize(w, h)
	Widget.setSize(self, w, h)

	local panelWidth, panelHeight = self.panel:getSize()
	do
		if panelWidth == 0 then
			panelWidth = w
		end

		if panelHeight == 0 then
			panelHeight = h
		end
	end

	self.panel:setSize(panelWidth, panelHeight)
	self:performLayout()
end

function ScrollablePanel:setScrollSize(...)
	Widget.setScrollSize(self, ...)
	self.panel:setScrollSize(...)
end

function ScrollablePanel:getFloatyScrollBars()
	return self.floatyScrollBars
end

function ScrollablePanel:setFloatyScrollBars(value)
	self.floatyScrollBars = value or false
	self:performLayout()
end

function ScrollablePanel:setScrollBarVisible(vertical, horizontal)
	if vertical ~= nil then
		self.alwaysShowVerticalScrollBar = vertical
	end

	if horizontal ~= nil then
		self.alwaysShowHorizontalScrollBar = horizontal
	end

	self:performLayout()
end

function ScrollablePanel:setScrollBarOffset(vertical, horizontal)
	self.verticalScrollOffset = vertical or self.verticalScrollOffset
	self.horizontalScrollOffset = horizontal or self.horizontalScrollOffset
end

function ScrollablePanel:getScrollBarVisible()
	return self.alwaysShowVerticalScrollBar, self.alwaysShowHorizontalScrollBar
end

function ScrollablePanel:getScrollBar()
	return self.verticalScroll, self.horizontalScroll
end

function ScrollablePanel:getScrollBarActive()
	local width, height = self:getSize()
	local scrollSizeX, scrollSizeY = self:getScrollSize()

	return scrollSizeX > width, scrollSizeY > height
end

function ScrollablePanel:performLayout()
	Widget.performLayout(self)

	local width, height = self:getSize()
	local scrollSizeX, scrollSizeY = self:getScrollSize()

	local panelWidth, panelHeight = scrollSizeX, scrollSizeY
	if scrollSizeX > width or self.alwaysShowHorizontalScrollBar then
		if scrollSizeY > height then
			self.horizontalScroll:setSize(
				width - self.scrollBarSize - self.horizontalScrollOffset,
				self.scrollBarSize)
			self.horizontalScroll:setPosition(0, height - self.scrollBarSize)
		else
			self.horizontalScroll:setSize(
				width - self.horizontalScrollOffset,
				self.scrollBarSize)
			self.horizontalScroll:setPosition(0, height - self.scrollBarSize)
		end
		self.horizontalScroll:setPosition(self.horizontalScrollOffset, height - self.scrollBarSize)

		Widget.removeChild(self, self.horizontalScroll)
		Widget.addChild(self, self.horizontalScroll)
		self.horizontalScroll:performLayout()
		self.isHorizontalScroll = true

		if not self.floatyScrollBars then
			panelHeight = height - self.scrollBarSize
		end
	else
		Widget.removeChild(self, self.horizontalScroll)
		self.isHorizontalScroll = false
	end

	if scrollSizeY > height or self.alwaysShowVerticalScrollBar then
		if scrollSizeX > width then
			self.verticalScroll:setSize(
				self.scrollBarSize,
				height - self.scrollBarSize - self.verticalScrollOffset)
		else
			self.verticalScroll:setSize(
				self.scrollBarSize,
				height - self.verticalScrollOffset)
		end
		self.verticalScroll:setPosition(width - self.scrollBarSize - 4, self.verticalScrollOffset)

		Widget.removeChild(self, self.verticalScroll)
		Widget.addChild(self, self.verticalScroll)
		self.verticalScroll:performLayout()
		self.isVerticalScroll = true

		if not self.floatyScrollBars then
			panelWidth = width - self.scrollBarSize
		end
	else
		Widget.removeChild(self, self.verticalScroll)
		self.isVerticalScroll = false
	end

	self.panel:setSize(panelWidth, panelHeight)
	self.panel:performLayout()

	self:setScrollSize(self.panel:getSize())
end

function ScrollablePanel:getNumChildren()
	return self.panel:getNumChildren()
end

function ScrollablePanel:addChild(...)
	self.panel:addChild(...)
end

function ScrollablePanel:removeChild(...)
	self.panel:removeChild(...)
end

function ScrollablePanel:getChildAt(...)
	return self.panel:getChildAt(...)
end

function ScrollablePanel:mouseScroll(x, y)
	Widget.mouseScroll(self, x, y)

	if self.isVerticalScroll then
		self.verticalScroll:mouseScroll(x, y)
	end

	if self.isHorizontalScroll then
		self.horizontalScroll:mouseScroll(x, y)
	end
end

return ScrollablePanel
