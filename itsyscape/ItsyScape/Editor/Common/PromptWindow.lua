--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/PromptWindow.lua
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
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local TextInput = require "ItsyScape.UI.TextInput"
local Widget = require "ItsyScape.UI.Widget"

local PromptWindow = Class(Widget)
PromptWindow.DEFAULT_WIDTH = 240
PromptWindow.DEFAULT_HEIGHT = 160
PromptWindow.PADDING = 8

function PromptWindow:new(application)
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

	self.queryLabel = Label()
	self.queryLabel:setPosition(PromptWindow.PADDING, PromptWindow.PADDING)
	self:addChild(self.queryLabel)

	self.input = TextInput()
	self.input:setSize(
		PromptWindow.DEFAULT_WIDTH - PromptWindow.PADDING * 2,
		32)
	self.input:setPosition(
		PromptWindow.PADDING,
		PromptWindow.DEFAULT_HEIGHT - (PromptWindow.PADDING * 2 + 32) * 2)
	self.input.onSubmit:register(function()
		self.onSubmit(self, self.input:getText())
		self:close()
	end)
	self:addChild(self.input)

	self.buttonsGridLayout = GridLayout()
	self.buttonsGridLayout:setPadding(PromptWindow.PADDING, 0)
	self.buttonsGridLayout:setUniformSize(
		true,
		PromptWindow.DEFAULT_WIDTH / 2 - PromptWindow.PADDING * 2, 32)
	self.buttonsGridLayout:setSize(
		PromptWindow.DEFAULT_WIDTH,
		32)
	self.buttonsGridLayout:setPosition(
		PromptWindow.PADDING,
		PromptWindow.DEFAULT_HEIGHT - 32 - PromptWindow.PADDING)
	self:addChild(self.buttonsGridLayout)

	self.okButton = Button()
	self.okButton.onClick:register(function()
		self.onSubmit(self, self.input:getText())
		self:close()
	end)
	self.okButton:setText("OK")
	self.buttonsGridLayout:addChild(self.okButton)

	self.cancelButton = Button()
	self.cancelButton.onClick:register(function()
		self.onCancel(self)
		self:close()
	end)
	self.cancelButton:setText("Cancel")
	self.buttonsGridLayout:addChild(self.cancelButton)

	self:setSize(PromptWindow.DEFAULT_WIDTH, PromptWindow.DEFAULT_HEIGHT)
end

function PromptWindow:getOverflow()
	return true
end

function PromptWindow:open(query, title, width, height)
	width = width or PromptWindow.DEFAULT_WIDTH
	height = height or PromptWindow.DEFAULT_HEIGHT

	self.titleLabel:setText(title or "Prompt")
	self.queryLabel:setText(query or "Please enter a value.")

	self:setSize(width, height)

	local windowWidth, windowHeight = love.window.getMode()
	local x, y = windowWidth / 2 - width / 2, windowHeight / 2 - height / 2

	self:setPosition(x, y)

	local root = parent or self.application:getUIView():getRoot()
	root:addChild(self)
end

function PromptWindow:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
	end
end

function PromptWindow:performLayout()
	local width, height = self:getSize()

	self.panel:setSize(width, height)

	local inputWidth, inputHeight = self.input:getSize()
	self.input:setSize(
		width - PromptWindow.PADDING * 2,
		inputHeight)
	self.input:setPosition(
		PromptWindow.PADDING,
		height - (PromptWindow.PADDING * 2 + 32) * 2)

	self.buttonsGridLayout:setPosition(
		PromptWindow.PADDING,
		height - 32 - PromptWindow.PADDING)
end

return PromptWindow
