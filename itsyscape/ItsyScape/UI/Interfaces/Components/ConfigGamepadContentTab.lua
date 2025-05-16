--------------------------------------------------------------------------------
-- ItsyScape/UI/Interfaces/Components/ConfigGamepadContentTab.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Callback = require "ItsyScape.Common.Callback"
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Utility = require "ItsyScape.Game.Utility"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Icon = require "ItsyScape.UI.Icon"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"
local GamepadContentTab = require "ItsyScape.UI.Interfaces.Components.GamepadContentTab"
local StatBar = require "ItsyScape.UI.Interfaces.Components.StatBar"

local ConfigGamepadContentTab = Class(GamepadContentTab)
ConfigGamepadContentTab.PADDING = 16
ConfigGamepadContentTab.BUTTON_PADDING = 4
ConfigGamepadContentTab.ICON_SIZE = 48

ConfigGamepadContentTab.PROMPT_LABEL_STYLE = {
	color = { 1, 1, 1, 1 },
	font = "Resources/Renderers/Widget/Common/Serif/Regular.ttf",
	fontSize = 26,
	textShadow = true,
	center = true,
	align = "center"
}

ConfigGamepadContentTab.GROUP_PANEL_STYLE = {
	image = "Resources/Game/UI/Panels/WindowGroup.png"
}

function ConfigGamepadContentTab:new(interface)
	GamepadContentTab.new(self, interface)

	self.layout = GridLayout()
	self.layout:setSize(self:getSize())
	self.layout:setPadding(self.PADDING, self.PADDING)
	self.layout:setWrapContents(true)
	self:addChild(self.layout)

	self.prompt = Label()
	self.prompt:setStyle(self.PROMPT_LABEL_STYLE, LabelStyle)
	self.prompt:setSize(self.WIDTH - self.PADDING * 2, self.PROMPT_LABEL_STYLE.fontSize * 2)
	self.layout:addChild(self.prompt)

	self.buttons = GamepadGridLayout()
	self.buttons:setSize(self.WIDTH - self.PADDING * 2, 0)
	self.buttons:setPadding(0, self.PADDING)
	self.buttons:setUniformSize(true, self.WIDTH - self.PADDING * 2, self.ICON_SIZE + self.BUTTON_PADDING * 2)
	self.buttons:setWrapContents(true)
	self.buttons.onWrapFocus:register(self._onButtonsWrapFocus, self)
	self.layout:addChild(self.buttons)

	self.yesPlaceholder = Widget()
	self.noPlaceholder = Widget()
	self.quitSpace = Widget()

	self.yesButton = Button()
	self.yesButton:setText("Yes")
	self.yesButton.onClick:register(self._onClickYesButton, self)

	local yesIcon = Icon()
	yesIcon:setIcon("Resources/Game/UI/Icons/Concepts/Happy.png")
	yesIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	yesIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	self.yesButton:addChild(yesIcon)

	self.noButton = Button()
	self.noButton:setText("No")
	self.noButton.onClick:register(self._onClickNoButton, self)

	local noIcon = Icon()
	noIcon:setIcon("Resources/Game/UI/Icons/Concepts/Angry.png")
	noIcon:setSize(self.ICON_SIZE, self.ICON_SIZE)
	noIcon:setPosition(self.BUTTON_PADDING, self.BUTTON_PADDING)
	self.noButton:addChild(noIcon)

	self.quitButton = Button()
	self.quitButton:setText("Go to title screen")
	self.quitButton.onClick:register(self._onClickQuitButton, self)

	self.layout:setID("PlayerConfig")
end

function ConfigGamepadContentTab:focus(reason)
	GamepadContentTab.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if inputProvider then
		inputProvider:setFocusedWidget(child or self.buttons, reason)
	end
end

function ConfigGamepadContentTab:_onButtonsWrapFocus(_, child, directionX, directionY)
	self:onWrapFocus(directionX, directionY)
end

function ConfigGamepadContentTab:_onClickYesButton(button, buttonIndex)
	if buttonIndex == 1 then
		self:getInterface():sendPoke("rate", nil, { rating = true })
	end
end

function ConfigGamepadContentTab:_onClickNoButton(button, buttonIndex)
	if buttonIndex == 1 then
		self:getInterface():sendPoke("rate", nil, { rating = false })
	end
end

function ConfigGamepadContentTab:_onClickQuitButton(button, buttonIndex)
	if buttonIndex == 1 then
		self:getInterface():sendPoke("quit", nil, {})
	end
end

function ConfigGamepadContentTab:refresh(state)
	GamepadContentTab.refresh(self, state)

	if self.showSurvey ~= state.showSurvey then
		self.showSurvey = state.showSurvey

		local inputProvider = self:getInputProvider()
		local focusedWidget = inputProvider and inputProvider:getFocusedWidget()
		local isFocused = focusedWidget and focusedWidget:getParent() == self.buttons

		self.buttons:clearChildren()
		if self.showSurvey then
			self.prompt:setText("Did you enjoy playing ItsyRealm?")
			self.buttons:addChild(self.yesButton)
			self.buttons:addChild(self.noButton)
			self.buttons:addChild(self.quitSpace)
			self.buttons:addChild(self.quitButton)
		else
			if _ANALYTICS_ENABLED then
				self.prompt:setText("Thank you for your feedback!")
			else
				self.prompt:setText("Thank you for playing ItsyRealm!")
			end

			self.buttons:addChild(self.yesPlaceholder)
			self.buttons:addChild(self.noPlaceholder)
			self.buttons:addChild(self.quitSpace)
			self.buttons:addChild(self.quitButton)
		end

		self.layout:performLayout()
		if inputProvider and isFocused then
			inputProvider:setFocusedWidget(self.buttons)
		end
	end
end

return ConfigGamepadContentTab
