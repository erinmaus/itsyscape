--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadToolTip.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Color = require "ItsyScape.Graphics.Color"
local Label = require "ItsyScape.UI.Label"
local LabelStyle = require "ItsyScape.UI.LabelStyle"
local Panel = require "ItsyScape.UI.Panel"
local PanelStyle = require "ItsyScape.UI.PanelStyle"
local GamepadIcon = require "ItsyScape.UI.GamepadIcon"

local GamepadToolTip = Class(Panel)
GamepadToolTip.BUTTON_SIZE = 32
GamepadToolTip.PADDING = 4
GamepadToolTip.MAX_WIDTH = 256

GamepadToolTip.CONTROLLERS = {
	["Default"] = "SteamDeck",
	["DualSense Wireless Controller"] = "PlayStation",
	["Steam Deck"] = "SteamDeck"
}

function GamepadToolTip:new()
	Panel.new(self)

	self.gamepadIcon = GamepadIcon()
	self.gamepadIcon:setSize(self.BUTTON_SIZE, self.BUTTON_SIZE)
	self.gamepadIcon:setPosition(self.PADDING, self.PADDING)
	self.gamepadIcon:setButtonID("a")
	self.gamepadIcon:setButtonAction("color")
	self.gamepadIcon:setHasDropShadow(true)
	self:addChild(self.gamepadIcon)

	self.label = Label()
	self.label:setStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = self.BUTTON_SIZE - self.PADDING * 2,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, LabelStyle)
	self.label:setPosition(self.BUTTON_SIZE + self.PADDING * 2, self.PADDING)
	self:addChild(self.label)

	self.onStyleChange:register(self.performLayout, self)

	self.hasBackground = true
	self:setStyle({
		image = "Resources/Game/UI/Panels/ToolTip.png"
	}, PanelStyle)

	self.keybind = false
end

function GamepadToolTip:setKeybind(keybind)
	self.keybind = keybind or false
end

function GamepadToolTip:getKeybind()
	return self.keybind
end

function GamepadToolTip:setButtonID(id)
	self.gamepadIcon:setButtonID(id)
end

function GamepadToolTip:getGamepadIcon()
	return self.gamepadIcon
end

function GamepadToolTip:setHasBackground(value)
	value = not not value

	if self.hasBackground ~= value then
		self.hasBackground = value

		if self.hasBackground then
			self:setStyle({
				image = "Resources/Game/UI/Panels/ToolTip.png"
			}, PanelStyle)
		else
			self:setStyle({
				image = false
			}, PanelStyle)
		end
	end
end

function GamepadToolTip:getHasBackground()
	return self.hasBackground
end

function GamepadToolTip:performLayout()
	Panel.performLayout(self)

	local style = self:getStyle()
	if not style then
		self:setSize(0, 0)
		return
	end

	local labelStyle = self.label:getStyle()

	local text = self:getText()
	local width, lines = labelStyle.font:getWrap(
		text,
		self.MAX_WIDTH - GamepadToolTip.BUTTON_SIZE - GamepadToolTip.PADDING * 4)

	local height = #lines * labelStyle.font:getHeight()

	self.label:setSize(width, height)
	self:setSize(
		math.min(width + GamepadToolTip.BUTTON_SIZE + GamepadToolTip.PADDING * 4, self.MAX_WIDTH),
		math.max(height + self.PADDING * 2, self.BUTTON_SIZE + self.PADDING * 2))
end

function GamepadToolTip:setText(value)
	Panel.setText(self, value)

	self.label:setText(value)
	self:performLayout()
end

function GamepadToolTip:update(delta)
	Panel.update(self, delta)

	if self.keybind then
		local inputProvider = self:getInputProvider()
		local buttonID = inputProvider and inputProvider:getKeybind(self.keybind)

		if buttonID then
			self:setButtonID(buttonID)
		end
	end
end

return GamepadToolTip
