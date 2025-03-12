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

	self.ids = {}
	self.actions = {}
	self.time = 0
	self.speed = 0.5
	self.outline = false
	self.color = Color()

	self:setSize(GamepadIcon.DEFAULT_SIZE, GamepadIcon.DEFAULT_SIZE)
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

function GamepadIcon:setID(id)
	self.ids = { id }
	self.time = 0
end

function GamepadIcon:setIDs(...)
	self.ids = { ... }
	self.time = 0
end

function GamepadIcon:getID()
	return self.ids[1] or false
end

function GamepadIcon:getIDs()
	return unpack(self.ids)
end

function GamepadIcon:getCurrentID()
	return self:getIDAtTime()
end

function GamepadIcon:getIDAtTime(time)
	self:_getAtTime(self.ids, time)
end

function GamepadIcon:getAction()
	return self.actions[1] or false
end

function GamepadIcon:setAction(action)
	self.actions = { actions }
	self.time = 0
end

function GamepadIcon:setActions(...)
	self.actions = { actions }
	self.time = 0
end

function GamepadIcon:getAction()
	return unpack(self.actions)
end

function GamepadIcon:getCurrentAction()
	return self:getActionAtTime(self.time)
end

function GamepadIcon:getActionAtTime(time)
	return self:_getAtTime(self.actions, time)
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

function GamepadIcon:update(delta)
	Widget.update(self, delta)

	self.time = self.time + delta
end

return GamepadIcon
