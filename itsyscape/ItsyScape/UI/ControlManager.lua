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

local WAS_ACTIVE = "was active"
local IS_ACTIVE = "active"
local NOT_ACTIVE = "not active"

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

function ControlManager:getCurrentInputScheme()
	return self.uiView:getCurrentInputScheme()
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
	if isRepeat then
		return
	end

	self.keys[scan] = love.timer.getTime()
	self:update()
end

function ControlManager:keyUp(_, scan, isRepeat)
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
		local isActive = self.activeControls[control] == IS_ACTIVE
		local isDown = control:isDown()

		local hasPriority = true
		for _, otherControl in pairs(self.controls) do
			if otherControl ~= control then
				local isOtherMaybeActive = self.activeControls[otherControl] ~= nil
				local isOtherDown = otherControl:isDown()
				if not isOtherMaybeActive and isOtherDown and otherControl:priority(control) then
					hasPriority = false
					break
				end
			end
		end

		if isActive and not isDown then
			self.activeControls[control] = WAS_ACTIVE
			widget:controlUp(control)
		elseif not isMaybeActive and isDown then
			if not hasPriority then
				self.activeControls[control] = WAS_ACTIVE
			else
				widget:controlDown(control)
				self.activeControls[control] = IS_ACTIVE
			end
		end

		if isMaybeActive and not isDown then
			local allOverlapsInactive = true
			local n = 0
			for active, status in pairs(self.activeControls) do
				if active ~= control then
					if control:overlaps(active) then
						n = n + 1
					end

					if control:overlaps(active) and status ~= NOT_ACTIVE then
						allOverlapsInactive = false
						break
					end
				end
			end

			if allOverlapsInactive then
				for active in pairs(self.activeControls) do
					if control:overlaps(active) then
						self.activeControls[active] = nil
					end
				end
			else
				self.activeControls[control] = NOT_ACTIVE
			end
		end
	end
end

return ControlManager
