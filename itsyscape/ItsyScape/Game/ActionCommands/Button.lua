--------------------------------------------------------------------------------
-- ItsyScape/Game/ActionCommand/Button.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Component = require "ItsyScape.Game.ActionCommands.Component"

local Button = Class(Component)
Button.TYPE = "button"

function Button:new()
	Component.new(self)

	self.gamepadButton = "x"
	self.gamepadText = false
	self.standardButton = "mouse_left"
	self.standardText = false
	self.touchButton = "tap"
	self.touchText = false
end

function Button:getGamepadButton()
	return self.gamepadButton
end

function Button:setGamepadButton(value)
	self.gamepadButton = value
end

function Button:getTouchButton()
	return self.touchButton
end

function Button:setTouchButton(value)
	self.touchButton = value
end

function Button:getStandardButton()
	return self.standardButton
end

function Button:setStandardButton(value)
	self.standardButton = value
end

function Button:getGamepadText()
	return self.gamepadText
end

function Button:setGamepadText(value)
	self.gamepadText = value
end

function Button:getTouchText()
	return self.touchText
end

function Button:setTouchText(value)
	self.touchText = value
end

function Button:getStandardText()
	return self.standardText
end

function Button:setStandardText(value)
	self.standardText = value
end

function Button:serialize(t)
	Component.serialize(self, t)

	t.gamepad = {
		button = self.gamepadButton,
		label = self.gamepadText
	}

	t.standard = {
		button = self.standardButton,
		controller = "KeyboardMouse",
		label = self.standardText
	}

	t.touch = {
		button = self.touchButton,
		controller = "Touch",
		label = self.touchText
	}
end

return Button
