--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/VideoTutorial.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local PromptWindow = require "ItsyScape.Editor.Common.PromptWindow"
local Button = require "ItsyScape.UI.Button"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"

local Bank = Class(Interface)

-- Layout properties
Bank.ITEM_TAB_SIZE = 48
Bank.ITEM_SIZE = 48
Bank.ITEM_ICON_PADDING = 2
Bank.ITEM_PADDING = 16
Bank.MIN_ITEM_TAB_COLUMNS = 4
Bank.MAX_ITEM_TAB_COLUMNS = 6
Bank.INVENTORY_COLUMNS = 4
Bank.SECTION_TITLE_BUTTON_SIZE = 48
Bank.SECTION_PADDING = 4
Bank.TITLE_LABEL_HEIGHT = 48

Bank.WITHDRAW_X_PADDING = 16
Bank.WITHDRAW_X_WINDOW_WIDTH = 480
Bank.WITHDRAW_X_WINDOW_HEIGHT = 160

-- Enums
Bank.SECTION_NONE = 0
Bank.TAB_NONE   = 0

-- Styles
Bank.ACTIVE_TAB_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/BankTab-Active.9.png",
	hover = "Resources/Renderers/Widget/Button/BankTab-Active.9.png",
	pressed = "Resources/Renderers/Widget/Button/BankTab-Active.9.png"
}

Bank.INACTIVE_TAB_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
	hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
	pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
}

Bank.BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24
}

Bank.ACTIVE_BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24
}

Bank.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true
}

Bank.LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24,
	textShadow = true
}

Bank.SECTION_TITLE_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.6, 0.5),
	active = Color(0.5, 0.4, 0.3),
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 24,
	color = Color(1, 1, 1, 1),
	textShadow = true,
	padding = 2
}

Bank.TEXT_INPUT_STYLE = {
	inactive = "Resources/Renderers/Widget/TextInput/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/TextInput/Default-Hover.9.png",
	active = "Resources/Renderers/Widget/TextInput/Default-Active.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	color = Color(1, 1, 1, 1),
	textShadow = true,
	padding = 4
}

function Bank:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Default.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.tabsLayout = ScrollablePanel(GridLayout)
	self.tabsLayout:getInnerPanel():setWrapContents(true)
	self.tabsLayout:getInnerPanel():setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)
	do
		local estimatedWidth = math.floor(w / 4)
		local estimatedNumRows = math.floor(estimatedWidth / (Bank.ITEM_TAB_SIZE + Bank.SECTION_PADDING))
		local clampedNumRows = math.max(math.min(estimatedNumRows, Bank.MAX_ITEM_TAB_COLUMNS), Bank.MIN_ITEM_TAB_COLUMNS)
		local realWidth = clampedNumRows * (Bank.ITEM_TAB_SIZE + Bank.SECTION_PADDING) + Bank.SECTION_PADDING

		self.tabsLayout:setSize(
			realWidth,
			h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT - Bank.ITEM_TAB_SIZE - Bank.ITEM_PADDING * 2)
		self.tabsLayout:setPosition(
			math.floor(w / 2) + Bank.SECTION_PADDING,
			Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT + Bank.ITEM_TAB_SIZE + Bank.ITEM_PADDING * 2)
	end
	self:addChild(self.tabsLayout)

	local tabsBackground = Panel()
	tabsBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	tabsBackground:setPosition(self.tabsLayout:getPosition())
	tabsBackground:setSize(self.tabsLayout:getSize())
	self.panel:addChild(tabsBackground)

	local tabsLabel = Label()
	tabsLabel:setText("Sections")
	tabsLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	tabsLabel:setPosition(self.tabsLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(tabsLabel)

	self.newSectionButton = Button()
	do
		local x, y = self.tabsLayout:getPosition()
		self.newSectionButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, ui:getResources()))
		self.newSectionButton:setPosition(
			x,
			Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
		self.newSectionButton:setSize(Bank.SECTION_TITLE_BUTTON_SIZE, Bank.SECTION_TITLE_BUTTON_SIZE)
		self.newSectionButton.onClick:register(self.addSection, self)

		local newSectionButtonIcon = Icon()
		newSectionButtonIcon:setIcon("Resources/Game/UI/Icons/Concepts/Add.png")
		self.newSectionButton:addChild(newSectionButtonIcon)

		self:addChild(self.newSectionButton)
	end

	self.bankLayout = ScrollablePanel(GridLayout)
	self.bankLayout:getInnerPanel():setWrapContents(true)
	self.bankLayout:getInnerPanel():setUniformSize(true, Bank.ITEM_SIZE, Bank.ITEM_SIZE)
	self.bankLayout:getInnerPanel():setPadding(Bank.ITEM_PADDING, Bank.ITEM_PADDING)
	self.bankLayout:setPosition(
		Bank.ITEM_PADDING,
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT + Bank.ITEM_TAB_SIZE + Bank.ITEM_PADDING * 2)
	self.bankLayout:setSize(
		w / 2 - Bank.ITEM_PADDING * 2,
		h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT - Bank.ITEM_TAB_SIZE - Bank.ITEM_PADDING * 2)
	self:addChild(self.bankLayout)

	local bankBackground = Panel()
	bankBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	bankBackground:setPosition(self.bankLayout:getPosition())
	bankBackground:setSize(self.bankLayout:getSize())
	self.panel:addChild(bankBackground)

	local noteButton = Button()
	noteButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, ui:getResources()))
	noteButton:setPosition(Bank.ITEM_PADDING, Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	noteButton:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)
	noteButton.onClick:register(self.toggleNote, self)
	noteButton:setToolTip(
		"Withdraw items as notes.",
		"Noted items are stackable but are only useful for trading.")

	local noteIcon = Icon()
	noteIcon:setIcon("Resources/Game/Items/Note.png")
	noteIcon:setSize(32, 32)
	noteIcon:setPosition(8, 8)
	noteButton:addChild(noteIcon)
	self:addChild(noteButton)

	self.noted = false

	local bankLabel = Label()
	bankLabel:setText("Bank")
	bankLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	bankLabel:setPosition(self.bankLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(bankLabel)

	local search = TextInput()
	search:setStyle(TextInputStyle(Bank.TEXT_INPUT_STYLE, ui:getResources()))
	search:setText("Search...")
	search:setData('empty', true)
	search:setPosition(
		self.bankLayout:getPosition() + self.bankLayout:getSize() * (1 / 3),
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	search:setSize(self.bankLayout:getSize() * (2 / 3), Bank.SECTION_TITLE_BUTTON_SIZE)
	search.onFocus:register(function()
		if search:getData('empty', true) then
			search:setText("")
		else
			search:setCursor(0, #search:getText() + 1)
		end
	end)
	search.onBlur:register(function()
		self:search(search)

		if search:getText() == "" then
			search:setText("Search...")
			search:setData('empty', true)
		end
	end)
	search.onValueChanged:register(function()
		self:search(search)

		if search:getText() ~= "" then
			search:setData('empty', false)
		end
	end)
	self:addChild(search)

	self.inventoryLayout = ScrollablePanel(GridLayout)
	self.inventoryLayout:getInnerPanel():setWrapContents(true)
	self.inventoryLayout:getInnerPanel():setUniformSize(true, Bank.ITEM_SIZE, Bank.ITEM_SIZE)
	self.inventoryLayout:getInnerPanel():setPadding(Bank.ITEM_PADDING, Bank.ITEM_PADDING)
	self.inventoryLayout:setPosition(
		w - ((Bank.ITEM_SIZE + Bank.ITEM_PADDING) * Bank.INVENTORY_COLUMNS + Bank.ITEM_PADDING * 2),
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT + Bank.ITEM_TAB_SIZE + Bank.ITEM_PADDING * 2)
	self.inventoryLayout:setSize(
		(Bank.ITEM_SIZE + Bank.ITEM_PADDING) * Bank.INVENTORY_COLUMNS + Bank.ITEM_PADDING,
		h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT - Bank.ITEM_TAB_SIZE - Bank.ITEM_PADDING * 2)
	do
		local state = self:getState()
		self:updateItemLayout(self.inventoryLayout, state.inventory, 'inventory')
	end
	self:addChild(self.inventoryLayout)

	local inventoryBackground = Panel()
	inventoryBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	inventoryBackground:setPosition(self.inventoryLayout:getPosition())
	inventoryBackground:setSize(self.inventoryLayout:getSize())
	self.panel:addChild(inventoryBackground)

	local inventoryLabel = Label()
	inventoryLabel:setText("Inventory")
	inventoryLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	inventoryLabel:setPosition(self.inventoryLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(inventoryLabel)

	self.closeButton = Button()
	self.closeButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, ui:getResources()))
	self.closeButton:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)
	self.closeButton:setPosition(w - Bank.ITEM_TAB_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.sections = {}
	self.activeSection = Bank.SECTION_NONE
	self.activeTab = Bank.TAB_NONE
	self:generateSections()
	self:generateTabs()
	self.tabsLayout:performLayout()

	self.numBankSpaces = 0
	self.withdrawXCount = 1000
end

function Bank:getIsFullscreen()
	return true
end

function Bank:withdrawX(index)
	local promptWindow = PromptWindow(_APP)
	promptWindow.onSubmit:register(function(_, value)
		value = tonumber(value)
		if value then
			self.withdrawXCount = value
			self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = self.withdrawXCount })
		end
	end)

	promptWindow:open(
		"How many would you like to withdraw?",
		"Withdraw-X",
		tostring(self.withdrawXCount),
		Bank.WITHDRAW_X_WINDOW_WIDTH,
		Bank.WITHDRAW_X_WINDOW_HEIGHT)

	local x, y = love.graphics.getScaledPoint(love.mouse.getPosition())
	x = x - Bank.WITHDRAW_X_WINDOW_WIDTH / 2
	y = y - Bank.WITHDRAW_X_WINDOW_HEIGHT / 2

	local width, height = promptWindow:getSize()

	local screenWidth, screenHeight = love.graphics.getScaledMode()

	if x < Bank.WITHDRAW_X_PADDING then
		x = Bank.WITHDRAW_X_PADDING
	end

	if y < Bank.WITHDRAW_X_PADDING then
		y = Bank.WITHDRAW_X_PADDING
	end

	if x + width > screenWidth then
		x = screenWidth - width - Bank.WITHDRAW_X_PADDING
	end

	if y + height > screenHeight then
		y = screenHeight - height - Bank.WITHDRAW_X_PADDING
	end

	promptWindow:setPosition(x, y)
end

function Bank:search(textInput)
	self:sendPoke("search", nil, { query = textInput:getText() })
end

function Bank:generateSection(stateSection, sectionIndex)
	local w = self.tabsLayout:getSize()

	local gridLayout = GridLayout()
	gridLayout:setWrapContents(true)
	gridLayout:setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)
	gridLayout:setSize(w, Bank.SECTION_TITLE_BUTTON_SIZE)

	local addButton
	if sectionIndex > 0 then
		local sectionTextInput = TextInput()
		sectionTextInput:setStyle(TextInputStyle(Bank.SECTION_TITLE_STYLE, self:getView():getResources()))
		sectionTextInput:setText(stateSection.name)
		sectionTextInput:setSize(
			w - Bank.SECTION_TITLE_BUTTON_SIZE - Bank.SECTION_PADDING * 5,
			Bank.SECTION_TITLE_BUTTON_SIZE)
		sectionTextInput.onBlur:register(self.renameSection, self, sectionIndex)
		sectionTextInput.onSubmit:register(self.renameSection, self, sectionIndex)
		sectionTextInput.onSubmit:register(self.blurTextInput, self)
		gridLayout:addChild(sectionTextInput)

		addButton = DraggableButton()
		addButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		addButton.onRightClick:register(self.probeSection, self, sectionIndex)
		addButton:setSize(Bank.SECTION_TITLE_BUTTON_SIZE, Bank.SECTION_TITLE_BUTTON_SIZE)

		local addButtonIcon = Icon()
		addButtonIcon:setIcon("Resources/Game/UI/Icons/Concepts/Add.png")
		addButton:addChild(addButtonIcon)

		gridLayout:addChild(addButton)
	end

	self.sections[sectionIndex] = { layout = gridLayout, itemDropTarget = addButton }

	self.tabsLayout:addChild(gridLayout)
end

function Bank:renameSection(sectionIndex, textInput)
	textInput:setCursor(0)
	self:sendPoke("renameSection", nil, { sectionIndex = sectionIndex, name = textInput:getText() })
end

function Bank:addQuery(sectionIndex)
	self:sendPoke("addSectionQuery", nil, { sectionIndex = sectionIndex })
end

function Bank:blurTextInput()
	self:getView():getInputProvider():setFocusedWidget(nil)
end

function Bank:generateSections()
	self:generateSection({ name = "Common" }, 0, false)

	local sections = self:getState().sections
	for i = 1, #sections do
		self:generateSection(sections[i], i, true)
	end
end

function Bank:addSectionButton(sectionIndex, tabIndex)
	local button = DraggableButton()
	button:setData('sectionIndex', sectionIndex)
	button:setData('tabIndex', tabIndex)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = ItemIcon()
	icon:setData('sectionIndex', sectionIndex)
	icon:setData('tabIndex', tabIndex)
	icon:setData('featuredItem', 1)
	icon:bind('itemID', "sections[{sectionIndex}][{tabIndex}][1]")
	button:addChild(icon)

	button.onLeftClick:register(self.openTab, self, sectionIndex, tabIndex)
	button.onRightClick:register(self.probeTab, self, sectionIndex, tabIndex)

	self.sections[sectionIndex].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:addAllButton()
	local button = Button()
	button:setData('sectionIndex', Bank.SECTION_NONE)
	button:setData('tabIndex', Bank.TAB_NONE)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = Icon()
	icon:setIcon("Resources/Game/UI/Icons/Things/Chest.png")
	button:addChild(icon)

	button.onClick:register(self.clickAllButton, self)

	self.sections[0].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:clickAllButton(_, index)
	if index == 1 then
		self:closeTab()
	elseif index == 2 then
		self:probeAllButton()
	end
end

function Bank:tryMakeButtonActiveStyle(button)
	local sectionIndex = button:getData('sectionIndex')
	local tabIndex = button:getData('tabIndex')

	if self.activeSection == sectionIndex and self.activeTab == tabIndex then
		button:setStyle(ButtonStyle(Bank.ACTIVE_TAB_STYLE, self:getView():getResources()))
	else
		button:setStyle(ButtonStyle(Bank.INACTIVE_TAB_STYLE, self:getView():getResources()))
	end
end

function Bank:generateTabs()
	self:addAllButton()

	local sections = self:getState().sections
	for i = 1, #sections do
		for j = 1, #sections[i] do
			self:addSectionButton(i, j)
		end
	end
end

function Bank:updateSections()
	-- The psuedo-section "Section 0" is for the "Common"
	for i = 0, #self.sections do
		self.tabsLayout:removeChild(self.sections[i].layout)
	end

	self:generateSections()
	self:generateTabs()
	self.tabsLayout:performLayout()
end

function Bank:addSection()
	self:sendPoke("addSection", nil, { name = "New Section" })
end

function Bank:deleteSection(sectionIndex)
	self:sendPoke("deleteSection", nil, { sectionIndex = sectionIndex })
end

function Bank:probeSection(sectionIndex)
	local sectionName = self:getState().sections[sectionIndex].name

	local actions = {
		{
			id = "Delete",
			verb = "Delete", -- TODO: [LANG]
			object = sectionName,
			callback = function()
				self:deleteSection(sectionIndex)
			end
		}
	}

	self:getView():probe(actions)
end

function Bank:probeAllButton()
	local actions = {
		{
			id = "View",
			verb = "View",
			object = "Bank",
			callback = function()
				self:closeTab()
			end
		},
		{
			id = "Sort",
			verb = "Sort",
			object = "Bank",
			callback = function()
				self:sortBank()
			end
		}
	}

	self:getView():probe(actions)
end

function Bank:probeTab(sectionIndex, tabIndex)
	local actions = {
		{
			id = "View",
			verb = "View", -- TODO: [LANG]
			object = "Tab",
			callback = function()
				self:openTab(sectionIndex, tabIndex)
			end
		},
		{
			id = "Sort",
			verb = "Sort", -- TODO: [LANG]
			object = "Tab",
			callback = function()
				self:sortTab(sectionIndex, tabIndex)
			end
		},
		{
			id = "Add",
			verb = "Add",
			object = "Search results",
			callback = function()
				self:addSearchResultsToTab(sectionIndex, tabIndex)
			end
		},
		{
			id = "Delete",
			verb = "Delete", -- TODO: [LANG]
			object = "Tab",
			callback = function()
				self:deleteTab(sectionIndex, tabIndex)
			end
		}
	}

	self:getView():probe(actions)
end

function Bank:openTab(sectionIndex, tabIndex)
	self:addChild(self.newSectionButton)
	self:addChild(self.tabsLayout)

	self.activeSection = sectionIndex
	self.activeTab = tabIndex
	self:sendPoke("openTab", nil, { sectionIndex = sectionIndex, tabIndex = tabIndex })

	self.bankLayout:getInnerPanel():setScroll(0, 0)
end

function Bank:sortBank()
	self:sendPoke("sortBank", nil, {})
end

function Bank:sortTab(sectionIndex, tabIndex)
	self:sendPoke("sortTab", nil, { sectionIndex = sectionIndex, tabIndex = tabIndex })
end

function Bank:addSearchResultsToTab(sectionIndex, tabIndex)
	local items = self:getState().items

	for i = 1, #items do
		if not items[i].disabled then
			self:sendPoke("addItemToSectionTab", nil, {
				sectionIndex = sectionIndex,
				tabIndex = tabIndex,
				itemIndex = i
			})
		end
	end
end

function Bank:closeTab()
	self:addChild(self.newSectionButton)
	self:addChild(self.tabsLayout)

	self.activeSection = Bank.SECTION_NONE
	self.activeTab = Bank.TAB_NONE
	self:sendPoke("closeTab", nil, {})
end

function Bank:deleteTab(sectionIndex, tabIndex)
	if self.activeSection == sectionIndex and self.activeTab == tabIndex then
		self:sendPoke("closeTab", nil, {})
	end

	self:sendPoke("removeTab", nil, { sectionIndex = sectionIndex, tabIndex = tabIndex })
end

function Bank:toggleNote(button)
	self.noted = not self.noted

	if self.noted then
		button:setStyle(ButtonStyle(Bank.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
	else
		button:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
	end
end

function Bank:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if self.numBankSpaces ~= state.items.max then
		local children = {}
		for index, child in self.bankLayout:getInnerPanel():iterate() do
			table.insert(children, child)
		end

		for i = 1, #children do
			self.bankLayout:removeChild(children[i])
		end

		self:updateItemLayout(self.bankLayout, state.items, 'items')

		self.numBankSpaces = state.items.max
	end

	local bankWidth, bankHeight = self.bankLayout:getSize()
	local bankScrollX, bankScrollY = self.bankLayout:getInnerPanel():getScroll()
	local maxScrollX, maxScrollY = self.bankLayout:getInnerPanel():getSize()
	self.bankLayout:getInnerPanel():setScroll(
		math.min(math.max(maxScrollX - bankWidth, 0), bankScrollX),
		math.min(math.max(maxScrollY - bankHeight, 0), bankScrollY))
end

function Bank:updateItemLayout(layout, items, source)
	for i = 1, items.max do
		local button = DraggableButton()
		local icon = ItemIcon()
		icon:setData('index', i)
		icon:bind("itemID", string.format("%s[{index}].id", source))
		icon:bind("itemCount", string.format("%s[{index}].count", source))
		icon:bind("itemIsNoted", string.format("%s[{index}].noted", source))
		icon:bind("isDisabled", string.format("%s[{index}].disabled", source))
		icon:setSize(
			Bank.ICON_SIZE,
			Bank.ICON_SIZE)
		icon:setPosition(
			Bank.ICON_PADDING,
			Bank.ICON_PADDING)

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)
		button:setData('bank-droppable-target', true)
		button:setData('source', source)
		button.onDrop:register(self.swap, self)
		button.onDrag:register(self.drag, self, source, layout)
		button.onLeftClick:register(self.activate, self, source)
		button.onRightClick:register(self.probe, self, source)
		button.onMouseMove:register(self.examine, self, icon, source, i)

		layout:addChild(button)
	end

	layout:setScrollSize(layout:getInnerPanel():getSize())
	layout:setData('source', source)
end

function Bank:examine(icon, source, index)
	local state = self:getState()
	self:examineItem(icon, state[source], index)
end

function Bank:getRightHandItem(layout, source)
	local x, y = love.graphics.getScaledPoint(love.mouse.getPosition())

	if source ~= 'items' then
		return nil
	end

	for i, widget in layout:getInnerPanel():iterate() do
		local widgetX, widgetY = widget:getAbsolutePosition()
		local widgetWidth, widgetHeight = widget:getSize()

		if x >= widgetX + widgetWidth and y >= widgetY and
		   x <= widgetX + widgetWidth + Bank.ITEM_PADDING and y <= widgetY + widgetHeight
		then
			return widget:getData('icon'):getData('index')
		elseif i == 1 and
		       x >= widgetX - Bank.ITEM_PADDING and y >= widgetY and
		       x <= widgetX and y <= widgetY + widgetHeight
		then
			return 0
		end
	end

	return nil
end

function Bank:drag(source, layout, button, x, y, absoluteX, absoluteY)
	local icon = button:getData('icon')
	local rightHandItem = self:getRightHandItem(layout, source)
	if rightHandItem then
		local SHRINKAGE = 0.5
		icon:setSize(self.ITEM_SIZE * SHRINKAGE, self.ITEM_SIZE * SHRINKAGE)
		icon:setPosition(
			Bank.ITEM_ICON_PADDING + (Bank.ITEM_SIZE * SHRINKAGE / 2),
			Bank.ITEM_ICON_PADDING + (Bank.ITEM_SIZE * SHRINKAGE / 2))
	else
		icon:setSize(Bank.ITEM_SIZE, Bank.ITEM_SIZE)
		icon:setPosition(Bank.ITEM_ICON_PADDING, Bank.ITEM_ICON_PADDING)
	end
	if self:getView():getRenderManager():getCursor() ~= icon then
		self:getView():getRenderManager():setCursor(icon)
	end
end

local function isInside(x, y, widget)
	local widgetX, widgetY = widget:getAbsolutePosition()
	local widgetWidth, widgetHeight = widget:getSize()

	if x >= widgetX and y >= widgetY and
	   x <= widgetX + widgetWidth and y <= widgetY + widgetHeight
	then
		return widget
	end
end

function Bank:findButton(layout, x, y)
	for _, button in layout:iterate() do
		if isInside(x, y, button) then
			return button
		end
	end

	if isInside(x, y, layout) then
		return layout
	end
end

function Bank:swap(button, x, y, absoluteX, absoluteY)
	local icon = button:getData('icon')
	local index = icon:getData('index')

	local sourceInventory = button:getData('source')

	if index then
		local inputProvider = self:getView():getInputProvider()
		local destination = self:findButton(self.bankLayout:getInnerPanel(), absoluteX, absoluteY) or
		                    self:findButton(self.inventoryLayout:getInnerPanel(), absoluteX, absoluteY)

		if destination then
			local destinationInventory = destination:getData('source')
			local newIndex
			if destination:isCompatibleType(DraggableButton) then
				newIndex = destination:getData('icon'):getData('index')
			end

			if destinationInventory == 'items' or destinationInventory == nil then
				if sourceInventory == 'inventory' then
					local state = self:getState()
					local numItems = state.inventory[index].count
					self:sendPoke("deposit", nil, { index = index, count = numItems })
				else
					if newIndex == nil then
						local rightHandItem = self:getRightHandItem(self.bankLayout, 'items')
						if rightHandItem then
							if rightHandItem <= index then
								rightHandItem = rightHandItem + 1
							end

							self:sendPoke("insertBank", nil, { tab = 0, a = index, b = rightHandItem })
						end
					else
						self:sendPoke("swapBank", nil, { tab = 0, a = index, b = newIndex })
					end
				end
			elseif destinationInventory == 'inventory' then
				if sourceInventory == 'items' then
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 1 })
				elseif index and newIndex then
					self:sendPoke("swapInventory", nil, { a = index, b = newIndex })
				end
			end
		else
			local wasInSection = false
			for i = 1, #self.sections do
				local dropTarget = self.sections[i].itemDropTarget
				if dropTarget and isInside(absoluteX, absoluteY, dropTarget) then
					self:sendPoke("addSectionTab", nil, { sectionIndex = i, itemIndex = index })
					wasInSection = true
					break
				else
					local destination = self:findButton(self.sections[i].layout, absoluteX, absoluteY)
					if destination and destination:getData('tabIndex') then
						self:sendPoke("addItemToSectionTab", nil, { sectionIndex = i, tabIndex = destination:getData('tabIndex'), itemIndex = index })
						wasInSection = true
						break
					end
				end
			end

			if not wasInSection and self.activeSection ~= Bank.SECTION_NONE and self.activeTab ~= Bank.TAB_NONE then
				local sectionIndex = self.activeSection
				local tabIndex = self.activeTab

				local state = self:getState()
				if #state.items == 1 then
					self:closeTab()
				end

				self:sendPoke("removeItemFromSectionTab", nil, { sectionIndex = sectionIndex, tabIndex = tabIndex, itemIndex = index })
			end
		end
	end

	if self:getView():getRenderManager():getCursor() == icon then
		self:getView():getRenderManager():setCursor(nil)
	end

	icon:setSize(Bank.ITEM_SIZE, Bank.ITEM_SIZE)
	icon:setPosition(Bank.ITEM_ICON_PADDING, Bank.ITEM_ICON_PADDING)
end

function Bank:probe(source, button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState()[source] or {}
	local item = items[index]
	if item then
		local object = item.name
		local actions = {}

		if source == 'inventory' then
			table.insert(actions, {
				id = "Deposit-1",
				verb = "Deposit", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("deposit", nil, { index = index, count = 1 })
				end
			})

			table.insert(actions, {
				id = "Deposit-10",
				verb = "Deposit-10", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("deposit", nil, { index = index, count = 10 })
				end
			})

			table.insert(actions, {
				id = "Deposit-100",
				verb = "Deposit-100", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("deposit", nil, { index = index, count = 100 })
				end
			})

			table.insert(actions, {
				id = "Deposit-All",
				verb = "Deposit-All", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("deposit", nil, { index = index, count = math.huge })
				end
			})
		elseif source == 'items' then
			table.insert(actions, {
				id = "Withdraw-1",
				verb = "Withdraw", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 1 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-10",
				verb = "Withdraw-10", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 10 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-100",
				verb = "Withdraw-100", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 100 })
				end
			})

			table.insert(actions, {
				id = string.format("Withdraw-%d", self.withdrawXCount),
				verb = string.format("Withdraw-%d", self.withdrawXCount), -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 100 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-X",
				verb = "Withdraw-X", -- TODO: [LANG]
				object = object,
				callback = function()
					self:withdrawX(index)
				end
			})

			table.insert(actions, {
				id = "Withdraw-All",
				verb = "Withdraw-All", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = math.huge })
				end
			})

			if self.activeSection ~= Bank.SECTION_NONE and self.activeTab ~= Bank.SECTION_NONE then
				table.insert(actions, {
					id = "Remove-From-Tab",
					verb = "Remove-From-Tab",
					object = object,
					callback = function()
						local sectionIndex = self.activeSection
						local tabIndex = self.activeTab

						local state = self:getState()
						if #state.items == 1 then
							self:closeTab()
						end

						self:sendPoke("removeItemFromSectionTab", nil, { sectionIndex = sectionIndex, tabIndex = tabIndex, itemIndex = index })
					end
				})
			end
		end

		table.insert(actions, {
			id = "Examine",
			verb = "Examine", -- TODO: [LANG]
			object = object,
			callback = function()
				self:getView():examine(item.id)
			end
		})

		self:getView():probe(actions)
	end
end

function Bank:activate(source, button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState()[source] or {}
	local item = items[index]
	if item then
		if source == 'inventory' then
			self:sendPoke("deposit", nil, { index = index, count = 1 })
		elseif source == 'items' then
			self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 1 })
		end
	end
end

return Bank
