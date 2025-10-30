--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/CraftInfoContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"
local EquipmentStatsPanel = require "ItsyScape.UI.Interfaces.Common.EquipmentStatsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local CraftInfoContentTab = Class(GamepadContentTab)
CraftInfoContentTab.PADDING = 8
CraftInfoContentTab.BUTTON_PADDING = 4
CraftInfoContentTab.ICON_SIZE = 64

CraftInfoContentTab.STAT_BAR_HEIGHT = 32

CraftInfoContentTab.CONSTRAINTS_HEIGHT = GamepadContentTab.HEIGHT - CraftInfoContentTab.ICON_SIZE - CraftInfoContentTab.PADDING * 3

CraftInfoContentTab.ITEM_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ItemButton-Default.png",
	hover = "Resources/Game/UI/Buttons/ItemButton-Default.png",
	inactive = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

CraftInfoContentTab.ITEM_NAME_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	lineHeight = 0.8,
	textShadow = true
}

CraftInfoContentTab.ITEM_DESCRIPTION_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

CraftInfoContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

function CraftInfoContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(self.PADDING, self.PADDING)
	self:addChild(self.layout)

	local titleLabel = GridLayout()
	titleLabel:setEdgePadding(false, false)
	titleLabel:setPadding(self.PADDING, self.PADDING)
	titleLabel:setSize(self.WIDTH, self.ICON_SIZE)
	self.layout:addChild(titleLabel)

	local button = Button()
	button:setStyle(self.ITEM_BUTTON_STYLE, ButtonStyle)
	button:setSize(self.ICON_SIZE, self.ICON_SIZE)
	titleLabel:addChild(button)

	self.itemIcon = ItemIcon()
	self.itemIcon:setSize(self.ICON_SIZE - self.BUTTON_PADDING * 2, self.ICON_SIZE - self.BUTTON_PADDING * 2)
	self.itemIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	button:addChild(self.itemIcon)

	self.itemNameLabel = Label()
	self.itemNameLabel:setStyle(self.ITEM_NAME_LABEL_STYLE, LabelStyle)
	self.itemNameLabel:setSize(self.WIDTH - self.ICON_SIZE - self.PADDING * 3, self.ICON_SIZE)
	titleLabel:addChild(self.itemNameLabel)

	local description = Panel()
	description:setStyle(self.GROUP_PANEL_STYLE, PanelStyle)
	description:setSize(
		self.WIDTH,
		self.HEIGHT - self.CONSTRAINTS_HEIGHT - self.ICON_SIZE - self.PADDING * 4)

	local descriptionWidth, descriptionHeight = description:getSize()

	self.itemDescriptionLabel = Label()
	self.itemDescriptionLabel:setPosition(self.PADDING, self.PADDING)
	self.itemDescriptionLabel:setSize(descriptionWidth - self.PADDING * 2, descriptionHeight - self.PADDING * 2)
	self.itemDescriptionLabel:setStyle(self.ITEM_DESCRIPTION_LABEL_STYLE, LabelStyle)
	description:addChild(self.itemDescriptionLabel)

	self.layout:addChild(description)

	local constraintsGroup = Panel()
	constraintsGroup:setStyle(self.GROUP_PANEL_STYLE, PanelStyle)
	constraintsGroup:setSize(self.WIDTH, self.CONSTRAINTS_HEIGHT)
	self.layout:addChild(constraintsGroup)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(0, 0)
	self.constraintsPanel:setSize(self.WIDTH - self.PADDING * 2, self.CONSTRAINTS_HEIGHT - self.PADDING * 2)
	self.constraintsPanel:setPosition(self.PADDING, self.PADDING)
	constraintsGroup:addChild(self.constraintsPanel)

	local constraintsPanelWidth = self.WIDTH - self.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE
	local constraintsConfig = {
		headerFontSize = 16,
		constraintFontSize = 16,
		padding = 0
	}

	self.requirementsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.requirementsPanel:setText("Requirements")
	self.requirementsPanel:setData("skillAsLevel", true)
	self.requirementsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.requirementsPanel)

	self.inputsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.inputsPanel:setText("Ingredients")
	self.inputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.inputsPanel)

	self.outputsPanel = ConstraintsPanel(self:getUIView(), constraintsConfig)
	self.outputsPanel:setText("Products")
	self.outputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.outputsPanel)

	self.layout:setID("CraftItemInfo")
end

function CraftInfoContentTab:gamepadScroll(x, y)
	self.constraintsPanel:mouseScroll(x, y)
end

function CraftInfoContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self.itemIcon:setItemID(state.item.id)
	self.itemNameLabel:setText(state.item.name)
	self.itemDescriptionLabel:setText(state.item.description)

	self.requirementsPanel:setConstraints(state.constraints.requirements)
	self.inputsPanel:setConstraints(state.constraints.inputs)
	self.outputsPanel:setConstraints(state.constraints.outputs)

	self.constraintsPanel:getInnerPanel():setScroll(0, 0)
	self.constraintsPanel:performLayout()
end

return CraftInfoContentTab
