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
local InputScheme = require "ItsyScape.UI.InputScheme"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ConfigGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.ConfigGamepadContentTab"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local EquipmentGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.EquipmentGamepadContentTab"
local InventoryGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.InventoryGamepadContentTab"
local ItemInfoGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.ItemInfoGamepadContentTab"
local SkillInfoContentTab = require "ItsyScape.UI.Interfaces.Components.SkillInfoContentTab"
local SkillsGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.SkillsGamepadContentTab"
local SkillGuideContentTab = require "ItsyScape.UI.Interfaces.Components.SkillGuideContentTab"
local SkillGuideInfoContentTab = require "ItsyScape.UI.Interfaces.Components.SkillGuideInfoContentTab"

local GamepadRibbon = Class(Interface)

GamepadRibbon.Container = Class(Widget)

function GamepadRibbon.Container:getOverflow()
	return true
end

GamepadRibbon.TAB_PLAYER_INVENTORY = "PlayerInventory"
GamepadRibbon.TAB_PLAYER_EQUIPMENT = "PlayerEquipment"
GamepadRibbon.TAB_PLAYER_SKILLS    = "PlayerSkills"
GamepadRibbon.TAB_SETTINGS         = "Settings"

GamepadRibbon.TOOL_TIPS = {
	[GamepadRibbon.TAB_PLAYER_INVENTORY] = {
		ToolTip.Header("Inventory"),
		ToolTip.Text("See the items you are currently carrying.")
	},
	[GamepadRibbon.TAB_PLAYER_EQUIPMENT] = {
		ToolTip.Header("Equipment"),
		ToolTip.Text("View, interact with, and remove your equipment."),
		ToolTip.Text("You can also see your equipment bonuses.")
	},
	[GamepadRibbon.TAB_PLAYER_SKILLS] = {
		ToolTip.Header("Skills"),
		ToolTip.Text("View your skills and see helpful skill guides.")
	},
	[GamepadRibbon.TAB_SETTINGS] = {
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

	self.isShowing = false
	self.isHiding = false
	self.currentTabName = false
	self.tabButtons = {}
	self.tabFuncs = {}
	self.tabs = {}

	self.previousFocusedContent = false

	self.container = GamepadRibbon.Container()

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

	self.contentLayoutWrapper = Widget()
	self.contentLayoutWrapper:setSize(self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayoutWrapper:setPosition(
			self.TAB_CONTAINER_WIDTH / 2 - self.CONTENT_WIDTH / 2,
			self.TAB_CONTAINER_HEIGHT + self.TITLE_ROW_HEIGHT)
	self.container:addChild(self.contentLayoutWrapper)

	self.contentLayout = GamepadGridLayout()
	self.contentLayout:setWrapScroll(false)
	self.contentLayout:setSize(self.CONTENT_WIDTH, self.CONTENT_HEIGHT)
	self.contentLayout:setPadding(self.PADDING, self.PADDING)
	self.contentLayout:setUniformSize(true, GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT)
	self.contentLayoutWrapper:addChild(self.contentLayout)

	self:setSize(
		self.WINDOW_WIDTH,
		self.TAB_CONTAINER_HEIGHT + self.WINDOW_HEIGHT)

	self:_initInventoryTab()
	self:_initEquipmentTab()
	self:_initSkillTab()
	self:_initSettingsTab()

	self.ribbonKeybindInfo = GamepadToolTip()
	self.ribbonKeybindInfo:setHasBackground(false)
	self.ribbonKeybindInfo:setControl("openRibbon")
	self.ribbonKeybindInfo:setText("Close")
	self.container:addChild(self.ribbonKeybindInfo)

	self.secondaryKeybindInfo = GamepadToolTip()
	self.secondaryKeybindInfo:setHasBackground(false)
	self.secondaryKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "gamepadSecondaryAction")
	self.secondaryKeybindInfo:setButtonID(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, false)

	self.tertiaryKeybindInfo = GamepadToolTip()
	self.tertiaryKeybindInfo:setHasBackground(false)
	self.tertiaryKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, "gamepadTertiaryAction")
	self.tertiaryKeybindInfo:setButtonID(GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD, false)

	self:performLayout()
	self.isDirty = false

	self.contentLayoutTargetScrollX = 0

	self.combinedState = {}
end

function GamepadRibbon:restoreFocus()
	self:_openOrClose()
end

function GamepadRibbon:gamepadRelease(joystick, button)
	Interface.gamepadRelease(self, joystick, button)

	local inputProvider = self:getInputProvider()
	if not (inputProvider and inputProvider:isCurrentJoystick(joystick)) then
		return
	end

	local currentTabIndex = self:_getTabIndex(self.currentTabName)
	if not currentTabIndex then
		return
	end

	local offset
	if button == inputProvider:getKeybind("gamepadNext") then
		offset = 1
	elseif button == inputProvider:getKeybind("gamepadPrevious") then
		offset = -1
	end

	if offset then
		local index = math.wrapIndex(currentTabIndex, offset, #self.tabs)

		local currentFocusedWidget = inputProvider:getFocusedWidget()

		inputProvider:setFocusedWidget(self.tabLayout:getChildAt(index), "select")
		self:openTab (self.tabs[index])

		if not currentFocusedWidget:hasParent(self.tabLayout) then
			local child = self.contentLayout:getChildAt(1)
			inputProvider:setFocusedWidget(child or self.tabLayout, "select")
		end
	end
end

function GamepadRibbon:hide()
	self.isHiding = true
	self:_openOrClose()
end

function GamepadRibbon:show()
	self.isHiding = false
	self:_openOrClose()
end

function GamepadRibbon:_openOrClose()
	local inputProvider = self:getInputProvider()
	if self.isShowing and not self.isHiding then
		self:addChild(self.container)

		self.contentLayout:focus()
	else
		local focusedWidget = inputProvider:getFocusedWidget()
		if focusedWidget and focusedWidget:hasParent(self) then
			inputProvider:setFocusedWidget(nil, "close")
		end

		self:removeChild(self.container)
		self:getView():removeFromFocusStack(self)
	end
end

function GamepadRibbon:toggle()
	if self.isHiding then
		return
	end

	self.isShowing = not self.isShowing
	if self.isShowing then
		self:sendPoke("open", nil, {})
	else
		self:sendPoke("close", nil, {})
	end

	self:_openOrClose()

	self.isDirty = true
end

function GamepadRibbon:getIsShowing()
	return self.isShowing
end

function GamepadRibbon:attach(reason)
	self:openTab(self.TAB_PLAYER_INVENTORY)
	self:focusChild(self.inventoryTabContent, "select")
end

function GamepadRibbon:getOverflow()
	return true
end

function GamepadRibbon:_onTabWrapFocus(_, widget, directionX, directionY)
	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	if directionX ~= 0 then
		inputProvider:setFocusedWidget(widget, "select")
	elseif directionY > 0 then
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
	local maxKeybindWidth = math.max(
		self.secondaryKeybindInfo:getParent() and secondaryKeybindWidth or 0,
		self.tertiaryKeybindInfo:getParent() and tertiaryKeybindWidth or 0,
		ribbonKeybindWidth)

	self.ribbonKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - maxKeybindWidth - self.PADDING,
		0)

	self.secondaryKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - maxKeybindWidth - self.PADDING,
		ribbonKeybindHeight)

	self.tertiaryKeybindInfo:setPosition(
		self.TAB_CONTAINER_WIDTH - maxKeybindWidth - self.PADDING,
		ribbonKeybindHeight + secondaryKeybindHeight)
end

function GamepadRibbon:openTab(tab)
	if self.currentTabName == tab then
		return
	end

	self.contentLayoutTargetScrollX = 0
	self.contentLayoutWrapper:setScroll(0, 0)

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

	self.contentLayout:setSize(
		math.max(
			Theme.calculateTiledSizeWithPadding(self.PADDING, GamepadContentTab.WIDTH, self.contentLayout:getNumChildren()),
			Theme.calculateTiledSizeWithPadding(self.PADDING, GamepadContentTab.WIDTH, 2)),
		self.CONTENT_HEIGHT)
	self.contentLayout:performLayout()
	self.contentLayoutWrapper:setScrollSize(self.contentLayout:getSize())

	self:sendPoke("openTab", nil, { tab = tab })

	self.isDirty = true
	self.previousFocusedContent = false
end

function GamepadRibbon:_setKeybindInfo(secondary, tertiary, secondaryButton, tertiaryButton)
	secondaryButton = secondaryButton or "gamepadSecondaryAction"
	tertiaryButton = tertiaryButton or "gamepadTertiaryAction"

	if secondary then
		self.secondaryKeybindInfo:setMessage(GamepadToolTip.INPUT_SCHEME_GAMEPAD, secondary)
		self.secondaryKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, secondaryButton)

		if self.secondaryKeybindInfo:getParent() ~= self.container then
			self.container:addChild(self.secondaryKeybindInfo)
		end

		self.secondaryKeybindInfo:performLayout()
	else
		if self.secondaryKeybindInfo:getParent() == self.container then
			self.container:removeChild(self.secondaryKeybindInfo)
		end
	end

	if tertiary then
		self.tertiaryKeybindInfo:setMessage(GamepadToolTip.INPUT_SCHEME_GAMEPAD, tertiary)
		self.tertiaryKeybindInfo:setKeybind(GamepadToolTip.INPUT_SCHEME_GAMEPAD, tertiaryButton)

		if self.tertiaryKeybindInfo:getParent() ~= self.container then
			self.container:addChild(self.tertiaryKeybindInfo)
		end

		self.tertiaryKeybindInfo:performLayout()
	else
		if self.tertiaryKeybindInfo:getParent() == self.container then
			self.container:removeChild(self.tertiaryKeybindInfo)
		end
	end
end

function GamepadRibbon:_openInventoryTab()
	self.contentLayout:addChild(self.inventoryTabContent)
	self.contentLayout:addChild(self.itemInfoContent)
	self:_updateInventoryTab()

	self.titleLabel:setText("Inventory")
	self:_setKeybindInfo("More options", "Swap")
end

function GamepadRibbon:_updateInventoryTab()
	if not self.combinedState.inventory then
		return
	end

	self.inventoryTabContent:refresh(self.combinedState.inventory)

	local index = self.inventoryTabContent:getCurrentInventorySlotIndex()
	local item = self.combinedState.inventory.items[index]
	local otherItem
	if item then
		local slot
		if item.slot == Equipment.PLAYER_SLOT_TWO_HANDED then
			slot = Equipment.PLAYER_SLOT_RIGHT_HAND
		else
			slot = item.slot
		end

		otherItem = self.combinedState.equipment.items[slot]
	end

	if self.currentTabName == self.TAB_PLAYER_INVENTORY then
		self.itemInfoContent:refresh({ item = item, otherItem = otherItem })
	end
end

function GamepadRibbon:_initInventoryTab()
	self.inventoryTabContent = InventoryGamepadContentTab(self)
	self.inventoryTabContent.onWrapFocus:register(self._onContentWrapFocus, self)

	self.itemInfoContent = ItemInfoGamepadContentTab(self)

	self:_addTab(
		self.TAB_PLAYER_INVENTORY,
		"Resources/Game/UI/Icons/Common/Inventory.png",
		self._openInventoryTab)
end

function GamepadRibbon:_openEquipmentTab()
	self.contentLayout:addChild(self.equipmentTabContent)
	self.contentLayout:addChild(self.itemInfoContent)
	self:_updateEquipmentTab()

	self.titleLabel:setText("Equipment")
	self:_setKeybindInfo("More options")
end

function GamepadRibbon:_updateEquipmentTab()
	if not (self.combinedState.equipment and self.combinedState.stats) then
		return
	end

	self.equipmentTabContent:refresh({
		items = self.combinedState.equipment.items,
		count = self.combinedState.equipment.count,
		stats = self.combinedState.stats
	})

	local slot = self.equipmentTabContent:getCurrentEquipmentSlot()
	local item = self.equipmentTabContent:getEquipmentItem(slot)

	if self.currentTabName == self.TAB_PLAYER_EQUIPMENT then
		self.itemInfoContent:refresh({ item = item })
	end
end

function GamepadRibbon:_initEquipmentTab()
	self.equipmentTabContent = EquipmentGamepadContentTab(self)
	self.equipmentTabContent.onWrapFocus:register(self._onContentWrapFocus, self)

	self:_addTab(
		self.TAB_PLAYER_EQUIPMENT,
		"Resources/Game/UI/Icons/Common/Equipment.png",
		self._openEquipmentTab)
end

function GamepadRibbon:_onSelectSkill()
	local skillGuideState = self.skillGuideContentTab:getState()
	if skillGuideState.actions and #skillGuideState.actions == 0 then
		return
	end

	self.contentLayoutTargetScrollX = self.skillGuideContentTab:getPosition() - self.PADDING
	self:focusChild(self.skillGuideContentTab, "select")

	self:_setKeybindInfo("Back", nil, "gamepadBack")

	local skillInfoState = self.skillInfoTabContent:getState()
	if skillInfoState and skillInfoState.name then
		self.titleLabel:setText(string.format("%s Skill Guide", skillInfoState.name))
	end
end

function GamepadRibbon:_navigateSkillsBack(_, control)
	if control:is("back") then
		self.titleLabel:setText("Skills")
		self:focusChild(self.skillsTabContent, "select")
		self.contentLayoutTargetScrollX = 0

		self:_setKeybindInfo()
	end
end

function GamepadRibbon:_propagateSkillGuideScroll(_, x, y)
	self.skillGuideInfoContentTab:gamepadScroll(x, y)
end

function GamepadRibbon:_initSkillTab()
	self.skillsTabContent = SkillsGamepadContentTab(self)
	self.skillsTabContent.onWrapFocus:register(self._onContentWrapFocus, self)
	self.skillsTabContent.onSelectSkill:register(self._onSelectSkill, self)
	self.skillInfoTabContent = SkillInfoContentTab(self)
	self.skillGuideContentTab = SkillGuideContentTab(self)
	self.skillGuideContentTab.onWrapFocus:register(self._onContentWrapFocus, self)
	self.skillGuideContentTab.onControlDown:register(self._navigateSkillsBack, self)
	self.skillGuideContentTab.onGamepadScroll:register(self._propagateSkillGuideScroll, self)
	self.skillGuideInfoContentTab = SkillGuideInfoContentTab(self)

	self:_addTab(
		self.TAB_PLAYER_SKILLS,
		"Resources/Game/UI/Icons/Common/Skills.png",
		self._openSkillTab)
end

function GamepadRibbon:_openSkillTab()
	self.contentLayout:addChild(self.skillsTabContent)
	self.contentLayout:addChild(self.skillInfoTabContent)
	self.contentLayout:addChild(self.skillGuideContentTab)
	self.contentLayout:addChild(self.skillGuideInfoContentTab)
	self:_updateSkillTab()

	self.titleLabel:setText("Skills")
	self:_setKeybindInfo()
end

function GamepadRibbon:_updateSkillTab()
	if not self.combinedState.skills then
		return
	end

	self.skillsTabContent:refresh(self.combinedState.skills)

	local index = self.skillsTabContent:getCurrentSkillIndex()
	local skill = self.combinedState.skills and self.combinedState.skills.skills[index]
	if skill then
		self.skillInfoTabContent:refresh(skill)
	end

	local skillGuideState = self.skillGuideContentTab:getState()
	if skillGuideState.skill ~= (skill and skill.id) then
		self:sendPoke("selectSkill", nil, { skill = skill.id })
		self.skillGuideContentTab:refresh({
			skill = skill.id,
			actions = skillGuideState.actions or {}
		})
	end

	local skillGuideInfoState = self.skillGuideInfoContentTab:getState()
	local currentSkillGuideAction = skillGuideState.actions and skillGuideState.actions[self.skillGuideContentTab:getCurrentEntryIndex()]
	if currentSkillGuideAction and skillGuideInfoState.action and skillGuideInfoState.action.id ~= currentSkillGuideAction.id then
		self:sendPoke("selectSkillAction", nil, { id = currentSkillGuideAction.id })
	end
end

function GamepadRibbon:populateSkillGuide(skill, actions)
	self.skillGuideContentTab:refresh({
		hasAmuletOfYendor = self:getState().hasAmuletOfYendor,
		skill = skill,
		actions = actions
	})

	self.skillsTabContent:setHasActions(#actions > 0)

	if #actions > 0 then
		self:sendPoke("selectSkillAction", nil, { id = actions[1].id })
	else
		self:sendPoke("selectSkillAction", nil, { id = -1 })
	end
end

function GamepadRibbon:populateSkillGuideAction(action, constraints)
	self.skillGuideInfoContentTab:refresh({
		action = action,
		constraints = constraints
	})
end

function GamepadRibbon:_updateSettingsTab()
	local state = self:getState()

	self.configTabContent:refresh({
		showSurvey = state.showSurvey
	})
end

function GamepadRibbon:_initSettingsTab()
	self.configTabContent = ConfigGamepadContentTab(self)
	self.configTabContent.onWrapFocus:register(self._onContentWrapFocus, self)

	self:_addTab(
		self.TAB_SETTINGS,
		"Resources/Game/UI/Icons/Concepts/Settings.png",
		self._openSettingsTab)
end

function GamepadRibbon:_openSettingsTab()
	self.contentLayout:addChild(self.configTabContent)
	self:_updateSettingsTab()

	self.titleLabel:setText("Config")
	self:_setKeybindInfo()
end

function GamepadRibbon:_onSelectTab(tab, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	self:openTab(tab)
end

function GamepadRibbon:_addTab(tab, iconFilename, openFunc)
	local button = Button()
	button:setID(string.format("GamepadRibbon-%s", tab))
	button:setStyle(ButtonStyle(self.INACTIVE_TAB_BUTTON_STYLE, self:getView():getResources()))
	button:setToolTip(unpack(self.TOOL_TIPS[tab] or {}))
	button.onClick:register(self._onSelectTab, self, tab)

	local icon = Icon()
	icon:setIcon(iconFilename)
	icon:setSize(self.TAB_BUTTON_SIZE - self.PADDING * 2, self.TAB_BUTTON_SIZE - self.PADDING * 2)
	icon:setPosition(self.PADDING, self.PADDING)
	button:addChild(icon)

	self.tabLayout:addChild(button)

	self.tabButtons[tab] = button
	self.tabFuncs[tab] = openFunc

	table.insert(self.tabs, tab)
end

function GamepadRibbon:_getTabIndex(tab)
	for i, t in ipairs(self.tabs) do
		if t == tab then
			return i
		end
	end

	return nil
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

function GamepadRibbon:updateSkills(skills)
	self.combinedState.skills = skills
end

function GamepadRibbon:updateEquipment(equipment)
	self.combinedState.equipment = equipment
end

function GamepadRibbon:updateEquipmentStats(stats)
	self.combinedState.stats = stats
end

function GamepadRibbon:updateInventory(inventory)
	self.combinedState.inventory = inventory
end

function GamepadRibbon:_updateScroll(delta)
	local currentScrollX, currentScrollY = self.contentLayoutWrapper:getScroll()
	local scrollOffsetX = delta * (Theme.CONTENT_SCROLL_SPEED_UNITS / Theme.CONTENT_SCROLL_SPEED_DURATION)

	if self.contentLayoutTargetScrollX < currentScrollX then
		currentScrollX = math.max(currentScrollX - scrollOffsetX, self.contentLayoutTargetScrollX)
	elseif self.contentLayoutTargetScrollX > currentScrollX then
		currentScrollX = math.min(currentScrollX + scrollOffsetX, self.contentLayoutTargetScrollX)
	end

	self.contentLayoutWrapper:setScroll(currentScrollX, currentScrollY)
end

function GamepadRibbon:update(delta)
	Interface.update(self, delta)

	self:_updateScroll(delta)
	self:_updateInventoryTab()
	self:_updateEquipmentTab()
	self:_updateSkillTab()
	self:_updateSettingsTab()

	if self.isDirty then
		self:performLayout()
		self.isDirty = false
	end
end

return GamepadRibbon
