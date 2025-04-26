--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/SkillGuideContentTab.lua
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
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"

local SkillGuideContentTab = Class(GamepadContentTab)
SkillGuideContentTab.PADDING = 8
SkillGuideContentTab.ICON_SIZE = 24
SkillGuideContentTab.BUTTON_PADDING = 4
SkillGuideContentTab.SKILL_VALUE_SIZE = 112

SkillGuideContentTab.INACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/Button-Pressed.png",
	hover = "Resources/Game/UI/Buttons/Button-Hover.png",
	inactive = "Resources/Game/UI/Buttons/Button-Default.png"
}

SkillGuideContentTab.ACTIVE_BUTTON_STYLE = {
	pressed = "Resources/Game/UI/Buttons/ButtonActive-Pressed.png",
	hover = "Resources/Game/UI/Buttons/ButtonActive-Hover.png",
	inactive = "Resources/Game/UI/Buttons/ButtonActive-Default.png"
}

SkillGuideContentTab.SKILL_NAME_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 20,
	lineHeight = 2,
	textShadow = true
}

SkillGuideContentTab.SKILL_VALUE_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 18,
	lineHeight = 2,
	textShadow = true,
	align = "center"
}

function SkillGuideContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.scrollableLayout = ScrollablePanel(GamepadGridLayout)
	self.scrollableLayout:setSize(self:getSize())
	self.layout = self.scrollableLayout:getInnerPanel()
	self.layout:setWrapContents(true)
	self.layout:setSize(self:getSize() - ScrollablePanel.DEFAULT_SCROLL_SIZE, 0)
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self:getSize() - self.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
		self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self.layout.onBlurChild:register(self._onBlurLayoutChild, self)
	self.layout.onFocusChild:register(self._onFocusLayoutChild, self)
	self.layout.onWrapFocus:register(self._onLayoutWrapFocus, self)
	self:addChild(self.scrollableLayout)

	self.layout:setID("PlayerSkillGuide")

	self.toolTip = GamepadToolTip()
	self.toolTip:setKeybind("gamepadPrimaryAction")
	self.toolTip:setText("Open skill guide")
	self:getInterface().onClose:register(self._onClose, self)

	self.currentSkillIndex = 1
	self.showToolTip = false
end

function SkillGuideContentTab:getCurrentSkillIndex()
	return self.currentSkillIndex
end

function SkillGuideContentTab:_updateToolTip()
	local root = self:getUIView():getRoot()

	if self.showToolTip then
		if self.toolTip:getParent() ~= root then
			root:addChild(self.toolTip)
		end

		local toolTipWidth = self.toolTip:getSize()

		local child = self.layout:getChildAt(self.currentSkillIndex)
		local absoluteChildX, absoluteChildY = child:getAbsolutePosition()
		local childWidth, childHeight = child:getSize()
		local positionX, positionY = absoluteChildX + childWidth - self.PADDING, absoluteChildY + childHeight + self.PADDING

		local selfAbsoluteX1 = self.layout:getAbsolutePosition()
		local selfWidth = self.layout:getSize()

		self.toolTip:setPosition(math.min(positionX, selfAbsoluteX1 + selfWidth - toolTipWidth), positionY)
	else
		if self.toolTip:getParent() == root then
			root:removeChild(self.toolTip)
		end
	end
end

function SkillGuideContentTab:_onBlurLayoutChild(layout, child)
	self.showToolTip = false
	self:_updateToolTip()
end

function SkillGuideContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentSkillIndex = child:getData("index") or 1

	self.showToolTip = true
	self:_updateToolTip()
end

function SkillGuideContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function SkillGuideContentTab:_onClose()
	local toolTipParent = self.toolTip:getParent()
	if toolTipParent then
		toolTipParent:removeChild(self.toolTip)
	end
end

function SkillGuideContentTab:getIsFocusable()
	return true
end

function SkillGuideContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentSkillIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function SkillGuideContentTab:openSkillGuide(skill)
	self:getInterface():sendPoke("selectSkillGuide", nil, { skill = skill })
end

function SkillGuideContentTab:_addSkillButton()
	local index = self.layout:getNumChildren() + 1

	local button = Button()
	button:setData("index", index)
	button:setStyle(self.INACTIVE_BUTTON_STYLE, ButtonStyle)
	button.onClick:register(self.activate, self, index)

	local skillIcon = Icon()
	skillIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	skillIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	button:addChild(skillIcon)
	button:setData("icon", skillIcon)

	local width = self:getSize()

	local skillNameLabel = Label()
	skillNameLabel:setStyle(self.SKILL_NAME_LABEL_STYLE, LabelStyle)
	skillNameLabel:setPosition(self.ICON_SIZE + self.BUTTON_PADDING * 2, (self.ICON_SIZE - self.SKILL_NAME_LABEL_STYLE.fontSize) / 2)
	skillNameLabel:setSize(
		width - self.ICON_SIZE - self.SKILL_VALUE_SIZE - self.BUTTON_PADDING * 4,
		self.BUTTON_PADDING * 2 + self.ICON_SIZE)
	button:addChild(skillNameLabel)
	button:setData("name", skillNameLabel)

	local skillValueLabel = Label()
	skillValueLabel:setStyle(self.SKILL_VALUE_LABEL_STYLE, LabelStyle)
	skillValueLabel:setPosition(self.ICON_SIZE + skillNameLabel:getSize() + self.BUTTON_PADDING * 3, (self.ICON_SIZE - self.SKILL_VALUE_LABEL_STYLE.fontSize) / 2)
	skillValueLabel:setSize(
		self.SKILL_VALUE_SIZE,
		self.BUTTON_PADDING * 2 + self.ICON_SIZE)
	button:addChild(skillValueLabel)
	button:setData("value", skillValueLabel)

	self.scrollableLayout:addChild(button)
end

function SkillGuideContentTab:populate(count)
	while self.layout:getNumChildren() > count do
		self.layout:removeChild(self.layout:getChildAt(self.layout:getNumChildren()))
	end

	while self.layout:getNumChildren() < count do
		self:_addSkillButton()
	end

	self.layout:performLayout()
	self.scrollableLayout:setScrollSize(self.layout:getSize())
end

function SkillGuideContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:populate(#state.skills)

	for index, skill in ipairs(state.skills) do
		local button = self.layout:getChildAt(index)

		local icon = button:getData("icon")
		icon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", skill.id))

		local name = button:getData("name")
		name:setText(skill.name)

		local value = button:getData("value")

		local color
		if skill.workingLevel > skill.baseLevel then
			color = "ui.stat.better"
		elseif skill.workingLevel < skill.baseLevel then
			color = "ui.stat.worse"
		else
			color = "ui.stat.neutral"
		end

		value:setText({
			color,
			tostring(skill.workingLevel),
			"ui.stat.zero",
			"/",
			"ui.text",
			tostring(skill.baseLevel)
		})
	end

	self:_updateToolTip()
end

function SkillGuideContentTab:activate(index, button, buttonIndex)
	if buttonIndex ~= 1 then
		return
	end

	local state = self:getState()
	local skills = state and state.skills
	local skill = skills[index]

	if not skill then
		return
	end

	self:openSkillGuide(skill.id)
end

return SkillGuideContentTab
