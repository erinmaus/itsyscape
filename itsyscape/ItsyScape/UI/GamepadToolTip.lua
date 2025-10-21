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
local UIView = require "ItsyScape.UI.UIView"

local GamepadToolTip = Class(Panel)
GamepadToolTip.BUTTON_SIZE = 32
GamepadToolTip.PADDING = 4
GamepadToolTip.MAX_WIDTH = 256

GamepadToolTip.CONTROLLERS = {
	["Default"] = "SteamDeck",
	["DualSense Wireless Controller"] = "PlayStation",
	["Steam Deck"] = "SteamDeck"
}

GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD = UIView.INPUT_SCHEME_MOUSE_KEYBOARD
GamepadToolTip.INPUT_SCHEME_TOUCH          = UIView.INPUT_SCHEME_TOUCH
GamepadToolTip.INPUT_SCHEME_GYRO           = UIView.INPUT_SCHEME_GYRO
GamepadToolTip.INPUT_SCHEME_GAMEPAD        = UIView.INPUT_SCHEME_GAMEPAD

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

	self.variants = {}
	self.currentInputScheme = false

	self.requireParentFocus = false
	self.isParentFocused = false
end

function GamepadToolTip:getOverflow()
	return true
end

function GamepadToolTip:setRequireFocus(value)
	value = not not value

	if self.requireParentFocus ~= value then
		self.requireParentFocus = value
		self.currentInputScheme = false
	end
end

function GamepadToolTip:getRequireFocus()
	return self.requireParentFocus
end

function GamepadToolTip:setRowSize(width, height)
	self.maxWidth = width or self.maxWidth
	self.buttonSize = height or self.buttonSize
end

function GamepadToolTip:getRowSize()
	return self.maxWidth, self.buttonSize
end

function GamepadToolTip:_setVariantKeyValue(inputScheme, key, value)
	local variant = self.variants[inputScheme]
	if not variant then
		variant = {}
		self.variants[inputScheme] = variant
	end

	variant[key] = value
	self.currentInputScheme = false
end

function GamepadToolTip:setMessage(inputScheme, text)
	self:_setVariantKeyValue(inputScheme, "message", text)
end

function GamepadToolTip:setKeybind(inputScheme, keybind)
	self:_setVariantKeyValue(inputScheme, "keybind", keybind)
end

function GamepadToolTip:setButtonID(inputScheme, id)
	self:_setVariantKeyValue(inputScheme, "buttons", { id })
end

function GamepadToolTip:setButtonIDs(inputScheme, ...)
	self:_setVariantKeyValue(inputScheme, "buttons", { ... })
end

function GamepadToolTip:setButtonAction(inputScheme, action)
	self:_setVariantKeyValue(inputScheme, "actions", { action })
end

function GamepadToolTip:setButtonActions(inputScheme, ...)
	self:_setVariantKeyValue(inputScheme, "actions", { ... })
end

function GamepadToolTip:setSpeed(inputScheme, speed)
	self:_setVariantKeyValue(inputScheme, "speed", speed)
end

function GamepadToolTip:setCenter(value)
	value = not not value

	if self.centerParent ~= value then
		self.centerParent = value
		self.currentInputScheme = false
	end
end

function GamepadToolTip:getCenter()
	return self.centerParent
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

function GamepadToolTip:_applyVariant()
	local uiView = self:getParentData(UIView)

	local inputScheme
	if not uiView then
		inputScheme = GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD
		self.currentInputScheme = false
	else
		inputScheme = uiView:getCurrentInputScheme()
	end

	if inputScheme == GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD then
		self.gamepadIcon:setController("KeyboardMouse")
	elseif inputScheme == GamepadToolTip.INPUT_SCHEME_TOUCH then
		self.gamepadIcon:setController("Touch")
	else
		self.gamepadIcon:setController()
	end

	local variant = self.variants[inputScheme] or self.variants[GamepadToolTip.INPUT_SCHEME_MOUSE_KEYBOARD] or next(self.variants)
	if variant then
		local showButton = not self.requireParentFocus or (self:getParent() and self:getParent():getIsFocused())

		if showButton then
			if variant.buttons then
				self.gamepadIcon:setButtonIDs(unpack(variant.buttons))
			end

			if variant.keybind then
				local inputProvider = self:getInputProvider()
				local buttonID = inputProvider and inputProvider:getKeybind(variant.keybind)

				if buttonID then
					self.gamepadIcon:setButtonID(buttonID)
				end
			end

			if variant.actions then
				self.gamepadIcon:setButtonActions(unpack(variant.actions))
			end
		else
			self.gamepadIcon:setButtonID("none")
			self.gamepadIcon:setButtonAction()
		end

		if variant.message then
			self:setText(variant.message)
		end

		if variant.speed then
			self.gamepadIcon:setSpeed(variant.speed)
		end
	end
end

function GamepadToolTip:performLayout()
	Panel.performLayout(self)

	self:_applyVariant()

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
	local text = self:getText()
	local buttonID = self.gamepadIcon:getButtonID()

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

	if self.gamepadIcon:getButtonID() == "none" then
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

	if self.centerParent and self:getParent() then
		local selfWidth, selfHeight = self:getSize()
		local parentWidth, parentHeight = self:getParent():getSize()

		self:setPosition(parentWidth / 2 - selfWidth / 2, parentHeight / 2 - selfHeight / 2)
	end
end

function GamepadToolTip:setText(value)
	Panel.setText(self, value)
	self:performLayout()
end

function GamepadToolTip:update(delta)
	Panel.update(self, delta)

	if self.requireParentFocus then
		if self.isParentFocused ~= (self:getParent() and self:getParent():getIsFocused()) then
			self.currentInputScheme = false
			self.isParentFocused = self:getParent() and self:getParent():getIsFocused()
		end
	end

	local uiView = self:getParentData(UIView)
	if uiView and uiView:getCurrentInputScheme() ~= self.currentInputScheme then
		self:performLayout()
		self.currentInputScheme = uiView:getCurrentInputScheme()
	end
end

return GamepadToolTip
