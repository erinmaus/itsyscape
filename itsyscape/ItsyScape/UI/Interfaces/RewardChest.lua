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
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local RewardChest = Class(Interface)
RewardChest.WIDTH = 480
RewardChest.HEIGHT = 320
RewardChest.TAB_SIZE = 48
RewardChest.ITEM_SIZE = 48
RewardChest.BUTTON_SIZE = 48
RewardChest.ACTION_BUTTON_WIDTH = 128
RewardChest.PADDING = 12
RewardChest.ICON_PADDING = 2
RewardChest.ICON_SIZE = 48

function RewardChest:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(RewardChest.WIDTH, RewardChest.HEIGHT)
	self:setPosition(
		(w - RewardChest.WIDTH) / 2,
		(h - RewardChest.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(self:getSize())
	self:addChild(panel)

	local icon = Icon()
	icon:setIcon("Resources/Game/UI/Icons/Things/Chest.png")
	icon:setPosition(RewardChest.PADDING, RewardChest.PADDING)
	self:addChild(icon)

	local titleLabel = Label()
	titleLabel:setText("Reward Chest")
	titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	titleLabel:setPosition(RewardChest.PADDING * 2 + RewardChest.ICON_SIZE, RewardChest.PADDING)
	self:addChild(titleLabel)

	self.contentLayout = ScrollablePanel(GridLayout)
	self.contentLayout:getInnerPanel():setWrapContents(true)
	self.contentLayout:getInnerPanel():setUniformSize(
		true,
		RewardChest.ITEM_SIZE,
		RewardChest.ITEM_SIZE)
	self.contentLayout:getInnerPanel():setPadding(
		RewardChest.PADDING,
		RewardChest.PADDING)
	self.contentLayout:setPosition(
		RewardChest.PADDING,
		RewardChest.TAB_SIZE + RewardChest.PADDING * 2)
	self.contentLayout:setSize(
		RewardChest.WIDTH - RewardChest.PADDING * 2,
		RewardChest.HEIGHT - RewardChest.TAB_SIZE - RewardChest.PADDING * 2 - RewardChest.BUTTON_SIZE - RewardChest.PADDING * 2)
	self.contentLayout:getInnerPanel():setSize(
		RewardChest.WIDTH - RewardChest.PADDING * 2,
		RewardChest.HEIGHT - RewardChest.TAB_SIZE - RewardChest.PADDING * 2)
	self.contentLayout:setFloatyScrollBars(false)
	self:addChild(self.contentLayout)

	self.collectButton = Button()
	self.collectButton:setText("Collect")
	self.collectButton:setSize(RewardChest.ACTION_BUTTON_WIDTH, RewardChest.BUTTON_SIZE)
	self.collectButton:setPosition(
		RewardChest.WIDTH - RewardChest.ACTION_BUTTON_WIDTH - RewardChest.PADDING,
		RewardChest.HEIGHT - RewardChest.BUTTON_SIZE - RewardChest.PADDING)
	self.collectButton.onClick:register(function()
		self:sendPoke("collect", nil, {})
	end)
	self:addChild(self.collectButton)

	self.closeButton = Button()
	self.closeButton:setSize(RewardChest.BUTTON_SIZE, RewardChest.BUTTON_SIZE)
	self.closeButton:setPosition(RewardChest.WIDTH - RewardChest.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self:populate()
end

function RewardChest:populate()
	local state = self:getState()
	local items = state.items

	for i = 1, #items do
		local button = Button()
		local icon = ItemIcon()
		icon:setData('index', i)
		icon:setData('source', self.currentSource)
		icon:bind("itemID", string.format("items[{index}].id"))
		icon:bind("itemCount", string.format("items[{index}].count"))
		icon:bind("itemIsNoted", string.format("items[{index}].noted"))
		icon:setSize(
			RewardChest.ICON_SIZE,
			RewardChest.ICON_SIZE)
		icon:setPosition(
			RewardChest.ICON_PADDING,
			RewardChest.ICON_PADDING)

		button:setStyle(ButtonStyle({
			inactive = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			hover = "Resources/Renderers/Widget/Button/InventoryItem.9.png",
			pressed = "Resources/Renderers/Widget/Button/InventoryItem.9.png"
		}, self:getView():getResources()))

		button:addChild(icon)
		button:setData('icon', icon)

		button:setToolTip(
			ToolTip.Header(items[i].name),
			ToolTip.Text(items[i].description))

		self.contentLayout:addChild(button)
	end

	self.contentLayout:setScrollSize(
		self.contentLayout:getInnerPanel():getSize())
end

function RewardChest:getRightHandItem(x, y)
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

function RewardChest:drag(button, x, y, absoluteX, absoluteY)
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

function RewardChest:swap(button, x, y)
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
				self:sendPoke("swapRewardChest", nil, { tab = 0, a = index, b = newIndex })
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

					self:sendPoke("insertRewardChest", nil, { tab = 0, a = index, b = rightHandItem })
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

function RewardChest:probe(button)
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
					self:sendPoke("withdraw", nil, { index = index, count = math.huge })
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

function RewardChest:activate(button)
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

return RewardChest
