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

local Bank = Class(Interface)

-- Layout properties
Bank.ITEM_TAB_SIZE = 48
Bank.ITEM_SIZE = 48
Bank.ITEM_ICON_PADDING = 2
Bank.ITEM_PADDING = 12
Bank.MIN_ITEM_TAB_COLUMNS = 2
Bank.MAX_ITEM_TAB_COLUMNS = 6
Bank.INVENTORY_COLUMNS = 4
Bank.SECTION_TITLE_BUTTON_SIZE = 48
Bank.SECTION_PADDING = 4
Bank.TITLE_LABEL_HEIGHT = 48

-- Enums
Bank.QUERY_NONE = -1

-- Styles
Bank.ACTIVE_TAB_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/BankTab-Active.9.png",
	hover = "Resources/Renderers/Widget/Button/BankTab-Active.9.png",
	pressed = "Resources/Renderers/Widget/Button/BankTab-Active.9.png"
}

Bank.INACTIVE_TAB_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/BankTab-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/BankTab-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/BankTab-Pressed.9.png"
}

Bank.BUTTON_STYLE = {
	inactive = "Resources/Renderers/Widget/Button/Purple-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Purple-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Purple-Pressed.9.png"
}

Bank.TITLE_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	width = width,
}

Bank.SECTION_TITLE_STYLE = {
	inactive = Color(0, 0, 0, 0),
	hover = Color(0.7, 0.5, 0.7),
	active = Color(0.6, 0.4, 0.6),
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 24,
	color = Color(1, 1, 1, 1),
	textShadow = true,
	padding = 2
}

function Bank:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/FullscreenInterface.9.png"
	}, ui:getResources()))
	self:addChild(self.panel)

	self.tabsLayout = ScrollablePanel(GridLayout)
	self.tabsLayout:getInnerPanel():setWrapContents(true)
	self.tabsLayout:getInnerPanel():setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)
	do
		local estimatedWidth = math.floor(w / 4)
		local estimatedNumRows = estimatedWidth % (Bank.ITEM_TAB_SIZE + Bank.SECTION_PADDING)
		local clampedNumRows = math.max(math.min(estimatedNumRows, Bank.MAX_ITEM_TAB_COLUMNS), Bank.MIN_ITEM_TAB_COLUMNS)
		local realWidth = clampedNumRows * (Bank.ITEM_TAB_SIZE + Bank.SECTION_PADDING) + Bank.SECTION_PADDING

		self.tabsLayout:setSize(realWidth, h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT)
		self.tabsLayout:setPosition(math.floor(w / 2) + Bank.SECTION_PADDING, Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	end
	self:addChild(self.tabsLayout)

	local tabsBackground = Panel()
	tabsBackground:setZDepth(-1)
	tabsBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/FullscreenGroup.9.png"
	}, ui:getResources()))
	tabsBackground:setPosition(self.tabsLayout:getPosition())
	tabsBackground:setSize(self.tabsLayout:getSize())
	self.panel:addChild(tabsBackground)

	local tabsLabel = Label()
	tabsLabel:setText("Sections")
	tabsLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	tabsLabel:setPosition(self.tabsLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(tabsLabel)

	self.bankLayout = ScrollablePanel(GridLayout)
	self.bankLayout:getInnerPanel():setWrapContents(true)
	self.bankLayout:getInnerPanel():setUniformSize(true, Bank.ITEM_SIZE, Bank.ITEM_SIZE)
	self.bankLayout:getInnerPanel():setPadding(Bank.ITEM_PADDING, Bank.ITEM_PADDING)
	self.bankLayout:setPosition(Bank.ITEM_PADDING, Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	self.bankLayout:setSize(w / 2 - Bank.ITEM_PADDING * 2, h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT)
	self:addChild(self.bankLayout)

	local bankBackground = Panel()
	bankBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/FullscreenGroup.9.png"
	}, ui:getResources()))
	bankBackground:setPosition(self.bankLayout:getPosition())
	bankBackground:setSize(self.bankLayout:getSize())
	self.panel:addChild(bankBackground)

	local bankLabel = Label()
	bankLabel:setText("Bank")
	bankLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	bankLabel:setPosition(self.bankLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(bankLabel)

	self.inventoryLayout = ScrollablePanel(GridLayout)
	self.inventoryLayout:getInnerPanel():setWrapContents(true)
	self.inventoryLayout:getInnerPanel():setUniformSize(true, Bank.ITEM_SIZE, Bank.ITEM_SIZE)
	self.inventoryLayout:getInnerPanel():setPadding(Bank.ITEM_PADDING, Bank.ITEM_PADDING)
	self.inventoryLayout:setPosition(
		w - ((Bank.ITEM_SIZE + Bank.ITEM_PADDING) * Bank.INVENTORY_COLUMNS + Bank.ITEM_PADDING * 2),
		Bank.ITEM_PADDING + Bank.TITLE_LABEL_HEIGHT)
	self.inventoryLayout:setSize(
		(Bank.ITEM_SIZE + Bank.ITEM_PADDING) * Bank.INVENTORY_COLUMNS + Bank.ITEM_PADDING,
		h - Bank.ITEM_PADDING * 2 - Bank.TITLE_LABEL_HEIGHT)
	do
		local state = self:getState()
		self:updateItemLayout(self.inventoryLayout, state.inventory, 'inventory')
	end
	self:addChild(self.inventoryLayout)

	local inventoryBackground = Panel()
	inventoryBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/FullscreenGroup.9.png"
	}, ui:getResources()))
	inventoryBackground:setPosition(self.inventoryLayout:getPosition())
	inventoryBackground:setSize(self.inventoryLayout:getSize())
	self.panel:addChild(inventoryBackground)

	local inventoryLabel = Label()
	inventoryLabel:setText("Inventory")
	inventoryLabel:setStyle(LabelStyle(Bank.TITLE_LABEL_STYLE, ui:getResources()))
	inventoryLabel:setPosition(self.inventoryLayout:getPosition(), Bank.ITEM_PADDING)
	self:addChild(inventoryLabel)

	self.filterSections = {}
	self.activeQuery = Bank.QUERY_NONE
	self:generateFilterSections()
	self:generateTabs()
	self.tabsLayout:performLayout()

	self.numInventorySpaces = 0
	self.numBankSpaces = 0
end

function Bank:generateFilterSection(stateSection, index)
	local w = self.tabsLayout:getSize()

	local gridLayout = GridLayout()
	gridLayout:setWrapContents(true)
	gridLayout:setPadding(Bank.SECTION_PADDING, Bank.SECTION_PADDING)
	gridLayout:setSize(w, Bank.SECTION_TITLE_BUTTON_SIZE)

	local sectionTextBox = TextInput()
	sectionTextBox:setStyle(TextInputStyle(Bank.SECTION_TITLE_STYLE, self:getView():getResources()))
	sectionTextBox:setText(stateSection.name)
	sectionTextBox:setSize(
		w - Bank.SECTION_TITLE_BUTTON_SIZE - Bank.SECTION_PADDING * 5,
		Bank.SECTION_TITLE_BUTTON_SIZE)
	sectionTextBox.onBlur:register(self.renameSection, self, i)
	sectionTextBox.onSubmit:register(self.renameSection, self, i)
	gridLayout:addChild(sectionTextBox)

	local deleteButton = Button()
	deleteButton:setStyle(ButtonStyle(Bank.BUTTON_STYLE, self:getView():getResources()))
	deleteButton:setText("X")
	deleteButton.onClick:register(self, self.deleteSection, sectionIndex)
	deleteButton:setSize(Bank.SECTION_TITLE_BUTTON_SIZE, Bank.SECTION_TITLE_BUTTON_SIZE)
	gridLayout:addChild(deleteButton)

	table.insert(self.filterSections, {
		layout = gridLayout
	})

	self.tabsLayout:addChild(gridLayout)
end

function Bank:renameSection(index, textBox)
	-- TODO
end

function Bank:deleteSection(index)
	-- TODO
end

function Bank:generateFilterSections()
	self:generateFilterSection({ name = "Common" }, 1)
	self:generateFilterSection({ name = "Weapons" }, 2)
end

function Bank:addFilterButton(itemID, sectionIndex, queryIndex)
	local button = Button()
	button:setData('query-index', queryIndex)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = ItemIcon()
	icon:setPosition(Bank.ITEM_ICON_PADDING, Bank.ITEM_ICON_PADDING)
	icon:setItemID(itemID)
	button:addChild(icon)

	button.onClick:register(self.onPerformQuery, self, queryIndex)

	self.filterSections[sectionIndex].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:addAllButton()
	local button = Button()
	button:setData('query-index', Bank.QUERY_NONE)
	button:setSize(Bank.ITEM_TAB_SIZE, Bank.ITEM_TAB_SIZE)

	local icon = Icon()
	icon:setPosition(Bank.ITEM_ICON_PADDING, Bank.ITEM_ICON_PADDING)
	icon:setIcon("Resources/Game/UI/Icons/Things/Chest.png")
	button:addChild(icon)

	button.onClick:register(self.onClearQuery, self)

	self.filterSections[1].layout:addChild(button)
	self:tryMakeButtonActiveStyle(button)
end

function Bank:tryMakeButtonActiveStyle(button)
	local queryIndex = button:getData('query-index')

	if self.activeQuery == queryIndex then
		button:setStyle(ButtonStyle(Bank.ACTIVE_TAB_STYLE, self:getView():getResources()))
	else
		button:setStyle(ButtonStyle(Bank.INACTIVE_TAB_STYLE, self:getView():getResources()))
	end
end

function Bank:generateTabs()
	self:addAllButton()
	self:addFilterButton("UnholySacrificialKnife", 2, 1)
end

function Bank:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if self.numBankSpaces ~= state.items.max then
		local children = {}
		for index, child in self.bankLayout:iterate() do
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
			inactive = "Resources/Renderers/Widget/Button/BankItem.9.png",
			hover = "Resources/Renderers/Widget/Button/BankItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/BankItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)
		button:setData('bank-droppable-target', true)
		button.onDrop:register(self.swap, self)
		button.onDrag:register(self.drag, self, source)
		button.onLeftClick:register(self.activate, self)
		button.onRightClick:register(self.probe, self, source)

		layout:addChild(button)
	end

	layout:setScrollSize(layout:getInnerPanel():getSize())
end

function Bank:getRightHandItem(layout, source, x, y)
	if source ~= 'items' then
		return nil
	end

	for i, widget in layout:iterate() do
		local buttonX, buttonY = widget:getPosition()
		local buttonWidth, buttonHeight = widget:getSize()

		if x >= buttonX + buttonWidth and y >= buttonY and
		   x <= buttonX + buttonWidth + Bank.ITEM_PADDING and y <= buttonY + buttonHeight
		then
			return widget:getData('icon'):getData('index')
		elseif i == 1 and
		       x >= buttonX - Bank.ITEM_PADDING and y >= buttonY and
		       x <= buttonX and y <= buttonY + buttonHeight
		then
			return 0
		end
	end
end

function Bank:drag(source, button, x, y, absoluteX, absoluteY)
	local icon = button:getData('icon')
	local rightHandItem = self:getRightHandItem(source, absoluteX, absoluteY)
	if rightHandItem then
		local SHRINKAGE = 0.5
		icon:setSize(self.ITEM_SIZE * SHRINKAGE, self.ITEM_SIZE * SHRINKAGE)
		icon:setPosition(
			self.ICON_PADDING + (self.ITEM_SIZE * SHRINKAGE / 2),
			self.ICON_PADDING + (self.ITEM_SIZE * SHRINKAGE / 2))
	else
		icon:setSize(self.ITEM_SIZE, self.ITEM_SIZE)
		icon:setPosition(self.ICON_PADDING, self.ICON_PADDING)
	end
	if self:getView():getRenderManager():getCursor() ~= icon then
		self:getView():getRenderManager():setCursor(icon)
	end
end

function Bank:swap(button, x, y)
	local icon = button:getData('icon')
	if self:getView():getRenderManager():getCursor() == icon then
		self:getView():getRenderManager():setCursor(nil)
	end
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

return Bank
