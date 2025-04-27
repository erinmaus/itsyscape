--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/CraftCategoriesContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Vector = require "ItsyScape.Common.Math.Vector"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local CraftCategoriesContentTab = Class(GamepadContentTab)
CraftCategoriesContentTab.PADDING = 8
CraftCategoriesContentTab.ICON_SIZE = 48
CraftCategoriesContentTab.BUTTON_PADDING = 4

CraftCategoriesContentTab.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	inactive = "Resources/Game/UI/Buttons/Button-Default.png"
}

CraftCategoriesContentTab.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	inactive = "Resources/Game/UI/Buttons/Button-Default.png"
}

CraftCategoriesContentTab.CATEGORY_NAME_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true
}

function CraftCategoriesContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.onCategorySelected = Callback()

	self.scrollableLayout = ScrollablePanel(GamepadGridLayout)
	self.scrollableLayout:setSize(self:getSize())
	self.scrollableLayout:setScrollBarVisible(true)

	self.layout = self.scrollableLayout:getInnerPanel()
	self.layout:setWrapContents(true)
	self.layout:setSize(self:getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self:getSize() - self.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self.layout.onBlurChild:register(self._onBlurLayoutChild, self)
	self.layout.onFocusChild:register(self._onFocusLayoutChild, self)
	self.layout.onWrapFocus:register(self._onLayoutWrapFocus, self)
	self:addChild(self.scrollableLayout)

	self.layout:setID("CraftCategories")

	self.currentCategoryIndex = 1
	self.activeCategoryIndex = -1
end

function CraftCategoriesContentTab:getCurrentCategoryIndex()
	return self.currentCategoryIndex
end

function CraftCategoriesContentTab:setActiveCategoryIndex(value)
	if self.activeCategoryIndex >= 1 and self.activeCategoryIndex <= self.layout:getNumChildren() then
		local child = self.layout:getChildAt(self.activeCategoryIndex)
		child:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	if value >= 1 and value <= self.layout:getNumChildren() then
		local child = self.layout:getChildAt(value)
		child:setStyle(self.ACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	self.activeCategoryIndex = value
end

function CraftCategoriesContentTab:getActiveCategoryIndex()
	return self.activeCategoryIndex
end

function CraftCategoriesContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentCategoryIndex = child:getData("index") or 1
end

function CraftCategoriesContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function CraftCategoriesContentTab:_onClose()
	local toolTipParent = self.toolTip:getParent()
	if toolTipParent then
		toolTipParent:removeChild(self.toolTip)
	end
end

function CraftCategoriesContentTab:getIsFocusable()
	return true
end

function CraftCategoriesContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentCategoryIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function CraftCategoriesContentTab:_addCategoryButton()
	local index = self.layout:getNumChildren() + 1

	local button = Button()
	button:setData("index", index)
	button:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
	button.onClick:register(self.activate, self, index)

	local itemIcon = ItemIcon()
	itemIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	itemIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	button:addChild(itemIcon)
	button:setData("icon", itemIcon)

	local width = self:getSize()

	local categoryNameLabel = Label()
	categoryNameLabel:setStyle(self.CATEGORY_NAME_LABEL_STYLE, LabelStyle)
	categoryNameLabel:setPosition(self.ICON_SIZE + self.BUTTON_PADDING * 2, (self.ICON_SIZE - self.CATEGORY_NAME_LABEL_STYLE.fontSize) / 2)
	categoryNameLabel:setSize(
		width - self.ICON_SIZE - self.BUTTON_PADDING * 2,
		self.BUTTON_PADDING * 2 + self.ICON_SIZE)
	button:addChild(categoryNameLabel)
	button:setData("name", categoryNameLabel)

	self.scrollableLayout:addChild(button)
end

function CraftCategoriesContentTab:populate(count)
	local isDifferentSize = self.layout:getNumChildren() ~= count

	while self.layout:getNumChildren() > count do
		self.layout:removeChild(self.layout:getChildAt(self.layout:getNumChildren()))
	end

	while self.layout:getNumChildren() < count do
		self:_addCategoryButton()
	end

	self.layout:performLayout()
	self.scrollableLayout:setScrollSize(self.layout:getSize())

	if isDifferentSize then
		self:setActiveCategoryIndex(self.activeCategoryIndex)
	end
end

function CraftCategoriesContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:populate(#state.groups)

	for index, group in ipairs(state.groups) do
		local button = self.layout:getChildAt(index)

		local icon = button:getData("icon")
		icon:setItemID(group.itemIcon)

		local name = button:getData("name")
		name:setText(group.value)
	end
end

function CraftCategoriesContentTab:activate(index, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	self:onCategorySelected(index)
end

return CraftCategoriesContentTab
