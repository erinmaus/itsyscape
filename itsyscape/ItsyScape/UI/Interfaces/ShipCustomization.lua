--------------------------------------------------------------------------------
-- ItsyScape/UI/ShipCustomization.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Vector = require "ItsyScape.Common.Math.Vector"
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local ThirdPersonCamera = require "ItsyScape.Graphics.ThirdPersonCamera"
local SceneSnippet = require "ItsyScape.UI.SceneSnippet"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Icon = require "ItsyScape.UI.Icon"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local ShipCustomization = Class(Interface)
ShipCustomization.WIDTH = 800
ShipCustomization.HEIGHT = 600
ShipCustomization.TAB_SIZE = 48
ShipCustomization.PADDING = 8
ShipCustomization.DEFAULT_ITEMS = {
	["Cannon"] = "Cannon_Iron",
	["Helm"] = "Helm_Common",
	["Hull"] = "Hull_Common",
	["Rigging"] = "Rigging_Common",
	["Sail"] = "Sail_Common",
	["Storage"] = "Storage_Crate",
	["Figurehead"] = "Figurehead_Common"
}

ShipCustomization.STATS = {
	{ stat = "Health", name = "Health" },
	{ stat = "OffenseRange", name = "Cannon Range" },
	{ stat = "Distance", name = "Distance" },
	{ stat = "OffenseMinDamage", name = "Min Damage" },
	{ stat = "Defense", name = "Defense" },
	{ stat = "OffenseMaxDamage", name = "Max Damage" },
	{ stat = "Speed", name = "Speed" },
}

ShipCustomization.COLORS = {
	"Red",
	"Green",
	"Blue"
}

ShipCustomization.COLOR_CHANNELS = {
	"Primary",
	"Accent"
}

ShipCustomization.ACTIVE_TAB_STYLE = function()
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png"
	}
end

ShipCustomization.INACTIVE_TAB_STYLE = function()
	return {
		inactive = "Resources/Renderers/Widget/Button/Ribbon-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Ribbon-Hover.9.png",
		pressed = "Resources/Renderers/Widget/Button/Ribbon-Pressed.9.png"
	}
end

ShipCustomization.ACTIVE_ITEM_STYLE = function()
	return {
		pressed = "Resources/Renderers/Widget/Button/ActiveDefault-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/ActiveDefault-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/ActiveDefault-Hover.9.png",
		fontSize = 16,
		textShadow = true
	}
end

ShipCustomization.INACTIVE_ITEM_STYLE = function()
	return {
		pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
		fontSize = 16,
		textShadow = true
	}
end

function ShipCustomization:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(ShipCustomization.WIDTH, ShipCustomization.HEIGHT)
	self:setPosition(
		(w - ShipCustomization.WIDTH) / 2,
		(h - ShipCustomization.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(ShipCustomization.WIDTH, ShipCustomization.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(ShipCustomization.TAB_SIZE, ShipCustomization.TAB_SIZE)
	self.closeButton:setPosition(ShipCustomization.WIDTH - ShipCustomization.TAB_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.shipScene = SceneSnippet()
	self.shipScene:setIsFullLit(true)
	self.shipScene:setSize(ShipCustomization.WIDTH / 2, ShipCustomization.HEIGHT / 2)
	self.shipScene:setPosition(
		ShipCustomization.PADDING,
		ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	self:addChild(self.shipScene)

	self.camera = ThirdPersonCamera()
	self.camera:setDistance(55)
	self.camera:setUp(Vector(0, -1, 0))
	self.camera:setPosition(Vector(23.5, 10, 28))
	self.camera:setHorizontalRotation(-math.pi / 8)
	self.camera:setWidth(ShipCustomization.WIDTH / 2)
	self.camera:setHeight(ShipCustomization.HEIGHT / 2)
	self.shipScene:setCamera(self.camera)

	self.statsPanel = GridLayout()
	self.statsPanel:setWrapContents(true)
	self.statsPanel:setSize(ShipCustomization.WIDTH / 2, ShipCustomization.HEIGHT / 2)
	self.statsPanel:setPadding(ShipCustomization.PADDING, ShipCustomization.PADDING)
	self.statsPanel:setUniformSize(
		true,
		ShipCustomization.WIDTH / 4 - ShipCustomization.PADDING * 2,
		(ShipCustomization.HEIGHT - ShipCustomization.PADDING * 4) / 16)
	self.statsPanel:setPosition(
		0,
		ShipCustomization.HEIGHT / 2 + ShipCustomization.TAB_SIZE + ShipCustomization.PADDING * 2)
	self:addChild(self.statsPanel)
	do
		local _, panelWidth, panelHeight = self.statsPanel:getUniformSize()

		for i = 1, #ShipCustomization.STATS do
			local stat = ShipCustomization.STATS[i]
			local statPanel = GridLayout()
			statPanel:setWrapContents(true)
			statPanel:setPadding(0, 0)

			local leftLabel = Label()
			leftLabel:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
				fontSize = 18,
				textShadow = true,
				color = { 1, 1, 1, 1 }
			}, ui:getResources()))
			leftLabel:setText(stat.name)
			leftLabel:setSize(panelWidth * (3 / 4), panelHeight)
			statPanel:addChild(leftLabel)

			local rightLabel = Label()
			rightLabel:setStyle(LabelStyle({
				font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
				fontSize = 18,
				textShadow = true,
				color = { 1, 1, 1, 1 }
			}, ui:getResources()))
			rightLabel:bind("text", "stats[{stat}]")
			rightLabel:setData("stat", stat.stat)
			rightLabel:setSize(panelWidth * (1 / 4), panelHeight)
			statPanel:addChild(rightLabel)

			self.statsPanel:addChild(statPanel)
		end
	end

	self.tabLayout = GridLayout()
	self.tabLayout:setPadding(ShipCustomization.PADDING)
	self.tabLayout:setUniformSize(
		true,
		ShipCustomization.TAB_SIZE,
		ShipCustomization.TAB_SIZE)
	self.tabLayout:setPosition(0, 0)
	self.tabLayout:setSize(
		ShipCustomization.WIDTH,
		ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	self:addChild(self.tabLayout)

	self.itemsLayout = ScrollablePanel(GridLayout)
	self.itemsLayout:getInnerPanel():setWrapContents(true)
	self.itemsLayout:getInnerPanel():setPadding(ShipCustomization.PADDING / 2)
	self.itemsLayout:getInnerPanel():setUniformSize(
		true,
		ShipCustomization.WIDTH / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE - ShipCustomization.PADDING,
		ShipCustomization.TAB_SIZE)
	self.itemsLayout:setSize(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2)
	self.itemsLayout:setPosition(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	self:addChild(self.itemsLayout)
	self.items = {}

	self.colorPanel = Panel()
	self.colorPanel:setStyle(PanelStyle({}, ui:getResources()))
	self.colorPanel:setSize(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 - ShipCustomization.PADDING * 2 - ShipCustomization.TAB_SIZE)
	self.colorPanel:setPosition(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 + ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	self.colorInputs = {}
	do
		local panelWidth, panelHeight = self.colorPanel:getSize()

		for i = 1, #ShipCustomization.COLOR_CHANNELS do
			local channel = ShipCustomization.COLOR_CHANNELS[i]:lower()

			do
				local label = Label()
				label:setStyle(LabelStyle({
					font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
					fontSize = 24,
					textShadow = true,
					color = { 1, 1, 1, 1 }
				}, ui:getResources()))
				label:setText(ShipCustomization.COLOR_CHANNELS[i])
				label:setPosition((i - 1) / #ShipCustomization.COLOR_CHANNELS * panelWidth, 0)
				self.colorPanel:addChild(label)
			end

			local panel = GridLayout()
			panel:setSize(
				panelWidth / #ShipCustomization.COLOR_CHANNELS,
				panelHeight)
			panel:setPosition(
				(i - 1) / #ShipCustomization.COLOR_CHANNELS * panelWidth,
				24)
			panel:setUniformSize(
				true,
				panelWidth / 4 - ShipCustomization.PADDING * 2,
				32)
			panel:setPadding(ShipCustomization.PADDING, ShipCustomization.PADDING)

			local inputs = {}
			for j = 1, #ShipCustomization.COLORS do
				local color = ShipCustomization.COLORS[j]:lower()
				local label = Label()
				label:setText(ShipCustomization.COLORS[j])
				label:setStyle(LabelStyle({
					font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
					fontSize = 20,
					textShadow = true,
					color = { 1, 1, 1, 1 }
				}, ui:getResources()))
				panel:addChild(label)

				local input = TextInput()
				input.onValueChanged:register(self.onColorInputChanged, self, channel, color)
				panel:addChild(input)

				inputs[color] = input
			end

			self.colorInputs[channel] = inputs
			self.colorPanel:addChild(panel)
		end
	end

	self.buyPanel = Panel()
	self.buyPanel:setStyle(PanelStyle({}, ui:getResources()))
	self.buyPanel:setSize(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 - ShipCustomization.PADDING * 2 - ShipCustomization.TAB_SIZE)
	self.buyPanel:setPosition(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 + ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	do
		local panelWidth, panelHeight = self.buyPanel:getSize()

		self.requirementsConstraints = ConstraintsPanel(ui)
		self.requirementsConstraints:setSize(
			panelWidth / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.requirementsConstraints:setText("Requirements")

		local requirementsConstraintsParent = ScrollablePanel(Panel)
		requirementsConstraintsParent:getInnerPanel():setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		requirementsConstraintsParent:addChild(self.requirementsConstraints)
		requirementsConstraintsParent:setSize(panelWidth / 2, panelHeight - ShipCustomization.TAB_SIZE - ShipCustomization.PADDING * 2)
		requirementsConstraintsParent:setPosition(0, 0)
		self.buyPanel:addChild(requirementsConstraintsParent)

		self.inputConstraints = ConstraintsPanel(ui)
		self.inputConstraints:setSize(
			panelWidth / 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.inputConstraints:setText("Cost")

		local inputConstraintsParent = ScrollablePanel(Panel)
		inputConstraintsParent:getInnerPanel():setStyle(PanelStyle({
			image = "Resources/Renderers/Widget/Panel/Group.9.png"
		}, ui:getResources()))
		inputConstraintsParent:addChild(self.inputConstraints)
		inputConstraintsParent:setSize(panelWidth / 2, panelHeight - ShipCustomization.TAB_SIZE - ShipCustomization.PADDING * 2)
		inputConstraintsParent:setPosition(panelWidth / 2, 0)
		self.buyPanel:addChild(inputConstraintsParent)

		local buyButton = Button()
		buyButton:setSize(panelWidth / 2, ShipCustomization.TAB_SIZE)
		buyButton:setPosition(panelWidth / 4, panelHeight - ShipCustomization.TAB_SIZE - ShipCustomization.PADDING)
		buyButton:setText("Buy!")
		buyButton.onClick:register(self.buy, self)
		buyButton:setToolTip(
			ToolTip.Text("Purchase this item? This transaction will take resources from your bank if you are not carrying enough. How nice!"))
		self.buyPanel:addChild(buyButton)
	end

	self.activatePanel = Panel()
	self.activatePanel:setStyle(PanelStyle({}, ui:getResources()))
	self.activatePanel:setSize(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 - ShipCustomization.PADDING * 2 - ShipCustomization.TAB_SIZE)
	self.activatePanel:setPosition(
		ShipCustomization.WIDTH / 2,
		ShipCustomization.HEIGHT / 2 + ShipCustomization.PADDING * 2 + ShipCustomization.TAB_SIZE)
	do
		local panelWidth, panelHeight = self.activatePanel:getSize()

		local icon = Icon()
		icon:setPosition(ShipCustomization.PADDING, ShipCustomization.PADDING)
		self.activatePanel:addChild(icon)

		local header = Label()
		header:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
			fontSize = 32,
			textShadow = true,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		header:setPosition(icon:getSize() + ShipCustomization.PADDING * 2, ShipCustomization.PADDING)
		self.activatePanel:addChild(header)

		local description = Label()
		description:setStyle(LabelStyle({
			font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
			fontSize = 24,
			textShadow = true,
			width = panelWidth - ShipCustomization.PADDING * 2,
			color = { 1, 1, 1, 1 }
		}, ui:getResources()))
		description:setPosition(
			ShipCustomization.PADDING,
			ShipCustomization.PADDING + Icon.DEFAULT_SIZE)
		self.activatePanel:addChild(description)

		self.activatePanel:setData('icon', icon)
		self.activatePanel:setData('header', header)
		self.activatePanel:setData('description', description)

		local activateButton = Button()
		activateButton:setSize(panelWidth / 2, ShipCustomization.TAB_SIZE)
		activateButton:setPosition(panelWidth / 4, panelHeight - ShipCustomization.TAB_SIZE - ShipCustomization.PADDING)
		activateButton:setText("Activate!")
		activateButton.onClick:register(self.activate, self)
		self.activatePanel:addChild(activateButton)
	end

	self:populateTabs()
end

function ShipCustomization:populateTabs()
	local state = self:getState()

	self.tabs = {}
	for i = 1, #state.tabs do
		local tabState = state.tabs[i]

		local button = Button()
		if i == 1 then
			button:setStyle(ButtonStyle(
				ShipCustomization.ACTIVE_TAB_STYLE(),
				self:getView():getResources()))
			self.activeTab = button
			self:populateItems(tabState.item)
		else
			button:setStyle(ButtonStyle(
				ShipCustomization.INACTIVE_TAB_STYLE(),
				self:getView():getResources()))
		end

		button.onClick:register(self.switchTab, self, tabState.item)
		button:setToolTip(
			ToolTip.Header(tabState.name),
			ToolTip.Text(tabState.description))

		local icon = Icon()
		icon:setSize(self.TAB_SIZE, self.TAB_SIZE)
		button:addChild(icon)

		button:setData('item', tabState.item)
		button:setData('icon', icon)

		table.insert(self.tabs, button)
		self.tabLayout:addChild(button)
	end

	self:refreshTabIcons()
end

function ShipCustomization:refreshTabIcons()
	local state = self:getState()

	for i = 1, #self.tabs do
		local tab = self.tabs[i]
		local item = tab:getData('item')
		local icon = tab:getData('icon')

		local currentItem = state.current[item].resource or self.DEFAULT_ITEMS[item] or "Null"
		icon:setIcon(string.format("Resources/Game/SailingItems/%s/Icon.png", currentItem))
	end
end

function ShipCustomization:switchTab(item, button)
	if button ~= self.activeTab then
		if self.activeTab then
			self.activeTab:setStyle(ButtonStyle(
				ShipCustomization.INACTIVE_TAB_STYLE(),
				self:getView():getResources()))
		end

		button:setStyle(ButtonStyle(
			ShipCustomization.ACTIVE_TAB_STYLE(),
			self:getView():getResources()))

		self.activeTab = button

		self:populateItems(item)

		if self.activePanel then
			self:removeChild(self.activePanel)
			self.activePanel = nil
		end
	end
end

function ShipCustomization:selectItem(itemGroup, itemInfo, button)
	if button ~= self.activeItemButton then
		if self.activeItemButton then
			self.activeItemButton:setStyle(ButtonStyle(
				ShipCustomization.INACTIVE_ITEM_STYLE(),
				self:getView():getResources()))
		end

		button:setStyle(ButtonStyle(
			ShipCustomization.ACTIVE_ITEM_STYLE(),
			self:getView():getResources()))

		self.activeItemButton = button

		self:populateItemPanel(itemGroup, itemInfo)
	end
end

function ShipCustomization:populateItems(item, keepScroll)
	for i = 1, #self.items do
		self.itemsLayout:removeChild(self.items[i])
	end
	self.items = {}

	local state = self:getState()
	local items = state.items[item]
	for i = 1, #items do
		local button = Button()
		if self.currentItemInfo and items[i].resource == self.currentItemInfo.resource then
			button:setStyle(ButtonStyle(
				ShipCustomization.ACTIVE_ITEM_STYLE(),
				self:getView():getResources()))
			self.activeItemButton = button
		else
			button:setStyle(ButtonStyle(
				ShipCustomization.INACTIVE_ITEM_STYLE(),
				self:getView():getResources()))
		end
		button.onClick:register(self.selectItem, self, item, items[i])
		button:setText(items[i].name)

		local icon = Icon()
		icon:setSize(ShipCustomization.TAB_SIZE, ShipCustomization.TAB_SIZE)
		icon:setPosition(ShipCustomization.PADDING, 0)
		icon:setIcon(string.format("Resources/Game/SailingItems/%s/Icon.png", items[i].resource))
		button:addChild(icon)

		if not items[i].unlocked then
			icon:setColor(Color(0.5, 0.5, 0.5, 1))
		end

		button:setToolTip(
			ToolTip.Header(items[i].name),
			ToolTip.Text(items[i].description))
		table.insert(self.items, button)

		self.itemsLayout:addChild(button)

		-- This is done here so button:getSize() returns the size determined
		-- by the items layout.
		if state.current[item].resource == items[i].resource then
			local activeIcon = Icon()
			activeIcon:setSize(ShipCustomization.TAB_SIZE, ShipCustomization.TAB_SIZE)
			activeIcon:setPosition(button:getSize() - ShipCustomization.TAB_SIZE, 0)
			activeIcon:setIcon("Resources/Game/UI/Icons/Concepts/Star.png")
			button:addChild(activeIcon)
		end
	end

	if not keepScroll then
		self.itemsLayout:getInnerPanel():setScroll(0, 0)
	end

	self.itemsLayout:setScrollSize(self.itemsLayout:getInnerPanel():getSize())
end

function ShipCustomization:populateItemPanel(itemGroup, itemInfo)
	local state = self:getState()

	if self.activePanel then
		self:removeChild(self.activePanel)
		self.activePanel = nil
	end

	if state.current[itemGroup].resource == itemInfo.resource then
		self:addChild(self.colorPanel)
		self:refreshColors(itemGroup)
		self.activePanel = self.colorPanel
	elseif not itemInfo.unlocked and itemInfo.purchasable then
		self:addChild(self.buyPanel)
		self:refreshConstraints(itemInfo)
		self.activePanel = self.buyPanel
	else
		self:addChild(self.activatePanel)
		self:refreshDescription(itemInfo)
		self.activePanel = self.activatePanel
	end

	self.currentItemGroup = itemGroup
	self.currentItemInfo = itemInfo
end

function ShipCustomization:refreshConstraints(itemInfo)
	self.requirementsConstraints:setData("skillAsLevel", true)
	self.requirementsConstraints:setConstraints(itemInfo.constraints.requirements)
	self.requirementsConstraints:getParent():setSize(self.requirementsConstraints:getSize())
	self.requirementsConstraints:getParent():setScroll(0, 0)
	self.requirementsConstraints:getParent():getParent():setScrollSize(self.requirementsConstraints:getParent():getSize())

	self.inputConstraints:setData("skillAsLevel", false)
	self.inputConstraints:setConstraints(itemInfo.constraints.inputs)
	self.inputConstraints:getParent():setSize(self.inputConstraints:getSize())
	self.inputConstraints:getParent():setScroll(0, 0)
	self.inputConstraints:getParent():getParent():setScrollSize(self.inputConstraints:getParent():getSize())
end

function ShipCustomization:refreshDescription(itemInfo)
	local panel = self.activatePanel

	local icon = panel:getData('icon')
	icon:setIcon(string.format("Resources/Game/SailingItems/%s/Icon.png", itemInfo.resource))

	local header = panel:getData('header')
	header:setText(itemInfo.name)

	local description = panel:getData('description')
	description:setText(itemInfo.description)
end

function ShipCustomization:refreshColors(itemGroup)
	local state = self:getState()
	local currentItem = state.current[itemGroup]

	for channel, inputs in pairs(self.colorInputs) do
		for color, input in pairs(inputs) do
			local value = currentItem[channel][color]
			local normalizedValue = math.floor(math.max(0, math.min((value - 0.2) / 0.6, 1)) * 100 + 0.5)

			input:setText(tostring(normalizedValue))
		end
	end
end

function ShipCustomization:onColorInputChanged(channel, color, textInput, text)
	local value = tonumber(text)

	if not value then
		local numberValue = text:match("[^%d]*(%d+)")
		if text ~= "" then
			if numberValue then
				value = tonumber(numberValue)
				textInput:setText(tostring(numberValue))
			else
				value = 100
				textInput:setText(tostring(value))
			end
		end
	elseif value > 100 then
		value = 100
		textInput:setText(tostring(value))
	elseif value < 0 then
		value = 0
		textInput:setText(tostring(value))
	end

	local component
	if channel == "primary" then
		component = "1"
	elseif channel == "accent" then
		component = "2"
	else
		component = "0"
	end

	local normalizedValue = (value or 0) / 100 * 0.6 + 0.2 -- Keep it between 0.2 .. 0.8
	self:sendPoke("changeColorComponent", nil, {
		item = self.currentItemGroup,
		color = color .. component,
		value = normalizedValue
	})
end

function ShipCustomization:buy()
	self:sendPoke("buy", nil, {
		resource = self.currentItemInfo.resource
	})
end

function ShipCustomization:onBought(success, resource)
	if success and self.currentItemInfo and self.currentItemInfo.resource == resource then
		self.currentItemInfo.unlocked = true
		self:populateItems(self.currentItemGroup, true)
		self:populateItemPanel(self.currentItemGroup, self.currentItemInfo)
	end
end

function ShipCustomization:activate()
	self:sendPoke("activate", nil, {
		resource = self.currentItemInfo.resource
	})
end

function ShipCustomization:onActivated(success, resource)
	if success and self.currentItemInfo and self.currentItemInfo.resource == resource then
		self:populateItems(self.currentItemGroup, true)
		self:selectItem(self.currentItemInfo, self.currentItemGroup, self.activeItemButton)
		self:populateItemPanel(self.currentItemGroup, self.currentItemInfo)
	end
end

function ShipCustomization:update(...)
	Interface.update(self, ...)

	local state = self:getState()

	self.camera:setVerticalRotation(math.pi / 8 * love.timer.getTime())
	self.shipScene:setRoot(self:getView():getGameView():getMapSceneNode(state.layer))
end

return ShipCustomization
