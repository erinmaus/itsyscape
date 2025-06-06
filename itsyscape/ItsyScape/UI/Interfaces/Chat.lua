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
local Button = require "ItsyScape.UI.Button"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local TextInput = require "ItsyScape.UI.TextInput"
local TextInputStyle = require "ItsyScape.UI.TextInputStyle"
local Interface = require "ItsyScape.UI.Interface"

local Chat = Class(Interface)
Chat.WIDTH   = 480
Chat.HEIGHT  = _MOBILE and 136 or 240
Chat.INPUT   = 48
Chat.PADDING = 8
Chat.Z_DEPTH = -1000

Chat.BUTTON_WIDTH = 96
Chat.LINE_HEIGHT  = 24

function Chat:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local windowWidth, windowHeight = love.graphics.getScaledMode()

	self:setPosition(0, windowHeight - Chat.HEIGHT - Chat.INPUT)

	self:setSize(Chat.WIDTH, Chat.HEIGHT + Chat.INPUT)
	self:setIsSelfClickThrough(true)

	self.mainPanel = Panel()
	self.mainPanel:setStyle(PanelStyle({ image = false }, ui:getResources()))
	self.mainPanel:setSize(self:getSize())
	self.mainPanel:setIsSelfClickThrough(true)

	self.messages = {}

	self.textInput = TextInput()
	self.textInput:setHint("Enter chat message")
	self.textInput:setStyle(TextInputStyle({
		inactive = Color(0, 0, 0, 0),
		active = Color(0, 0, 0, 0.5),
		hover = Color(0, 0, 0, 0.3),
		color = { 1, 1, 1, 1 },
		selectionColor = { 1, 1, 1, 0.5 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 22,
		padding = 4,
		textShadow = true
	}, ui:getResources()))
	self.textInput.onFocus:register(self.onTextInputFocus, self)
	self.textInput.onBlur:register(self.onTextInputBlur, self)
	self.textInput.onValueChanged:register(self.onTextInputValueChanged, self)
	self.textInput.onSubmit:register(self.send, self)
	self.textInput:setText("Click here to chat...")
	self.textInput:setSize(Chat.WIDTH - Chat.BUTTON_WIDTH, Chat.INPUT)
	self.textInput:setPosition(0, Chat.HEIGHT)
	self.mainPanel:addChild(self.textInput)

	self.hideButton = Button()
	self.hideButton:setText("Hide")
	self.hideButton:setToolTip("Hide chat")
	self.hideButton:setSize(Chat.BUTTON_WIDTH, Chat.INPUT)
	self.hideButton:setPosition(Chat.WIDTH - Chat.BUTTON_WIDTH, Chat.HEIGHT)
	self.hideButton.onClick:register(self.hide, self)
	self.mainPanel:addChild(self.hideButton)

	self.showButton = Button()
	self.showButton:setText("Chat")
	self.showButton:setToolTip("Show chat")
	self.showButton:setSize(Chat.BUTTON_WIDTH, Chat.INPUT)
	self.showButton:setPosition(0, Chat.HEIGHT)
	self.showButton.onClick:register(self.show, self)

	self.chatPanel = ScrollablePanel(GridLayout)
	self.chatPanel:setSize(Chat.WIDTH, Chat.HEIGHT)
	self.chatPanel:getInnerPanel():setPadding(Chat.PADDING, Chat.PADDING)
	self.chatPanel:getInnerPanel():setWrapContents(true)
	self.chatPanel:getInnerPanel():setIsSelfClickThrough(true)
	self.chatPanel:setIsSelfClickThrough(true)
	self.chatPanel:getInnerPanel():setIsSelfClickThrough(true)
	self.mainPanel:addChild(self.chatPanel)

	self.chatLabelStyle = LabelStyle({
		color = { 1, 1, 1, 1 },
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Regular.ttf",
		fontSize = 22,
		padding = 4,
		textShadow = true
	}, self:getView():getResources())

	self.received = 0

	self.isMessageEmpty = true

	self.keybind = Keybinds['PLAYER_1_CHAT']
	self.isKeybindDown = self.keybind:isDown()
	self.hadFocusedWidget = self:getView():getInputProvider():getFocusedWidget() ~= nil

	self:setZDepth(Chat.Z_DEPTH)

	if self:getState().hidden then
		self:hide()
	else
		self:show()
	end
end

function Chat:onTextInputValueChanged()
	self.isMessageEmpty = false
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
	if not self.isMessageEmpty and not self.textInput:getText():match("^%s*$") then
		self:sendPoke("chat", nil, { message = self.textInput:getText() })
	end

	self.isMessageEmpty = true
	self.textInput:setText("Click here to chat...")
	self.textInput:blur()
end

function Chat:show()
	self:sendPoke("show", nil, {})
	self:addChild(self.mainPanel)
	self:removeChild(self.showButton)
end

function Chat:hide()
	self:sendPoke("hide", nil, {})
	self:removeChild(self.mainPanel)
	self:addChild(self.showButton)
end

function Chat:updateChat(messages)
	local push = 0
	local pushStart = #self.messages

	local w = self.chatPanel:getInnerPanel():getSize()

	if #self.messages > #messages then
		while #self.messages > #messages do
			self.chatPanel:removeChild(self.messages[1])
			table.remove(self.messages, 1)
		end
	elseif #messages > #self.messages then
		while #messages > #self.messages do
			local label = Label()
			label:setStyle(self.chatLabelStyle)
			label:setIsSelfClickThrough(true)

			self.chatPanel:addChild(label)
			table.insert(self.messages, label)
		end
	end

	for i = 1, #messages do
		local _, lines = self.chatLabelStyle.font:getWrap(messages[i], w)
		local h = #lines * self.chatLabelStyle.font:getHeight() * self.chatLabelStyle.font:getLineHeight()

		self.messages[i]:setText(messages[i])
		self.messages[i]:setSize(w, h)

		if i > pushStart then
			push = push + h + self.chatPanel:getInnerPanel():getPadding()
		end
	end

	if push > 0 then
		push = push + self.chatPanel:getInnerPanel():getPadding()
	end

	self.chatPanel:getInnerPanel():performLayout()

	local scrollWidth, scrollHeight = self.chatPanel:getInnerPanel():getSize()
	local scrollX, scrollY = self.chatPanel:getInnerPanel():getScroll()
	local panelWidth, panelHeight = self.chatPanel:getSize()

	self.chatPanel:setScrollSize(scrollWidth, scrollHeight)

	if scrollHeight > Chat.HEIGHT and scrollY + push + panelHeight >= scrollHeight - panelHeight / 2 then
		self.chatPanel:getInnerPanel():setScroll(scrollX, math.min(scrollY + push, scrollHeight - panelHeight))
	elseif pushStart > #self.messages then
		if scrollHeight < panelHeight then
			self.chatPanel:getInnerPanel():setScroll(scrollX, 0)
		else
			self.chatPanel:getInnerPanel():setScroll(scrollX, math.min(scrollY, scrollHeight - panelHeight))
		end
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
		elseif not self.hadFocusedWidget then
			self:getView():getInputProvider():setFocusedWidget(self.textInput)
		end
	end

	self.hadFocusedWidget = self:getView():getInputProvider():getFocusedWidget()
	self.isKeybindDown = isKeybindDown

	if _MOBILE then
		local _, scrollHeight = self.chatPanel:getScrollSize()
		local _, height = self.chatPanel:getSize()

		local isClickThrough = scrollHeight <= height

		local scrollBar = self.chatPanel:getScrollBar()
		scrollBar:setIsSelfClickThrough(isClickThrough)
	end
end

return Chat
