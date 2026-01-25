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
local FullscreenPanel = require "ItsyScape.UI.FullscreenPanel"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GamepadToolTip = require "ItsyScape.UI.GamepadToolTip"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local PropertiesPrompt = require "ItsyScape.UI.Interfaces.Components.PropertiesPrompt"

local SkillGuideContentTab = Class(GamepadContentTab)

function SkillGuideContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.scrollableLayout = ScrollablePanel(GamepadGridLayout)
	self.scrollableLayout:setSize(self:getSize())

	self.layout = self.scrollableLayout:getInnerPanel()
	self.layout:setWrapContents(true)
	self.layout:setSize(self:getSize(), 0)
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setUniformSize(
		true,
		self:getSize(),
		Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_BUTTON_SIZE))
	self.layout.onFocusChild:register(self._onFocusLayoutChild, self)
	self.layout.onWrapFocus:register(self._onLayoutWrapFocus, self)
	self:addChild(self.scrollableLayout)

	self.layout:setID("PlayerSkillGuide")

	self:getInterface().onClose:register(self._onClose)

	self.currentSkillGuideEntryIndex = 1
end

function SkillGuideContentTab:getCurrentEntryIndex()
	return self.currentSkillGuideEntryIndex
end

function SkillGuideContentTab:_onFocusLayoutChild(layout, child)
	if not child then
		return
	end

	self.currentSkillGuideEntryIndex = child:getData("index") or 1
end

function SkillGuideContentTab:_onLayoutWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function SkillGuideContentTab:_onClose()
	self:dismissSummonPrompt()
end

function SkillGuideContentTab:getIsFocusable()
	return true
end

function SkillGuideContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		local child = self.layout:getChildAt(self.currentSkillGuideEntryIndex)
		inputProvider:setFocusedWidget(child or self.layout, reason)
	end
end

function SkillGuideContentTab:openSkillGuide(skill)
	self:getInterface():sendPoke("selectSkillGuide", nil, { skill = skill })
end

function SkillGuideContentTab:_addSkillGuideEntryButton(action)
	local index = self.layout:getNumChildren() + 1

	local button = Button()
	button:setData("index", index)
	button:setStyle(Theme.INACTIVE_BUTTON_STYLE, ButtonStyle)
	button.onClick:register(self.activate, self, index)

	self.layout:addChild(button)
end

function SkillGuideContentTab:populate(count)
	while self.layout:getNumChildren() > count do
		self.layout:removeChild(self.layout:getChildAt(self.layout:getNumChildren()))
	end

	while self.layout:getNumChildren() < count do
		self:_addSkillGuideEntryButton()
	end

	Theme.layoutScrollablePanelWithGridLayout(
		self.scrollableLayout,
		GamepadContentTab.WIDTH,
		Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_BUTTON_SIZE))
end

function SkillGuideContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	self:populate(#state.actions)

	for index, action in ipairs(state.actions) do
		local button = self.layout:getChildAt(index)

		if button:getData("actionID") ~= action.id then
			button:clearChildren()

			local icon, label = Theme.getIconLabelForAction(action.id, self:getGameDB())

			icon:setPosition(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_INNER_PADDING)
			button:addChild(icon)

			label:setPosition(Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_ICON_SIZE), Theme.DEFAULT_INNER_PADDING)
			label:setSize(0, Theme.calculateSizeWithPadding(Theme.DEFAULT_INNER_PADDING, Theme.DEFAULT_BUTTON_SIZE))
			label:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
			button:addChild(label)
		end
	end
end

function SkillGuideContentTab:dismissSummonPrompt()
	if self.summonPrompt and self.summonPrompt:getParent() then
		self.summonPrompt:getParent():removeChild(self.summonPrompt)
	end

	self.summonPrompt = nil
end

function SkillGuideContentTab:summon(action, count)
	self:getInterface():sendPoke("steal", nil, { id = action.id, count = count or 1 })
end

function SkillGuideContentTab:_onSummonSubmitted(action, _, _, form)
	self:summon(action, math.max(form.Count, 1))
	self:dismissSummonPrompt()
end

function SkillGuideContentTab:_onSummonCancelled()
	self:dismissSummonPrompt()
end

function SkillGuideContentTab:summonX(action)
	if self.summonPrompt then
		self:dismissSummonPrompt()
	end

	local summonPrompt = PropertiesPrompt()
	summonPrompt.onSubmit:register(self._onSummonSubmitted, self, action)
	summonPrompt.onCancel:register(self._onSummonCancelled, self, action)
	summonPrompt:setText(string.format("Summon %s %s Constraints", action.verb, action.name))
	summonPrompt:setProperties({
		PropertiesPrompt.Property("count", "Count", "number", 1)
	})

	local rootParent = self:getRootParent()
	if rootParent then
		local panel = FullscreenPanel()
		panel:setStyle({
			color = { 0, 0, 0, 0.5 },
			radius = 0
		}, PanelStyle)
		panel:addChild(summonPrompt)

		rootParent:addChild(panel)
		panel:performLayout()

		summonPrompt:focus()

		self.summonPrompt = panel
	end
end

function SkillGuideContentTab:probe(index, button)
	local state = self:getState()
	local hasAmuletOfYendor = state.hasAmuletOfYendor
	local actions = state and state.actions
	local action = actions[index]

	local actions = {}
	table.insert(actions, {
		id = #actions + 1,
		type = "examine",
		verb = "Examine",
		object = action.name,
		objectType = action.resourceType:lower(),
		callback = Function(self.examine, self, action, button)
	})

	if action and hasAmuletOfYendor then
		table.insert(actions, {
			id = #actions + 1,
			type = "x-debug-summon",
			verb = "Summon",
			object = action.name,
			objectType = action.resourceType:lower(),
			callback = Function(self.summon, self, action, 1)
		})

		table.insert(actions, {
			id = #actions + 1,
			type = "x-debug-summon",
			verb = "Summon-X",
			object = action.name,
			objectType = action.resourceType:lower(),
			callback = Function(self.summonX, self, action)
		})
	end

	local buttonX, buttonY = button:getAbsoluteCenter()
	self:getUIView():probe(actions, buttonX, buttonY, true, false)
end

function SkillGuideContentTab:activate(index, button, buttonIndex)
	if buttonIndex == 2 then
		self:probe(index, button)
		return
	end

	if buttonIndex ~= 1 then
		return
	end

	local state = self:getState()
	local actions = state and state.actions
	local action = actions[index]

	if not action then
		return
	end

	self:openSkillGuide(action.id)
end

return SkillGuideContentTab
