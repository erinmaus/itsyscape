--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/SkillGuideInfoContentTab.lua
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
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local EquipmentStatsPanel = require "ItsyScape.UI.Interfaces.Common.EquipmentStatsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local SkillGuideInfoContentTab = Class(GamepadContentTab)
SkillGuideInfoContentTab.ICON_SIZE = 64
SkillGuideInfoContentTab.DESCRIPTION_HEIGHT = 100
SkillGuideInfoContentTab.CONSTRAINTS_HEIGHT = Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, GamepadContentTab.HEIGHT, SkillGuideInfoContentTab.ICON_SIZE, SkillGuideInfoContentTab.DESCRIPTION_HEIGHT)

SkillGuideInfoContentTab.ITEM_NAME_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	lineHeight = 0.8,
	textShadow = true
}

SkillGuideInfoContentTab.ITEM_DESCRIPTION_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	spaceLines = true
}

function SkillGuideInfoContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setUniformSize(true, Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH), 0)
	self.layout:setPadding(0, Theme.DEFAULT_OUTER_PADDING)
	self:addChild(self.layout)

	self.titleLabel = GridLayout()
	self.titleLabel:setEdgePadding(false, false)
	self.titleLabel:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.titleLabel:setSize(self.WIDTH, self.ICON_SIZE)
	self.layout:addChild(self.titleLabel)

	self.iconButton = Button()
	self.iconButton:setStyle(Theme.ITEM_BUTTON_STYLE, ButtonStyle)
	self.iconButton:setSize(self.ICON_SIZE, self.ICON_SIZE)
	self.titleLabel:addChild(self.iconButton)

	self.description = Panel()
	self.description:setStyle(Theme.GROUP_PANEL_STYLE, PanelStyle)
	self.description:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.HEIGHT, self.ICON_SIZE, self.CONSTRAINTS_HEIGHT))

	local descriptionWidth, descriptionHeight = self.description:getSize()

	self.descriptionLabel = Label()
	self.descriptionLabel:setPosition(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.descriptionLabel:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, descriptionWidth),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, descriptionHeight))
	self.descriptionLabel:setStyle(self.ITEM_DESCRIPTION_LABEL_STYLE, LabelStyle)
	self.description:addChild(self.descriptionLabel)

	self.layout:addChild(self.description)

	local constraintsGroup = Panel()
	constraintsGroup:setStyle(Theme.GROUP_PANEL_STYLE, PanelStyle)
	constraintsGroup:setSize(self.WIDTH, self.CONSTRAINTS_HEIGHT)
	self.layout:addChild(constraintsGroup)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(0, 0)
	self.constraintsPanel:setSize(
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH),
		Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.CONSTRAINTS_HEIGHT))
	self.constraintsPanel:setPosition(
		Theme.DEFAULT_OUTER_PADDING,
		Theme.DEFAULT_OUTER_PADDING)
	constraintsGroup:addChild(self.constraintsPanel)

	local constraintsPanelWidth = Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH)

	self.requirementsPanel = ConstraintsPanel(self:getUIView(), Theme.STANDARD_CONSTRAINTS_CONFIG)
	self.requirementsPanel:setText("Requirements")
	self.requirementsPanel:setData("skillAsLevel", true)
	self.requirementsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.requirementsPanel)

	self.inputsPanel = ConstraintsPanel(self:getUIView(), Theme.STANDARD_CONSTRAINTS_CONFIG)
	self.inputsPanel:setText("Ingredients")
	self.inputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.inputsPanel)

	self.outputsPanel = ConstraintsPanel(self:getUIView(), Theme.STANDARD_CONSTRAINTS_CONFIG)
	self.outputsPanel:setText("Products")
	self.outputsPanel:setSize(constraintsPanelWidth)
	self.constraintsPanel:addChild(self.outputsPanel)

	self.layout:setID("CraftItemInfo")
end

function SkillGuideInfoContentTab:expand()
	local currentWidth, currentHeight = GamepadContentTab.WIDTH, GamepadContentTab.HEIGHT

	local constraintsGroupWidth, constraintsGroupHeight = self.WIDTH, self.CONSTRAINTS_HEIGHT

	self.constraintsPanel:getInnerPanel():setUniformSize(true, Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, constraintsGroupWidth), 0)
	self.constraintsPanel:getInnerPanel():setSize(Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, constraintsGroupWidth), 0)
	self.constraintsPanel:getInnerPanel():performLayout()

	local constraintsWidth, constraintsHeight = self.constraintsPanel:getInnerPanel():getSize()

	local constraintsGroup = self.constraintsPanel:getParent()
	constraintsGroup:setSize(
		constraintsGroupWidth,
		Theme.calculateSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, constraintsHeight))

	self.constraintsPanel:setSize(constraintsWidth, constraintsHeight)
	self.constraintsPanel:setScrollSize(constraintsWidth, constraintsHeight)
	self.constraintsPanel:performLayout()

	self.layout:setWrapContents(true)
	self.layout:setUniformSize(true, Theme.calculateInnerSize(Theme.DEFAULT_OUTER_PADDING, self.WIDTH), 0)
	self.layout:performLayout()

	self:setSize(
		currentWidth,
		currentHeight + (constraintsHeight - constraintsGroupHeight))
end

function SkillGuideInfoContentTab:gamepadScroll(x, y)
	self.constraintsPanel:mouseScroll(x, y)
end

function SkillGuideInfoContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	local description
	self.icon, self.label, description = Theme.getIconLabelForAction(
		state.action.id,
		self:getGameDB())

	self.icon:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_INNER_PADDING, self.ICON_SIZE),
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_INNER_PADDING, self.ICON_SIZE))
	self.icon:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)

	self.iconButton:clearChildren()
	self.iconButton:addChild(self.icon)

	self.label:setStyle(self.ITEM_NAME_LABEL_STYLE, LabelStyle)
	self.label:setSize(
		Theme.calculateRemainingSizeWithPadding(Theme.DEFAULT_OUTER_PADDING, self.WIDTH, self.ICON_SIZE),
		self.ICON_SIZE)

	self.titleLabel:clearChildren()
	self.titleLabel:addChild(self.iconButton)
	self.titleLabel:addChild(self.label)

	self.descriptionLabel:setText(description)

	self.constraintsPanel:getInnerPanel():clearChildren()

	if #state.constraints.requirements > 0 then
		self.constraintsPanel:getInnerPanel():addChild(self.requirementsPanel)
		self.requirementsPanel:setConstraints(state.constraints.requirements)
	end

	if #state.constraints.inputs > 0 then
		self.constraintsPanel:getInnerPanel():addChild(self.inputsPanel)
		self.inputsPanel:setConstraints(state.constraints.inputs)
	end

	if #state.constraints.outputs > 0 then
		self.constraintsPanel:getInnerPanel():addChild(self.outputsPanel)
		self.outputsPanel:setConstraints(state.constraints.outputs)
	end

	local elementWidth = self.constraintsPanel:getSize()
	Theme.layoutScrollablePanelWithGridLayout(
		self.constraintsPanel,
		Theme.calculateInnerSize(Theme.DEFAULT_INNER_PADDING, elementWidth),
		0)

	self.constraintsPanel:getInnerPanel():setScroll(0, 0)
end

function SkillGuideInfoContentTab:gamepadScroll(x, y)
	GamepadContentTab.gamepadScroll(self, x, y)
	self.constraintsPanel:mouseScroll(x, y)
end

return SkillGuideInfoContentTab
