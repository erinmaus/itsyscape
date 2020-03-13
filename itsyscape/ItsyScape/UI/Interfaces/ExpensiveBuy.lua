--------------------------------------------------------------------------------
-- ItsyScape/UI/ExpensiveBuy.lua
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
local ToolTip = require "ItsyScape.UI.ToolTip"
local ConstraintsPanel = require "ItsyScape.UI.Interfaces.Common.ConstraintsPanel"

local ExpensiveBuy = Class(Interface)
ExpensiveBuy.WIDTH = 320
ExpensiveBuy.HEIGHT = 480
ExpensiveBuy.PADDING = 8
ExpensiveBuy.BUTTON_SIZE = 48

function ExpensiveBuy:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(ExpensiveBuy.WIDTH, ExpensiveBuy.HEIGHT)
	self:setPosition(
		(w - ExpensiveBuy.WIDTH) / 2,
		(h - ExpensiveBuy.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(ExpensiveBuy.WIDTH, ExpensiveBuy.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(ExpensiveBuy.BUTTON_SIZE, ExpensiveBuy.BUTTON_SIZE)
	self.closeButton:setPosition(ExpensiveBuy.WIDTH - ExpensiveBuy.BUTTON_SIZE, 0)
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
		width = ExpensiveBuy.WIDTH - ExpensiveBuy.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, ui:getResources()))
	confirmLabel:setText("Confirm Purchase")
	confirmLabel:setPosition(ExpensiveBuy.PADDING, ExpensiveBuy.PADDING)
	self:addChild(confirmLabel)

	local constraintsPanelBackground = Panel()
	constraintsPanelBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	constraintsPanelBackground:setSize(
		ExpensiveBuy.WIDTH - ExpensiveBuy.PADDING * 2,
		ExpensiveBuy.HEIGHT - ExpensiveBuy.BUTTON_SIZE * 2 - ExpensiveBuy.PADDING * 4)
	constraintsPanelBackground:setPosition(ExpensiveBuy.PADDING, ExpensiveBuy.BUTTON_SIZE + ExpensiveBuy.PADDING)
	self:addChild(constraintsPanelBackground)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:setSize(
		ExpensiveBuy.WIDTH,
		ExpensiveBuy.HEIGHT - ExpensiveBuy.BUTTON_SIZE * 2 - ExpensiveBuy.PADDING * 4)
	self.constraintsPanel:setPosition(0, ExpensiveBuy.BUTTON_SIZE + ExpensiveBuy.PADDING)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(ExpensiveBuy.PADDING * 2, ExpensiveBuy.PADDING)

	do
		local state = self:getState()

		self.requirementsConstraints = ConstraintsPanel(ui)
		self.requirementsConstraints:setData("skillAsLevel", true)
		self.requirementsConstraints:setSize(
			ExpensiveBuy.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - ExpensiveBuy.PADDING * 2,
			0)
		self.requirementsConstraints:setText("Requirements")
		self.requirementsConstraints:setConstraints(state.requirements)
		self.constraintsPanel:addChild(self.requirementsConstraints)

		self.inputsConstraints = ConstraintsPanel(ui)
		self.inputsConstraints:setSize(
			ExpensiveBuy.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - ExpensiveBuy.PADDING * 2,
			0)
		self.inputsConstraints:setText("Cost")
		self.inputsConstraints:setConstraints(state.inputs)
		self.constraintsPanel:addChild(self.inputsConstraints)

		self.outputsConstraints = ConstraintsPanel(ui)
		self.outputsConstraints:setSize(
			ExpensiveBuy.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - ExpensiveBuy.PADDING * 2,
			0)
		self.outputsConstraints:setText("Goods")
		self.outputsConstraints:setConstraints(state.outputs)
		self.constraintsPanel:addChild(self.outputsConstraints)
	end

	self.constraintsPanel:setScrollSize(self.constraintsPanel:getInnerPanel():getSize())
	self:addChild(self.constraintsPanel)

	self.buyButton = Button()
	self.buyButton:setSize(ExpensiveBuy.WIDTH / 2 - ExpensiveBuy.PADDING * 4, ExpensiveBuy.BUTTON_SIZE)
	self.buyButton:setPosition(ExpensiveBuy.PADDING, ExpensiveBuy.HEIGHT - ExpensiveBuy.BUTTON_SIZE - ExpensiveBuy.PADDING)
	self.buyButton:setText("Buy!")
	self.buyButton.onClick:register(function()
		self:sendPoke("buy", nil, {})
	end)
	self.buyButton:setToolTip(
		ToolTip.Text("Items will be wired from your bank if you're not carrying enough."))
	self:addChild(self.buyButton)

	self.cancelButton = Button()
	self.cancelButton:setSize(ExpensiveBuy.WIDTH / 2 - ExpensiveBuy.PADDING * 4, ExpensiveBuy.BUTTON_SIZE)
	self.cancelButton:setPosition(
		ExpensiveBuy.WIDTH - (ExpensiveBuy.WIDTH / 2 - ExpensiveBuy.PADDING * 4) - ExpensiveBuy.PADDING,
		ExpensiveBuy.HEIGHT - ExpensiveBuy.BUTTON_SIZE - ExpensiveBuy.PADDING)
	self.cancelButton:setText("Nevermind!")
	self.cancelButton.onClick:register(function()
		self:sendPoke("nevermind", nil, {})
	end)
	self:addChild(self.cancelButton)
end

return ExpensiveBuy
