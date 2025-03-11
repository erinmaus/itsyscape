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
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local InventoryGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.InventoryGamepadContentTab"

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

GamepadRibbon.TAB_BUTTON_SIZE = 64
GamepadRibbon.TAB_CONTAINER_WIDTH = 640
GamepadRibbon.TAB_CONTAINER_HEIGHT = GamepadRibbon.TAB_BUTTON_SIZE + GamepadRibbon.PADDING

GamepadRibbon.ACTIVE_TAB_STYLE = {
	inactive = "Resources/Game/UI/Buttons/ActiveRibbonTab-Default.png",
	hover = "Resources/Game/UI/Buttons/ActiveRibbonTab-Hover.png",
	pressed = "Resources/Game/UI/Buttons/ActiveRibbonTab-Pressed.png"
}

GamepadRibbon.INACTIVE_TAB_STYLE = {
	inactive = "Resources/Game/UI/Buttons/RibbonTab-Default.png",
	hover = "Resources/Game/UI/Buttons/RibbonTab-Hover.png",
	pressed = "Resources/Game/UI/Buttons/RibbonTab-Pressed.png"
}

function GamepadRibbon:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self:setData(GamepadSink, GamepadSink())

	self.activeTab = false
	self.tabButtons = {}

	self.container = GamepadRibbon.Container()
	self:addChild(self.container)

	local tabPanel = Panel()
	tabPanel:setSize(self.TAB_CONTAINER_WIDTH, self.TAB_CONTAINER_HEIGHT)
	self.container:addChild(tabPanel)

	self.tabLayout = GamepadGridLayout()
	self.tabLayout:setSize(self.TAB_CONTAINER_WIDTH, self.CONTENT_HEIGHT)
	self.tabLayout:setUniformSize(true, self.TAB_BUTTON_SIZE, self.TAB_BUTTON_SIZE)
	self.tabLayout:setPadding(0, 0)
	tabPanel:addChild(self.tabLayout)

	local contentPanel = Panel()
	contentPanel:setSize(self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	contentPanel:setPosition(self.TAB_CONTAINER_WIDTH / 2 -  self.CONTENT_WIDTH / 2, self.TAB_CONTAINER_HEIGHT)
	self.container:addChild(contentPanel)

	self.contentLayout = GridLayout()
	self.contentLayout:setSize(self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPadding(self.PADDING, self.PADDING)
	self.contentLayout:setUniformSize(true, self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPosition(
			self.TAB_CONTAINER_WIDTH / 2 - self.CONTENT_WIDTH / 2,
			self.TAB_CONTAINER_HEIGHT)
	self:addChild(self.contentLayout)

	self:setSize(
		math.max(self.CONTENT_WIDTH, self.CONTENT_WIDTH),
		self.TAB_CONTAINER_HEIGHT + self.CONTENT_HEIGHT)

	self:_initInventoryTab()
	self:_initEquipmentTab()
	self:_initSkillTab()
	self:_initSettingsTab()

	self:performLayout()
end

function GamepadRibbon:attach(reason)
	self:openTab("inventory")
	self:_openInventoryTab()
end

function GamepadRibbon:getOverflow()
	return true
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
		self.PADDING)
end

function GamepadRibbon:openTab(tab)
	self.contentLayout:clearChildren()

	local currentTabButton = self.tabButtons[self.currentTabName]
	if currentTabButton then
		currentTabButton:setStyle(ButtonStyle(self.INACTIVE_TAB_STYLE, self:getView():getResources()))
	end

	local nextTabButton = self.tabButtons[tab]
	if nextTabButton then
		nextTabButton:setStyle(ButtonStyle(self.ACTIVE_TAB_STYLE, self:getView():getResources()))
	end

	self.currentTabName = tab
end

function GamepadRibbon:_openInventoryTab()
	self.contentLayout:addChild(self.inventoryTabContent)
	self.inventoryTabContent:refresh(self:getState().inventory)
	self:focusChild(self.inventoryTabContent, "select")
end

function GamepadRibbon:_initInventoryTab()
	self.inventoryTabContent = InventoryGamepadContentTab(self)

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

function GamepadRibbon:_onSelectTab(tab, openFunc, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	if self.previousActiveTabButton then
		self.previousActiveTabButton:setStyle(ButtonStyle(self.INACTIVE_TAB_STYLE, self:getView():getResources()))
	end

	button:setStyle(ButtonStyle(self.ACTIVE_TAB_STYLE, self:getView():getResources()))
	self.previousActiveTabButton = button

	self:openTab(tab)

	if openFunc then
		openFunc(self)
	end

	self:sendPoke("openTab", nil, { tab = tab })
end

function GamepadRibbon:_addTab(tab, icon, openFunc)
	local button = Button()
	button:setID(string.format("Ribbon-%s", tab))
	button:setStyle(ButtonStyle(self.INACTIVE_TAB_STYLE, self:getView():getResources()))
	button.onClick:register(self._onSelectTab, tab, openFunc)

	local icon = Icon()
	icon:setIcon(icon)
	icon:setSize(self.TAB_BUTTON_SIZE, self.TAB_BUTTON_SIZE)
	button:addChild(icon)

	self.tabLayout:addChild(button)

	self.tabButtons[tab] = button
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

	local state = self:getState()
	self.inventoryTabContent:refresh(state.inventory)
end

return GamepadRibbon
