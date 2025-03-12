--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/ItemInfoGamepadContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Function = require "ItsyScape.Common.Function"
local Vector = require "ItsyScape.Common.Math.Vector"
local Equipment = require "ItsyScape.Game.Equipment"
local Widget = require "ItsyScape.UI.Widget"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local EquipmentStatsPanel = require "ItsyScape.UI.Interfaces.Common.EquipmentStatsPanel"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local ItemInfoGamepadContentTab = Class(GamepadContentTab)
ItemInfoGamepadContentTab.PADDING = 8
ItemInfoGamepadContentTab.BIG_ICON = 64
ItemInfoGamepadContentTab.BUTTON_PADDING = 6

ItemInfoGamepadContentTab.ITEM_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ItemButton-Default.png",
	hover = "Resources/Game/UI/Buttons/ItemButton-Default.png",
	inactive = "Resources/Game/UI/Buttons/ItemButton-Default.png"
}

ItemInfoGamepadContentTab.ITEM_NAME_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/Serif/SemiBold.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	lineHeight = 0.8,
	textShadow = true
}

ItemInfoGamepadContentTab.ITEM_DESCRIPTION_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

ItemInfoGamepadContentTab.NO_STATS_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24,
	color = { 1, 1, 1, 1 },
	textShadow = true,
	align = "center"
}

ItemInfoGamepadContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

function ItemInfoGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(0, self.PADDING)
	self:addChild(self.layout)

	local titleLabel = GridLayout()
	titleLabel:setPadding(self.PADDING, self.PADDING)
	titleLabel:setSize(self.WIDTH, self.BIG_ICON)

	self.layout:addChild(titleLabel)

	local button = Button()
	button:setStyle(ButtonStyle(self.ITEM_BUTTON_STYLE, self:getResources()))
	button:setSize(self.BIG_ICON, self.BIG_ICON)
	titleLabel:addChild(button)

	self.itemIcon = ItemIcon()
	self.itemIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	self.itemIcon:setSize(self.BIG_ICON - self.BUTTON_PADDING * 2, self.BIG_ICON - self.BUTTON_PADDING * 2)
	button:addChild(self.itemIcon)

	self.itemNameLabel = Label()
	self.itemNameLabel:setStyle(LabelStyle(self.ITEM_NAME_LABEL_STYLE, self:getResources()))
	self.itemNameLabel:setSize(self.WIDTH - self.BIG_ICON - self.PADDING * 3, self.BIG_ICON)
	titleLabel:addChild(self.itemNameLabel)

	local description = Panel()
	description:setStyle(PanelStyle(self.GROUP_PANEL_STYLE, self:getResources()))
	description:setSize(
		self.WIDTH,
		self.HEIGHT - EquipmentStatsPanel.DEFAULT_HEIGHT - self.BIG_ICON - self.PADDING * 4)

	local descriptionWidth, descriptionHeight = description:getSize()

	self.descriptionLabel = Label()
	self.descriptionLabel:setPosition(self.PADDING, self.PADDING)
	self.descriptionLabel:setSize(descriptionWidth - self.PADDING * 2, descriptionHeight - self.PADDING * 2)
	self.descriptionLabel:setStyle(LabelStyle(self.ITEM_DESCRIPTION_LABEL_STYLE, self:getResources()))
	description:addChild(self.descriptionLabel)

	self.layout:addChild(description)

	self.noStatsLabel = Label()
	self.noStatsLabel:setStyle(LabelStyle(self.NO_STATS_LABEL_STYLE, self:getResources()))
	self.noStatsLabel:setText("There are no equipment stats to show.")
	self.noStatsLabel:setPosition(self.PADDING, EquipmentStatsPanel.DEFAULT_HEIGHT / 2 - self.NO_STATS_LABEL_STYLE.fontSize)
	self.noStatsLabel:setSize(self.WIDTH - self.PADDING * 2, self.NO_STATS_LABEL_STYLE.fontSize * 2)

	self.stats = EquipmentStatsPanel(self:getUIView(), { width = self.WIDTH - self.PADDING * 2 })
	self.stats:setPosition(self.PADDING, self.PADDING)

	self.statsPanel = Panel()
	self.statsPanel:setStyle(PanelStyle(self.GROUP_PANEL_STYLE, self:getResources()))
	self.statsPanel:setSize(self.WIDTH, EquipmentStatsPanel.DEFAULT_HEIGHT)
	self.layout:addChild(self.statsPanel)

	self.layout:performLayout()
end

function ItemInfoGamepadContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	local item = state.item
	if not item then
		self.itemIcon:setItemID(false)
		self.itemIcon:setItemCount(0)
		self.itemIcon:setItemIsNoted(false)
		self.itemNameLabel:setText("Empty inventory slot")
		self.descriptionLabel:setText("Go out and collect more items!")

		if self.stats:getParent() == self.statsPanel then
			self.statsPanel:removeChild(self.stats)
		end

		if self.noStatsLabel:getParent() ~= self.statsPanel then
			self.statsPanel:addChild(self.noStatsLabel)
		end

		return
	end

	self.itemIcon:setItemID(item.id)
	self.itemIcon:setItemCount(item.count)
	self.itemIcon:setItemIsNoted(item.noted)

	self.itemNameLabel:setText(item.name)
	self.descriptionLabel:setText(item.description)

	if not item.stats or #item.stats == 0 or not item.slot then
		if self.stats:getParent() == self.statsPanel then
			self.statsPanel:removeChild(self.stats)
		end

		if self.noStatsLabel:getParent() ~= self.statsPanel then
			self.statsPanel:addChild(self.noStatsLabel)
		end
	else
		if self.stats:getParent() ~= self.statsPanel then
			self.statsPanel:addChild(self.stats)
		end

		if self.noStatsLabel:getParent() == self.statsPanel then
			self.statsPanel:removeChild(self.noStatsLabel)
		end

		self.stats:compareStats(item.stats, state.otherItem and state.otherItem.stats)
	end
end

return ItemInfoGamepadContentTab
