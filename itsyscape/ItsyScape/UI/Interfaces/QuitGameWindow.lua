--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/QuitGameWindow.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Button = require "ItsyScape.UI.Button"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local Interface = require "ItsyScape.UI.Interface"

local QuitGameWindow = Class(Interface)
QuitGameWindow.DEFAULT_WIDTH = 480
QuitGameWindow.DEFAULT_HEIGHT = 240
QuitGameWindow.PADDING = 8

function QuitGameWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local width, height = love.graphics.getScaledMode()

	self:setPosition(
		width / 2 - QuitGameWindow.DEFAULT_WIDTH / 2,
		height / 2 - QuitGameWindow.DEFAULT_HEIGHT / 2)

	self.panel = Panel()
	self.panel:setSize(
		QuitGameWindow.DEFAULT_WIDTH,
		QuitGameWindow.DEFAULT_HEIGHT)
	self:addChild(self.panel)

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, ui:getResources()))
	self.titleLabel:setPosition(16, -32)
	self.titleLabel:setText("Quit Game")
	self:addChild(self.titleLabel)

	self.messageLabel = Label()
	self.messageLabel:setPosition(QuitGameWindow.PADDING, QuitGameWindow.PADDING)
	self.messageLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 24,
		color = { 1, 1, 1, 1 },
		width = QuitGameWindow.DEFAULT_WIDTH - QuitGameWindow.PADDING * 2,
		textShadow = true
	}, ui:getResources()))
	self.messageLabel:setText("Do you want to quit? All progress will be saved.")
	self:addChild(self.messageLabel)

	self.cancelButton = Button()
	self.cancelButton:setSize(96, 32)
	self.cancelButton:setPosition(
		QuitGameWindow.PADDING + 96 + QuitGameWindow.PADDING,
		QuitGameWindow.DEFAULT_HEIGHT - 32 - QuitGameWindow.PADDING)
	self.cancelButton.onClick:register(function()
		self:cancel()
	end)
	self.cancelButton:setText("Cancel")
	self:addChild(self.cancelButton)

	self.okButton = Button()
	self.okButton:setSize(96, 32)
	self.okButton:setPosition(
		QuitGameWindow.PADDING,
		QuitGameWindow.DEFAULT_HEIGHT - 32 - QuitGameWindow.PADDING)
	self.okButton.onClick:register(function()
		self:confirm()
	end)
	self.okButton:setText("OK")
	self:addChild(self.okButton)

	self:setSize(QuitGameWindow.DEFAULT_WIDTH, QuitGameWindow.DEFAULT_HEIGHT)
end

function QuitGameWindow:getOverflow()
	return true
end

function QuitGameWindow:confirm()
	self:sendPoke("confirm", nil, {})
end

function QuitGameWindow:cancel()
	self:sendPoke("cancel", nil, {})
end

return QuitGameWindow
