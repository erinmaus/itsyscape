--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/DialogBox.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Utility = require "ItsyScape.Game.Utility"
local Mapp = require "ItsyScape.GameDB.Mapp"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Interface = require "ItsyScape.UI.Interface"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local TextInput = require "ItsyScape.UI.TextInput"

local DialogBox = Class(Interface)
DialogBox.PADDING = 16
DialogBox.HEIGHT = 240

function DialogBox:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local w, h = love.window.getMode()
	self:setSize(w, DialogBox.HEIGHT + 32)
	self:setPosition(0, 0)

	local panel = Panel()
	panel:setSize(w, DialogBox.HEIGHT)
	self:addChild(panel)

	self.speakerLabel = Label()
	self.speakerLabel:setText("Unknown")
	self.speakerLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	self.speakerLabel:setPosition(DialogBox.PADDING, DialogBox.HEIGHT)
	self:addChild(self.speakerLabel)

	self.messageLabel = Label()
	self.messageLabel:setText("Lorem ipsum...")
	self.messageLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 24,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, self:getView():getResources()))
	self.messageLabel:setPosition(DialogBox.PADDING, DialogBox.PADDING)
	panel:addChild(self.messageLabel)

	self.inputBox = TextInput()
	self.inputBox:setSize(w - DialogBox.PADDING * 2, 32)
	self.inputBox:setPosition(DialogBox.PADDING, DialogBox.HEIGHT / 2 - 16)

	self.nextButton = Button()
	self.nextButton:setText("Continue >")
	self.nextButton:setSize(128, 32)
	self.nextButton:setPosition(w - 128, DialogBox.HEIGHT)
	self.nextButton.onClick:register(DialogBox.pump, self)

	self.options = {}
end

function DialogBox:getOverflow()
	return true
end

function DialogBox:pump()
	local state = self:getState()

	if state.input then
		self:sendPoke("submit", nil, { value = self.inputBox:getText() })
	else
		self:sendPoke("next", nil, {})
	end
end

function DialogBox:select(index)
	self:sendPoke("select", nil, { index = index })
end

function DialogBox:next()
	local state = self:getState()

	for i = 1, #self.options do
		self:removeChild(self.options[i])
	end
	self.options = {}

	if state.content then
		self.messageLabel:setText(table.concat(state.content[1], "\n"))
		self:addChild(self.nextButton)
		self:removeChild(self.inputBox)
	elseif state.input then
		self.messageLabel:setText(table.concat(state.input, "\n"))

		self:getView():getInputProvider():setFocusedWidget(self.inputBox)
		self.inputBox:setText("")

		self:addChild(self.inputBox)
		self:addChild(self.nextButton)
	elseif state.options then
		self.messageLabel:setText("")
		self:removeChild(self.inputBox)
		local y = DialogBox.PADDING
		local w, h = self:getSize()
		for i = 1, #state.options do
			local option = Button()
			option:setText(table.concat(state.options[i], " "))
			option:setSize(w - DialogBox.PADDING * 2, 32)
			option:setPosition(DialogBox.PADDING, y)
			option.onClick:register(DialogBox.select, self, i)
			self:addChild(option)

			y = y + DialogBox.PADDING + 32

			table.insert(self.options, option)
		end

		self:removeChild(self.nextButton)
	end

	self.speakerLabel:setText(state.speaker)
end

return DialogBox
