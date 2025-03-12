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
	["rightshoulder"] = "r1",
	["leftshoulder"] = "l1",
	["triggerright"] = "r2",
	["triggerleft"] = "l2"
}

function GamepadIconRenderer:new(resources)
	WidgetRenderer.new(self, resources)

	self.icons = {}
end

function GamepadIconRenderer:_buildNames(joystickName, icon)
	local controller = GamepadIcon.CONTROLLERS[joystickName] or GamepadIcon.CONTROLLERS["Default"]
	local prefix = string.format("Resources/Game/UI/Icons/Controllers/DB/%s", controller)

	local id = icon:getCurrentButtonID()
	local action = icon:getCurrentButtonAction() or "none"
	local button = id and GamepadIconRenderer.GAMEPAD_BUTTON[id]

	if not button then
		return nil, nil
	end

	local suffixes = {}
	if icon:getOutline() then
		suffixes = {
			string.format("%s_%s_%s", controller, button, action),
			string.format("%s_%s_outline", controller, button),
			string.format("%s_%s", controller, button),
		}
	else
		suffixes = {
			string.format("%s_%s_%s", controller, button, action),
			string.format("%s_%s", controller, button),
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
			print("trying", path)
			if love.filesystem.getInfo(path) then
				local s, r = pcall(love.graphics.newImage, path)
				if not s then
					value = false
				else
					print("success!")
					value = r
				end
			else
				value = false
			end

			if not value then
				print("not successful")
			end
		end

		self.icons[path] = value
		if value then
			return value
		end
	end

	return nil
end

function GamepadIconRenderer:draw(widget, state)
	self:visit(widget)

	local inputProvider = widget:getInputProvider()
	local joystickName = inputProvider and inputProvider:getCurrentJoystick() and inputProvider:getCurrentJoystick():getName() or "Default"


	local icon = self:_getIcon(joystickName, widget)
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
