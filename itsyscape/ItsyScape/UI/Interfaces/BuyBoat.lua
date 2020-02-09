--------------------------------------------------------------------------------
-- ItsyScape/UI/BuyBoat.lua
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

local BuyBoat = Class(Interface)
BuyBoat.WIDTH = 320
BuyBoat.HEIGHT = 480
BuyBoat.PADDING = 8
BuyBoat.BUTTON_SIZE = 48

function BuyBoat:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(BuyBoat.WIDTH, BuyBoat.HEIGHT)
	self:setPosition(
		(w - BuyBoat.WIDTH) / 2,
		(h - BuyBoat.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(BuyBoat.WIDTH, BuyBoat.HEIGHT)
	self:addChild(panel)

	self.closeButton = Button()
	self.closeButton:setSize(BuyBoat.BUTTON_SIZE, BuyBoat.BUTTON_SIZE)
	self.closeButton:setPosition(BuyBoat.WIDTH - BuyBoat.BUTTON_SIZE, 0)
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
		width = BuyBoat.WIDTH - BuyBoat.PADDING * 2,
		color = { 1, 1, 1, 1 }
	}, ui:getResources()))
	confirmLabel:setText("Confirm Purchase")
	confirmLabel:setPosition(BuyBoat.PADDING, BuyBoat.PADDING)
	self:addChild(confirmLabel)

	local constraintsPanelBackground = Panel()
	constraintsPanelBackground:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/Group.9.png"
	}, ui:getResources()))
	constraintsPanelBackground:setSize(
		BuyBoat.WIDTH - BuyBoat.PADDING * 2,
		BuyBoat.HEIGHT - BuyBoat.BUTTON_SIZE * 2 - BuyBoat.PADDING * 4)
	constraintsPanelBackground:setPosition(BuyBoat.PADDING, BuyBoat.BUTTON_SIZE + BuyBoat.PADDING)
	self:addChild(constraintsPanelBackground)

	self.constraintsPanel = ScrollablePanel(GridLayout)
	self.constraintsPanel:setSize(
		BuyBoat.WIDTH,
		BuyBoat.HEIGHT - BuyBoat.BUTTON_SIZE * 2 - BuyBoat.PADDING * 4)
	self.constraintsPanel:setPosition(0, BuyBoat.BUTTON_SIZE + BuyBoat.PADDING)
	self.constraintsPanel:getInnerPanel():setWrapContents(true)
	self.constraintsPanel:getInnerPanel():setPadding(BuyBoat.PADDING * 2, BuyBoat.PADDING)

	do
		local state = self:getState()

		self.requirementsConstraints = ConstraintsPanel(ui)
		self.requirementsConstraints:setData("skillAsLevel", true)
		self.requirementsConstraints:setSize(
			BuyBoat.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - BuyBoat.PADDING * 2,
			0)
		self.requirementsConstraints:setText("Requirements")
		self.requirementsConstraints:setConstraints(state.requirements)
		self.constraintsPanel:addChild(self.requirementsConstraints)

		self.inputsConstraints = ConstraintsPanel(ui)
		self.inputsConstraints:setSize(
			BuyBoat.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - BuyBoat.PADDING * 2,
			0)
		self.inputsConstraints:setText("Cost")
		self.inputsConstraints:setConstraints(state.inputs)
		self.constraintsPanel:addChild(self.inputsConstraints)

		self.outputsConstraints = ConstraintsPanel(ui)
		self.outputsConstraints:setSize(
			BuyBoat.WIDTH - ScrollablePanel.DEFAULT_SCROLL_SIZE - BuyBoat.PADDING * 2,
			0)
		self.outputsConstraints:setText("Goods")
		self.outputsConstraints:setConstraints(state.outputs)
		self.constraintsPanel:addChild(self.outputsConstraints)
	end

	self.constraintsPanel:setScrollSize(self.constraintsPanel:getInnerPanel():getSize())
	self:addChild(self.constraintsPanel)

	self.buyButton = Button()
	self.buyButton:setSize(BuyBoat.WIDTH / 2 - BuyBoat.PADDING * 4, BuyBoat.BUTTON_SIZE)
	self.buyButton:setPosition(BuyBoat.PADDING, BuyBoat.HEIGHT - BuyBoat.BUTTON_SIZE - BuyBoat.PADDING)
	self.buyButton:setText("Buy!")
	self.buyButton.onClick:register(function()
		self:sendPoke("buy", nil, {})
	end)
	self.buyButton:setToolTip(
		ToolTip.Text("Items will be wired from your bank if you're not carrying enough."))
	self:addChild(self.buyButton)

	self.cancelButton = Button()
	self.cancelButton:setSize(BuyBoat.WIDTH / 2 - BuyBoat.PADDING * 4, BuyBoat.BUTTON_SIZE)
	self.cancelButton:setPosition(
		BuyBoat.WIDTH - (BuyBoat.WIDTH / 2 - BuyBoat.PADDING * 4) - BuyBoat.PADDING,
		BuyBoat.HEIGHT - BuyBoat.BUTTON_SIZE - BuyBoat.PADDING)
	self.cancelButton:setText("Nevermind!")
	self.cancelButton.onClick:register(function()
		self:sendPoke("nevermind", nil, {})
	end)
	self:addChild(self.cancelButton)
end

return BuyBoat
