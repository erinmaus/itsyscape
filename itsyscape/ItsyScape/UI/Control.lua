--------------------------------------------------------------------------------
-- ItsyScape/UI/Control.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local InputScheme = require "ItsyScape.UI.InputScheme"

local Control = Class()

Control.INPUT_TYPE_UI = "ui"
Control.INPUT_TYPE_WORLD = "world"

Control.KEYBOARD_MODIFIERS = {
	["lshift"] = true,
	["rshift"] = true,
	["lctrl"] = true,
	["rctrl"] = true,
	["lalt"] = true,
	["ralt"] = true,
	["menu"] = true
}

Control.KEYBOARD_MODIFIER_ALIASES = {
	["lshift"] = "rshift",
	["rshift"] = "lshift",
	["lctrl"] = "rctrl",
	["rctrl"] = "lctrl",
	["lalt"] = "ralt",
	["ralt"] = "lalt",
}

function Control:new(name, controlManager)
	self.name = name
	self.controlManager = controlManager
end

function Control:getName()
	return self.name
end

function Control:is(name)
	return self:isValid() and self.controlManager:has(self) and self.name == name
end

function Control:_getKeybind(inputScheme)
	local controlType, controlName = unpack(Config.get("Input", "CONTROL", "name", self.name, "inputScheme", inputScheme))
	local keybind = Config.get("Input", "KEYBIND", "type", controlType, "name", controlName)
	return keybind
end

function Control:getInputType()
	local type = Config.get("Input", "name", self.name, "inputScheme", "$type")

	if type == Control.INPUT_TYPE_UI or type == Control.INPUT_TYPE_WORLD then
		return type
	end

	return nil
end

function Control:_overlaps(other)
	local selfKeybind = self:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)
	local otherKeybind = other:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)

	for _, selfKey in ipairs(selfKeybind) do
		local otherHasSelfKey = false

		for _, otherKey in ipairs(otherKeybind) do
			if selfKey == otherKey then
				otherHasSelfKey = true
				break
			end
		end

		if not otherHasSelfKey then
			return false
		end
	end

	return true
end

function Control:overlaps(other)
	if not (self:isValid() and other:isValid()) then
		return false
	end

	return self:_overlaps(other) or other:_overlaps(self)
end

function Control:priority(other)
	if not (self:isValid() and other:isValid()) then
		return false
	end

	local selfKeybind = self:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)
	local otherKeybind = other:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)

	return self:overlaps(other) and #selfKeybind > #otherKeybind
end

function Control:getKeyboardKey()
	local keybind = self:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)
	if not keybind then
		return nil
	end

	for _, scan in ipairs(keybind) do
		if not Control.KEYBOARD_MODIFIERS[scan] then
			return scan
		end
	end

	return nil
end

function Control:_isKeyboardValid()
	local keybind = self:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)
	if not keybind then
		return false
	end

	local n = 0
	for _, scan in ipairs(keybind) do
		if not Control.KEYBOARD_MODIFIERS[scan] then
			n = n + 1
		end
	end

	return n == 1
end

function Control:getGamepadButton()
	local keybind = self:_getKeybind(InputScheme.INPUT_SCHEME_GAMEPAD)
	if not keybind then
		return nil
	end

	return keybind
end

function Control:_isGamepadValid()
	return self:getGamepadButton() ~= nil
end

function Control:assignTo(other)
	other.name = self.name
end

function Control:isValid(inputScheme)
	inputScheme = inputScheme or self.controlManager:getCurrentInputScheme()

	if inputScheme == InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		return self:_isKeyboardValid()
	elseif inputScheme == InputScheme.INPUT_SCHEME_GAMEPAD then
		return self:_isGamepadValid()
	end

	return false
end

function Control:_isKeyboardDown()
	local key = self:getKeyboardKey()

	local keyTime = self.controlManager:getKeyboardInputTime(key)
	if not keyTime then
		return false
	end

	local keybind = self:_getKeybind(InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD)
	if not keybind then
		return false
	end

	for _, otherKey in ipairs(keybind) do
		if Control.KEYBOARD_MODIFIERS[otherKey] then
			local aliasKey = Control.KEYBOARD_MODIFIER_ALIASES[otherKey]

			local otherKeyTime = self.controlManager:getKeyboardInputTime(otherKey)
			local aliasKeyTime = aliasKey and self.controlManager:getKeyboardInputTime(aliasKey)

			if not (otherKeyTime or aliasKeyTime) then
				return false
			end

			if not ((otherKeyTime and otherKeyTime <= keyTime) or (aliasKeyTime and aliasKeyTime <= keyTime)) then
				return false
			end
		end
	end

	return true
end

function Control:_isGamepadDown()
	local button = self:getGamepadButton()
	local buttonTime = self.controlManager:getGamepadInputTime(button)
	return not not buttonTime
end

function Control:getButtons(inputScheme)
	inputScheme = inputScheme or self.controlManager:getCurrentInputScheme()

	if inputScheme == InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		return unpack(self:_getKeybind(inputScheme))
	elseif inputScheme == InputScheme.INPUT_SCHEME_GAMEPAD then
		return self:_getKeybind(inputScheme)
	end

	return "none"
end

function Control:isDown(inputScheme)
	inputScheme = inputScheme or self.controlManager:getCurrentInputScheme()

	if not self:isValid(inputScheme) then
		return false
	end

	if inputScheme == InputScheme.INPUT_SCHEME_MOUSE_KEYBOARD then
		return self:_isKeyboardDown()
	elseif inputScheme == InputScheme.INPUT_SCHEME_GAMEPAD then
		return self:_isGamepadDown()
	end

	return false
end

function Control:isUp(inputScheme)
	return not self:isDown(inputScheme)
end

return Control
