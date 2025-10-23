--------------------------------------------------------------------------------
-- ItsyScape/UI/ControlManager.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Config = require "ItsyScape.Game.Config"
local Control = require "ItsyScape.UI.Control"
local Controls = require "ItsyScape.UI.Controls"

local ControlManager = Class()

function ControlManager:new(uiView)
	self.uiView = uiView

	self.keys = {}
	self.buttons = {}
	self.axes = {}

	self.controls = {}
	self.activeControls = {}

	for _, controlName in ipairs(Controls) do
		self:add(controlName)
	end
end

function ControlManager:add(name)
	if self.controls[name] then
		error(string.format("control '%s' already exists", name))
	end

	self.controls[name] = Control(name, self)
end

function ControlManager:has(control)
	return self.controls[control:getName()] == control
end

function ControlManager:get(name)
	return self.controls[name]
end

function ControlManager:joystickAdd(joystick)
	local id = joystick:getID()
	self.buttons[id] = {}
	self.axes[id] = {}
end

function ControlManager:joystickRemove(joystick)
	local id = joystick:getID()
	self.buttons[id] = nil
	self.axes[id] = nil
end

function ControlManager:gamepadAxis(joystick, axis, value)
	local id = joystick:getID()
	local axes = self.axes[id]
	axes[axis] = value
	self:update()
end

function ControlManager:gamepadPress(joystick, button)
	local id = joystick:getID()
	local buttons = self.buttons[id]
	if buttons then
		buttons[button] = love.timer.getTime()
	end
	self:update()
end

function ControlManager:gamepadRelease(joystick, button)
	local id = joystick:getID()
	local buttons = self.buttons[id]
	if buttons then
		buttons[button] = nil
	end
	self:update()
end

function ControlManager:keyDown(_, scan, isRepeat)
	if not isRepeat then
		self.keys[scan] = love.timer.getTime()
	end

	self:update()
end

function ControlManager:keyUp(_, scan)
	self.keys[scan] = nil
	self:update()
end

function ControlManager:getKeyboardInputTime(scan)
	return self.keys[scan]
end

function ControlManager:isKeyboardKeyDown(scan)
	return self:getKeyboardInputTime(scan) ~= nil
end

function ControlManager:getGamepadInputTime(button)
	local inputProvider = self.uiView:getInputProvider()
	local activeController = inputProvider:getCurrentJoystick()
	local buttons = activeController and self.buttons[activeController:getID()]
	return buttons and buttons[button]
end

function ControlManager:isGamepadButtonDown(button)
	return self:getGamepadInputTime(button) ~= nil
end

function ControlManager:getGamepadAxis(axis)
	local inputProvider = self.uiView:getInputProvider()
	local activeController = inputProvider:getCurrentJoystick()
	local axes = activeController and self.axes[activeController:getID()]
	return axes and axes[axis]
end

function ControlManager:update()
	local inputProvider = self.uiView:getInputProvider()
	local widget = inputProvider:getFocusedWidget() or self.uiView:getRoot()

	for _, control in pairs(self.controls) do
		local isMaybeActive = self.activeControls[control] ~= nil
		local isActive = self.activeControls[control] == true
		local isDown = control:isDown()

		if isActive and not isDown then
			self.activeControls[control] = nil
			widget:controlUp(control)
		elseif not isMaybeActive and isDown then
			local overlaps = false
			for _, active in pairs(self.activeControls) do
				if self:overlaps(active) then
					overlaps = true
					break
				end
			end

			if not overlaps then
				widget:controlDown(control)
				self.activeControls[control] = true
			else
				self.activeControls[control] = false
			end
		end

		if isMaybeActive and not isDown then
			local allOverlapsInactive = true
			for otherControl, active in pairs(self.activeControls) do
				if control:overlaps(otherControl) and active == true then
					allOverlapsInactive = false
					break
				end
			end

			if allOverlapsInactive then
				for otherControl in pairs(self.activeControls) do
					self.activeControls[otherControl] = nil
				end
			else
				self.activeControls[control] = false
			end
		end
	end
end

return ControlManager
