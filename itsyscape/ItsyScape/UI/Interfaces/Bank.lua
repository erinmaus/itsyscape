--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local DraggableButton = require "ItsyScape.UI.DraggableButton"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local Widget = require "ItsyScape.UI.Widget"

local Bank = Class(Interface)
Bank.WIDTH = 480
Bank.HEIGHT = 320
Bank.TAB_SIZE = 48
Bank.ITEM_SIZE = 48
Bank.BUTTON_SIZE = 48
Bank.PADDING = 12
Bank.ICON_PADDING = 2

Bank.ACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}
end

Bank.INACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}
end

function Bank:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(Bank.WIDTH, Bank.HEIGHT)
	self:setPosition(
		(w - Bank.WIDTH) / 2,
		(h - Bank.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.tabs = {}
	self.tabsLayout = ScrollablePanel(GridLayout)
	self.tabsLayout:getInnerPanel():setUniformSize(
		true,
		Bank.TAB_SIZE,
		Bank.TAB_SIZE)
	self.tabsLayout:getInnerPanel():setPadding(Bank.PADDING, Bank.PADDING)
	self.tabsLayout:setSize(
		Bank.WIDTH - Bank.PADDING * 2,
		Bank.TAB_SIZE + Bank.PADDING)
	self:addChild(self.tabsLayout)

	local inventoryButton = Button()
	inventoryButton:setStyle(ButtonStyle(
		Bank.INACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Common/Inventory.png"),
		self:getView():getResources()))
	inventoryButton.onClick:register(self.openInventory, self)
	inventoryButton:setData('tab-icon', "Resources/Game/UI/Icons/Common/Inventory.png")
	self.tabsLayout:addChild(inventoryButton)

	local bankButton = Button()
	bankButton:setStyle(ButtonStyle(
		Bank.ACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Things/Chest.png"),
		self:getView():getResources()))
	bankButton.onClick:register(self.openBank, self)
	bankButton:setData('tab-icon', "Resources/Game/UI/Icons/Things/Chest.png")
	self.tabsLayout:addChild(bankButton)

	local noteButton = Button()
	noteButton.onClick:register(self.toggleNote, self)
	noteButton:setToolTip(
		"Withdraw items as notes.",
		"Noted items are stackable but are only useful for trading.")
	local noteIcon = Icon()
	noteIcon:setSize(32, 32)
	noteIcon:setPosition(8, 8)
	noteIcon:setIcon("Resources/Game/Items/Note.png")
	noteButton:addChild(noteIcon)
	self.tabsLayout:addChild(noteButton)

	self.tabContent = { max = 0}
	self.tabContentLayout = ScrollablePanel(GridLayout)
	self.tabContentLayout:getInnerPanel():setWrapContents(true)
	self.tabContentLayout:getInnerPanel():setUniformSize(
		true,
		Bank.ITEM_SIZE,
		Bank.ITEM_SIZE)
	self.tabContentLayout:getInnerPanel():setPadding(
		Bank.PADDING,
		Bank.PADDING)
	self.tabContentLayout:setPosition(
		Bank.PADDING,
		Bank.TAB_SIZE + Bank.PADDING * 2)
	self.tabContentLayout:setSize(
		Bank.WIDTH - Bank.PADDING * 2,
		Bank.HEIGHT - Bank.TAB_SIZE - Bank.PADDING * 2)
	self.tabContentLayout:getInnerPanel():setSize(
		Bank.WIDTH - Bank.PADDING * 2,
		Bank.HEIGHT - Bank.TAB_SIZE - Bank.PADDING * 2)
	self.tabContentLayout:setFloatyScrollBars(false)
	self:addChild(self.tabContentLayout)

	self.closeButton = Button()
	self.closeButton:setSize(Bank.BUTTON_SIZE, Bank.BUTTON_SIZE)
	self.closeButton:setPosition(Bank.WIDTH - Bank.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self:activateTab(bankButton)
	self.previousSource = false
	self.currentSource = 'items'

	self.noted = false
end

function Bank:activateTab(button)
	if self.activeButton then
		local style = Bank.INACTIVE_TAB_STYLE(self.activeButton:getData('tab-icon'))
		self.activeButton:setStyle(ButtonStyle(style, self:getView():getResources()))
	end

	local style = Bank.ACTIVE_TAB_STYLE(button:getData('tab-icon'))
	button:setStyle(ButtonStyle(style, self:getView():getResources()))
	self.activeButton = button

	self.tabContentLayout:setScroll(0, 0)
	self.tabContentLayout:getInnerPanel():setScroll(0, 0)
end

function Bank:openInventory(button)
	self.currentSource = 'inventory'
	self:activateTab(button)
end

function Bank:openBank(button)
	self.currentSource = 'items'
	self:activateTab(button)
end

function Bank:toggleNote(button)
	self.noted = not self.noted

	if self.noted then
		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png"
		}, self:getView():getResources()))
	else
		button:setStyle(false)
	end
end

function Bank:update(...)
	Interface.update(self, ...)

	local state = self:getState()
	if self.currentSource ~= self.previousSource or
	   self.tabContent.max ~= state[self.currentSource].max
	then
		local items = state[self.currentSource]

		for _, item in pairs(self.tabContent) do
			self.tabContentLayout:removeChild(item)
		end
		self.tabContent = { max = items.max }

		for i = 1, items.max do
			local button = DraggableButton()
			local icon = ItemIcon()
			icon:setData('index', i)
			icon:setData('source', self.currentSource)
			icon:bind("itemID", string.format("%s[{index}].id", self.currentSource))
			icon:bind("itemCount", string.format("%s[{index}].count", self.currentSource))
			icon:bind("itemIsNoted", string.format("%s[{index}].noted", self.currentSource))
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
			button.onDrop:register(self.swap, self)
			button.onDrag:register(self.drag, self)
			button.onLeftClick:register(self.activate, self)
			button.onRightClick:register(self.probe, self)

			self.tabContentLayout:addChild(button)
			table.insert(self.tabContent, button)
		end

		self.tabContentLayout:setScrollSize(
			self.tabContentLayout:getInnerPanel():getSize())

		self.previousSource = self.currentSource
	end
end

function Bank:getRightHandItem(x, y)
	if self.currentSource == 'items' then
		for i = 1, #self.tabContent do
			local buttonX, buttonY = self.tabContent[i]:getPosition()
			local buttonWidth, buttonHeight = self.tabContent[i]:getSize()

			if x >= buttonX + buttonWidth and y >= buttonY and
			   x <= buttonX + buttonWidth + self.PADDING and y <= buttonY + buttonHeight
			then
				return self.tabContent[i]:getData('icon'):getData('index')
			elseif i == 1 and
			       x >= buttonX - self.PADDING and y >= buttonY and
			       x <= buttonX and y <= buttonY + buttonHeight
			then
				return 0
			end
		end
	end
end

function Bank:drag(button, x, y, absoluteX, absoluteY)
	local icon = button:getData('icon')
	local rightHandItem = self:getRightHandItem(absoluteX, absoluteY)
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
	local index = icon:getData('index')
	if index then
		local inputProvider = self:getView():getInputProvider()
		local destination
		do
			for i = 1, #self.tabContent do
				local buttonX, buttonY = self.tabContent[i]:getPosition()
				local buttonWidth, buttonHeight = self.tabContent[i]:getSize()

				if x >= buttonX and y >= buttonY and
				   x <= buttonX + buttonWidth and y <= buttonY + buttonHeight
				then
					destination = self.tabContent[i]
					break
				end
			end
		end

		if destination then
			local newIndex = destination:getData('icon'):getData('index')
			if self.currentSource == 'items' then
				self:sendPoke("swapBank", nil, { tab = 0, a = index, b = newIndex })
			elseif self.currentSource == 'inventory' then
				self:sendPoke("swapInventory", nil, { a = index, b = newIndex })
			end
		else
			if self.currentSource == 'items' then
				local rightHandItem = self:getRightHandItem(x, y)
				if rightHandItem then
					if rightHandItem <= index then
						rightHandItem = rightHandItem + 1
					end

					self:sendPoke("insertBank", nil, { tab = 0, a = index, b = rightHandItem })
				end
			end
		end
	end

	if self:getView():getRenderManager():getCursor() == icon then
		self:getView():getRenderManager():setCursor(nil)
	end

	icon:setSize(self.ITEM_SIZE, self.ITEM_SIZE)
	icon:setPosition(self.ICON_PADDING, self.ICON_PADDING)
end

function Bank:probe(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState()[self.currentSource] or {}
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

		if self.currentSource == 'inventory' then
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
		elseif self.currentSource == 'items' then
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

function Bank:activate(button)
	local index = button:getData('icon'):getData('index')
	local items = self:getState()[self.currentSource] or {}
	local item = items[index]
	if item then
		if self.currentSource == 'inventory' then
			self:sendPoke("deposit", nil, { index = index, count = 1 })
		elseif self.currentSource == 'items' then
			self:sendPoke("withdraw", nil, { noted = self.noted, index = index, count = 1 })
		end
	end
end

return Bank
