--------------------------------------------------------------------------------
-- ItsyScape/UI/QuestAccept.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Interface = require "ItsyScape.UI.Interface"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local QuestAccept = Class(Interface)
QuestAccept.WIDTH = 320
QuestAccept.HEIGHT = 480
QuestAccept.PADDING = 8
QuestAccept.BUTTON_SIZE = 48

QuestAccept.BUTTON_DISABLED = {
	inactive = "Resources/Renderers/Widget/Button/Disabled-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Disabled-Hover.9.png",
	pressed = "Resources/Renderers/Widget/Button/Disabled-Pressed.9.png",
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
	fontSize = 24,
	textShadow = true,
	padding = 4
}

function QuestAccept:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.graphics.getScaledMode()
	self:setSize(QuestAccept.WIDTH, QuestAccept.HEIGHT)
	self:setPosition(
		(w - QuestAccept.WIDTH) / 2,
		(h - QuestAccept.HEIGHT) / 2)

	local state = self:getState()

	local panel = Panel()
	panel:setSize(QuestAccept.WIDTH, QuestAccept.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(QuestAccept.BUTTON_SIZE, QuestAccept.BUTTON_SIZE)
	self.closeButton:setPosition(QuestAccept.WIDTH - QuestAccept.BUTTON_SIZE, 0)
	self.closeButton:setText("X")
	self.closeButton.onClick:register(function()
		self:sendPoke("close", nil, {})
	end)
	self:addChild(self.closeButton)

	local confirmLabel = Label()
	confirmLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textShadow = true,
		width = QuestAccept.WIDTH - QuestAccept.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, ui:getResources()))
	confirmLabel:setText(state.questName)
	confirmLabel:setPosition(QuestAccept.PADDING, QuestAccept.PADDING)
	self:addChild(confirmLabel)

	local constraintsPanelBackground = Panel()
	constraintsPanelBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	constraintsPanelBackground:setSize(
		QuestAccept.WIDTH - QuestAccept.PADDING * 2,
		QuestAccept.HEIGHT - QuestAccept.BUTTON_SIZE * 2 - QuestAccept.PADDING * 4)
	constraintsPanelBackground:setPosition(QuestAccept.PADDING, QuestAccept.BUTTON_SIZE + QuestAccept.PADDING)
	self:addChild(constraintsPanelBackground)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:setSize(
		QuestAccept.WIDTH,
		QuestAccept.HEIGHT - QuestAccept.BUTTON_SIZE * 2 - QuestAccept.PADDING * 4)
	self.constraintsPanel:setPosition(0, QuestAccept.BUTTON_SIZE + QuestAccept.PADDING)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(QuestAccept.PADDING * 2, QuestAccept.PADDING)

	self.requirementsConstraints = ConstraintsPanel(ui)
	self.requirementsConstraints:setData("skillAsLevel", true)
	self.requirementsConstraints:setSize(
		QuestAccept.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - QuestAccept.PADDING * 2,
		0)
	self.requirementsConstraints:setText("Requirements")
	self.requirementsConstraints:setConstraints(state.requirements)
	self.constraintsPanel:addChild(self.requirementsConstraints)

	if #state.outputs > 1 then
		self.rewardConstraints = ConstraintsPanel(ui)
		self.rewardConstraints:setSize(
			QuestAccept.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - QuestAccept.PADDING * 2,
			0)
		self.rewardConstraints:setText("Reward")
		self.rewardConstraints:setConstraints(state.outputs)
		self.constraintsPanel:addChild(self.rewardConstraints)
	end

	self.constraintsPanel:setScrollSize(self.constraintsPanel:getInnerPanel():getSize())
	self:addChild(self.constraintsPanel)

	self.constraintsPanel:setScrollSize(self.constraintsPanel:getInnerPanel():getSize())

	self.acceptButton = Button()
	self.acceptButton:setSize(QuestAccept.WIDTH / 2 - QuestAccept.PADDING * 4, QuestAccept.BUTTON_SIZE)
	self.acceptButton:setPosition(QuestAccept.PADDING, QuestAccept.HEIGHT - QuestAccept.BUTTON_SIZE - QuestAccept.PADDING)
	self.acceptButton:setText("Accept")
	self.acceptButton.onClick:register(function()
		local state = self:getState()
		if state.canPerform then
			self:sendPoke("accept", nil, {})
		end
	end)
	self:addChild(self.acceptButton)

	local state = self:getState()
	if not state.canPerform then
		self.acceptButton:setStyle(
			ButtonStyle(QuestAccept.BUTTON_DISABLED,
			self:getView():getResources()))
		self.acceptButton:setToolTip(ToolTip.Text("You do not meet the requirements to start this quest."))
	else
		self.acceptButton:setToolTip(ToolTip.Text("You meet the requirements to start this quest."))
	end

	self.declineButton = Button()
	self.declineButton:setSize(QuestAccept.WIDTH / 2 - QuestAccept.PADDING * 4, QuestAccept.BUTTON_SIZE)
	self.declineButton:setPosition(
		QuestAccept.WIDTH - (QuestAccept.WIDTH / 2 - QuestAccept.PADDING * 4) - QuestAccept.PADDING,
		QuestAccept.HEIGHT - QuestAccept.BUTTON_SIZE - QuestAccept.PADDING)
	self.declineButton:setText("Decline")
	self.declineButton.onClick:register(function()
		self:sendPoke("decline", nil, {})
	end)
	self:addChild(self.declineButton)
end

return QuestAccept
