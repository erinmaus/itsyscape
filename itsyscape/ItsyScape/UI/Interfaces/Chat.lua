--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Chat.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local Interface = require "ItsyScape.UI.Interface"

local Chat = Class(Interface)
Chat.WIDTH   = 480
Chat.HEIGHT  = 240
Chat.INPUT   = 48
Chat.PADDING = 8

Chat.LINE_HEIGHT = 24

function Chat:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local windowWidth, windowHeight = love.graphics.getScaledMode()
	self:setPosition(0, windowHeight - Chat.HEIGHT - Chat.INPUT)
	self:setSize(Chat.WIDTH, Chat.HEIGHT + Chat.INPUT)

	self.messages = {}

	self.textInput = TextInput()
	self.textInput:setStyle(TextInputStyle({
		inactive = Color(0, 0, 0, 0),
		active = Color(0, 0, 0, 0.5),
		hover = Color(0, 0, 0, 0.3),
		color = { 1, 1, 1, 1 },
		selectionColor = { 1, 1, 1, 0.5 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 20,
		padding = 4,
		textShadow = true
	}, ui:getResources()))
	self.textInput.onFocus:register(self.onTextInputFocus, self)
	self.textInput.onBlur:register(self.onTextInputBlur, self)
	self.textInput.onSubmit:register(self.onTextInputSubmit, self)
	self.textInput:setText("Click here to chat...")
	self.textInput:setSize(Chat.WIDTH, Chat.INPUT)
	self.textInput:setPosition(0, Chat.HEIGHT)
	self:addChild(self.textInput)

	self.chatPanel = ScrollablePanel(GridLayout)
	self.chatPanel:setSize(Chat.WIDTH, Chat.HEIGHT)
	self.chatPanel:getInnerPanel():setUniformSize(true, Chat.WIDTH - Chat.PADDING * 2, Chat.LINE_HEIGHT)
	self.chatPanel:getInnerPanel():setPadding(Chat.PADDING, Chat.PADDING)
	self.chatPanel:getInnerPanel():setWrapContents(true)
	self.chatPanel:setIsClickThrough(true)
	self.chatPanel:getInnerPanel():setIsClickThrough(true)
	self:addChild(self.chatPanel)

	self.received = 0

	self.isMessageEmpty = true

	self.keybind = Keybinds['PLAYER_1_CHAT']
	self.isKeybindDown = self.keybind:isDown()
end

function Chat:onTextInputFocus()
	if self.isMessageEmpty then
		self.textInput:setText("")
	end
end

function Chat:onTextInputBlur()
	if self.isMessageEmpty and self.textInput:getText() == "" then
		self.textInput:setText("Click here to chat...")
	end
end

function Chat:send()
	self:sendPoke("chat", nil, { message = self.textInput:getText() })

	self.isMessageEmpty = true
	self.textInput:setText("Click here to chat...")
	self.textInput:blur()
end

function Chat:updateChat(messages)
	local push = 0

	if #messages < #self.messages then
		while #messages < #self.messages do
			self.chatPanel:removeChild(self.messages[i])
			table.remove(self.messages, 1)
		end
	elseif #messages > #self.messages then
		push = #messages - #self.messages
		while #messages > #self.messages do
			local label = Label()
			label:setStyle(LabelStyle({
				color = { 1, 1, 1, 1 },
				font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
				fontSize = 20,
				padding = 4,
				textShadow = true
			}, self:getView():getResources()))
			label:setIsClickThrough(true)

			self.chatPanel:addChild(label)
			table.insert(self.messages, label)
		end
	end

	for i = 1, #messages do
		self.messages[i]:setText(messages[i])
	end

	local scrollWidth, scrollHeight = self.chatPanel:getInnerPanel():getSize()
	self.chatPanel:setScrollSize(scrollWidth, scrollHeight)

	if scrollHeight > Chat.HEIGHT then
		local scrollX, scrollY = self.chatPanel:getInnerPanel():getScroll()
		self.chatPanel:getInnerPanel():setScroll(scrollX, scrollY + push * (Chat.LINE_HEIGHT + Chat.PADDING))
	end
end

function Chat:update(delta)
	Interface.update(self, delta)

	local state = self:getState()
	if self.received ~= state.received then
		self:updateChat(state.messages)
		self.received = state.received
	end

	local isKeybindDown = self.keybind:isDown()
	if not self.isKeybindDown and isKeybindDown then
		if self.textInput:getIsFocused() then
			self:send()
		else
			self:getView():getInputProvider():setFocusedWidget(self.textInput)
		end
	end
	self.isKeybindDown = isKeybindDown
end

return Chat
