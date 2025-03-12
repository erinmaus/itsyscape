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

GamepadIcon.CONTROLLERS = {
	["Default"] = "SteamDeck",
	["DualSense Wireless Controller"] = "PlayStation",
	["Steam Deck"] = "SteamDeck"
}

function GamepadIcon:new()
	Widget.new(self)

	self.buttonIDs = {}
	self.buttonActions = {}
	self.time = 0
	self.speed = 0.5
	self.outline = false
	self.useDefaultColor = true
	self.hasDropShadow = false
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
	self.buttonIDs = { id }
	self.time = 0
end

function GamepadIcon:setButtonIDs(...)
	self.buttonIDs = { ... }
	self.time = 0
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
	self.buttonActions = { actions }
	self.time = 0
end

function GamepadIcon:setButtonActions(...)
	self.buttonActions = { actions }
	self.time = 0
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

function GamepadIcon:update(delta)
	Widget.update(self, delta)

	self.time = self.time + delta
end

return GamepadIcon
