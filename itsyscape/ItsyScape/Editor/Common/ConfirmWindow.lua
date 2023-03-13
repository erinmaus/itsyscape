--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/ConfirmWindow.lua
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
local Widget = require "ItsyScape.UI.Widget"

local ConfirmWindow = Class(Widget)
ConfirmWindow.DEFAULT_WIDTH = 240
ConfirmWindow.DEFAULT_HEIGHT = 160
ConfirmWindow.PADDING = 8

function ConfirmWindow:new(application)
	Widget.new(self)

	self.application = application

	self.onSubmit = Callback()
	self.onCancel = Callback()

	self.panel = Panel()
	self.panel:setSize(self:getSize())
	self:addChild(self.panel)

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, application:getUIView():getResources()))
	self.titleLabel:setPosition(16, -32)
	self:addChild(self.titleLabel)

	self.messageLabel = Label()
	self.messageLabel:setPosition(ConfirmWindow.PADDING, ConfirmWindow.PADDING)
	self:addChild(self.messageLabel)

	self.cancelButton = Button()
	self.cancelButton:setSize(96, 32)
	self.cancelButton:setPosition(
		ConfirmWindow.PADDING,
		ConfirmWindow.DEFAULT_HEIGHT - 32 - ConfirmWindow.PADDING)
	self.cancelButton.onClick:register(function()
		self.onCancel(self)
		self:close()
	end)
	self.cancelButton:setText("Cancel")

	self.okButton = Button()
	self.okButton:setSize(96, 32)
	self.okButton:setPosition(
		ConfirmWindow.PADDING * 2 + 96,
		ConfirmWindow.DEFAULT_HEIGHT - 32 - ConfirmWindow.PADDING)
	self.okButton.onClick:register(function()
		self.onSubmit(self)
		self:close()
	end)
	self.okButton:setText("OK")

	self:addChild(self.okButton)
	self:addChild(self.cancelButton)

	self:setSize(ConfirmWindow.DEFAULT_WIDTH, ConfirmWindow.DEFAULT_HEIGHT)
end

function ConfirmWindow:getOverflow()
	return true
end

function ConfirmWindow:open(message, title, width, height)
	width = width or ConfirmWindow.DEFAULT_WIDTH
	height = height or ConfirmWindow.DEFAULT_HEIGHT

	self.titleLabel:setText(title or "Confirm")
	self.messageLabel:setText(message or "Are you sure you want to do that?")

	self:setSize(width, height)

	local windowWidth, windowHeight = love.window.getMode()
	local x, y = windowWidth / 2 - width / 2, windowHeight / 2 - height / 2

	self:setPosition(x, y)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function ConfirmWindow:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function ConfirmWindow:performLayout()
	local width, height = self:getSize()

	self.panel:setSize(width, height)

	self.messageLabel:setSize(width - self.PADDING, height - 32 - ConfirmWindow.PADDING)

	self.okButton:setPosition(
		ConfirmWindow.PADDING,
		height - 32 - ConfirmWindow.PADDING)

	self.cancelButton:setPosition(
		ConfirmWindow.PADDING * 2 + 96,
		height - 32 - ConfirmWindow.PADDING)
end

return ConfirmWindow
