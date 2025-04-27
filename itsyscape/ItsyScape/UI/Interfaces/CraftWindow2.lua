--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/CraftWindow2.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Interface = require "ItsyScape.UI.Interface"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local CraftCategoriesContentTab = require "ItsyScape.UI.Interfaces.Components.CraftCategoriesContentTab"
local CraftItemsContentTab = require "ItsyScape.UI.Interfaces.Components.CraftItemsContentTab"
local CraftInfoContentTab = require "ItsyScape.UI.Interfaces.Components.CraftInfoContentTab"

local CraftWindow = Class(Interface)

CraftWindow.TITLE_HEIGHT = 128
CraftWindow.PADDING = 8

CraftWindow.CONTENT_WIDTH = GamepadContentTab.WIDTH * 2 + CraftWindow.PADDING * 3
CraftWindow.CONTENT_HEIGHT = GamepadContentTab.HEIGHT + CraftWindow.PADDING * 2

CraftWindow.CONTENT_LAYOUT_WIDTH = GamepadContentTab.WIDTH * 4 + CraftWindow.PADDING * 5

CraftWindow.WIDTH = CraftWindow.CONTENT_WIDTH
CraftWindow.HEIGHT = CraftWindow.TITLE_HEIGHT + CraftWindow.PADDING + CraftWindow.CONTENT_HEIGHT

CraftWindow.TITLE_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

CraftWindow.CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

CraftWindow.SCROLL_SPEED_UNITS = GamepadContentTab.WIDTH
CraftWindow.SCROLL_SPEED_DURATION = 0.25

function CraftWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setSize(self.WIDTH, self.HEIGHT)
	self:setData(GamepadSink, GamepadSink())

	self.titlePanel = Panel()
	self.titlePanel:setSize(self.WIDTH, self.TITLE_HEIGHT)
	self.titlePanel:setStyle(self.TITLE_PANEL_STYLE, PanelStyle)
	self:addChild(self.titlePanel)

	self.contentPanel = Panel()
	self.contentPanel:setSize(self.WIDTH, self.CONTENT_HEIGHT)
	self.contentPanel:setPosition(0, self.TITLE_HEIGHT)
	self.contentPanel:setStyle(self.CONTENT_PANEL_STYLE, PanelStyle)
	self.contentPanel:setScrollSize(self.CONTENT_LAYOUT_WIDTH, self.CONTENT_HEIGHT)
	self:addChild(self.contentPanel)

	self.contentLayout = GridLayout()
	self.contentLayout:setSize(self.CONTENT_LAYOUT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPadding(self.PADDING, 0)
	self.contentLayout:setUniformSize(true, GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT)
	self.contentLayout:setPosition((self.WIDTH - self.CONTENT_WIDTH) / 2, self.PADDING)
	self.contentPanel:addChild(self.contentLayout)

	self.craftCategoriesContentTab = CraftCategoriesContentTab(self)
	self.craftCategoriesContentTab.onCategorySelected:register(self.onSelectCategory, self)

	self.craftItemsContentTab = CraftItemsContentTab(self)
	self.craftItemsContentTab.onGamepadRelease:register(
		self.onBack,
		self,
		self.craftCategoriesContentTab)

	self.craftInfoContentTab = CraftInfoContentTab(self)

	self.contentLayout:addChild(self.craftCategoriesContentTab)
	self.contentLayout:addChild(self.craftItemsContentTab)
	self.contentLayout:addChild(self.craftInfoContentTab)

	self:performLayout()

	self.contentLayoutTargetScrollX = 0
end

function CraftWindow:onBack(tab, _, joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if button == inputProvider:getKeybind("gamepadBack") then
			self.contentLayoutTargetScrollX = tab:getPosition()
			self:focusChild(tab)
		end
	end
end

function CraftWindow:onSelectCategory(_, categoryIndex)
	self.craftCategoriesContentTab:setActiveCategoryIndex(categoryIndex)

	self.contentLayoutTargetScrollX = self.craftItemsContentTab:getPosition()

	self:focusChild(self.craftItemsContentTab)

	self.currentCraftItemIndex = -1
end

function CraftWindow:attach()
	Interface.attach(self)

	self:tick()
	self:focusChild(self.craftCategoriesContentTab)
end

function CraftWindow:performLayout()
	Interface.performLayout(self)

	local width, height = itsyrealm.graphics.getScaledMode()
	local selfWidth, selfHeight = self:getSize()
	self:setPosition((width - selfWidth) / 2, (height - selfHeight) / 2)
end

function CraftWindow:tick()
	Interface.tick(self)

	local state = self:getState()
	self.craftCategoriesContentTab:refresh(state)
	self.craftItemsContentTab:refresh(state.groups[self.craftCategoriesContentTab:getCurrentCategoryIndex()] or {})
end

function CraftWindow:update(delta)
	Interface.update(self, delta)

	local currentScrollX, currentScrollY = self.contentLayout:getScroll()
	local scrollOffsetX = delta * (self.SCROLL_SPEED_UNITS / self.SCROLL_SPEED_DURATION)

	if self.contentLayoutTargetScrollX < currentScrollX then
		currentScrollX = math.max(currentScrollX - scrollOffsetX, self.contentLayoutTargetScrollX)
	elseif self.contentLayoutTargetScrollX > currentScrollX then
		currentScrollX = math.min(currentScrollX + scrollOffsetX, self.contentLayoutTargetScrollX)
	end

	self.contentLayout:setScroll(currentScrollX, currentScrollY)

	if self.currentCraftItemIndex ~= self.craftItemsContentTab:getCurrentItemIndex() then
		self.currentCraftItemIndex = self.craftItemsContentTab:getCurrentItemIndex()

		local categoryIndex = self.craftCategoriesContentTab:getCurrentCategoryIndex()
		local state = self:getState()
		local items = state.groups[categoryIndex]
		local item = items and items[self.currentCraftItemIndex]

		if item then
			self.craftInfoContentTab:refresh(item)
		end
	end
end

return CraftWindow
