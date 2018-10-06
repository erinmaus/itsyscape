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
local Widget = require "ItsyScape.UI.Widget"
local Panel = require "ItsyScape.UI.Panel"
local ScrollBar = require "ItsyScape.UI.ScrollBar"

local ScrollablePanel = Class(Panel)
ScrollablePanel.DEFAULT_SCROLL_SIZE = 48

function ScrollablePanel:new(InnerPanelType)
	Panel.new(self)

	self.scrollBarSize = ScrollablePanel.DEFAULT_SCROLL_SIZE

	self.verticalScroll = ScrollBar()
	self.verticalScroll:setZDepth(2)
	self.horizontalScroll = ScrollBar()
	self.horizontalScroll:setZDepth(2)
	self.panel = (InnerPanelType or Panel)()

	self.verticalScroll:setTarget(self.panel)
	self.horizontalScroll:setTarget(self.panel)
	self.isVerticalScroll = false
	self.isHorizontalScroll = false

	self.floatyScrollBars = false

	Widget.addChild(self, self.panel)
end

function ScrollablePanel:getInnerPanel()
	return self.panel
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

function ScrollablePanel:performLayout()
	Widget.performLayout(self)

	local width, height = self:getSize()
	local scrollSizeX, scrollSizeY = self:getScrollSize()

	local panelWidth, panelHeight = scrollSizeX, scrollSizeY
	if scrollSizeX > width then
		if scrollSizeY > height then
			self.horizontalScroll:setSize(
				width - self.scrollBarSize,
				self.scrollBarSize)
			self.horizontalScroll:setPosition(0, height - self.scrollBarSize)
		else
			self.horizontalScroll:setSize(
				width,
				self.scrollBarSize)
			self.horizontalScroll:setPosition(0, height - self.scrollBarSize)
		end

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

	if scrollSizeY > height then
		if scrollSizeX > width then
			self.verticalScroll:setSize(
				self.scrollBarSize,
				height - self.scrollBarSize)
			self.verticalScroll:setPosition(width - self.scrollBarSize - 4, 0)
		else
			self.verticalScroll:setSize(
				self.scrollBarSize,
				height)
			self.verticalScroll:setPosition(width - self.scrollBarSize - 4, 0)
		end

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
end

function ScrollablePanel:addChild(...)
	self.panel:addChild(...)
end

function ScrollablePanel:removeChild(...)
	self.panel:removeChild(...)
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
