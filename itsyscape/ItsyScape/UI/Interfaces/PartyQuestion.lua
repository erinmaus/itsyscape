--------------------------------------------------------------------------------
-- ItsyScape/UI/PartyQuestion.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"

local PartyQuestion = Class(Interface)
PartyQuestion.WIDTH = 320
PartyQuestion.HEIGHT = 480
PartyQuestion.PADDING = 8
PartyQuestion.BUTTON_SIZE = 48
PartyQuestion.DESCRIPTION_HEIGHT = PartyQuestion.BUTTON_SIZE * 4

PartyQuestion.BUTTONS = {
	["join"] = {
		text = "Join",
		toolTip = "Join a new party."
	},

	["rejoin"] = {
		text = "Rejoin",
		toolTip = "Rejoin your current party."
	},

	["create"] = {
		text = "Create",
		toolTip = "Create a party for a raid with you as the leader."
	},

	["leave"] = {
		text = "Leave",
		toolTip = "Leave the party you are currently in."
	},

	["close"] = {
		text = "Nevermind",
		toolTip = "Don't do anything."
	}
}

function PartyQuestion:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(PartyQuestion.WIDTH, PartyQuestion.HEIGHT)
	self:setPosition(
		(w - PartyQuestion.WIDTH) / 2,
		(h - PartyQuestion.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(PartyQuestion.WIDTH, PartyQuestion.HEIGHT)
	self:addChild(panel)

	local descriptionPanelBackground = Panel()
	descriptionPanelBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	descriptionPanelBackground:setSize(
		PartyQuestion.WIDTH - PartyQuestion.PADDING * 2,
		PartyQuestion.DESCRIPTION_HEIGHT)
	descriptionPanelBackground:setPosition(
		PartyQuestion.PADDING,
		PartyQuestion.BUTTON_SIZE + PartyQuestion.PADDING)
	self:addChild(descriptionPanelBackground)

	self.closeButton = Button()
	self.closeButton:setSize(PartyQuestion.BUTTON_SIZE, PartyQuestion.BUTTON_SIZE)
	self.closeButton:setPosition(PartyQuestion.WIDTH - PartyQuestion.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	self.buttonsLayout = ScrollablePanel(GridLayout)
	self.buttonsLayout:setSize(
		PartyQuestion.WIDTH,
		PartyQuestion.HEIGHT)
	self.buttonsLayout:setPosition(0, PartyQuestion.BUTTON_SIZE + PartyQuestion.DESCRIPTION_HEIGHT + PartyQuestion.PADDING * 2)
	self.buttonsLayout:getInnerPanel():setWrapContents(true)
	self.buttonsLayout:getInnerPanel():setPadding(PartyQuestion.PADDING * 2, PartyQuestion.PADDING)

	local state = self:getState()

	local description = Label()
	description:setText(state.description)
	description:setStyle(LabelStyle({
		color = { 1, 1, 1, 1 },
		textShadow = true,
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 20
	}, ui:getResources()))
	description:setPosition(PartyQuestion.PADDING, PartyQuestion.PADDING)
	description:setSize(
		PartyQuestion.WIDTH - PartyQuestion.PADDING * 4,
		PartyQuestion.DESCRIPTION_HEIGHT - PartyQuestion.PADDING * 2)
	descriptionPanelBackground:addChild(description)

	local title = Label()
	title:setText(state.name)
	title:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		width = PartyQuestion.WIDTH - PartyQuestion.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, ui:getResources()))
	title:setPosition(PartyQuestion.PADDING, PartyQuestion.PADDING)
	self:addChild(title)

	for i = 1, #state.actions do
		local action = state.actions[i]
		local buttonInfo = PartyQuestion.BUTTONS[action]

		if buttonInfo then
			local button = Button()
			button:setSize(
				PartyQuestion.WIDTH - PartyQuestion.PADDING * 4,
				PartyQuestion.BUTTON_SIZE)
			button:setText(buttonInfo.text)
			button:setToolTip(buttonInfo.toolTip)

			button.onClick:register(function()
				self:sendPoke(action, nil, {})
			end)

			self.buttonsLayout:addChild(button)
		end
	end

	self.buttonsLayout:setScrollSize(self.buttonsLayout:getInnerPanel():getSize())
	self:addChild(self.buttonsLayout)
end

return PartyQuestion
