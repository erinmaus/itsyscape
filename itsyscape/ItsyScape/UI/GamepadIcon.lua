--------------------------------------------------------------------------------
-- ItsyScape/UI/GamepadIcon.lua
--
-- This file is a part of ItsyScape.
--
-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.
--------------------------------------------------------------------------------
local Class = require "ItsyScape.Common.Class"
local Color = require "ItsyScape.Graphics.Color"
local Widget = require "ItsyScape.UI.Widget"

local GamepadIcon = Class(Widget)
GamepadIcon.DEFAULT_SIZE = 48
GamepadIcon.DEFAULT_SPEED = 0.5

GamepadIcon.CONTROLLERS = {
	["Default"] = "SteamDeck",
	["DualSense Wireless Controller"] = "PlayStation",
	["PS5 Controller"] = "PlayStation",
	["Steam Deck"] = "SteamDeck"
}

function GamepadIcon:new()
	Widget.new(self)

	self.buttonIDs = {}
	self.buttonActions = {}
	self.time = 0
	self.speed = self.DEFAULT_SPEED
	self.outline = false
	self.useDefaultColor = true
	self.hasDropShadow = false
	self.controller = false
	self.color = Color()

	self:setSize(GamepadIcon.DEFAULT_SIZE, GamepadIcon.DEFAULT_SIZE)
	self:setButtonID("a")
end

function GamepadIcon:_getAtTime(array, time)
	time = time or love.timer.getTime()

	local multiplier
	if self.speed <= 0 then
		multiplier = 0
	else
		multiplier = 1 / self.speed
	end

	local index = math.wrapIndex(math.floor((time * multiplier) + 1), 0, math.max(#array, 1))

	return array[index]
end

function GamepadIcon:setButtonID(id)
	self:setButtonIDs(id)
end

function GamepadIcon:setButtonIDs(...)
	local newButtons = { ... }
	local isDifferent = false
	if #self.buttonIDs == #newButtons then
		for i, buttonID in ipairs(self.buttonIDs) do
			local newButtonID = newButtons[i]

			if buttonID ~= newButtonID then
				isDifferent = true
				break
			end
		end
	else
		isDifferent = true
	end

	if isDifferent then
		self.buttonIDs = newButtons
		self.time = 0
	end
end

function GamepadIcon:getButtonID()
	return self.buttonIDs[1] or false
end

function GamepadIcon:getButtonIDs()
	return unpack(self.buttonIDs)
end

function GamepadIcon:getCurrentButtonID()
	return self:getButtonIDAtTime(self.time)
end

function GamepadIcon:getButtonIDAtTime(time)
	return self:_getAtTime(self.buttonIDs, time)
end

function GamepadIcon:getButtonAction()
	return self.buttonActions[1] or false
end

function GamepadIcon:setButtonAction(action)
	self:setButtonActions(action)
end

function GamepadIcon:setButtonActions(...)
	local newActions = { ... }
	local isDifferent = false
	if #self.buttonActions == #newActions then
		for i, buttonAction in ipairs(self.buttonActions) do
			local newButtonAction = newActions[i]

			if buttonAction ~= newButtonAction then
				isDifferent = true
				break
			end
		end
	else
		isDifferent = true
	end

	if isDifferent then
		self.buttonActions = { ... }
		self.time = 0
	end
end

function GamepadIcon:getButtonAction()
	return unpack(self.buttonActions)
end

function GamepadIcon:getCurrentButtonAction()
	return self:getButtonActionAtTime(self.time)
end

function GamepadIcon:getButtonActionAtTime(time)
	return self:_getAtTime(self.buttonActions, time)
end

function GamepadIcon:setOutline(value)
	self.outline = value or false
end

function GamepadIcon:getOutline()
	return self.outline
end

function GamepadIcon:setColor(value)
	self.color = value or Color()
end

function GamepadIcon:getColor()
	return self.color
end

function GamepadIcon:setUseDefaultColor(value)
	self.useDefaultColor = value or false
end

function GamepadIcon:getUseDefaultColor()
	return self.useDefaultColor
end

function GamepadIcon:setHasDropShadow(value)
	self.hasDropShadow = value or false
end

function GamepadIcon:getHasDropShadow()
	return self.hasDropShadow
end

function GamepadIcon:setController(value)
	self.controller = value or false
end

function GamepadIcon:getController()
	return self.controller
end

function GamepadIcon:setSpeed(value)
	value = value or self.DEFAULT_SPEED

	if self.speed ~= value then
		-- Scale current time to new speed.
		self.time = self.time / self.speed * value

		self.speed = value
	end
end

function GamepadIcon:update(delta)
	Widget.update(self, delta)

	self.time = self.time + delta
end

return GamepadIcon
