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

function Button:blur(...)
	self.isPressed["keyboard"] = nil
	self.isPressed["gamepad"] = nil

	Widget.blur(self, ...)
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
	self.isMouseOver = true
	self.isPressed[button] = true
	Widget.mousePress(self, x, y, button)
end

function Button:mouseRelease(x, y, button, ...)
	if self.isPressed[button] and self.isMouseOver then
		self:onClick(button)
	end

	self.isPressed[button] = nil

	Widget.mouseRelease(self, x, y, button, ...)
end

function Button:keyDown(key, ...)
	if key == "return" or key == "space" then
		self.isPressed["keyboard"] = (self.isPressed["keyboard"] or 0) + 1
	end
end

function Button:keyUp(key, ...)
	if key == "return" or key == "space" then
		self.isPressed["keyboard"] = (self.isPressed["keyboard"] or 0) - 1
		if self.isPressed["keyboard"] <= 0 then
			self.isPressed["keyboard"] = nil
		end

		self:onClick(1)
	end

	Widget.keyUp(self, key, ...)
end

function Button:gamepadPress(joystick, button)
	self.isPressed["gamepad"] = (self.isPressed["gamepad"] or 0) + 1

	Widget.gamepadPress(self, joystick, button)
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

	self.isPressed["gamepad"] = (self.isPressed["gamepad"] or 0) - 1
	if self.isPressed["gamepad"] <= 0 then
		self.isPressed["gamepad"] = nil
	end

	Widget.gamepadRelease(self, joystick, button)
end

return Button
