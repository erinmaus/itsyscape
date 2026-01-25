--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/SkillGuide.lua
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
local SpellIcon = require "ItsyScape.UI.SpellIcon"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ItemIcon = require "ItsyScape.UI.ItemIcon"
local Widget = require "ItsyScape.UI.Widget"
local Theme = require "ItsyScape.UI.Interfaces.Theme"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"
local SkillGuideContentTab = require "ItsyScape.UI.Interfaces.Components.SkillGuideContentTab"
local SkillGuideInfoContentTab = require "ItsyScape.UI.Interfaces.Components.SkillGuideInfoContentTab"

local SkillGuide = Class(Interface)

function SkillGuide:new(id, index, ui)
	Interface.new(self, id, index, ui)

	self.titleSkillIcon = Icon()

	self.titlePanel, self.titleLabel = Theme.newMiniTitlePanelWithLabel(self, nil, self.titleSkillIcon)
	self.closeButton = Theme.newCloseButton(self.titlePanel)
	self.contentPanel = Theme.newContentPanel(self, nil, nil, self.titlePanel)

	self.contentLayout = GridLayout()
	self.contentLayout:setEdgePadding(false, true)
	self.contentLayout:setPadding(Theme.DEFAULT_OUTER_PADDING, Theme.DEFAULT_OUTER_PADDING)
	self.contentLayout:setUniformSize(true, Theme.CONTENT_WIDTH, Theme.CONTENT_HEIGHT)
	self.contentLayout:setSize(self.contentPanel:getSize())
	self.contentPanel:addChild(self.contentLayout)

	self.nothingLabel = Label()
	self.nothingLabel:setStyle(Theme.BUTTON_LABEL_STYLE, LabelStyle)
	self.nothingLabel:setText("This skill guide is empty... for now.")

	self.skillGuideContent = SkillGuideContentTab(self)
	self.skillGuideContent.onSelectAction:register(self._selectAction, self)

	self.skillGuideInfoContent = SkillGuideInfoContentTab(self)

	local state = self:getState()
	if #state.actions == 0 then
		self.contentPanel:addChild(self.nothingLabel)
	else
		self.contentLayout:addChild(self.skillGuideContent)
		self.contentLayout:addChild(self.skillGuideInfoContent)
	end

	self.skillGuideContent:refresh({
		hasAmuletOfYendor = state.hasAmuletOfYendor,
		actions = state.actions
	})
	self.skillGuideContent:selectEntry(1)

	self.titleSkillIcon:setIcon(string.format("Resources/Game/UI/Icons/Skills/%s.png", state.skill.id))
	self.titleLabel:setText(string.format("%s Skill Guide", state.skill.name))

	self:performLayout()
end

function SkillGuide:performLayout()
	Interface.performLayout(self)

	self:setSize(Theme.CONTENT_WINDOW_WIDTH, Theme.CONTENT_WINDOW_HEIGHT)

	local width, height = itsyrealm.graphics.getScaledMode()
	self:setPosition(
		(width - Theme.CONTENT_WINDOW_WIDTH) / 2,
		(height - Theme.CONTENT_WINDOW_HEIGHT) / 2)
end

function SkillGuide:_selectAction(_, action, button)
	if self.activeButton then
		self.activeButton:setStyle(Theme.DEFAULT_INACTIVE_BUTTON_STYLE, ButtonStyle)
		self.activeButton = nil
	end

	if button then
		button:setStyle(Theme.DEFAULT_ACTIVE_BUTTON_STYLE, ButtonStyle)
		self.activeButton = button

	end

	self:sendPoke("selectSkillAction", nil, { id = action.id })
end

function SkillGuide:populateSkillGuideAction(action, constraints)
	self.skillGuideInfoContent:refresh({
		action = action,
		constraints = constraints
	})
end

return SkillGuide
