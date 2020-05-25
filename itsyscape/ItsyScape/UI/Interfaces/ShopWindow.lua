--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/PlayerStats.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Icon = require "ItsyScape.UI.Icon"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Widget = require "ItsyScape.UI.Widget"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local ShopWindow = Class(Interface)
ShopWindow.WIDTH = 480
ShopWindow.HEIGHT = 320
ShopWindow.BUTTON_SIZE = 48
ShopWindow.BUTTON_PADDING = 4
ShopWindow.PADDING = 4
ShopWindow.TAB_SIZE = 48

ShopWindow.ACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}
end

ShopWindow.INACTIVE_TAB_STYLE = function(icon)
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		icon = { filename = icon, x = 0.5, y = 0.5 }
	}
end

function ShopWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(ShopWindow.WIDTH, ShopWindow.HEIGHT)
	self:setPosition(
		(w - ShopWindow.WIDTH) / 2,
		(h - ShopWindow.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	self.tabs = {}
	self.tabsLayout = ScrollablePanel(GridLayout)
	self.tabsLayout:getInnerPanel():setUniformSize(
		true,
		ShopWindow.TAB_SIZE,
		ShopWindow.TAB_SIZE)
	self.tabsLayout:getInnerPanel():setPadding(ShopWindow.PADDING, ShopWindow.PADDING)
	self.tabsLayout:setSize(
		ShopWindow.WIDTH - ShopWindow.PADDING * 2,
		ShopWindow.TAB_SIZE + ShopWindow.PADDING)
	self:addChild(self.tabsLayout)

	local inventoryButton = Button()
	inventoryButton:setStyle(ButtonStyle(
		ShopWindow.INACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Common/Inventory.png"),
		self:getView():getResources()))
	inventoryButton.onClick:register(self.openInventory, self)
	inventoryButton:setData('tab-icon', "Resources/Game/UI/Icons/Common/Inventory.png")
	self.tabsLayout:addChild(inventoryButton)

	local shopButton = Button()
	shopButton:setStyle(ButtonStyle(
		ShopWindow.ACTIVE_TAB_STYLE("Resources/Game/UI/Icons/Things/Chest.png"),
		self:getView():getResources()))
	shopButton.onClick:register(self.openShopWindow, self)
	shopButton:setData('tab-icon', "Resources/Game/UI/Icons/Things/Chest.png")
	self.tabsLayout:addChild(shopButton)

	self.activeTabButton = shopButton

	self.sellInventory = {}
	self.sellGrid = ScrollablePanel(GridLayout)
	self.sellGrid:getInnerPanel():setWrapContents(true)
	self.sellGrid:getInnerPanel():setUniformSize(
		true,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2)
	self.sellGrid:getInnerPanel():setPadding(ShopWindow.BUTTON_PADDING)
	self.sellGrid:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT - ShopWindow.TAB_SIZE - ShopWindow.PADDING * 2)
	self.sellGrid:setPosition(0, ShopWindow.TAB_SIZE + ShopWindow.PADDING * 2)

	self.buyGrid = ScrollablePanel(GridLayout)
	self.buyGrid:getInnerPanel():setUniformSize(
		true,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2,
		ShopWindow.BUTTON_SIZE + ShopWindow.BUTTON_PADDING * 2)
	self.buyGrid:getInnerPanel():setPadding(ShopWindow.BUTTON_PADDING)
	self.buyGrid:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT - ShopWindow.TAB_SIZE - ShopWindow.PADDING * 2)
	self.buyGrid:setPosition(0, ShopWindow.TAB_SIZE + ShopWindow.PADDING * 2)
	self:addChild(self.buyGrid)

	self.costPanel = ConstraintsPanel(self:getView())
	self.costPanel:setText("Cost")
	self.costPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self.costPanel:setPosition(ShopWindow.WIDTH * (1 / 2), 0)
	self:addChild(self.costPanel)

	self.productPanel = ConstraintsPanel(self:getView())
	self.productPanel:setText("Product")
	self.productPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self.productPanel:setPosition(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT / 3)
	self:addChild(self.productPanel)

	self.buyActionPanel = GridLayout()
	self.buyActionPanel:setPadding(ShopWindow.PADDING)
	self.buyActionPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.PADDING * 2 + ShopWindow.BUTTON_SIZE * 3)
	self.buyActionPanel:setPosition(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT - ShopWindow.BUTTON_SIZE * 2 - ShopWindow.PADDING * 5)

	self.buyQuantityInput = TextInput()
	self.buyQuantityInput:setText("1")
	self.buyQuantityInput:setSize(ShopWindow.WIDTH / 2 * (2 / 3), ShopWindow.BUTTON_SIZE)
	self.buyQuantityInput.onFocus:register(function(input)
		self.buyQuantityInput:setCursor(0, #self.buyQuantityInput:getText() + 1)
	end)
	self.buyActionPanel:addChild(self.buyQuantityInput)

	do
		local QUANTITIES = {
			false, 1, 10, 100
		}

		for i = 1, #QUANTITIES do
			local quantity = QUANTITIES[i]
			local buyButton = Button()
			buyButton:setText(tostring(quantity or "Buy"))
			buyButton.onClick:register(self.buy, self, quantity)
			buyButton:setSize(ShopWindow.WIDTH / 2 / 4, ShopWindow.BUTTON_SIZE)
			self.buyActionPanel:addChild(buyButton)
		end
	end

	self.sellActionPanel = GridLayout()
	self.sellActionPanel:setPadding(ShopWindow.PADDING)
	self.sellActionPanel:setSize(ShopWindow.WIDTH * (1 / 2), ShopWindow.PADDING * 2 + ShopWindow.BUTTON_SIZE * 3)
	self.sellActionPanel:setPosition(ShopWindow.WIDTH * (1 / 2), ShopWindow.HEIGHT - ShopWindow.BUTTON_SIZE * 2 - ShopWindow.PADDING * 5)

	self.sellQuantityInput = TextInput()
	self.sellQuantityInput:setText("1")
	self.sellQuantityInput:setSize(ShopWindow.WIDTH / 2 * (2 / 3), ShopWindow.BUTTON_SIZE)
	self.sellQuantityInput.onFocus:register(function(input)
		self.sellQuantityInput:setCursor(0, #self.sellQuantityInput:getText() + 1)
	end)
	self.sellActionPanel:addChild(self.sellQuantityInput)

	do
		local QUANTITIES = {
			false, 1, 10, 100
		}

		for i = 1, #QUANTITIES do
			local quantity = QUANTITIES[i]
			local sellButton = Button()
			sellButton:setText(tostring(quantity or "Sell"))
			sellButton.onClick:register(self.sell, self, quantity)
			sellButton:setSize(ShopWindow.WIDTH / 2 / 4, ShopWindow.BUTTON_SIZE)
			self.sellActionPanel:addChild(sellButton)
		end
	end

	self.closeButton = Button()
	self.closeButton:setSize(ShopWindow.BUTTON_SIZE, ShopWindow.BUTTON_SIZE)
	self.closeButton:setPosition(ShopWindow.WIDTH - ShopWindow.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.ready = false
	self.activeItem = false
	self.previousSelection = false
end

function ShopWindow:update(...)
	Interface.update(self, ...)

	if not self.ready then
		local state = self:getState()
		local gameDB = self:getView():getGame():getGameDB()
		local brochure = gameDB:getBrochure()
		for i = 1, #state.inventory do
			local action = gameDB:getAction(state.inventory[i].id)
			if action then
				local item, quantity
				for output in brochure:getOutputs(action) do
					local outputResource = brochure:getConstraintResource(output)
					local outputType = brochure:getResourceTypeFromResource(outputResource)
					if outputType.name == "Item" then
						item = outputResource
						quantity = output.count
						break
					end
				end

				if item then
					local name, description = Utility.Item.getInfo(
						item.name,
						self:getView():getGame():getGameDB())

					local button = Button()
					button.onClick:register(self.selectItem, self, state.inventory[i])

					local itemIcon = ItemIcon()
					itemIcon:setItemID(item.name)
					if quantity > 1 then
						itemIcon:setItemCount(quantity)
					end
					itemIcon:setPosition(2, 2)

					itemIcon:setToolTip(
						ToolTip.Header(name),
						ToolTip.Text(description))

					button:addChild(itemIcon)

					self.buyGrid:addChild(button)
				end
			end
		end

		self.ready = true
	end

	do
		local state = self:getState()

		for i = 1, #self.sellInventory do
			self.sellGrid:removeChild(self.sellInventory[i])
		end

		local index = 1
		for i = 1, state.playerInventory.max do
			local item = state.playerInventory[i]

			if item then
				local name, description = Utility.Item.getInfo(
					item.id,
					self:getView():getGame():getGameDB())

				local button = self.sellInventory[index] or Button()
				button.onClick:unregister(self.selectItem)
				button.onClick:register(self.selectItem, self, i)

				local itemIcon = button:getData('icon') or ItemIcon()
				itemIcon:setItemID(item.id)
				itemIcon:setItemCount(item.count)
				itemIcon:setItemIsNoted(item.noted)
				itemIcon:setPosition(2, 2)

				itemIcon:setToolTip(
					ToolTip.Header(name),
					ToolTip.Text(description))

				button:addChild(itemIcon)

				button:setData('icon', itemIcon)

				self.sellGrid:addChild(button)
				self.sellInventory[index] = button

				index = index + 1
			end
		end

		self.sellGrid:setScrollSize(self.sellGrid:getInnerPanel():getSize())
		do
			local sw, sh = self.sellGrid:getScrollSize()
			local w, h = self.sellGrid:getSize()
			local sx, sy = self.sellGrid:getInnerPanel():getScroll()
			self.sellGrid:getInnerPanel():setScroll(
				math.min(sw - w, sx),
				math.min(sh - h, sy))
			self.sellGrid:performLayout()
		end
	end
end

function ShopWindow:openInventory(button)
	self:activateTab(button)

	self:removeChild(self.buyGrid)
	self:addChild(self.sellGrid)

	self:sendPoke("viewInventory", nil, {})
end

function ShopWindow:openShopWindow(button)
	self:activateTab(button)

	self:removeChild(self.sellGrid)
	self:addChild(self.buyGrid)

	self:sendPoke("viewShop", nil, {})
end

function ShopWindow:activateTab(button)
	if self.activeTabButton then
		local style = ShopWindow.INACTIVE_TAB_STYLE(self.activeTabButton:getData('tab-icon'))
		self.activeTabButton:setStyle(ButtonStyle(style, self:getView():getResources()))
	end

	local style = ShopWindow.ACTIVE_TAB_STYLE(button:getData('tab-icon'))
	button:setStyle(ButtonStyle(style, self:getView():getResources()))
	self.activeTabButton = button
end

function ShopWindow:selectItem(action, button)
	if self.previousSelection then
		self.previousSelection:setStyle(nil)
	end

	if self.previousSelection ~= button and button then
		button:setStyle(ButtonStyle({
			pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
			inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
			hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png"
		}, self:getView():getResources()))

		self.previousSelection = button

		if type(action) == 'number' then
			self.activePlayerInventoryItem = action
			self:sendPoke("selectInventory", nil, { index = action })
			self:addChild(self.sellActionPanel)
			self.sellQuantityInput:setText(tostring(button:getData('icon'):getItemCount()))
		else
			self.activeItem = action
			self:sendPoke("selectShop", nil, { id = action.id })
			self.buyQuantityInput:setText(tostring(action.count))
			self:addChild(self.buyActionPanel)
		end
	else
		self.activeItem = false
		self.previousSelection = false
		self.activePlayerInventoryItem = false
		self:removeChild(self.buyActionPanel)
		self:removeChild(self.sellActionPanel)
		self:populateRequirements({
			inputs = {},
			outputs = {}
		})
	end
end

function ShopWindow:populateRequirements(e)
	self.costPanel:setConstraints(e.inputs)
	self.productPanel:setConstraints(e.outputs)
end

function ShopWindow:buy(quantity)
	if not quantity then
		local s, r = pcall(tonumber, self.buyQuantityInput:getText())
		if s then
			quantity = r
		end

		if quantity then
			self:sendPoke("buy", nil, { id = self.activeItem.id, count = quantity })
		end
	else
		self.buyQuantityInput:setText(tostring(quantity))
	end
end

function ShopWindow:sell(quantity)
	if not quantity then
		local s, r = pcall(tonumber, self.sellQuantityInput:getText())
		if s then
			quantity = r
		end

		if quantity then
			self:sendPoke("sell", nil, { index = self.activePlayerInventoryItem, count = quantity })
			self:selectItem()
		end
	else
		self.sellQuantityInput:setText(tostring(quantity))
	end
end

return ShopWindow
