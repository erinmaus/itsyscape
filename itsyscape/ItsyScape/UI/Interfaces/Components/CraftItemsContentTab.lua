--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/CraftItemsContentTab.lua
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

local CraftItemsContentTab = Class(GamepadContentTab)
CraftItemsContentTab.PADDING = 8
CraftItemsContentTab.ICON_SIZE = 48
CraftItemsContentTab.BUTTON_PADDING = 4

CraftItemsContentTab.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	inactive = "Resources/Game/UI/Buttons/Button-Default.png"
}

CraftItemsContentTab.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	inactive = "Resources/Game/UI/Buttons/Button-Default.png"
}

CraftItemsContentTab.ITEM_NAME_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 18,
	center = true,
	textShadow = true
}

function CraftItemsContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.onItemSelected = Callback()

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

	self.layout:setID("CraftCategoryItems")

	self.currentItemIndex = 1
	self.activeItemIndex = -1
end

function CraftItemsContentTab:getCurrentItemIndex()
	return self.currentItemIndex
end

function CraftItemsContentTab:setActiveItemIndex(value)
	if self.activeItemIndex >= 1 and self.activeItemIndex <= self.layout:getNumChildren() then
		local child = self.layout:getChildAt(self.activeItemIndex)
		child:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	if value >= 1 and value <= self.layout:getNumChildren() then
		local child = self.layout:getChildAt(value)
		child:setStyle(self.ACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	self.activeItemIndex = value
end

function CraftItemsContentTab:getActiveItemIndex()
	return self.activeItemIndex
end

function CraftItemsContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentItemIndex = child:getData("index") or 1
end

function CraftItemsContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function CraftItemsContentTab:_onClose()
	local toolTipParent = self.toolTip:getParent()
	if toolTipParent then
		toolTipParent:removeChild(self.toolTip)
	end
end

function CraftItemsContentTab:getIsFocusable()
	return true
end

function CraftItemsContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentItemIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function CraftItemsContentTab:_addItemButton()
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

	local _, width = self.layout:getUniformSize()

	local itemNameLabel = Label()
	itemNameLabel:setStyle(self.ITEM_NAME_LABEL_STYLE, LabelStyle)
	itemNameLabel:setPosition(
		self.ICON_SIZE + self.BUTTON_PADDING * 2,
		0)
	itemNameLabel:setSize(
		width - self.ICON_SIZE - self.BUTTON_PADDING * 3,
		self.BUTTON_PADDING * 2 + self.ICON_SIZE)
	button:addChild(itemNameLabel)
	button:setData("name", itemNameLabel)

	self.scrollableLayout:addChild(button)
end

function CraftItemsContentTab:populate(count)
	local isDifferentSize = self.layout:getNumChildren() ~= count

	while self.layout:getNumChildren() > count do
		self.layout:removeChild(self.layout:getChildAt(self.layout:getNumChildren()))
	end

	while self.layout:getNumChildren() < count do
		self:_addItemButton()
	end

	self.layout:performLayout()
	self.scrollableLayout:setScrollSize(self.layout:getSize())

	if isDifferentSize then
		self:setActiveItemIndex(self.activeItemIndex)
	end
end

function CraftItemsContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:populate(#state.group)

	for index, resource in ipairs(state.group) do
		local button = self.layout:getChildAt(index)

		local icon = button:getData("icon")
		icon:setItemID(resource.item.id)
		icon:setItemCount(resource.count)
		icon:setIsDisabled(not resource.canPerformAction)

		local name = button:getData("name")
		name:setText(resource.item.name)
	end

	if self.currentCategoryIndex ~= state.index then
		self.layout:setScroll(0, 0)
		self.currentCategoryIndex = state.index
	end
end

function CraftItemsContentTab:activate(index, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	self:onItemSelected(index)
end

return CraftItemsContentTab
