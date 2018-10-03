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
Bank.PADDING = 4
Bank.ICON_PADDING = 2

Bank.ACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}
end

Bank.INACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
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
		Bank.ACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Common/Inventory.png"),
		self:getView():getResources()))
	inventoryButton.onClick:register(self.openInventory, self)
	self.tabsLayout:addChild(inventoryButton)

	local bankButton = Button()
	bankButton:setStyle(ButtonStyle(
		Bank.ACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Common/Inventory.png"),
		self:getView():getResources()))
	bankButton.onClick:register(self.openBank, self)
	self.tabsLayout:addChild(bankButton)

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
	self:addChild(self.tabContentLayout)

	self.closeButton = Button()
	self.closeButton:setSize(Bank.BUTTON_SIZE, Bank.BUTTON_SIZE)
	self.closeButton:setPosition(Bank.WIDTH - Bank.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.currentSource = 'items'
	self.previousSource = false
end

function Bank:openInventory()
	self.currentSource = 'inventory'
end

function Bank:openBank()
	self.currentSource = 'items'
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

function Bank:drag(button, x, y)
	if self:getView():getRenderManager():getCursor() ~= button:getData('icon') then
		self:getView():getRenderManager():setCursor(button:getData('icon'))
	end
end

function Bank:swap(button, x, y)
	local index = button:getData('icon'):getData('index')
	if index then
		local inputProvider = self:getView():getInputProvider()
		local destination
		do
			local widgets = inputProvider:getWidgetsUnderPoint(x, y)
			for i = 1, #widgets do
				if widgets[i]:getData('bank-droppable-target') then
					destination = widgets[i]
					break
				end
			end
		end

		if destination then
			if self.currentSource == 'items' then
				self:sendPoke("bankSwap", nil, { a = index, b = newIndex })
			elseif self.currentSource == 'inventory' then
				self:sendPoke("inventorySwap", nil, { a = index, b = newIndex })
			end
		end
	end


	if self:getView():getRenderManager():getCursor() == button:getData('icon') then
		self:getView():getRenderManager():setCursor(nil)
	end
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
					self:sendPoke("deposit", nil, { index = index, count = item.count })
				end
			})
		elseif self.currentSource == 'items' then
			table.insert(actions, {
				id = "Withdraw-1",
				verb = "Withdraw", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { index = index, count = 1 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-10",
				verb = "Withdraw-10", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { index = index, count = 10 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-100",
				verb = "Withdraw-100", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { index = index, count = 100 })
				end
			})

			table.insert(actions, {
				id = "Withdraw-All",
				verb = "Withdraw-All", -- TODO: [LANG]
				object = object,
				callback = function()
					self:sendPoke("withdraw", nil, { index = index, count = item.count })
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
				-- TODO: examine item
				Log.info("It's a %s.", object)
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
			self:sendPoke("withdraw", nil, { index = index, count = 1 })
		end
	end
end

return Bank
