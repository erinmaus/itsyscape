--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/GamepadRibbon.lua
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
local Equipment = require "ItsyScape.Game.Equipment"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local InventoryGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.InventoryGamepadContentTab"
local ItemInfoGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.ItemInfoGamepadContentTab"

local GamepadRibbon = Class(Interface)

GamepadRibbon.Container = Class(Widget)

function GamepadRibbon.Container:getOverflow()
	return true
end

GamepadRibbon.TOOL_TIPS = {
	["inventory"] = {
		ToolTip.Header("Inventory"),
		ToolTip.Text("See the items you are currently carrying.")
	},
	["equipment"] = {
		ToolTip.Header("Equipment"),
		ToolTip.Text("View, interact with, and remove your equipment."),
		ToolTip.Text("You can also see your equipment bonuses.")
	},
	["skills"] = {
		ToolTip.Header("Skills"),
		ToolTip.Text("View your skills and see helpful skill guides.")
	},
	["settings"] = {
		ToolTip.Header("Settings"),
		ToolTip.Text("Show settings and quit the game.")
	}
}

GamepadRibbon.PADDING = 8

GamepadRibbon.CONTENT_WIDTH = GamepadContentTab.WIDTH * 2 + GamepadRibbon.PADDING * 3
GamepadRibbon.CONTENT_HEIGHT = GamepadContentTab.HEIGHT + GamepadRibbon.PADDING * 2

GamepadRibbon.RIBBON_LOGO_SIZE = 32

GamepadRibbon.TAB_BUTTON_SIZE = 64
GamepadRibbon.TAB_CONTAINER_WIDTH = 640
GamepadRibbon.TAB_CONTAINER_HEIGHT = 128

GamepadRibbon.TITLE_ROW_HEIGHT = 26

GamepadRibbon.WINDOW_WIDTH = GamepadRibbon.TAB_CONTAINER_WIDTH
GamepadRibbon.WINDOW_HEIGHT = GamepadRibbon.CONTENT_HEIGHT + GamepadRibbon.TITLE_ROW_HEIGHT

GamepadRibbon.ACTIVE_TAB_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ActiveRibbonTab-Default.png",
	hover = "Resources/Game/UI/Buttons/ActiveRibbonTab-Hover.png",
	pressed = "Resources/Game/UI/Buttons/ActiveRibbonTab-Pressed.png"
}

GamepadRibbon.INACTIVE_TAB_BUTTON_STYLE = {
	inactive = "Resources/Game/UI/Buttons/RibbonTab-Default.png",
	hover = "Resources/Game/UI/Buttons/RibbonTab-Hover.png",
	pressed = "Resources/Game/UI/Buttons/RibbonTab-Pressed.png"
}

GamepadRibbon.TAB_CONTAINER_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowTitle.png"
}

GamepadRibbon.CONTENT_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowContent.png"
}

function GamepadRibbon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setData(GamepadSink, GamepadSink())

	self.activeTab = false
	self.tabButtons = {}
	self.tabFuncs = {}

	self.previousFocusedContent = false

	self.container = GamepadRibbon.Container()
	self:addChild(self.container)

	self.tabPanel = Panel()
	self.tabPanel:setSize(self.TAB_CONTAINER_WIDTH, self.TAB_CONTAINER_HEIGHT)
	self.tabPanel:setStyle(PanelStyle(self.TAB_CONTAINER_PANEL_STYLE, self:getView():getResources()))
	self.container:addChild(self.tabPanel)

	local ribbonIcon = Icon()
	ribbonIcon:setIcon("Resources/Game/UI/Icons/Logo.png")
	ribbonIcon:setSize(self.RIBBON_LOGO_SIZE, self.RIBBON_LOGO_SIZE)
	ribbonIcon:setPosition(self.PADDING, self.PADDING + self.PADDING / 2)
	self.tabPanel:addChild(ribbonIcon)

	local ribbonLabel = Label()
	ribbonLabel:setText("Ribbon")
	ribbonLabel:setStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = self.RIBBON_LOGO_SIZE,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, LabelStyle)
	ribbonLabel:setPosition(self.RIBBON_LOGO_SIZE + self.PADDING * 2, self.PADDING / 2)
	self.tabPanel:addChild(ribbonLabel)

	self.tabLayout = GamepadGridLayout()
	self.tabLayout:setSize(self.TAB_CONTAINER_WIDTH, self.CONTENT_HEIGHT)
	self.tabLayout:setUniformSize(true, self.TAB_BUTTON_SIZE, self.TAB_BUTTON_SIZE)
	self.tabLayout:setPadding(0, 0)
	self.tabLayout.onWrapFocus:register(self._onTabWrapFocus, self)
	self.tabPanel:addChild(self.tabLayout)

	self.contentPanel = Panel()
	self.contentPanel:setSize(self.WINDOW_WIDTH, self.WINDOW_HEIGHT)
	self.contentPanel:setPosition(self.TAB_CONTAINER_WIDTH / 2 -  self.WINDOW_WIDTH / 2, self.TAB_CONTAINER_HEIGHT)
	self.contentPanel:setStyle(PanelStyle(self.CONTENT_PANEL_STYLE, self:getView():getResources()))
	self.container:addChild(self.contentPanel)

	self.titleLabel = Label()
	self.titleLabel:setStyle({
		font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
		fontSize = self.TITLE_ROW_HEIGHT,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, LabelStyle)
	self.titleLabel:setPosition(self.PADDING, 0)
	self.contentPanel:addChild(self.titleLabel)

	self.contentLayout = GridLayout()
	self.contentLayout:setSize(self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPadding(self.PADDING, self.PADDING)
	self.contentLayout:setUniformSize(true, GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT)
	self.contentLayout:setPosition(
			self.TAB_CONTAINER_WIDTH / 2 - self.CONTENT_WIDTH / 2,
			self.TAB_CONTAINER_HEIGHT + self.TITLE_ROW_HEIGHT)
	self:addChild(self.contentLayout)

	self:setSize(
		self.WINDOW_WIDTH,
		self.TAB_CONTAINER_HEIGHT + self.WINDOW_HEIGHT)

	self:_initInventoryTab()
	self:_initEquipmentTab()
	self:_initSkillTab()
	self:_initSettingsTab()

	self.ribbonKeybindInfo = GamepadToolTip()
	self.ribbonKeybindInfo:setHasBackground(false)
	self.ribbonKeybindInfo:setKeybind("gamepadOpenRibbon")
	self.ribbonKeybindInfo:setText("Close")
	self:addChild(self.ribbonKeybindInfo)

	self.secondaryKeybindInfo = GamepadToolTip()
	self.secondaryKeybindInfo:setHasBackground(false)
	self.secondaryKeybindInfo:setKeybind("gamepadSecondaryAction")

	self.tertiaryKeybindInfo = GamepadToolTip()
	self.tertiaryKeybindInfo:setHasBackground(false)
	self.tertiaryKeybindInfo:setKeybind("gamepadTertiaryAction")

	self:performLayout()
	self.isDirty = false
end

function GamepadRibbon:attach(reason)
	self:openTab("inventory")
end

function GamepadRibbon:getOverflow()
	return true
end

function GamepadRibbon:_onTabWrapFocus(_, _, directionX, directionY)
	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if directionY > 0 then
		local child = self.previousFocusedContent or self.contentLayout:getChildAt(1)
		if child then
			inputProvider:setFocusedWidget(child, "select")
		end

		self.previousFocusedContent = false
	end
end

function GamepadRibbon:_onContentWrapFocus(content, directionX, directionY)
	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if directionY < 0 then
		inputProvider:setFocusedWidget(self.tabLayout, "select")
		self.previousFocusedContent = content
	elseif directionX ~= 0 then
		local focusedWidget = inputProvider:getFocusedWidget()

		if focusedWidget then
			local index

			for i, widget in self.contentLayout:iterate() do
				if focusedWidget:hasParent(widget) or focusedWidget == widget then
					index = i
					break
				end
			end

			if index then
				local newIndex = math.wrapIndex(index, math.zerosign(directionX), self.contentLayout:getNumChildren())
				local child = self.contentLayout:getChildAt(newIndex)
				if child and child:getIsFocusable() then
					inputProvider:setFocusedWidget(child, "select")
				end
			end
		end
	end
end

function GamepadRibbon:performLayout()
	local width, height = itsyrealm.graphics.getScaledMode()
	local selfWidth, selfHeight = self:getSize()
	self:setPosition(
		width / 2 - selfWidth / 2,
		height / 2 - selfHeight / 2)

	local numChildren = self.tabLayout:getNumChildren()
	local _, tabWidth, tabHeight = self.tabLayout:getUniformSize()
	local _, tabPaddingX, tabPaddingY = self.tabLayout:getPadding()

	local physicalTabLayoutWidth = numChildren * (tabWidth + tabPaddingX) + tabPaddingX
	self.tabLayout:setPosition(
		self.TAB_CONTAINER_WIDTH / 2 - physicalTabLayoutWidth / 2,
		self.TAB_CONTAINER_HEIGHT - tabHeight)

	local ribbonKeybindWidth, ribbonKeybindHeight = self.ribbonKeybindInfo:getSize()
	local secondaryKeybindWidth, secondaryKeybindHeight = self.secondaryKeybindInfo:getSize()
	local tertiaryKeybindWidth, tertiaryKeybindHeight = self.tertiaryKeybindInfo:getSize()
	local width = math.max(secondaryKeybindWidth, tertiaryKeybindWidth)

	self.ribbonKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - width - self.PADDING,
		0)

	self.secondaryKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - width - self.PADDING,
		ribbonKeybindHeight)

	self.tertiaryKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - width - self.PADDING,
		ribbonKeybindHeight + secondaryKeybindHeight)
end

function GamepadRibbon:openTab(tab)
	self.contentLayout:clearChildren()

	local currentTabButton = self.tabButtons[self.currentTabName]
	if currentTabButton then
		currentTabButton:setStyle(ButtonStyle(self.INACTIVE_TAB_BUTTON_STYLE, self:getView():getResources()))
	end

	local nextTabButton = self.tabButtons[tab]
	if nextTabButton then
		nextTabButton:setStyle(ButtonStyle(self.ACTIVE_TAB_BUTTON_STYLE, self:getView():getResources()))
	end

	self.currentTabName = tab

	local openFunc = self.tabFuncs[tab]
	if openFunc then
		openFunc(self)
	end

	self:sendPoke("openTab", nil, { tab = tab })

	self.isDirty = true
end

function GamepadRibbon:_setKeybindInfo(secondary, tertiary)
	if secondary then
		self.secondaryKeybindInfo:setText(secondary)
		self.secondaryKeybindInfo:performLayout()

		if self.secondaryKeybindInfo:getParent() ~= self then
			self:addChild(self.secondaryKeybindInfo)
		end
	else
		if self.secondaryKeybindInfo:getParent() == self then
			self:removeChild(self.secondaryKeybindInfo)
		end
	end

	if tertiary then
		self.tertiaryKeybindInfo:setText(tertiary)
		self.tertiaryKeybindInfo:performLayout()

		if self.tertiaryKeybindInfo:getParent() ~= self then
			self:addChild(self.tertiaryKeybindInfo)
		end
	else
		if self.tertiaryKeybindInfo:getParent() == self then
			self:removeChild(self.tertiaryKeybindInfo)
		end
	end
end

function GamepadRibbon:_openInventoryTab()
	self.contentLayout:addChild(self.inventoryTabContent)
	self.contentLayout:addChild(self.itemInfoContent)
	self:focusChild(self.inventoryTabContent, "select")

	self.titleLabel:setText("Inventory")
	self:_setKeybindInfo("More options", "Swap")
end

function GamepadRibbon:_updateInventoryTab()
	local state = self:getState()

	self.inventoryTabContent:refresh(state.inventory)

	local index = self.inventoryTabContent:getCurrentInventorySlotIndex()
	local item = state.inventory.items[index]
	local otherItem
	if item then
		local slot
		if item.slot == Equipment.PLAYER_SLOT_TWO_HANDED then
			slot = Equipment.PLAYER_SLOT_RIGHT_HANDED
		else
			slot = item.slot
		end

		otherItem = state.equipment.items[slot]
	end

	self.itemInfoContent:refresh({ item = item, otherItem = otherItem })
end

function GamepadRibbon:_initInventoryTab()
	self.inventoryTabContent = InventoryGamepadContentTab(self)
	self.inventoryTabContent.onWrapFocus:register(self._onContentWrapFocus, self)

	self.itemInfoContent = ItemInfoGamepadContentTab(self)

	self:_addTab(
		"inventory",
		"Resources/Game/UI/Icons/Common/Inventory.png",
		self._openInventoryTab)
end

function GamepadRibbon:_initEquipmentTab()
	self:_addTab("equipment", "Resources/Game/UI/Icons/Common/Equipment.png")
end

function GamepadRibbon:_initSkillTab()
	self:_addTab("skills", "Resources/Game/UI/Icons/Common/Skills.png")
end

function GamepadRibbon:_initSettingsTab()
	self:_addTab("settings", "Resources/Game/UI/Icons/Concepts/Settings.png")
end

function GamepadRibbon:_onSelectTab(tab, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	self:openTab(tab)
end

function GamepadRibbon:_addTab(tab, iconFilename, openFunc)
	local button = Button()
	button:setID(string.format("Ribbon-%s", tab))
	button:setStyle(ButtonStyle(self.INACTIVE_TAB_BUTTON_STYLE, self:getView():getResources()))
	button.onClick:register(self._onSelectTab, tab)

	local icon = Icon()
	icon:setIcon(iconFilename)
	icon:setSize(self.TAB_BUTTON_SIZE - self.PADDING * 2, self.TAB_BUTTON_SIZE - self.PADDING * 2)
	icon:setPosition(self.PADDING, self.PADDING)
	button:addChild(icon)

	self.tabLayout:addChild(button)

	self.tabButtons[tab] = button
	self.tabFuncs[tab] = openFunc
end

function GamepadRibbon:activate(tab, isTabButton)
	if self.activeButton then
		self.activeButton:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/GamepadRibbon-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/GamepadRibbon-Hover.9.png",
			pressed = "Resources/Renderers/Widget/Button/GamepadRibbon-Pressed.9.png",
			icon = { filename = self.icons[self.activeButton], x = 0.5, y = 0.5 }
		}, self:getView():getResources()))
	end

	self.activeButton = false

	local button = self.buttons[tab]
	if button and not isTabButton then
		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/GamepadRibbon-Pressed.9.png",
			hover = "Resources/Renderers/Widget/Button/GamepadRibbon-Pressed.9.png",
			pressed = "Resources/Renderers/Widget/Button/GamepadRibbon-Pressed.9.png",
			icon = { filename = self.icons[button], x = 0.5, y = 0.5 }
		}, self:getView():getResources()))

		self.activeButton = button
	end
end

function GamepadRibbon:update(delta)
	Interface.update(self, delta)

	self:_updateInventoryTab()

	if self.isDirty then
		self:performLayout()
		self.isDirty = false
	end
end

return GamepadRibbon
