--------------------------------------------------------------------------------
-- ItsyScape/UI/Client/Controls.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local GridLayout = require "ItsyScape.UI.GridLayout"
local Keybinds = require "ItsyScape.UI.Keybinds"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local ToolTip = require "ItsyScape.UI.ToolTip"
local Widget = require "ItsyScape.UI.Widget"

local Controls = Class(Widget)
Controls.WIDTH = 640
Controls.HEIGHT = 480
Controls.PADDING = 8

Controls.BUTTON_WIDTH = 128
Controls.BUTTON_HEIGHT = 64

Controls.LABEL_STYLE = {
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/Bold.ttf",
	fontSize = 24,
	color = { 1, 1, 1, 1 },
	textShadow = true
}

Controls.BUTTON_STYLE = {
	pressed = "Resources/Renderers/Widget/Button/Default-Pressed.9.png",
	inactive = "Resources/Renderers/Widget/Button/Default-Inactive.9.png",
	hover = "Resources/Renderers/Widget/Button/Default-Hover.9.png",
	font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
	fontSize = 26,
	textShadow = true,
	textY = 0.5,
	textAlign = 'center'
}

Controls.SET_KEYBIND_LABEL = {
	font = "Resources/Renderers/Widget/Common/Serif/Bold.ttf",
	fontSize = 32,
	textShadow = true,
	align = 'center'
}

Controls.NAMES = {
	['PLAYER_1_MOVE_UP'] = 'Move Forward',
	['PLAYER_1_MOVE_DOWN'] = 'Move Backwards',
	['PLAYER_1_MOVE_LEFT'] = 'Move Left',
	['PLAYER_1_MOVE_RIGHT'] = 'Move Right',
	['PLAYER_1_FLEE'] = 'Flee from Combat',
	['STRATEGY_BAR_SLOT_1'] = 'Strategy Bar Slot 1',
	['STRATEGY_BAR_SLOT_2'] = 'Strategy Bar Slot 2',
	['STRATEGY_BAR_SLOT_3'] = 'Strategy Bar Slot 3',
	['STRATEGY_BAR_SLOT_4'] = 'Strategy Bar Slot 4',
	['STRATEGY_BAR_SLOT_5'] = 'Strategy Bar Slot 5',
	['STRATEGY_BAR_SLOT_6'] = 'Strategy Bar Slot 6',
	['STRATEGY_BAR_SLOT_7'] = 'Strategy Bar Slot 7',
	['STRATEGY_BAR_SLOT_8'] = 'Strategy Bar Slot 8',
	['STRATEGY_BAR_SLOT_9'] = 'Strategy Bar Slot 9',
	['STRATEGY_BAR_SLOT_10'] = 'Strategy Bar Slot 10',
	['MINIGAME_DASH'] = 'Dash (Minigame)',
	['SAILING_ACTION_PRIMARY'] = 'Primary Sailing Action',
	['SAILING_ACTION_SECONDARY'] = 'Secondary Sailing Action',
}

Controls.SetKeybind = Class(Widget)

function Controls.SetKeybind:new(application)
	Widget.new(self)

	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setPosition(-w / 4, -h / 4)

	self.panel = Panel()
	self.panel:setSize(w, h)
	self.panel:setStyle(PanelStyle({
		image = "Resources/Renderers/Widget/Panel/TipNotification.9.png"
	}, application:getUIView():getResources()))
	self:addChild(self.panel)

	self.infoLabel = Label()
	self.infoLabel:setStyle(
		LabelStyle(
			Controls.SET_KEYBIND_LABEL,
			application:getUIView():getResources()))
	self.infoLabel:setPosition(0, h / 2)
	self.infoLabel:setText("Press the keys you want. When done, release all keys.")
	self:addChild(self.infoLabel)

	self.keysLabel = Label()
	self.keysLabel:setStyle(
		LabelStyle(
			Controls.SET_KEYBIND_LABEL,
			application:getUIView():getResources()))
	self.keysLabel:setPosition(0, h / 2 + Controls.SET_KEYBIND_LABEL.fontSize * Controls.PADDING)
	self.keysLabel:setText("(no keys pressed)")
	self:addChild(self.keysLabel)

	self.keys = {}
	self.currentKeys = {}

	self.onSet = Callback()

	application:getUIView():getInputProvider():setFocusedWidget(self)
end

function Controls.SetKeybind:getIsFocusable()
	return true
end

function Controls.SetKeybind:keyDown(key, ...)
	Widget.keyDown(self, key, ...)

	if not self.keys[key] then
		table.insert(self.keys, key)
		self.keys[key] = true
	end

	self.keysLabel:setText(table.concat(self.keys, ', '))

	self.currentKeys[key] = true
end

function Controls.SetKeybind:keyUp(key, ...)
	Widget.keyDown(self, key, ...)

	self.currentKeys[key] = nil

	if not next(self.currentKeys, nil) then
		self:onSet(table.concat(self.keys, ' '))
	end
end

function Controls:new(application)
	Widget.new(self)

	self.application = application

	-- So by:
	--  1. Setting the size to the full screen resolution
	--  2. Setting the scroll to the center of screen (adjusted by window size)
	-- ...we prevent the user clicking anything underneath the settings screen
	-- and can position things relative to the top left corner of the window,
	-- rather than the top left corner of the screen.
	local w, h = love.graphics.getScaledMode()
	self:setSize(w, h)
	self:setScroll(
		-(w - Controls.WIDTH) / 2,
		-(h - Controls.HEIGHT) / 2)

	local panel = Panel()
	panel:setSize(Controls.WIDTH, Controls.HEIGHT)
	panel:setPosition(0, 0)
	self:addChild(panel)

	do
		self.keybinds = ScrollablePanel(GridLayout)
		self.keybinds:getInnerPanel():setPadding(0, 0)
		self.keybinds:getInnerPanel():setSize(
			Controls.WIDTH - Controls.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			0)
		self.keybinds:getInnerPanel():setUniformSize(
			true,
			Controls.WIDTH - Controls.PADDING * 2 - ScrollablePanel.DEFAULT_SCROLL_SIZE,
			Controls.BUTTON_HEIGHT + Controls.PADDING * 2)
		self.keybinds:getInnerPanel():setWrapContents(true)

		local function addKeybind(keybind)
			local nameLabel = Label()
			nameLabel:setText(Controls.NAMES[keybind:getName()] or keybind:getName())
			nameLabel:setStyle(
				LabelStyle(
					Controls.LABEL_STYLE,
					self.application:getUIView():getResources()))

			local bindLabel = Label()
			bindLabel:setText(keybind:getBinding())
			bindLabel:setStyle(
				LabelStyle(
					Controls.LABEL_STYLE,
					self.application:getUIView():getResources()))
			bindLabel:setPosition(Controls.PADDING, Controls.BUTTON_HEIGHT / 2)

			local button = Button()
			button:setText("Set")
			button:setSize(Controls.BUTTON_WIDTH, Controls.BUTTON_HEIGHT)
			button:setPosition(
				self.keybinds:getInnerPanel():getSize() - Controls.BUTTON_WIDTH,
				0)
			button.onClick:register(self.onSetKeybind, self, keybind, bindLabel)

			local panel = Panel()
			panel:setStyle(PanelStyle({ image = false }, self.application:getUIView():getResources()))
			panel:addChild(nameLabel)
			panel:addChild(bindLabel)
			panel:addChild(button)

			self.keybinds:addChild(panel)
		end

		for i = 1, #Keybinds do
			addKeybind(Keybinds[i])
		end

		self.keybinds:setSize(
			Controls.WIDTH - Controls.PADDING * 2,
			Controls.HEIGHT - Controls.BUTTON_HEIGHT - Controls.PADDING * 3)
		self.keybinds:setPosition(
			Controls.PADDING,
			Controls.PADDING)

		self.keybinds:setScrollSize(self.keybinds:getInnerPanel():getSize())
		self:addChild(self.keybinds)
	end

	do
		local confirmButton = Button()
		confirmButton:setText("Confirm")
		confirmButton:setStyle(
			ButtonStyle(
				Controls.BUTTON_STYLE,
				self.application:getUIView():getResources()))
		confirmButton:setSize(Controls.BUTTON_WIDTH, Controls.BUTTON_HEIGHT)
		confirmButton:setPosition(
			Controls.WIDTH - Controls.BUTTON_WIDTH - Controls.PADDING,
			Controls.HEIGHT - Controls.BUTTON_HEIGHT - Controls.PADDING)
		confirmButton.onClick:register(self.confirm, self, true)
		self:addChild(confirmButton)
	end

	self.onClose = Callback()
end

function Controls:onSetKeybind(keybind, label)
	local widget = Controls.SetKeybind(self.application)

	widget.onSet:register(function(_, binding)
		keybind:bind(binding)
		label:setText(binding)
		self:removeChild(widget)
	end)

	self:addChild(widget)
end

function Controls:confirm()
	self.onClose()
end

return Controls
