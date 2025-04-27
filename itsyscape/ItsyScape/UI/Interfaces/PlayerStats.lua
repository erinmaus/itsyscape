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
local Button = require "ItsyScape.UI.Button"
local Icon = require "ItsyScape.UI.Icon"
local Label = require "ItsyScape.UI.Label"
local GridLayout = require "ItsyScape.UI.GridLayout"
local PlayerTab = require "ItsyScape.UI.Interfaces.PlayerTab"
local SkillInfoContentTab = require "ItsyScape.UI.Interfaces.Components.SkillInfoContentTab"
local SkillsGamepadContentTab = require "ItsyScape.UI.Interfaces.Components.SkillsGamepadContentTab"

local PlayerStats = Class(PlayerTab)
PlayerStats.PADDING = 8
PlayerStats.BACK_BUTTON_WIDTH = 104
PlayerStats.BACK_BUTTON_HEIGHT = 48
PlayerStats.BACK_BUTTON_ICON_SIZE = 24

function PlayerStats:new(id, index, ui)
	PlayerTab.new(self, id, index, ui)

	self.layout = GridLayout()
	self.layout:setSize(PlayerStats.WIDTH, PlayerStats.HEIGHT)
	self.layout:setScrollSize(PlayerStats.WIDTH * 2, PlayerStats.HEIGHT)
	self.layout:setPadding(0, 0)
	self:addChild(self.layout)

	self.infoContent = SkillInfoContentTab(self)
	self.skillsContent = SkillsGamepadContentTab(self)

	self.layout:addChild(self.skillsContent)
	self.layout:addChild(self.infoContent)

	self.backButton = Button()
	self.backButton:setSize(self.BACK_BUTTON_WIDTH, self.BACK_BUTTON_HEIGHT)
	self.backButton:setPosition(
		(self.WIDTH - self.BACK_BUTTON_WIDTH) / 2,
		self.HEIGHT - self.BACK_BUTTON_HEIGHT - self.PADDING)
	self.backButton.onClick:register(self.onBackButtonPress, self)

	local backButtonLabel = Label()
	backButtonLabel:setPosition(self.BACK_BUTTON_ICON_SIZE + self.PADDING * 2, self.PADDING)
	backButtonLabel:setSize(self.BACK_BUTTON_WIDTH - self.BACK_BUTTON_ICON_SIZE + self.PADDING * 3, self.BACK_BUTTON_HEIGHT)
	backButtonLabel:setText("Back")
	self.backButton:addChild(backButtonLabel)

	local backButtonIcon = Icon()
	backButtonIcon:setIcon("Resources/Game/UI/Icons/Common/Back.png")
	backButtonIcon:setSize(self.BACK_BUTTON_ICON_SIZE, self.BACK_BUTTON_ICON_SIZE)
	backButtonIcon:setPosition(self.PADDING, (self.BACK_BUTTON_HEIGHT - self.BACK_BUTTON_ICON_SIZE) / 2)
	self.backButton:addChild(backButtonIcon)

	self.infoContent:addChild(self.backButton)

	self.skillsContent.onSelectSkill:register(self.onSelectSkill, self)
end

function PlayerStats:onSelectSkill()
	self.layout:setScroll(self.infoContent:getPosition())
end

function PlayerStats:onBackButtonPress()
	self.layout:setScroll(self.skillsContent:getPosition())
end

function PlayerStats:attach()
	PlayerTab.attach()

	self:tick()
end

function PlayerStats:tick()
	PlayerTab.tick(self)

	state = self:getState()
	self.skillsContent:refresh(state)

	local index = self.skillsContent:getCurrentSkillIndex()
	local skill = state.skills[index]
	if skill then
		self.infoContent:refresh(skill)
	end
end

return PlayerStats
