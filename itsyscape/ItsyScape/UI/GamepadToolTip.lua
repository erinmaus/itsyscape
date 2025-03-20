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

	self.buttonSize = self.BUTTON_SIZE
	self.maxWidth = self.MAX_WIDTH

	self.previousID = "none"

	self.gamepadIcon = GamepadIcon()
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
	self.label:setPosition(self.buttonSize + self.PADDING * 2, self.PADDING)
	self:addChild(self.label)

	self.onStyleChange:register(self.performLayout, self)

	self.hasBackground = true
	self:setStyle({
		image = "Resources/Game/UI/Panels/ToolTip.png"
	}, PanelStyle)

	self.keybind = false

	self:setIsSelfClickThrough(true)
	self:setAreChildrenClickThrough(true)
end

function GamepadToolTip:setRowSize(width, height)
	self.maxWidth = width
	self.buttonSize = height
end

function GamepadToolTip:getRowSize()
	return self.maxWidth, self.buttonSize
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

function GamepadToolTip:setButtonIDs(...)
	self.gamepadIcon:setButtonIDs(...)
end

function GamepadToolTip:getButtonID()
	return self.gamepadIcon:getCurrentButtonID()
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

	self.gamepadIcon:setSize(self.buttonSize, self.buttonSize)
	self.label:setPosition(self.buttonSize + self.PADDING * 2)

	self.label:setStyle({
		font = "Resources/Renderers/Widget/Common/DefaultSansSerif/SemiBold.ttf",
		fontSize = self.buttonSize - self.PADDING * 2,
		color = { 1, 1, 1, 1 },
		textShadow = true
	}, LabelStyle)
	if not self.label:updateStyle() then
		self:setSize(0, 0)
		return
	end

	local style = self:getStyle()
	if not style then
		self:setSize(0, 0)
		return
	end

	local labelStyle = self.label:getStyle()
	local buttonID = self:getButtonID()

	local text = self:getText()

	local width, numLines
	if self.maxWidth == math.huge then
		local t
		if type(text) == "table" then
			t = {}

			for i = 2, #(text[buttonID] or text), 2 do
				table.insert(t, (text[buttonID] or text)[i])
			end

			t = table.concat(t, "")
		else
			t = tostring(text)
		end

		width = labelStyle.font:getWidth(t)
		numLines = (select(2, t:gsub("\n", "")) or 0) + 1
	else
		local w, l = labelStyle.font:getWrap(
			text,
			self.maxWidth - self.buttonSize - self.PADDING * 4)

		width = w
		numLines = #l
	end

	local height = numLines * labelStyle.font:getHeight()
	self.label:setSize(width, height)

	if type(text) == "table" then
		self.label:setText(text[buttonID] or text)
	else
		self.label:setText(text)
	end

	if self:getButtonID() == "none" then
		self.label:setPosition(self.PADDING * 2, self.PADDING)
		self:setSize(
			math.min(width + self.PADDING * 4, self.maxWidth),
			math.max(height + self.PADDING * 2, self.BUTTON_SIZE + self.PADDING * 2))
	else
		self.label:setPosition(self.buttonSize + self.PADDING * 2, self.PADDING)
		self:setSize(
			math.min(width + self.buttonSize + self.PADDING * 4, self.maxWidth),
			math.max(height + self.PADDING * 2, self.BUTTON_SIZE + self.PADDING * 2))
	end
end

function GamepadToolTip:setText(value)
	Panel.setText(self, value)
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

	if self.previousID ~= self:getButtonID() then
		print(">>> new button", self:getButtonID())
		self.previousID = self:getButtonID()
		self:performLayout()
	end
end

return GamepadToolTip
