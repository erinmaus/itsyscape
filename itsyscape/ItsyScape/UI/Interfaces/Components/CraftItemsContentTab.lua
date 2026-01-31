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
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local CraftItemsContentTab = Class(GamepadContentTab)

CraftItemsContentTab.OVERRIDE_BUTTON_LABEL_STYLE = Theme.override(
	Theme.BUTTON_LABEL_STYLE,
	{ padding = Theme.DEFAULT_INNER_PADDING })

function CraftItemsContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.onItemSelected = Callback()

	self.scrollableLayout = ScrollablePanel(GamepadGridLayout)
	self.scrollableLayout:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.HEIGHT))
	self.scrollableLayout:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)

	self.layout = self.scrollableLayout:getInnerPanel()
	self.layout:setWrapContents(true)
	self.layout:setSize(self.scrollableLayout:getSize(), 0)
	self.layout:setPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
	self.layout:setUniformSize(
		true,
		Theme.calculateInnerSize(Theme.DEFAULT_INNER_PADDING, self.scrollableLayout:getSize()),
		Theme.calculateInnerSize(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_ICON_SIZE))
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
		child:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	end

	if value >= 1 and value <= self.layout:getNumChildren() then
		local child = self.layout:getChildAt(value)
		child:setStyle(Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)
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
	button:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
	button.onClick:register(self.activate, self, index)

	local itemIcon = ItemIcon()
	itemIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	itemIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	button:addChild(itemIcon)
	button:setData("icon", itemIcon)

	local _, width = self.layout:getUniformSize()

	local itemNameLabel = Label()
	itemNameLabel:setStyle(self.OVERRIDE_BUTTON_LABEL_STYLE, LabelStyle)
	itemNameLabel:setPosition(Theme.DEFAULT_ICON_SIZE, 0)
	itemNameLabel:setSize(0, Theme.DEFAULT_BUTTON_SIZE)
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

	Theme.layoutScrollablePanelWithGridLayout(
		self.scrollableLayout,
		Theme.calculateInnerSize(Theme.DEFAULT_INNER_PADDING, self.scrollableLayout:getSize()),
		Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_ICON_SIZE))

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
