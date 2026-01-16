--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadPokeMenu.lua
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
local Color = require "ItsyScape.Graphics.Color"
local Button = require "ItsyScape.UI.Button"
local ButtonStyle = require "ItsyScape.UI.ButtonStyle"
local GamepadGridLayout = require "ItsyScape.UI.GamepadGridLayout"
local ScrollablePanel = require "ItsyScape.UI.ScrollablePanel"
local GamepadSink = require "ItsyScape.UI.GamepadSink"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local Widget = require "ItsyScape.UI.Widget"

local GamepadPokeMenu = Class(Widget)
GamepadPokeMenu.PADDING = 8
GamepadPokeMenu.MAX_NUM_ROWS = 12

function GamepadPokeMenu:new(view, actions)
	Widget.new(self)

	self:setData(GamepadSink, GamepadSink())

	self.uiView = view

	local buttonStyle = ButtonStyle({
		inactive = "Resources/Game/UI/Buttons/Probe-Default.png",
		pressed = "Resources/Game/UI/Buttons/Probe-Pressed.png",
		hover = "Resources/Game/UI/Buttons/Probe-Hover.png",
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = 24,
		textX = 0,
		padding = GamepadPokeMenu.PADDING,
		textY = 0.5,
		textAlign = 'left'
	}, view:getResources())

	local panelStyle = PanelStyle({
		image = "Resources/Game/UI/Panels/Probe.png"
	}, view:getResources())
	self:setStyle(panelStyle)

	self.actions = {}

	local itemColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.poke.item"))
	local propColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.poke.prop"))
	local actorColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.poke.actor"))
	local miscColor = Color.fromHexString(Config.get("Config", "COLOR", "color", "ui.poke.misc"))

	self.layout = ScrollablePanel(GamepadGridLayout)
	self.gridLayout = self.layout:getInnerPanel()
	self.gridLayout:setWrapFocus(true)
	self.gridLayout:setWrapContents(true)
	self:addChild(self.layout)

	local maxTextLength = 0
	local function addAction(action)
		table.insert(self.actions, {
			id = action.id,
			verb = action.verb,
			object = action.object,
			callback = action.callback
		})

		local objectColor
		if action.objectType == "item" then
			objectColor = itemColor
		elseif action.objectType == "prop" then
			objectColor = propColor
		elseif action.objectType == "actor" then
			objectColor = actorColor
		else
			objectColor = miscColor
		end

		local buttonText, text
		if action.object then
			text = string.format("%s %s", action.verb or "*Poke", action.object)
			buttonText = {
				{ 1, 1, 1, 1 },
				action.verb or "*Poke",
				{ 1, 1, 1, 1 },
				" ",
				{ objectColor:get() },
				action.object
			}
		else
			text = action.verb or "*Poke"
			buttonText = text
		end

		local button = Button()
		button:setID(string.format("PokeMenu-%s-%s", action.type or action.verb, action.objectID or action.object))
		button:setText(buttonText)
		button:setStyle(buttonStyle)
		button.onClick:register(function(_, buttonIndex)
			if buttonIndex ~= 1 then
				return
			end

			local s, r = pcall(action.callback)
			if not s then
				io.stderr:write("error: ", r, "\n")
			end

			self:close()
		end)

		local textLength = buttonStyle.font:getWidth(text)
		maxTextLength = math.max(textLength + GamepadPokeMenu.PADDING * 2, maxTextLength)

		self.gridLayout:addChild(button)
	end

	for i = 1, #actions do
		addAction(actions[i])
	end

	addAction({
		id = "Cancel",
		verb = "Cancel",
		object = false,
		callback = function()
			self:close()
		end
	})

	local width = maxTextLength + GamepadPokeMenu.PADDING * 2
	local height = buttonStyle.font:getHeight()

	self.gridLayout:setSize(width, 0)
	self.gridLayout:setUniformSize(true, width, height + GamepadPokeMenu.PADDING * 2)
	self.gridLayout:setPadding(0, GamepadPokeMenu.PADDING)
	self.gridLayout:setPosition(GamepadPokeMenu.PADDING, GamepadPokeMenu.PADDING)
	self.gridLayout:performLayout()

	local rowHeight = (height + GamepadPokeMenu.PADDING * 2)

	local windowWidth, windowHeight = itsyrealm.graphics.getScaledMode()
	local maxHeight = math.ceil(math.floor(windowHeight * (3 / 4)) / rowHeight) * rowHeight

	local realWidth, realHeight = self.gridLayout:getSize()
	if realHeight > maxHeight then
		realHeight = maxHeight
		realWidth = realWidth + ScrollablePanel.DEFAULT_SCROLL_SIZE + GamepadPokeMenu.PADDING * 2
	else
		realWidth = realWidth + GamepadPokeMenu.PADDING * 2
		realHeight = realHeight + GamepadPokeMenu.PADDING * 2
	end

	self.layout:setSize(realWidth, realHeight - GamepadPokeMenu.PADDING * 2)
	self.layout:setScrollSize(self.gridLayout:getSize())

	self:setSize(realWidth, realHeight)

	self.onClose = Callback()

	self:setZDepth(7000)
end

function GamepadPokeMenu:focus(reason)
	Widget.focus(self, reason)

	local inputProvider = self:getInputProvider()
	if not inputProvider then
		return
	end

	inputProvider:setFocusedWidget(self.gridLayout, reason)
end

function GamepadPokeMenu:gamepadPress(joystick, button)
	local inputProvider = self:getInputProvider()
	if not (inputProvider and inputProvider:isCurrentJoystick(joystick)) then
		return
	end

	if inputProvider:getKeybind("gamepadBack") ~= button then
		return
	end

	self:close()
end

function GamepadPokeMenu:close()
	local p = self:getParent()
	if p then
		p:removeChild(self)
		self:onClose()
	end
end

return GamepadPokeMenu
