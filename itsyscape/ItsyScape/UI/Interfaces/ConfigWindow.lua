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
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local Interface = require "ItsyScape.UI.Interface"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Controls = require "ItsyScape.UI.Client.Controls"

local ConfigWindow = Class(Interface)
ConfigWindow.DEFAULT_WIDTH = 480
ConfigWindow.DEFAULT_HEIGHT = 240
ConfigWindow.PADDING = 8
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
	layout:setSize(ConfigWindow.DEFAULT_WIDTH / 2, Controls.DEFAULT_HEIGHT)
	layout:setUniformSize(true, ConfigWindow.BUTTON_SIZE, ConfigWindow.BUTTON_SIZE)
	layout:setPadding(ConfigWindow.PADDING, ConfigWindow.PADDING)
	layout:setWrapContents(true)
	self:addChild(layout)

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

	self.titleLabel = Label()
	self.titleLabel:setStyle(LabelStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
		fontSize = 32,
		color = { 1, 1, 1, 1 },
		textShadow = true,
		align = "center"
	}, ui:getResources()))
	self.titleLabel:setPosition(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING, ConfigWindow.PADDING)
	self.titleLabel:setSize(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.LINE_HEIGHT * 2)
	self.titleLabel:setText("ItsyRealm")
	self:addChild(self.titleLabel)

	local label = Label()
	label:setText("Make sure you're in a safe place before changing settings.")
	label:setSize(ConfigWindow.DEFAULT_WIDTH / 2 - ConfigWindow.PADDING * 2, ConfigWindow.LINE_HEIGHT)
	label:setPosition(ConfigWindow.DEFAULT_WIDTH / 2 + ConfigWindow.PADDING, ConfigWindow.PADDING + ConfigWindow.BUTTON_SIZE)
	self:addChild(label)

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

	self:setSize(ConfigWindow.DEFAULT_WIDTH, ConfigWindow.DEFAULT_HEIGHT)
end

function ConfigWindow:quit()
	self:sendPoke("quit", nil, {})
end

function ConfigWindow:close()
	self:sendPoke("cancel", nil, {})
end

return ConfigWindow
