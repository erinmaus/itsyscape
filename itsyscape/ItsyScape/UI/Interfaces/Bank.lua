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
Bank.ITEM_PADDING = 12
Bank.MIN_ITEM_TAB_COLUMNS = 4
Bank.MAX_ITEM_TAB_COLUMNS = 6
Bank.INVENTORY_COLUMNS = 4
Bank.SECTION_TITLE_BUTTON_SIZE = 48
Bank.SECTION_PADDING = 4
Bank.TITLE_LABEL_HEIGHT = 48

-- Enums
Bank.SECTION_NONE = 0
Bank.QUERY_NONE   = 0

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

	self.addSectionButton = Button()
	do
		local x, y = self.tabsLayout:getPosition()
		self.addSectionButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, ui:getResources()))
		self.addSectionButton:setPosition(
			x,
			Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
		self.addSectionButton:setSize(Bank.SECTION_TITLE_BUTTON_SIZE, Bank.SECTION_TITLE_BUTTON_SIZE)
		self.addSectionButton.onClick:register(self.addSection, self)

		local addSectionButtonIcon = Icon()
		addSectionButtonIcon:setIcon("Resources/Game/UI/Icons/Concepts/Add.png")
		self.addSectionButton:addChild(addSectionButtonIcon)

		self:addChild(self.addSectionButton)
	end

	-- This is only visible when editing/creating a filter.
	self.filterEditPanel = ScrollablePanel(GridLayout)
	self.filterEditPanel:getInnerPanel():setWrapContents(true)
	self.filterEditPanel:getInnerPanel():setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING * 2)
	self.filterEditPanel:setPosition(self.tabsLayout:getPosition())
	self.filterEditPanel:setSize(self.tabsLayout:getSize())

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

	local withdrawXTextInput = TextInput()
	withdrawXTextInput:setStyle(TextInputStyle(Bank.TEXT_INPUT_STYLE, ui:getResources()))
	withdrawXTextInput:setText('1000')
	withdrawXTextInput:setPosition(
		self.bankLayout:getPosition() + self.bankLayout:getSize() * (2 / 3),
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	withdrawXTextInput:setSize(self.bankLayout:getSize() / 3, Bank.SECTION_TITLE_BUTTON_SIZE)
	withdrawXTextInput.onFocus:register(function()
		withdrawXTextInput:setCursor(0, #withdrawXTextInput:getText() + 1)
	end)
	withdrawXTextInput.onValueChanged:register(self.changeWithdrawXAmount, self)
	self:addChild(withdrawXTextInput)

	local withdrawXLabel = Label()
	withdrawXLabel:setStyle(LabelStyle(Bank.LABEL_STYLE, ui:getResources()))
	withdrawXLabel:setText("Withdraw-X Quantity:")
	withdrawXLabel:setPosition(
		withdrawXTextInput:getPosition() - 250,
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT + 12)
	self:addChild(withdrawXLabel)

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

	self.filterSections = {}
	self.activeSection = Bank.SECTION_NONE
	self.activeFilter = Bank.QUERY_NONE
	self:generateFilterSections()
	self:generateTabs()
	self.tabsLayout:performLayout()

	self.numBankSpaces = 0
	self.withdrawXCount = 1000
end

function Bank:changeWithdrawXAmount(textInput)
	-- Remove all non-number values
	value = string.gsub(textInput:getText(), "[^%d]", "")
	textInput:setText(value)

	self.withdrawXCount = tonumber(value) or 1
end

function Bank:generateFilterSection(stateSection, sectionIndex)
	local w = self.tabsLayout:getSize()

	local gridLayout = GridLayout()
	gridLayout:setWrapContents(true)
	gridLayout:setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)
	gridLayout:setSize(w, Bank.SECTION_TITLE_BUTTON_SIZE)

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

		local addButton = DraggableButton()
		addButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		addButton.onLeftClick:register(self.addQuery, self, sectionIndex)
		addButton.onRightClick:register(self.probeSection, self, sectionIndex)
		addButton:setSize(Bank.SECTION_TITLE_BUTTON_SIZE, Bank.SECTION_TITLE_BUTTON_SIZE)

		local addButtonIcon = Icon()
		addButtonIcon:setIcon("Resources/Game/UI/Icons/Concepts/Add.png")
		addButton:addChild(addButtonIcon)

		gridLayout:addChild(addButton)
	end

	self.filterSections[sectionIndex] = { layout = gridLayout }

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

function Bank:generateFilterSections()
	self:generateFilterSection({ name = "Common" }, 0, false)

	local filters = self:getState().filters
	for i = 1, #filters do
		self:generateFilterSection(filters[i], i, true)
	end
end

function Bank:addFilterButton(sectionIndex, filterIndex)
	local button = DraggableButton()
	button:setData('sectionIndex', sectionIndex)
	button:setData('filterIndex', filterIndex)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = ItemIcon()
	icon:setData('sectionIndex', sectionIndex)
	icon:setData('filterIndex', filterIndex)
	icon:bind('itemID', "filters[{sectionIndex}][{filterIndex}].item")
	button:addChild(icon)

	button.onLeftClick:register(self.onPerformQuery, self, sectionIndex, filterIndex)
	button.onRightClick:register(self.probeFilter, self, sectionIndex, filterIndex)

	self.filterSections[sectionIndex].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:addAllButton()
	local button = Button()
	button:setData('sectionIndex', Bank.SECTION_NONE)
	button:setData('filterIndex', Bank.QUERY_NONE)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = Icon()
	icon:setIcon("Resources/Game/UI/Icons/Things/Chest.png")
	button:addChild(icon)

	button.onClick:register(self.onClearQuery, self)

	self.filterSections[0].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:tryMakeButtonActiveStyle(button)
	local sectionIndex = button:getData('sectionIndex')
	local filterIndex = button:getData('filterIndex')

	if self.activeSection == sectionIndex and self.activeFilter == filterIndex then
		button:setStyle(ButtonStyle(Bank.ACTIVE_TAB_STYLE, self:getView():getResources()))
	else
		button:setStyle(ButtonStyle(Bank.INACTIVE_TAB_STYLE, self:getView():getResources()))
	end
end

function Bank:generateTabs()
	self:addAllButton()

	local filters = self:getState().filters
	for i = 1, #filters do
		for j = 1, #filters[i] do
			self:addFilterButton(i, j)
		end
	end
end

function Bank:updateFilters()
	-- The psuedo-section "Section 0" is for the "Common"
	for i = 0, #self.filterSections do
		self.tabsLayout:removeChild(self.filterSections[i].layout)
	end

	self:generateFilterSections()
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
	local sectionName = self:getState().filters[sectionIndex].name

	local actions = {
		{
			id = "Add",
			verb = "Add", -- TODO: [LANG]
			object = sectionName,
			callback = function()
				self:addQuery(sectionIndex)
			end
		},
		{
			id = "Delete",
			verb = "Delete", -- TODO: [LANG]
			object = sectionName,
			callback = function()
				self:deleteSection(sectionIndex, queryIndex)
			end
		}
	}

	self:getView():probe(actions)
end

function Bank:probeFilter(sectionIndex, queryIndex)
	local actions = {
		{
			id = "View",
			verb = "View", -- TODO: [LANG]
			object = "Filter",
			callback = function()
				self:switchToFilter(sectionIndex, queryIndex)
			end
		},
		{
			id = "Edit",
			verb = "Edit", -- TODO: [LANG]
			object = "Filter",
			callback = function()
				self:openFilterEdit(sectionIndex, queryIndex)
			end
		},
		{
			id = "Delete",
			verb = "Delete", -- TODO: [LANG]
			object = "Filter",
			callback = function()
				self:deleteFilter(sectionIndex, queryIndex)
			end
		}
	}

	self:getView():probe(actions)
end

function Bank:onPerformQuery(sectionIndex, queryIndex)
	self:removeChild(self.filterEditPanel)
	self:addChild(self.addSectionButton)
	self:addChild(self.tabsLayout)

	self.activeSection = sectionIndex
	self.activeFilter = queryIndex
	self:sendPoke("applyFilter", nil, { sectionIndex = sectionIndex, queryIndex = queryIndex })

	self.bankLayout:getInnerPanel():setScroll(0, 0)
end

function Bank:onClearQuery()
	self:removeChild(self.filterEditPanel)
	self:addChild(self.addSectionButton)
	self:addChild(self.tabsLayout)

	self.activeSection = Bank.SECTION_NONE
	self.activeFilter = Bank.QUERY_NONE
	self:sendPoke("clearFilter", nil, {})
end

function Bank:generateFilterOperation(sectionIndex, queryIndex, operationIndex)
	local function getOperation()
		return self:getState().filters[sectionIndex][queryIndex][operationIndex]
	end

	local function applyFilter()
		self:sendPoke("editFilter", nil, {
			sectionIndex = sectionIndex,
			queryIndex = queryIndex,
			query = self:getState().filters[sectionIndex][queryIndex] })
	end

	local childLayout = GridLayout()
	childLayout:setWrapContents(true)
	childLayout:setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)

	local width = self.filterEditPanel:getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE
	childLayout:setSize(width, 0)

	local function setFilterTerm(textInput)
		local operation = getOperation()
		operation.term = textInput:getText()
		applyFilter()
	end

	local queryInput = TextInput()
	queryInput:setStyle(TextInputStyle(Bank.TEXT_INPUT_STYLE, self:getView():getResources()))
	queryInput:setSize(width - Bank.SECTION_PADDING * 3, Bank.SECTION_TITLE_BUTTON_SIZE)
	queryInput.onSubmit:register(setFilterTerm)
	queryInput.onBlur:register(setFilterTerm)
	queryInput:setText(getOperation().term)
	childLayout:addChild(queryInput)

	local function setButtonStyle(key, invert, button)
		local enabled
		do
			local operation = getOperation()
			enabled = operation[key]

			if invert then
				enabled = not enabled
			end
		end

		if enabled then
			button:setStyle(ButtonStyle(Bank.ACTIVE_BUTTON_STYLE, self:getView():getResources()))
		else
			button:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		end
	end

	local function toggleOperationValue(key, button)
		local operation = getOperation()
		operation[key] = not operation[key]

		-- TODO: Invert toggle when moving to async model
		setButtonStyle(key, false, button)
		applyFilter()
	end

	local function addOperationValue(key, niceName, description)
		local button = Button()
		button:setText(niceName)
		button:setToolTip(description)
		button:setSize((width - Bank.SECTION_PADDING * 3) / 2 - Bank.SECTION_PADDING, Bank.SECTION_TITLE_BUTTON_SIZE)

		button.onClick:register(setButtonStyle, key, true)
		button.onClick:register(toggleOperationValue, key)

		setButtonStyle(key, false, button)
		childLayout:addChild(button)
	end

	addOperationValue("name", "Name", "Search for item name.")
	addOperationValue("description", "Descr.", "Search the description (examine) of an item.")
	addOperationValue("keyword", "Keyword", "Search for a keyword that describes the item.")
	addOperationValue("action", "Action", "Search for an action that can be performed with the item.")
	addOperationValue("flip", "Flip", "Exclude items matching this query.")

	do
		local deleteButton = Button()
		deleteButton:setText("Delete")
		deleteButton:setToolTip("Delete this query section.")
		deleteButton:setSize(
			(width - Bank.SECTION_PADDING * 3) / 2 - Bank.SECTION_PADDING,
			Bank.SECTION_TITLE_BUTTON_SIZE)

		deleteButton.onClick:register(function()
			local query = self:getState().filters[sectionIndex][queryIndex]
			table.remove(query, operationIndex)
			applyFilter()
		end)

		deleteButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		childLayout:addChild(deleteButton)
	end

	self.filterEditPanel:addChild(childLayout)
end

function Bank:deleteFilter(sectionIndex, queryIndex)
	if self.activeSection == sectionIndex and self.activeFilter == queryIndex then
		self:sendPoke("clearFilter", nil, {})
	end

	self:sendPoke("removeFilter", nil, { sectionIndex = sectionIndex, queryIndex = queryIndex })
end

function Bank:addQueryOp(sectionIndex, queryIndex)
	local state = self:getState()
	local query = state.filters[sectionIndex][queryIndex]
	table.insert(query, {
		term = "Potato",
		name = false,
		keyword = false,
		description = false,
		action = false,
		flip = false
	})

	self:sendPoke("editFilter", nil, {
		sectionIndex = sectionIndex,
		queryIndex = queryIndex,
		query = self:getState().filters[sectionIndex][queryIndex] })
end

function Bank:openFilterEdit(sectionIndex, queryIndex)
	local state = self:getState()
	local query = state.filters[sectionIndex][queryIndex]

	-- Clear existing filter
	do
		local children = {}
		for _, operation in self.filterEditPanel:getInnerPanel():iterate() do
			table.insert(children, operation)
		end

		for i = 1, #children do
			self.filterEditPanel:removeChild(children[i])
		end
	end

	for operationIndex = 1, #query do
		self:generateFilterOperation(sectionIndex, queryIndex, operationIndex)
	end

	do
		local addOpButton = Button()
		addOpButton:setText("Add Query")
		addOpButton:setToolTip("Also search for something else.")
		addOpButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		addOpButton:setSize(
			self.filterEditPanel:getInnerPanel():getSize() - Bank.SECTION_PADDING * 2,
			Bank.SECTION_TITLE_BUTTON_SIZE)
		addOpButton.onClick:register(self.addQueryOp, self, sectionIndex, queryIndex)
		self.filterEditPanel:addChild(addOpButton)
	end

	do
		local confirmButton = Button()
		confirmButton:setText("Confirm")
		confirmButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
		confirmButton:setSize(
			self.filterEditPanel:getInnerPanel():getSize() - Bank.SECTION_PADDING * 2,
			Bank.SECTION_TITLE_BUTTON_SIZE)
		confirmButton.onClick:register(self.onPerformQuery, self, sectionIndex, queryIndex)
		self.filterEditPanel:addChild(confirmButton)
	end

	self.filterEditPanel:setScrollSize(self.filterEditPanel:getInnerPanel():getSize())
	self.filterEditPanel:performLayout()

	local scrollSizeX, scrollSizeY = self.filterEditPanel:getScrollSize()
	local scrollX, scrollY = self.filterEditPanel:getScroll()

	self.filterEditPanel:getInnerPanel():setScroll(
		math.min(scrollX, scrollSizeX),
		math.min(scrollY, scrollSizeY))

	self:removeChild(self.tabsLayout)
	self:removeChild(self.addSectionButton)
	self:addChild(self.filterEditPanel)
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
end

function Bank:updateItemLayout(layout, items, source)
	for i = 1, items.max do
		local button = DraggableButton()
		local icon = ItemIcon()
		icon:setData('index', i)
		icon:bind("itemID", string.format("%s[{index}].id", source))
		icon:bind("itemCount", string.format("%s[{index}].count", source))
		icon:bind("itemIsNoted", string.format("%s[{index}].noted", source))
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
		button.onMouseMove:register(self.examine, self, icon, items, i)

		layout:addChild(button)
	end

	layout:setScrollSize(layout:getInnerPanel():getSize())
	layout:setData('source', source)
end

function Bank:examine(icon, inventory, index)
	self:examineItem(icon, inventory, index)
end

function Bank:getRightHandItem(layout, source, x, y)
	if source ~= 'items' then
		return nil
	end

	for i, widget in layout:getInnerPanel():iterate() do
		local widgetX, widgetY = widget:getPosition()
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
	local rightHandItem = self:getRightHandItem(layout, source, absoluteX, absoluteY)
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
	for _, button in layout:getInnerPanel():iterate() do
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
		local destination = self:findButton(self.bankLayout, absoluteX, absoluteY) or
		                    self:findButton(self.inventoryLayout, absoluteX, absoluteY)

		if destination then
			local destinationInventory = destination:getData('source')
			local newIndex
			if destination:isCompatibleType(DraggableButton) then
				newIndex = destination:getData('icon'):getData('index')
			end

			if destinationInventory == 'items' then
				if sourceInventory == 'inventory' then
					local state = self:getState()
					local numItems = state.inventory[index].count
					self:sendPoke("deposit", nil, { index = index, count = numItems })
				else
					if newIndex == nil then
						local rightHandItem = self:getRightHandItem(self.bankLayout, 'items', x, y)
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
		local object
		do
			-- TODO: [LANG]
			local gameDB = self:getView():getGame():getGameDB()
			object = Utility.Item.getName(item.id, gameDB, "en-US")
			if not object then
				object = "*" .. item.id
			end
		end

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
				id = "Withdraw-X",
				verb = "Withdraw-X", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = self.withdrawXCount })
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
		end

		for i = 1, #item.actions do
			table.insert(actions, {
				id = item.actions[i].type,
				verb = item.actions[i].verb,
				object = object,
				callback = function()
					self:sendPoke("poke", nil, { index = index, id = item.actions[i].id })
				end
			})
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
