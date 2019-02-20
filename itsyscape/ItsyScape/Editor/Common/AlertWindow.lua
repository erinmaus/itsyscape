--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/AlertWindow.lua
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

local AlertWindow = Class(Widget)
AlertWindow.DEFAULT_WIDTH = 240
AlertWindow.DEFAULT_HEIGHT = 160
AlertWindow.PADDING = 8

function AlertWindow:new(application)
	Widget.new(self)

	self.application = application

	self.onSubmit = Callback()

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
	self.messageLabel:setPosition(AlertWindow.PADDING, AlertWindow.PADDING)
	self:addChild(self.messageLabel)

	self.okButton = Button()
	self.okButton:setSize(96, 32)
	self.okButton:setPosition(
		AlertWindow.PADDING,
		AlertWindow.DEFAULT_HEIGHT - 32 - AlertWindow.PADDING)
	self.okButton.onClick:register(function()
		self.onSubmit(self)
		self:close()
	end)
	self.okButton:setText("OK")

	self:addChild(self.okButton)

	self:setSize(AlertWindow.DEFAULT_WIDTH, AlertWindow.DEFAULT_HEIGHT)
end

function AlertWindow:getOverflow()
	return true
end

function AlertWindow:open(message, title, width, height)
	width = width or AlertWindow.DEFAULT_WIDTH
	height = height or AlertWindow.DEFAULT_HEIGHT

	self.titleLabel:setText(title or "Alert")
	self.messageLabel:setText(message or "Something interesting happened.")

	self.messageLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 20,
		color = { 1, 1, 1, 1 },
		textShadow = true,
		width = width - self.PADDING * 2
	}, self.application:getUIView():getResources()))

	self:setSize(width, height)

	local windowWidth, windowHeight = love.window.getMode()
	local x, y = windowWidth / 2 - width / 2, windowHeight / 2 - height / 2

	self:setPosition(x, y)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function AlertWindow:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function AlertWindow:performLayout()
	local width, height = self:getSize()

	self.panel:setSize(width, height)

	self.okButton:setPosition(
		AlertWindow.PADDING,
		height - 32 - AlertWindow.PADDING)
end

return AlertWindow
