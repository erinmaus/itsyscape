--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/SkillInfoContentTab.lua
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
local Icon = require "ItsyScape.UI.Icon"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local SkillInfoContentTab = Class(GamepadContentTab)
SkillInfoContentTab.PADDING = 16
SkillInfoContentTab.BUTTON_PADDING = 4
SkillInfoContentTab.ICON_SIZE = 48

SkillInfoContentTab.STAT_BAR_HEIGHT = 32
SkillInfoContentTab.DESCRIPTION_HEIGHT = 128

SkillInfoContentTab.SKILL_NAME_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Regular.ttf",
	fontSize = 26,
	textShadow = true
}

SkillInfoContentTab.SKILL_DESCRIPTION_LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 16,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

SkillInfoContentTab.SKILL_VALUE_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 48,
	textShadow = true,
	align = "center"
}

SkillInfoContentTab.SKILL_XP_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 16,
	textShadow = true,
	spaceLines = true
}

SkillInfoContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

function SkillInfoContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(0, self.PADDING)
	self:addChild(self.layout)

	local titleLabel = GridLayout()
	titleLabel:setPadding(self.PADDING, self.PADDING)
	titleLabel:setSize(self.WIDTH, self.ICON_SIZE)
	self.layout:addChild(titleLabel)

	self.skillIcon = Icon()
	self.skillIcon:setSize(self.ICON_SIZE - self.BUTTON_PADDING * 2, self.ICON_SIZE - self.BUTTON_PADDING * 2)
	titleLabel:addChild(self.skillIcon)

	local skillNameLabelContainer = Widget()
	skillNameLabelContainer:setSize(self.WIDTH - self.ICON_SIZE - self.PADDING * 3, self.ICON_SIZE)
	titleLabel:addChild(skillNameLabelContainer)

	self.skillNameLabel = Label()
	self.skillNameLabel:setStyle(self.SKILL_NAME_LABEL_STYLE, LabelStyle)
	self.skillNameLabel:setPosition(0, (self.ICON_SIZE - self.SKILL_NAME_LABEL_STYLE.fontSize) / 2 - self.PADDING / 2)
	skillNameLabelContainer:addChild(self.skillNameLabel)

	self.skillValueLabel = Label()
	self.skillValueLabel:setStyle(self.SKILL_VALUE_LABEL_STYLE, LabelStyle)
	self.skillValueLabel:setSize(self.WIDTH, self.SKILL_VALUE_LABEL_STYLE.fontSize)
	self.layout:addChild(self.skillValueLabel)

	local skillXPContainer = Widget()
	skillXPContainer:setSize(self.WIDTH, self.SKILL_XP_LABEL_STYLE.fontSize)
	self.layout:addChild(skillXPContainer)

	self.skillXPLabel = Label()
	self.skillXPLabel:setStyle(self.SKILL_XP_LABEL_STYLE, LabelStyle)
	skillXPContainer:addChild(self.skillXPLabel)

	local description = Panel()
	description:setStyle(self.GROUP_PANEL_STYLE, PanelStyle)
	description:setSize(
		self.WIDTH,
		self.DESCRIPTION_HEIGHT)

	local descriptionWidth, descriptionHeight = description:getSize()

	self.descriptionLabel = Label()
	self.descriptionLabel:setPosition(self.PADDING, self.PADDING)
	self.descriptionLabel:setSize(descriptionWidth - self.PADDING * 2, descriptionHeight - self.PADDING * 2)
	self.descriptionLabel:setStyle(self.SKILL_DESCRIPTION_LABEL_STYLE, LabelStyle)
	description:addChild(self.descriptionLabel)

	self.layout:addChild(description)

	local progressColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.progress"))
	local remainderColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.resource.remainder"))

	self.skillProgressBar = StatBar()
	self.skillProgressBar:setSize(self.WIDTH, self.STAT_BAR_HEIGHT)
	self.skillProgressBar:setColors(remainderColor, progressColor)
	self.layout:addChild(self.skillProgressBar)

	self.skillProgressXPLabel = Label()
	self.skillProgressXPLabel:setStyle(self.SKILL_XP_LABEL_STYLE, LabelStyle)
	self.skillProgressBar:addChild(self.skillProgressXPLabel)

	self.layout:setID("PlayerSkillInfo")
end

function SkillInfoContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self.skillIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.id))
	self.skillNameLabel:setText(state.name)
	self.descriptionLabel:setText(state.description)
	self.skillXPLabel:setText(string.format("Total XP: %s", Utility.Text.prettyNumber(state.xp)))
	self.skillProgressXPLabel:setText(string.format("%s / %s", Utility.Text.prettyNumber(state.xpPastCurrentLevel), Utility.Text.prettyNumber(state.nextLevelXP)))
	self.skillProgressBar:updateProgress(state.xpPastCurrentLevel, state.nextLevelXP)

	local workingLevelColor
	if state.workingLevel > state.baseLevel then
		workingLevelColor = "ui.stat.better"
	elseif state.workingLevel < state.baseLevel then
		workingLevelColor = "ui.stat.worse"
	else
		workingLevelColor = "ui.stat.neutral"
	end

	self.skillValueLabel:setText({
		workingLevelColor,
		tostring(state.workingLevel),
		"ui.stat.zero",
		"/",
		"ui.text",
		tostring(state.baseLevel)
	})
end

return SkillInfoContentTab
