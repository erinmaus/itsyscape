--------------------------------------------------------------------------------
-- ItsyScape/Editor/Common/ConfigWindow.lua
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
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Icon = require "ItsyScape.UI.Icon"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local Interface = require "ItsyScape.UI.Interface"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Controls = require "ItsyScape.UI.Client.Controls"

local ConfigWindow = Class(Interface)
ConfigWindow.DEFAULT_WIDTH = 560
ConfigWindow.DEFAULT_HEIGHT = 400
ConfigWindow.PADDING = 16
ConfigWindow.LINE_HEIGHT = 24
ConfigWindow.BUTTON_SIZE = 48

ConfigWindow.BUTTON_STYLE = function(icon)
	return {
		pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
		inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
		hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
		icon = {
			filename = icon,
			x = 0.5,
			y = 0.5
		}
	}
end

function ConfigWindow:new(id, index, ui)
	Interface.new(self, id, index, ui)

	local width, height = love.graphics.getScaledMode()

	self:setPosition(
		width / 2 - ConfigWindow.DEFAULT_WIDTH / 2,
		height / 2 - ConfigWindow.DEFAULT_HEIGHT / 2)

	self.panel = Panel()
	self.panel:setSize(
		ConfigWindow.DEFAULT_WIDTH,
		ConfigWindow.DEFAULT_HEIGHT)
	self:addChild(self.panel)

	local layout = GridLayout()
	layout:setPosition(0, ConfigWindow.DEFAULT_HEIGHT / 2 - ConfigWindow.BUTTON_SIZE)
	layout:setSize(ConfigWindow.DEFAULT_WIDTH / 2, ConfigWindow.DEFAULT_HEIGHT / 2 - ConfigWindow.BUTTON_SIZE)
	layout:setUniformSize(true, ConfigWindow.BUTTON_SIZE, ConfigWindow.BUTTON_SIZE)
	layout:setPadding(ConfigWindow.PADDING, ConfigWindow.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

	if not _MOBILE then
		local controlsButton = Button()
		controlsButton:setStyle(ButtonStyle(
			ConfigWindow.BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Keyboard.png"),
			self:getView():getResources()))
		controlsButton.onClick:register(function()
			local controls = Controls(_APP)
			local root = self:getView():getRoot()
			root:addChild(controls)

			controls.onClose:register(function()
				root:removeChild(controls)
			end)
		end)
		controlsButton:setToolTip(ToolTip.Text("Configure controls."))
		layout:addChild(controlsButton)
	end

	local soundButton = Button()
	if _CONF.volume == 0 then
		soundButton:setStyle(ButtonStyle(
			ConfigWindow.BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Mute.png"),
			self:getView():getResources()))
	else
		soundButton:setStyle(ButtonStyle(
			ConfigWindow.BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Music.png"),
			self:getView():getResources()))
	end

	soundButton.onClick:register(function()
		if _CONF.volume == 0 then
			_CONF.volume = 1
			soundButton:setStyle(ButtonStyle(
				ConfigWindow.BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Music.png"),
				self:getView():getResources()))
		else
			_CONF.volume = 0
			soundButton:setStyle(ButtonStyle(
				ConfigWindow.BUTTON_STYLE("Resources/Game/UI/Icons/Concepts/Mute.png"),
				self:getView():getResources()))
		end

		love.audio.setVolume(_CONF.volume)
	end)
	soundButton:setToolTip(ToolTip.Text("Toggle sound and music on/off."))
	layout:addChild(soundButton)

	self.settingsLabel = Label()
	self.settingsLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true,
		align = "left"
	}, ui:getResources()))
	self.settingsLabel:setPosition(ConfigWindow.PADDING, ConfigWindow.PADDING)
	self.settingsLabel:setSize(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.LINE_HEIGHT * 2)
	self.settingsLabel:setText("Settings")
	self:addChild(self.settingsLabel)

	local configLabel = Label()
	configLabel:setText("Make sure you're in a safe place before changing settings.")
	configLabel:setSize(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.LINE_HEIGHT)
	configLabel:setPosition(ConfigWindow.PADDING, ConfigWindow.PADDING + ConfigWindow.BUTTON_SIZE)
	self:addChild(configLabel)

	self.surveyLabel = Label()
	self.surveyLabel:setSize(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.LINE_HEIGHT)
	self.surveyLabel:setPosition(ConfigWindow.DEFAULT_WIDTH / 2 + ConfigWindow.PADDING, ConfigWindow.PADDING + ConfigWindow.BUTTON_SIZE)
	self:addChild(self.surveyLabel)

	self.surveyLayout = GridLayout()
	self.surveyLayout:setPosition(ConfigWindow.DEFAULT_WIDTH / 2, ConfigWindow.DEFAULT_HEIGHT / 2 - ConfigWindow.BUTTON_SIZE)
	self.surveyLayout:setSize(ConfigWindow.DEFAULT_WIDTH / 2, ConfigWindow.DEFAULT_HEIGHT / 2 - ConfigWindow.BUTTON_SIZE)
	self.surveyLayout:setUniformSize(true, ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.BUTTON_SIZE)
	self.surveyLayout:setPadding(ConfigWindow.PADDING, ConfigWindow.PADDING)
	self.surveyLayout:setWrapContents(true)

	local yesButton = Button()
	local yesIcon = Icon()
	yesIcon:setIcon("Resources/Game/UI/Icons/Concepts/Happy.png")
	yesIcon:setPosition(ConfigWindow.PADDING, 0)
	yesButton:addChild(yesIcon)
	yesButton:setText("Yes")
	yesButton.onClick:register(self.rateSession, self, true)
	self.surveyLayout:addChild(yesButton)

	local noButton = Button()
	local noIcon = Icon()
	noIcon:setIcon("Resources/Game/UI/Icons/Concepts/Angry.png")
	noIcon:setPosition(ConfigWindow.PADDING, 0)
	noButton:addChild(noIcon)
	noButton:setText("No")
	noButton.onClick:register(self.rateSession, self, false)
	self.surveyLayout:addChild(noButton)

	self:tryShowSurvey()

	self.quitButton = Button()
	self.quitButton:setSize(
		ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2,
		ConfigWindow.BUTTON_SIZE)
	self.quitButton:setPosition(
		ConfigWindow.DEFAULT_WIDTH / 2 + ConfigWindow.PADDING,
		ConfigWindow.DEFAULT_HEIGHT - ConfigWindow.BUTTON_SIZE - ConfigWindow.PADDING)
	self.quitButton.onClick:register(function()
		self:quit()
	end)
	self.quitButton:setText("Go to Title Screen")
	self.quitButton:setToolTip(ToolTip.Text("Save all progress and return to the title screen."))
	self:addChild(self.quitButton)

	self.closeButton = Button()
	self.closeButton:setSize(ConfigWindow.BUTTON_SIZE, ConfigWindow.BUTTON_SIZE)
	self.closeButton:setPosition(
		ConfigWindow.DEFAULT_WIDTH - ConfigWindow.BUTTON_SIZE,
		0)
	self.closeButton.onClick:register(function()
		self:close()
	end)
	self.closeButton:setText("X")
	self:addChild(self.closeButton)

	self.onClose:register(function()
		if _APP then
			_APP:dismissQuit()
		end
	end)

	self:setSize(ConfigWindow.DEFAULT_WIDTH, ConfigWindow.DEFAULT_HEIGHT)
end

function ConfigWindow:rateSession(rating)
	self:sendPoke("rate", nil, { rating = rating })
end

function ConfigWindow:quit()
	self:sendPoke("quit", nil, {})
end

function ConfigWindow:tryShowSurvey()
	local state = self:getState()

	if not _ANALYTICS_ENABLED then
		self.surveyLabel:setText("Thank you for playing ItsyRealm!")
	else
		if state.showSurvey then
			self.surveyLabel:setText("Did you enjoy playing ItsyRealm today?")

			if not self.surveyLayout:getParent() then
				self:addChild(self.surveyLayout)
			end
		else
			self.surveyLabel:setText("Thank you for your feedback!")

			if self.surveyLayout:getParent() then
				self:removeChild(self.surveyLayout)
			end
		end
	end
end

function ConfigWindow:update(...)
	Interface.update(self, ...)

	self:tryShowSurvey()
end

function ConfigWindow:close()
	self:sendPoke("cancel", nil, {})
end

return ConfigWindow
