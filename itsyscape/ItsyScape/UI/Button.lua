--------------------------------------------------------------------------------
-- ItsyScape/UI/Button.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Callback = require "ItsyScape.Common.Callback"
local Widget = require "ItsyScape.UI.Widget"

local Button = Class(Widget)

function Button:new()
	Widget.new(self)
	self.onClick = Callback()
	self.isMouseOver = false
	self.isPressed = {}
end

function Button:getIsFocusable()
	return true
end

function Button:mouseEnter(x, y, top)
	if top then
		self.isMouseOver = true
	else
		self.isMouseOver = false
	end

	Widget.mouseEnter(self, x, y, top)
end

function Button:mouseLeave(...)
	self.isMouseOver = false
	Widget.mouseLeave(self, ...)
end

function Button:mousePress(x, y, button)
	self:focus()

	self.isMouseOver = true
	self.isPressed[button] = true
	Widget.mousePress(self, x, y, button)
end

function Button:mouseRelease(x, y, button, ...)
	if self.isPressed[button] and self.isMouseOver then
		self:onClick(button)
		self:blur()
	end

	self.isPressed[button] = nil

	Widget.mouseRelease(self, x, y, button, ...)
end

function Button:keyUp(key, ...)
	if key == "enter" or key == "space" then
		self:onClick("keyboard")
	end

	Widget.keyUp(self, key, ...)
end

function Button:gamepadRelease(joystick, button)
	local inputProvider = self:getInputProvider()
	if inputProvider and inputProvider:isCurrentJoystick(joystick) then
		if button == inputProvider:getKeybind("gamepadPrimaryAction") then
			self:onClick(1)
		elseif button == inputProvider:getKeybind("gamepadSecondaryAction") then
			self:onClick(2)
		end
	end

	Widget.gamepadRelease(self, joystick, button)
end

return Button
