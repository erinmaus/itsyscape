--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadIconRenderer.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local GamepadIcon = require "ItsyScape.UI.GamepadIcon"
local WidgetRenderer = require "ItsyScape.UI.WidgetRenderer"
local Utility = require "ItsyScape.Game.Utility"

local GamepadIconRenderer = Class(WidgetRenderer)

GamepadIconRenderer.GAMEPAD_BUTTON = {
	["a"] = "button_a",
	["b"] = "button_b",
	["x"] = "button_x",
	["y"] = "button_y",
	["dpup"] = "dpad_up",
	["dpdown"] = "dpad_down",
	["dpleft"] = "dpad_left",
	["dpright"] = "dpad_right",
	["dp"] = "dpad_none",
	["leftstick"] = "stick_l",
	["rightstick"] = "stick_r",
	["rightshoulder"] = "button_r1",
	["leftshoulder"] = "button_l1",
	["triggerright"] = "button_r2",
	["triggerleft"] = "button_l2"
}

GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE = {
	["SteamDeck"] = {
		["start"] = "button_options"
	},

	["PlayStation"] = {
		["start"] = "button_options",
		["back"] = "button_create",
		["rightshoulder"] = "trigger_r1",
		["leftshoulder"] = "trigger_l1",
	},

	["KeyboardMouse"] = {
		["a"] = "keyboard_a",
		["b"] = "keyboard_b",
		["c"] = "keyboard_c",
		["d"] = "keyboard_d",
		["e"] = "keyboard_e",
		["f"] = "keyboard_f",
		["g"] = "keyboard_g",
		["h"] = "keyboard_h",
		["i"] = "keyboard_i",
		["j"] = "keyboard_j",
		["k"] = "keyboard_k",
		["l"] = "keyboard_l",
		["m"] = "keyboard_m",
		["n"] = "keyboard_n",
		["o"] = "keyboard_o",
		["p"] = "keyboard_p",
		["q"] = "keyboard_q",
		["r"] = "keyboard_r",
		["s"] = "keyboard_s",
		["t"] = "keyboard_t",
		["u"] = "keyboard_u",
		["v"] = "keyboard_v",
		["w"] = "keyboard_w",
		["x"] = "keyboard_x",
		["y"] = "keyboard_y",
		["z"] = "keyboard_z",
		["0"] = "keyboard_0",
		["1"] = "keyboard_1",
		["2"] = "keyboard_2",
		["3"] = "keyboard_3",
		["4"] = "keyboard_4",
		["5"] = "keyboard_5",
		["6"] = "keyboard_6",
		["7"] = "keyboard_7",
		["8"] = "keyboard_8",
		["9"] = "keyboard_9",
		["space"] = "keyboard_space",
		["!"] = "keyboard_exclamation",
		["\""] = "keyboard_quote",
		["'"] = "keyboard_apostrophe",
		["*"] = "keyboard_asterisk,",
		["+"] = "keyboard_plus",
		[","] = "keyboard_comma,",
		["-"] = "keyboard_minus",
		["."] = "keyboard_period",
		["/"] = "keyboard_slash_forward,",
		[":"] = "keyboard_colon",
		[";"] = "keyboard_semicolon",
		["<"] = "keyboard_bracket_less",
		["="] = "keyboard_equals",
		[">"] = "keyboard_bracket_greater",
		["?"] = "keyboard_question",
		["["] = "keyboard_bracket_open",
		["\\"] = "keyboard_slash_back",
		["]"] = "keyboard_bracket_close",
		["^"] = "keyboard_caret",
		["kp0"] = "keyboard_0",
		["kp1"] = "keyboard_1",
		["kp2"] = "keyboard_2",
		["kp3"] = "keyboard_3",
		["kp4"] = "keyboard_4",
		["kp5"] = "keyboard_5",
		["kp6"] = "keyboard_6",
		["kp7"] = "keyboard_7",
		["kp8"] = "keyboard_8",
		["kp9"] = "keyboard_9",
		["kp."] = "keyboard_period",
		["kp,"] = "keyboard_comma",
		["kp/"] = "keyboard_slash_forward",
		["kp*"] = "keyboard_asterisk",
		["kp-"] = "keyboard_minus",
		["kp+"] = "keyboard_numpad_plus,",
		["kpenter"] = "keyboard_numpad_enter",
		["kp="] = "keyboard_equals,",
		["up"] = "keyboard_arrow_up,",
		["down"] = "keyboard_arrow_down",
		["right"] = "keyboard_arrow_right",
		["left"] = "keyboard_arrow_left",
		["home"] = "keyboard_home",
		["end"] = "keyboard_end",
		["pageup"] = "keyboard_page_up",
		["pagedown"] = "keyboard_page_down",
		["insert"] = "keyboard_insert",
		["backspace"] = "keyboard_backspace",
		["tab"] = "keyboard_tab",
		["return"] = "keyboard_return",
		["delete"] = "keyboard_delete",
		["f1"] = "keyboard_f1",
		["f2"] = "keyboard_f2",
		["f3"] = "keyboard_f3",
		["f4"] = "keyboard_f4",
		["f5"] = "keyboard_f5",
		["f6"] = "keyboard_f6",
		["f7"] = "keyboard_f7",
		["f8"] = "keyboard_f8",
		["f9"] = "keyboard_f9",
		["f10"] = "keyboard_f10",
		["f11"] = "keyboard_f11",
		["f12"] = "keyboard_f12",
		["numlock"] = "keyboard_numlock",
		["capslock"] = "keyboard_capslock",
		["rshift"] = "keyboard_shift",
		["lshift"] = "keyboard_shift",
		["rctrl"] = "keyboard_ctrl",
		["lctrl"] = "keyboard_ctrl",
		["ralt"] = "keyboard_alt",
		["lalt"] = "keyboard_alt"
	}
}

function GamepadIconRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.icons = {}
	self.replays = {}
end

function GamepadIconRenderer:drop(widget)
	self.replays[widget] = nil
end

function GamepadIconRenderer:_buildNames(joystickName, icon)
	local controller = icon:getController() or GamepadIcon.CONTROLLERS[joystickName] or GamepadIcon.CONTROLLERS["Default"]
	local prefix = string.format("Resources/Game/UI/Icons/Controllers/DB/%s", controller)

	local id = icon:getCurrentButtonID()
	local action = icon:getCurrentButtonAction() or "none"
	local button = id and (
		(GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller] and GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller][id]) or
		GamepadIconRenderer.GAMEPAD_BUTTON[id] or
		id)

	if not button then
		return nil, nil
	end

	local suffixes = {}
	if icon:getOutline() then
		suffixes = {
			string.format("%s_%s_%s", controller, button, action),
			string.format("%s_%s_outline", controller, button),
			string.format("%s_outline", button),
			string.format("%s_%s", controller, button),
			string.format("%s", button),
		}
	else
		suffixes = {
			string.format("%s_%s_%s", controller, button, action),
			string.format("%s_%s", controller, button),
			string.format("%s", button),
		}
	end

	if icon:getUseDefaultColor() then
		if icon:getOutline() then
			table.insert(suffixes, 1, string.format("%s_color_%s_outline", controller, button))
		else
			table.insert(suffixes, 1, string.format("%s_color_%s", controller, button))
		end
	end

	return prefix, suffixes
end

function GamepadIconRenderer:_getIcon(joystickName, icon)
	local prefix, suffixes = self:_buildNames(joystickName, icon)
	if not (prefix and suffixes) then
		return false
	end

	for _, suffix in ipairs(suffixes) do
		local path = string.format("%s/%s.png", prefix, suffix:lower())

		local value = self.icons[path]
		if value == nil then
			if love.filesystem.getInfo(path) then
				local s, r = pcall(love.graphics.newImage, path)
				if not s then
					value = false
				else
					value = r
				end
			else
				value = false
			end

			if value == false then
				Log.info("Couldn't load gamepad icon '%s'.", path)
			else
				Log.info("Loaded gamepad icon '%s'.", path)
			end
		end

		self.icons[path] = value
		if value then
			return value
		end
	end

	return nil
end

function GamepadIconRenderer:isSame(widget)
	local replay = self.replays[widget]
	if not replay then
		return false
	end

	local oldOutline, oldUseColor, oldID, oldAction, oldButton, oldController = unpack(replay)

	local currentOutline = widget:getOutline()
	local currentUseColor = widget:getUseDefaultColor()
	local currentID = widget:getCurrentButtonID()
	local currentAction = widget:getCurrentButtonAction() or "none"
	local currentButton = id and (
		(GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller] and GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller][id]) or
		GamepadIconRenderer.GAMEPAD_BUTTON[id] or
		id)
	local currentController = widget:getController() or false

	return oldOutline == currentOutline and
	       oldUseColor == currentUseColor and
	       oldID == currentID and
	       oldAction == currentAction and
	       oldButton == currentButton and
	       oldController == currentController
end

function GamepadIconRenderer:draw(widget, state)
	self:visit(widget)

	local inputProvider = widget:getInputProvider()
	local joystickName = inputProvider and inputProvider:getCurrentJoystick() and inputProvider:getCurrentJoystick():getName() or "Default"

	if not self:isSame(widget) then
		local currentOutline = widget:getOutline()
		local currentUseColor = widget:getUseDefaultColor()
		local currentID = widget:getCurrentButtonID()
		local currentAction = widget:getCurrentButtonAction() or "none"
		local currentButton = id and (
			(GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller] and GamepadIconRenderer.GAMEPAD_BUTTON_OVERRIDE[controller][id]) or
			GamepadIconRenderer.GAMEPAD_BUTTON[id] or
			id)
		local currentController = widget:getController() or false

		local replay = { currentOutline, currentUseColor, currentID, currentAction, currentButton, currentController }
		replay.icon = self:_getIcon(joystickName, widget)

		self.replays[widget] = replay
	end

	local icon = self.replays[widget] and self.replays[widget].icon
	if icon then
		local scaleX, scaleY
		do
			local width, height = widget:getSize()
			scaleX = width / icon:getWidth()
			scaleY = height / icon:getHeight()
		end

		if widget:getHasDropShadow() then
			love.graphics.setColor(0, 0, 0, widget:getColor().a)
			itsyrealm.graphics.draw(icon, 2, 2, 0, scaleX, scaleY)
		end

		love.graphics.setColor(widget:getColor():get())
		itsyrealm.graphics.draw(icon, 0, 0, 0, scaleX, scaleY)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return GamepadIconRenderer
